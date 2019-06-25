#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin

# Anything should do before upgrade

echo -e "Back up shadowsocks configuration file"
cd ${SS_MERLIN_HOME}/etc/shadowsocks
cp config.json config.json.bak
git checkout config.json