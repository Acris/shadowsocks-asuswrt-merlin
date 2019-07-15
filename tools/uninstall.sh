#!/bin/sh

uninstall() {
  ansi_red="\033[1;31m"
  ansi_green="\033[1;32m"
  ansi_yellow="\033[1;33m"
  ansi_std="\033[m"

  SS_MERLIN_HOME=/opt/share/ss-merlin

  read -r -p "Are you sure you want to remove shadowsocks-ausuwrt-merlin? [y/N]" confirmation
  if [[ "$confirmation" != y ]] && [[ "$confirmation" != Y ]]; then
    echo -e "$ansi_green Uninstall cancelled. $ansi_std"
    exit
  fi

  echo -e "$ansi_green Stopping all services... $ansi_std"
  ${SS_MERLIN_HOME}/scripts/stop_all_services.sh

  echo -e "$ansi_green Cleaning iptables rules... $ansi_std"
  ${SS_MERLIN_HOME}/scripts/clean_iptables_rule.sh

  echo -e "$ansi_green Deleting cron jobs... $ansi_std"
  cru d check-services-alive
  cru d check-iptables-rule
  cru d update-ip-whitelist
  cru d update-dns-whitelist
  cru d update-gfwlist
  cru d upgrade-ss-merlin

  echo -e "$ansi_green Removing packages... $ansi_std"
  opkg remove --autoremove unbound haveged

  echo -e "$ansi_green Deleting system links... $ansi_std"
  rm -f /opt/bin/ss-merlin
  rm -f /opt/bin/ss-redir
  rm -f /opt/bin/v2ray-plugin

  echo -e "$ansi_green Cleaning dnsmasq configuration file... $ansi_std"
  sed -i "\#conf-dir=${SS_MERLIN_HOME}/etc/dnsmasq.d/,\*\.conf#d" /jffs/configs/dnsmasq.conf.add 2>/dev/null
  service restart_dnsmasq

  echo -e "$ansi_green Removing user scripts... $ansi_std"
  sed -i "/ss-merlin start/d" /jffs/scripts/post-mount 2>/dev/null

  echo -e "$ansi_green Deleting shadowsocks-ausuwrt-merlin... $ansi_std"
  rm -rf ${SS_MERLIN_HOME}
  rm -f /tmp/ss-merlin-is-run 2>/dev/null

  echo -e "$ansi_green Thanks for using shadowsocks-ausuwrt-merlin. It's been removed. $ansi_std"
}

uninstall
