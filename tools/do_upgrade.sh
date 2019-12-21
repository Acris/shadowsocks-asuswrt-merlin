#!/bin/ash

SS_MERLIN_HOME=/opt/share/ss-merlin

ansi_red="\033[1;31m"
ansi_green="\033[1;32m"
ansi_std="\033[m"

echo -e "$ansi_green Executing pre-upgrade commands... $ansi_std"
cd ${SS_MERLIN_HOME} || exit
git checkout bin/*
git checkout scripts/*.sh
git checkout tools/*.sh

echo -e "$ansi_green Updating source code... $ansi_std"
cd ${SS_MERLIN_HOME} || exit
if git pull; then
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

  echo -e "$ansi_green"
  echo "   ______           __                        __       "
  echo "  / __/ /  ___ ____/ /__ _    _____ ___  ____/ /__ ___ "
  echo " _\ \/ _ \/ _ \`/ _  / _ \ |/|/ (_-</ _ \/ __/  '_/(_-<"
  echo "/___/_//_/\_,_/\_,_/\___/__,__/___/\___/\__/_/\_\/___/  for Asuswrt-Merlin"
  echo "   ..has been updated and/or is at the current version!"
  echo -e "$ansi_std"
  echo "Give us a feedback at https://github.com/Acris/shadowsocks-asuswrt-merlin."
else
  echo -e "$ansi_red There was an error updating. Try again later? $ansi_std"
fi