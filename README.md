# Shadowsocks for Asuswrt-Merlin New Gen

shadowsocks-asuswrt-merlin will install `shadowsocks-libev` and `v2ray-plugin` on your Asuswrt-Merlin New Gen(version 382.xx and higher) based router, tested on NETGEAR R7000 and ASUS RT-AC86U.

For server side set up, you can easily install shadowsocks server and v2ray-plugin with docker by [https://github.com/Acris/docker-shadowsocks-libev](https://github.com/Acris/docker-shadowsocks-libev).

## Important notice
**Due to an automatic upgrade issue, for users whose shadowsocks-asuswrt-merlin version is before 2020/01/13, please uninstall it by `ss-merlin uninstall` and reinstall it again.**

## Getting Started

### Prerequisites
- Asuswrt-Merlin New Gen(version 382.xx and higher) based router
- Entware **must** be installed, you can find installation documents on [https://github.com/RMerl/asuswrt-merlin/wiki/Entware](https://github.com/RMerl/asuswrt-merlin/wiki/Entware)
- JFFS partition should be enabled
- ca-certificates should be installed for HTTPS support
- git and git-http should be installed
- wget should be installed

Make sure you have installed all prerequisites software and utils, you can install it by:
```sh
opkg update
opkg upgrade
opkg install ca-certificates git-http wget
```

### Installation
shadowsocks-asuswrt-merlin is installed by running the following commands in your terminal:
```sh
sh -c "$(wget https://raw.githubusercontent.com/Acris/shadowsocks-asuswrt-merlin/master/tools/install.sh -O -)"
```

### Configuration
#### Configure shadowsocks
The sample shadowsocks configuration file location is: `/opt/share/ss-merlin/etc/shadowsocks/config.sample.json`, ensure `local_address` is set to `0.0.0.0`.

We highly recommend to enable `v2ray-plugin` on your server side. You can set up your server in several command with: [https://github.com/Acris/docker-shadowsocks-libev](https://github.com/Acris/docker-shadowsocks-libev).

If you want to enable UDP support, you should set `mode` from `tcp_only` to `tcp_and_udp`.

For configuration file documents, you can go to: [https://github.com/shadowsocks/shadowsocks-libev/blob/master/doc/shadowsocks-libev.asciidoc#config-file](https://github.com/shadowsocks/shadowsocks-libev/blob/master/doc/shadowsocks-libev.asciidoc#config-file)
```sh
# Copy and edit the shadowsocks configuration file
cd /opt/share/ss-merlin/etc/shadowsocks
cp config.sample.json config.json
vi config.json
```

#### Configure shadowsocks-asuswrt-merlin
The sample shadowsocks-asuswrt-merlin configuration file location is: `/opt/share/ss-merlin/etc/ss-merlin.sample.conf`. Currently, shadowsocks-asuswrt-merlin support three mode:
- 0: GFW list.
- 1: Bypass mainland China.
- 2: Global mode.

You can also enable or disable UDP support to change `udp=0` or `udp=1`, ensure your server side support UDP and set `"mode": "tcp_and_udp"` in shadowsocks configuration file.
```sh
# Copy and edit the shadowsocks-asuswrt-merlin configuration file
cd /opt/share/ss-merlin/etc
cp ss-merlin.sample.conf ss-merlin.conf
vi ss-merlin.conf
```

Configure which LAN IP will pass transparent proxy by edit `lan_ips`, you can assign a LAN IP like 192.169.1.125 means only this device can pass transparent proxy.

And you can change the default DNS server for Chinese IPs by modifying `china_dns_ip`.

Then, start the service:
```sh
# Start the service
ss-merlin start
```

### Usage
```sh
admin@R7000:/tmp/home/root# ss-merlin 
 Usage: ss-merlin start|stop|restart|upgrade|uninstall
```

### Custom user rules
```
# Block domain
## Add domain to this file if you want to block it.
vi /opt/share/ss-merlin/rules/user_domain_name_blocklist.txt

# Force pass proxy
## You can add domain to this file if you want to force the domain pass proxy.
vi /opt/share/ss-merlin/rules/user_domain_name_gfwlist.txt

# Domain whitelist
## You can add domain to this file if you need the domain bypass proxy.
vi /opt/share/ss-merlin/rules/user_domain_name_whitelist.txt

# IP whitelist
## You can add IP address to this file if you need the IP bypass proxy.
vi /opt/share/ss-merlin/rules/user_ip_whitelist.txt

# Then, restart the service
ss-merlin restart
```

## Credits
Thanks for the following awesome projects ❤️
- [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)
- [v2ray-plugin](https://github.com/shadowsocks/v2ray-plugin)
- [asuswrt-merlin.ng](https://github.com/RMerl/asuswrt-merlin.ng)
- [Entware](https://github.com/Entware/Entware)
- [asuswrt-merlin-transparent-proxy](https://github.com/zw963/asuswrt-merlin-transparent-proxy)
- [unbound](https://nlnetlabs.nl/projects/unbound/about/)
- [dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list)
- [gfwlist](https://github.com/gfwlist/gfwlist)
- [gfwlist2dnsmasq](https://github.com/cokebar/gfwlist2dnsmasq)
- [ss-tproxy](https://github.com/zfl9/ss-tproxy)
- [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- And many more.

## License
```
The MIT License (MIT)

Copyright (c) 2016 Billy Zheng

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
