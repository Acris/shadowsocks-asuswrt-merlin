#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin
DNSMASQ_CONFIG_DIR=${SS_MERLIN_HOME}/etc/dnsmasq.d

# Anything should do after upgrade

echo "2019/04/20 Update GFW list after upgrade"
if [[ ! -f ${DNSMASQ_CONFIG_DIR}/dnsmasq_gfwlist_ipset.conf.bak ]]; then
  ${SS_MERLIN_HOME}/scripts/update_gfwlist.sh
fi

echo "2019/04/20 Destroy old ipset for rename"
if ipset list CHINAIP &> /dev/null; then
  ipset destroy CHINAIP 2> /dev/null
fi
if ipset list CHINAIPS &> /dev/null; then
  ipset destroy CHINAIPS 2> /dev/null
fi

echo -e "2019/05/11 Remove scripts from dhcpc-event"
sed -i "\#${SS_MERLIN_HOME}/scripts/apply_iptables_rule.sh#d" /jffs/scripts/dhcpc-event 2> /dev/null