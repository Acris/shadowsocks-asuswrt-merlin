#!/bin/sh

SS_MERLIN_HOME=/opt/share/ss-merlin

# Anything should do after upgrade
echo "2019/04/20 Update GFW list after upgrade"
${SS_MERLIN_HOME}/scripts/update_gfwlist.sh

echo "2019/04/20 Destroy old ipset for name changing"
if [[ -f /tmp/ss-merlin-is-run ]]; then
  ipset destroy CHINAIP 2> /dev/null
  ipset destroy CHINAIPS 2> /dev/null
fi