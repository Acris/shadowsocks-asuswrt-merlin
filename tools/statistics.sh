# Statistics

cd /opt/share/ss-merlin
branch=$(git rev-parse --abbrev-ref HEAD)
hash=$(git rev-parse --short HEAD)
mac=$(cat /sys/class/net/eth0/address)
wget --quiet --method POST --output-document - "https://ss-merlin.iloli.li/stats?version=${branch}_${hash}&mac=${mac}"