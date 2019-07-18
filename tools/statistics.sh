# Statistics

cd /opt/share/ss-merlin
branch=$(git rev-parse --abbrev-ref HEAD)
hash=$(git rev-parse --short HEAD)
wget --quiet --method POST --output-document - "https://ss-merlin.iloli.li/stats?version=${branch}_${hash}"