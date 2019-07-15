#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin

# Anything should do after upgrade
DNSMASQ_CONFIG_DIR=${SS_MERLIN_HOME}/etc/dnsmasq.d
if [[ -f ${DNSMASQ_CONFIG_DIR}/whitelist-domains.china.conf ]]; then
  rm -f ${DNSMASQ_CONFIG_DIR}/whitelist-domains.china.conf
fi
if [[ -f ${DNSMASQ_CONFIG_DIR}/blocklist-domains.china.conf ]]; then
  rm -f ${DNSMASQ_CONFIG_DIR}/blocklist-domains.china.conf
fi
