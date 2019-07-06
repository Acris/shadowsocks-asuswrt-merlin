#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin

# Anything should do after upgrade
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