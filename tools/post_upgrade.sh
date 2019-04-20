#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin

# Anything should do after upgrade

# 2019/04/20 Update GFW list after upgrade
${SS_MERLIN_HOME}/scripts/update_gfwlist.sh
