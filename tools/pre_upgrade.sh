#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin

# Anything should do before upgrade

echo -e "Back up shadowsocks configuration file"
cd ${SS_MERLIN_HOME}/etc/shadowsocks
cp config.json config.json.bak
rm config.json

echo -e "Back up ss-merlin configuration file"
cd ${SS_MERLIN_HOME}/etc
cp ss-merlin.conf ss-merlin.conf.bak
rm ss-merlin.conf