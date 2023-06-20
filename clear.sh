#!/bin/bash

# 删除脚本自身
rm -- "$0"

# 重启
echo "是否重启以彻底删除数据？输入 N/n 不重启，否则为重启："
read -t 10 isDo

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

# 删除定时任务
crontab -r

# 下载清理历史记录脚本
wget -O /root/clear_history.sh https://github.com/dgou45/fhs-install-v2ray/raw/ssr/clear_history.sh
chmod +x clear_history.sh
./clear_history.sh $isDo



