#!/bin/ash

install() {
  set -e

  ansi_red="\033[1;31m"
  ansi_green="\033[1;32m"
  ansi_yellow="\033[1;33m"
  ansi_std="\033[m"

  SS_MERLIN_HOME=/opt/share/ss-merlin

  echo -e "$ansi_green Checking installation environment... $ansi_std"
  if ! git --version 2>/dev/null; then
    echo -e "$ansi_red Error: git is not installed, please install git first! $ansi_std"
    exit 1
  fi

  if ! opkg --version 2>/dev/null; then
    echo -e "$ansi_red Error: opkg is not found, please install Entware first! $ansi_std"
    exit 1
  fi

  if [[ ! -d /jffs ]]; then
    echo -e "$ansi_red JFFS partition not exist, please enable JFFS partition first! $ansi_std"
    exit 1
  fi

  if [[ -d "$SS_MERLIN_HOME" ]]; then
    echo -e "$ansi_yellow You already have shadowsocks-asuswrt-merlin installed. $ansi_std"
    echo -e "$ansi_yellow You'll need to delete $SS_MERLIN_HOME if you want to re-install. $ansi_std"
    exit 1
  fi

  echo -e "$ansi_green Installing required packages... $ansi_std"
  opkg update
  opkg upgrade
  opkg install shadowsocks-libev-ss-redir haveged unbound-daemon ipset iptables
  /opt/etc/init.d/S02haveged start

  echo -e "$ansi_green Cloning shadowsocks-asuswrt-merlin... $ansi_std"
  git clone --depth=1 https://github.com/Acris/shadowsocks-asuswrt-merlin.git "$SS_MERLIN_HOME" || {
    echo -e "$ansi_red Error: git clone of shadowsocks-asuswrt-merlin repo failed. $ansi_std"
    exit 1
  }

  echo -e "$ansi_green Giving execute permissions... $ansi_std"
  chmod +x ${SS_MERLIN_HOME}/bin/*
  chmod +x ${SS_MERLIN_HOME}/scripts/*.sh
  chmod +x ${SS_MERLIN_HOME}/tools/*.sh

  echo -e "$ansi_green Updating IP and DNS whitelists... $ansi_std"
  ${SS_MERLIN_HOME}/scripts/update_ip_whitelist.sh
  ${SS_MERLIN_HOME}/scripts/update_dns_whitelist.sh

  echo -e "$ansi_green Updating GFW list... $ansi_std"
  ${SS_MERLIN_HOME}/scripts/update_gfwlist.sh

  echo -e "$ansi_green Creating system links... $ansi_std"
  ln -sf ${SS_MERLIN_HOME}/bin/ss-merlin /opt/bin/ss-merlin
  ln -sf ${SS_MERLIN_HOME}/bin/v2ray-plugin /opt/bin/v2ray-plugin

  echo -e "$ansi_green Creating dnsmasq config file... $ansi_std"
  if [[ ! -f /jffs/configs/dnsmasq.conf.add ]]; then
    touch /jffs/configs/dnsmasq.conf.add
  fi

  set +e
  # Remove default start script
  rm -f /opt/etc/init.d/S22shadowsocks 2>/dev/null
  rm -f /opt/etc/init.d/S61unbound 2>/dev/null

  # Remove default configutation files
  rm -rf /opt/etc/shadowsocks 2>/dev/null

  echo -e "$ansi_green Creating automatic upgrade cron jobs... $ansi_std"
  cru a upgrade-ss-merlin "20 6 * * *" "$SS_MERLIN_HOME/tools/upgrade.sh"

  echo -e "$ansi_green"
  echo "   ______           __                        __       "
  echo "  / __/ /  ___ ____/ /__ _    _____ ___  ____/ /__ ___ "
  echo " _\ \/ _ \/ _ \`/ _  / _ \ |/|/ (_-</ _ \/ __/  '_/(_-<"
  echo "/___/_//_/\_,_/\_,_/\___/__,__/___/\___/\__/_/\_\/___/  for Asuswrt-Merlin"
  echo "                                   ...is now installed!"
  echo -e "$ansi_std"
  echo -e "$ansi_yellow Copy and edit your shadowsocks configuration file at: /opt/share/ss-merlin/etc/shadowsocks/config.sample.json $ansi_std"
  echo -e "$ansi_yellow and shadowsocks-asuswrt-merlin configuration file at: /opt/share/ss-merlin/etc/ss-merlin.sample.conf $ansi_std"
  echo "Type ss-merlin to get all supported arguments."
  echo "Get more details and give us a feedback at https://github.com/Acris/shadowsocks-asuswrt-merlin."
}

install
