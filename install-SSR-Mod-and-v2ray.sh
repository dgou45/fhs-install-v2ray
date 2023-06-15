#!/bin/bash
set -e

# 获取节点ID，超时时间为 10 秒
valid_input=false
wait=10
while [ "$valid_input" = false ]; do
  echo "请输入节点ID（默认为 0 ）："
  if read -t $wait node_id; then
    echo "您输入的节点ID是：$node_id"
  else
    echo "超时未输入，节点ID默认为 0"
    node_id=0
  fi
  
  # 判断用户输入是否为数字
  if [[ "$node_id" =~ ^[0-9]+$ ]]; then
    valid_input=true
  else
    wait=10
    echo "输入无效，请重新输入一个有效的数字！"
  fi
done

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
cd
apt-get install build-essential
wget https://github.com/jedisct1/libsodium/releases/download/1.0.18-RELEASE/libsodium-1.0.18.tar.gz
tar xf libsodium-1.0.18.tar.gz && cd libsodium-1.0.18
./configure && make -j2 && make install
ldconfig

#是否安装v2ray
answer="$1"

if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
  #安装v2ray
  cd
  bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
  bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
  #下载v2ray配置文件
  wget -O /usr/local/etc/v2ray/config.json https://github.com/dgou45/fhs-install-v2ray/raw/ssr/config-v2ray.json
fi

#开启bbr
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr

#添加定时任务
{ echo "@reboot sh /root/shadowsocks-mod/run.sh"; echo "@reboot /bin/systemctl restart v2ray.service";echo "0 22 * * 0 /sbin/reboot";echo "0 22 * * * /bin/systemctl restart v2ray.service";echo "0 22 * * * sh /root/shadowsocks-mod/stop.sh && sh /root/shadowsocks-mod/run.sh"; } | EDITOR="tee" crontab -

#修改ssr节点ID
sudo sed -i "s|NODE_ID = 0|NODE_ID = $node_id|" /root/shadowsocks-mod/userapiconfig.py

echo "所有命令执行成功"

#删除脚本自身
echo "脚本正在删除自身..."
rm -- "$0"


