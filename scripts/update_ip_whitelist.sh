#!/bin/sh

update_ip_whitelist() {
  SS_MERLIN_HOME=/opt/share/ss-merlin

  wget -O - 'https://ss-merlin.iloli.li/proxy-github-raw/17mon/china_ip_list/master/china_ip_list.txt' | sed '/^#/d' > ${SS_MERLIN_HOME}/rules/chinadns_chnroute.txt.bak

  echo 'Update IP whitelist done.'
}

update_ip_whitelist
