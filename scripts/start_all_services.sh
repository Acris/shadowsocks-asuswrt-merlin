#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin

# Start if process not running
stubby_pid=`pidof stubby`
if [[ -z "$stubby_pid" ]]; then
  stubby -C ${SS_MERLIN_HOME}/etc/stubby/stubby.yml -v 3 -g
fi

sleep 5

ss_pid=`pidof ss-redir`
if [[ -z "$ss_pid" ]]; then
  ss-redir -c ${SS_MERLIN_HOME}/etc/shadowsocks/config.json -f /opt/var/run/ss-redir.pid
fi