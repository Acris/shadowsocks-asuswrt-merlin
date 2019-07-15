#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin

# Start if process not running
unbound_pid=$(pidof unbound)
if [[ -z "$unbound_pid" ]]; then
  unbound -c ${SS_MERLIN_HOME}/etc/unbound/unbound.conf
fi

ss_pid=$(pidof ss-redir)
if [[ -z "$ss_pid" ]]; then
  if [[ ! -f ${SS_MERLIN_HOME}/etc/shadowsocks/config.json ]]; then
    cp ${SS_MERLIN_HOME}/etc/shadowsocks/config.sample.json ${SS_MERLIN_HOME}/etc/shadowsocks/config.json
  fi
  ss-redir -c ${SS_MERLIN_HOME}/etc/shadowsocks/config.json -f /opt/var/run/ss-redir.pid
fi

echo "All service started."
