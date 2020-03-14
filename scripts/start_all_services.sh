#!/bin/ash

SS_MERLIN_HOME=/opt/share/ss-merlin
SHADOW_CONFIG_FILE=${SS_MERLIN_HOME}/etc/shadowsocks/config.json
use_v2ray=0
if [[ -f ${SHADOW_CONFIG_FILE} ]]; then
   use_v2ray=$(grep -w "plugin" ${SHADOW_CONFIG_FILE}|grep "v2ray" -c)
fi

# Start if process not running
ss_pid=$(pidof ss-redir)
if [[ -z "$ss_pid" ]]; then
  if [[ ! -f ${SS_MERLIN_HOME}/etc/shadowsocks/config.json ]]; then
    cp ${SS_MERLIN_HOME}/etc/shadowsocks/config.sample.json ${SS_MERLIN_HOME}/etc/shadowsocks/config.json
  fi
  ss-redir -c ${SS_MERLIN_HOME}/etc/shadowsocks/config.json -f /opt/var/run/ss-redir.pid
fi

v2ray_pid=$(pidof v2ray-plugin)
if [[ -z "$v2ray_pid" ]]; then
  if [ $use_v2ray -ge 1 ];then 
     killall ss-redir 2>/dev/null
     ss-redir -c ${SS_MERLIN_HOME}/etc/shadowsocks/config.json -f /opt/var/run/ss-redir.pid
  fi
fi

unbound_pid=$(pidof unbound)
if [[ -z "$unbound_pid" ]]; then
  unbound -c ${SS_MERLIN_HOME}/etc/unbound/unbound.conf
fi

echo "All service started."
