#!/bin/sh

update_ip_whitelist() {
  SS_MERLIN_HOME=/opt/share/ss-merlin

  wget -O - 'https://ss-merlin.iloli.li/proxy-apnic/apnic/stats/apnic/delegated-apnic-latest' | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' >${SS_MERLIN_HOME}/rules/chinadns_chnroute.txt

  echo 'Update IP whitelist done.'
}

update_ip_whitelist
