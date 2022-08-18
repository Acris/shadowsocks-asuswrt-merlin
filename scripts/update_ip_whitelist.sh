#!/bin/ash

update_ip_whitelist() {
  SS_MERLIN_HOME=/opt/share/ss-merlin

  wget -O - 'https://cdn.jsdelivr.net/gh/tmplink/IPDB@main/ipv4/cidr/CN.txt' | sed '/^#/d' > ${SS_MERLIN_HOME}/rules/chinadns_chnroute.txt.bak

  echo 'Update IP whitelist done.'
}

update_ip_whitelist
