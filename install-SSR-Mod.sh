#!/bin/bash
set -e

#安装工具
apt update
apt install -y python3-pip libffi-dev libssl-dev git

#安装ssr
git clone https://github.com/dgou45/shadowsocks-mod.git
cd shadowsocks-mod/
pip3 install -r requirements.txt
cp apiconfig.py userapiconfig.py
cp config.json user-config.json

#安装加密
cd /root
apt-get install build-essential
wget https://github.com/jedisct1/libsodium/releases/download/1.0.18-RELEASE/libsodium-1.0.18.tar.gz
tar xf libsodium-1.0.18.tar.gz && cd libsodium-1.0.18
./configure && make -j2 && make install
ldconfig

#开启bbr
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr

#添加定时任务
{ echo "@reboot sh /root/shadowsocks-mod/run.sh"; echo "@reboot /bin/systemctl restart v2ray.service";echo "0 22 * * 0 /sbin/reboot";echo "0 22 * * * /bin/systemctl restart v2ray.service";echo "0 22 * * * sh /root/shadowsocks-mod/stop.sh && sh /root/shadowsocks-mod/run.sh"; } | EDITOR="tee" crontab -

#修改混淆参数
sudo sed -i "s|MU_SUFFIX = 'zhaoj.in'|MU_SUFFIX = 'microsoft.com,www.icloud.com,www.apple.com,www.office.com,www.jd.hk,www.bing.com,cloudfront.com,cloudflare.com,ajax.microsoft.com'|" /root/shadowsocks-mod/userapiconfig.py

#删除脚本自身
rm -rf /root/install-SSR-Mod.sh

echo "所有命令执行成功"


