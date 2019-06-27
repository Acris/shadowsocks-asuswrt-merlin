#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin
DNSMASQ_CONFIG_DIR=${SS_MERLIN_HOME}/etc/dnsmasq.d

# Anything should do after upgrade
if ! cru l | grep upgrade-ss-merlin &> /dev/null; then
  echo -e "Creating automatic upgrade cron jobs..."
  cru a upgrade-ss-merlin "20 6 * * *" "$SS_MERLIN_HOME/tools/upgrade.sh"
fi

if [[ ! -f ${DNSMASQ_CONFIG_DIR}/dnsmasq_gfwlist_ipset.conf.bak ]]; then
  echo "2019/04/20 Update GFW list after upgrade"
  ${SS_MERLIN_HOME}/scripts/update_gfwlist.sh
fi

if ipset list CHINAIP &> /dev/null; then
  echo "2019/04/20 Destroy old CHINAIP ipset for rename"
  ipset destroy CHINAIP 2> /dev/null
fi
if ipset list CHINAIPS &> /dev/null; then
  echo "2019/04/20 Destroy old CHINAIPS ipset for rename"
  ipset destroy CHINAIPS 2> /dev/null
fi

if [[ -f /jffs/scripts/dhcpc-event ]]; then
  echo -e "2019/05/11 Remove dhcpc-event task"
  sed -i "\#${SS_MERLIN_HOME}/scripts/apply_iptables_rule.sh#d" /jffs/scripts/dhcpc-event 2> /dev/null
fi

if [[ -f ${SS_MERLIN_HOME}/etc/shadowsocks/config.json.bak ]]; then
  echo -e "Restore shadowsocks configuration file"
  cd ${SS_MERLIN_HOME}/etc/shadowsocks
  rm config.json
  mv config.json.bak config.json
  sed -i 's#\("local_address": "\).*#\10.0.0.0",#g' config.json
fi

if [[ -f ${SS_MERLIN_HOME}/etc/ss-merlin.conf.bak ]]; then
  echo -e "Restore ss-merlin configuration file"
  cd ${SS_MERLIN_HOME}/etc
  rm ss-merlin.conf
  mv ss-merlin.conf.bak ss-merlin.conf
fi

if stubby -h &> /dev/null; then
  # Uninstall stubby
  opkg remove --autoremove stubby 2> /dev/null
  rm -rf /opt/var/cache/stubby 2> /dev/null
fi