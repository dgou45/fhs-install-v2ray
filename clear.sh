#!/bin/bash

# 删除脚本自身
rm -- "$0"

# 删除ssr-mod+libsodium
shred -zvu -n 5 /root/shadowsocks-mod/userapiconfig.py
rm -rf /root/shadowsocks-mod
rm -rf /root/libsodium*
rm -rf /root/bbr.sh
rm -rf /root/install_bbr.log

# 删除V2ray
shred -zvu -n 5 /usr/local/etc/v2ray/config.json
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove
rm -rf /usr/local/etc/v2ray
rm -rf /var/log/v2ray

# 删除cf ddns
shred -zvu -n 5 /usr/local/bin/cf-ddns.sh
rm -rf /root/cloudflare.ids  cloudflare.log  ip.txt

# 删除定时任务
crontab -r

echo -e "\033[32m恭喜您，\033[33m所有命令执行成功！\033[0m"




