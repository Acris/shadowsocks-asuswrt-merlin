#!/bin/ash

update_dns_whitelist() {
  SS_MERLIN_HOME=/opt/share/ss-merlin

  ACCELERATED_CONFIG=${SS_MERLIN_HOME}/etc/dnsmasq.d/accelerated-domains.china.conf
  GOOGLE_CONFIG=${SS_MERLIN_HOME}/etc/dnsmasq.d/google.china.conf
  APPLE_CONFIG=${SS_MERLIN_HOME}/etc/dnsmasq.d/apple.china.conf

  wget https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf -O ${ACCELERATED_CONFIG}.bak
  wget https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf -O ${GOOGLE_CONFIG}.bak
  wget https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf -O ${APPLE_CONFIG}.bak

  echo 'Update DNS whitelist done.'
}

update_dns_whitelist
