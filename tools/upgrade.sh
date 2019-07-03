#!/bin/sh

upgrade() {
  SS_MERLIN_HOME=/opt/share/ss-merlin

  ansi_red="\033[1;31m";
  ansi_green="\033[1;32m"
  ansi_std="\033[m"

  echo -e "$ansi_green Executing pre upgrade scripts... $ansi_std"
  ${SS_MERLIN_HOME}/tools/pre_upgrade.sh

  echo -e "$ansi_green Updating source code... $ansi_std"
  cd ${SS_MERLIN_HOME}
  if git pull
  then
    echo -e "$ansi_green Giving execute permissions... $ansi_std"
    chmod +x ${SS_MERLIN_HOME}/bin/*
    chmod +x ${SS_MERLIN_HOME}/scripts/*.sh
    chmod +x ${SS_MERLIN_HOME}/tools/*.sh

    echo -e "$ansi_green Executing post upgrade scripts... $ansi_std"
    ${SS_MERLIN_HOME}/tools/post_upgrade.sh

    echo -e "$ansi_green Upgrading packages... $ansi_std"
    opkg update
    opkg upgrade

    if [[ -f /tmp/ss-merlin-is-run ]]; then
      echo -e "$ansi_green Restarting... $ansi_std"
      ss-merlin restart
    fi

    # Statistics
    cd ${SS_MERLIN_HOME}
    branch=`git rev-parse --abbrev-ref HEAD`
    hash=`git rev-parse --short HEAD`
    mac=`cat /sys/class/net/eth0/address`
    wget --quiet --method POST --output-document - "https://ss-merlin.iloli.li/stats?version=${branch}_${hash}&mac=${mac}"

    echo -e "$ansi_green"
    echo "   ______           __                        __       ";
    echo "  / __/ /  ___ ____/ /__ _    _____ ___  ____/ /__ ___ ";
    echo " _\ \/ _ \/ _ \`/ _  / _ \ |/|/ (_-</ _ \/ __/  '_/(_-<";
    echo "/___/_//_/\_,_/\_,_/\___/__,__/___/\___/\__/_/\_\/___/ ";
    echo "   ..has been updated and/or is at the current version!";
    echo -e "$ansi_std"
    echo "Give us a feedback at https://github.com/Acris/shadowsocks-asuswrt-merlin."
  else
    if [[ -f ${SS_MERLIN_HOME}/etc/shadowsocks/config.json.bak ]]; then
      echo -e "Restore shadowsocks configuration file"
      cd ${SS_MERLIN_HOME}/etc/shadowsocks
      rm config.json
      mv config.json.bak config.json
    fi
    if [[ -f ${SS_MERLIN_HOME}/etc/ss-merlin.conf.bak ]]; then
      echo -e "Restore ss-merlin configuration file"
      cd ${SS_MERLIN_HOME}/etc
      rm ss-merlin.conf
      mv ss-merlin.conf.bak ss-merlin.conf
    fi
    echo -e "$ansi_red There was an error updating. Try again later? $ansi_std"
  fi
}

upgrade