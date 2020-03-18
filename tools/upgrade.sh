#!/bin/ash

upgrade() {
  SS_MERLIN_HOME=/opt/share/ss-merlin

  cd ${SS_MERLIN_HOME} || exit
  git checkout bin/*
  git checkout scripts/*.sh
  git checkout tools/*.sh

  rm -f ${SS_MERLIN_HOME}/tools/do_upgrade.sh

  wget https://raw.github.com/Acris/shadowsocks-asuswrt-merlin/master/tools/do_upgrade.sh -O ${SS_MERLIN_HOME}/tools/do_upgrade.sh

  chmod +x ${SS_MERLIN_HOME}/tools/do_upgrade.sh

  ${SS_MERLIN_HOME}/tools/do_upgrade.sh
}

upgrade
