#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin

# Anything should do after upgrade
DNSMASQ_CONFIG_DIR=${SS_MERLIN_HOME}/etc/dnsmasq.d
rm -f ${DNSMASQ_CONFIG_DIR}/whitelist-domains.china.conf 2> /dev/null
rm -f ${DNSMASQ_CONFIG_DIR}/blocklist-domains.china.conf 2> /dev/null