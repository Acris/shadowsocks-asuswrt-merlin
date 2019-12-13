#!/bin/ash

update_gfwlist() {
  SS_MERLIN_HOME=/opt/share/ss-merlin
  DNSMASQ_CONFIG_DIR=${SS_MERLIN_HOME}/etc/dnsmasq.d

  wget -O - 'https://cokebar.github.io/gfwlist2dnsmasq/dnsmasq_gfwlist_ipset.conf' | sed "/127.0.0.1#5353/d" > ${DNSMASQ_CONFIG_DIR}/dnsmasq_gfwlist_ipset.conf.bak

  echo 'Update GFW list done.'
}

update_gfwlist
