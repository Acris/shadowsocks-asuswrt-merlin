#!/bin/sh

# delete related rules
iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS_TCP 2> /dev/null
iptables -t nat -F SHADOWSOCKS_TCP 2> /dev/null
iptables -t nat -X SHADOWSOCKS_TCP 2> /dev/null

iptables -t mangle -D PREROUTING -p udp -j SHADOWSOCKS_UDP 2> /dev/null
iptables -t mangle -F SHADOWSOCKS_UDP 2> /dev/null
iptables -t mangle -X SHADOWSOCKS_UDP 2> /dev/null

ip route del local default dev lo table 100 2> /dev/null
ip rule del fwmark 1 lookup 100 2> /dev/null

# Destory ipset
ipset destroy CHINAIP 2> /dev/null
ipset destroy CHINAIPS 2> /dev/null

echo "Clean iptables rule done."
