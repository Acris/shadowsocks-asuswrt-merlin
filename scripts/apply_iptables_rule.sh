#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin
DNSMASQ_CONFIG_DIR=${SS_MERLIN_HOME}/etc/dnsmasq.d

if [[ ! -f ${SS_MERLIN_HOME}/etc/ss-merlin.conf ]]; then
  cp ${SS_MERLIN_HOME}/etc/ss-merlin.sample.conf ${SS_MERLIN_HOME}/etc/ss-merlin.conf
fi
if [[ ! -f ${SS_MERLIN_HOME}/etc/shadowsocks/config.json ]]; then
  cp ${SS_MERLIN_HOME}/etc/shadowsocks/config.sample.json ${SS_MERLIN_HOME}/etc/shadowsocks/config.json
fi
. ${SS_MERLIN_HOME}/etc/ss-merlin.conf

modprobe ip_set
modprobe ip_set_hash_net
modprobe ip_set_hash_ip
modprobe xt_set

if [[ ${mode} -eq 0 ]]; then
  # Add GFW list to gfwlist ipset for GFW list mode
  if ipset create gfwlist hash:ip 2>/dev/null; then
    rm -f ${DNSMASQ_CONFIG_DIR}/dnsmasq_gfwlist_ipset.conf 2>/dev/null
    cp ${DNSMASQ_CONFIG_DIR}/dnsmasq_gfwlist_ipset.conf.bak ${DNSMASQ_CONFIG_DIR}/dnsmasq_gfwlist_ipset.conf
  fi
elif [[ ${mode} -eq 1 ]]; then
  # Add China IP to chinaips ipset for Bypass mainland China mode
  if ipset create chinaips hash:net 2>/dev/null; then
    OLDIFS="$IFS" && IFS=$'\n'
    if ipset list chinaips &>/dev/null; then
      count=$(ipset list chinaips | wc -l)
      if [[ "$count" -lt "8000" ]]; then
        echo "Applying China ipset rule, it maybe take several minute to finish..."
        for ip in $(cat ${SS_MERLIN_HOME}/rules/chinadns_chnroute.txt | grep -v '^#'); do
          ipset add chinaips ${ip}
        done
      fi
    fi
    IFS=${OLDIFS}
  fi
fi

# Create ipset for user domain name whitelist and user domain name gfwlist
ipset create userwhitelist hash:ip 2>/dev/null
ipset create usergfwlist hash:ip 2>/dev/null

# Add intranet IP to localips ipset for Bypass LAN
if ipset create localips hash:net 2>/dev/null; then
  OLDIFS="$IFS" && IFS=$'\n'
  if ipset list localips &>/dev/null; then
    echo "Applying localips ipset rule..."
    for ip in $(cat ${SS_MERLIN_HOME}/rules/localips | grep -v '^#'); do
      ipset add localips ${ip}
    done
  fi
  IFS=${OLDIFS}
fi

# Add whitelist
if ipset create whitelist hash:ip 2>/dev/null; then
  china_dns_ip=119.29.29.29
  remote_server_address=$(cat ${SS_MERLIN_HOME}/etc/shadowsocks/config.json | grep 'server"' | cut -d ':' -f 2 | cut -d '"' -f 2)
  remote_server_ip=${remote_server_address}
  ISIP=$(echo ${remote_server_address} | grep -E '([0-9]{1,3}[\.]){3}[0-9]{1,3}|:')
  if [[ -z "$ISIP" ]]; then
    echo "Resolving server IP address..."
    remote_server_ip=$(nslookup ${remote_server_address} ${china_dns_ip} | sed '1,4d' | awk '{print $3}' | grep -v : | awk 'NR==1{print}')
    echo "Server IP address is ${remote_server_ip}"
  fi

  OLDIFS="$IFS" && IFS=$'\n'
  if ipset list whitelist &>/dev/null; then
    # Add China default DNS server
    ipset add whitelist ${china_dns_ip}
    # Add shadowsocks server ip address
    ipset add whitelist ${remote_server_ip}
    # Add rubyfush DNS server
    ipset add whitelist 118.89.110.78
    ipset add whitelist 47.96.179.163

    # Add user_ip_whitelist.txt
    if [[ -e ${SS_MERLIN_HOME}/rules/user_ip_whitelist.txt ]]; then
      for ip in $(cat ${SS_MERLIN_HOME}/rules/user_ip_whitelist.txt | grep -v '^#'); do
        ipset add whitelist ${ip}
      done
    fi
  fi
  IFS=${OLDIFS}
fi

local_redir_port=$(cat ${SS_MERLIN_HOME}/etc/shadowsocks/config.json | grep 'local_port' | cut -d ':' -f 2 | grep -o '[0-9]*')

if iptables -t nat -N SHADOWSOCKS_TCP 2>/dev/null; then
  # TCP rules
  iptables -t nat -N SS_OUTPUT
  iptables -t nat -N SS_PREROUTING
  iptables -t nat -A OUTPUT -j SS_OUTPUT
  iptables -t nat -A PREROUTING -j SS_PREROUTING
  iptables -t nat -A SHADOWSOCKS_TCP -m set --match-set localips dst -j RETURN
  iptables -t nat -A SHADOWSOCKS_TCP -m set --match-set whitelist dst -j RETURN
  iptables -t nat -A SHADOWSOCKS_TCP -m set --match-set userwhitelist dst -j RETURN
  if [[ ${mode} -eq 1 ]]; then
    iptables -t nat -A SHADOWSOCKS_TCP -m set --match-set chinaips dst -j RETURN
  fi
  if [[ ${mode} -eq 0 ]]; then
    iptables -t nat -A SHADOWSOCKS_TCP -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports ${local_redir_port}
  else
    iptables -t nat -A SHADOWSOCKS_TCP -p tcp -j REDIRECT --to-ports ${local_redir_port}
  fi
  iptables -t nat -A SHADOWSOCKS_TCP -p tcp -m set --match-set usergfwlist dst -j REDIRECT --to-ports ${local_redir_port}
  # Apply TCP rules
  iptables -t nat -A SS_OUTPUT -p tcp -j SHADOWSOCKS_TCP
  iptables -t nat -A SS_PREROUTING -p tcp -s 192.168.0.0/16 -j SHADOWSOCKS_TCP
fi

if [[ ${udp} -eq 1 ]]; then
  if iptables -t mangle -N SHADOWSOCKS_UDP 2>/dev/null; then
    # UDP rules
    modprobe xt_TPROXY
    ip route add local 0.0.0.0/0 dev lo table 100
    ip rule add fwmark 0x2333 table 100
    iptables -t mangle -N SS_OUTPUT
    iptables -t mangle -N SS_PREROUTING
    iptables -t mangle -A OUTPUT -j SS_OUTPUT
    iptables -t mangle -A PREROUTING -j SS_PREROUTING
    iptables -t mangle -A SHADOWSOCKS_UDP -p udp -m set --match-set localips dst -j RETURN
    iptables -t mangle -A SHADOWSOCKS_UDP -p udp -m set --match-set whitelist dst -j RETURN
    iptables -t mangle -A SHADOWSOCKS_UDP -p udp -m set --match-set userwhitelist dst -j RETURN
    if [[ ${mode} -eq 1 ]]; then
      iptables -t mangle -A SHADOWSOCKS_UDP -p udp -m set --match-set chinaips dst -j RETURN
    fi
    if [[ ${mode} -eq 0 ]]; then
      iptables -t mangle -A SHADOWSOCKS_UDP -m set --match-set gfwlist dst -j MARK --set-mark 0x2333
    else
      iptables -t mangle -A SHADOWSOCKS_UDP -j MARK --set-mark 0x2333
    fi
    iptables -t mangle -A SHADOWSOCKS_UDP -m set --match-set usergfwlist dst -j MARK --set-mark 0x2333
    # Apply for udp
    iptables -t mangle -A SS_OUTPUT -p udp -j SHADOWSOCKS_UDP
    iptables -t mangle -A SS_PREROUTING -p udp -s 192.168.0.0/16 --dport 53 -m mark ! --mark 0x2333 -j ACCEPT
    iptables -t mangle -A SS_PREROUTING -p udp -s 192.168.0.0/16 -m mark ! --mark 0x2333 -j SHADOWSOCKS_UDP
    iptables -t mangle -A SS_PREROUTING -m mark --mark 0x2333 -p udp -j TPROXY --on-ip 127.0.0.1 --on-port ${local_redir_port}
  fi
fi

echo "Apply iptables rule done."
