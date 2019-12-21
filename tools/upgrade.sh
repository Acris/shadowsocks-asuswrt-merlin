#!/bin/ash

upgrade() {
  SS_MERLIN_HOME=/opt/share/ss-merlin

  rm -f ${SS_MERLIN_HOME}/tools/do_upgrade.sh

  wget https://cdn.jsdelivr.net/gh/Acris/shadowsocks-asuswrt-merlin@master/tools/do_upgrade.sh -O ${SS_MERLIN_HOME}/tools/do_upgrade.sh

  chmod +x ${SS_MERLIN_HOME}/tools/do_upgrade.sh

  ${SS_MERLIN_HOME}/tools/do_upgrade.sh
}

upgrade
