#!/bin/bash
set -e

# 删除脚本自身
rm -- "$0"

# 禁用 set -e
set +e

# 与用户交互输入新密码
read -s -p "请输入新的 root 密码：" new_password
echo

# 检查用户是否取消输入
if [[ -z "$new_password" ]]; then
    echo "用户取消输入密码。"
fi

# 使用输入的密码修改 root 密码
echo -e "$new_password\n$new_password" | sudo passwd root

# 检查修改密码的结果
if [[ $? -eq 0 ]]; then
    echo "root 密码已成功修改。"
else
    echo "修改 root 密码失败。"
fi

set -e

# 获取节点ID
valid_input=false
while [ "$valid_input" = false ]; do
    echo "请输入节点ID（默认为 0 ）："
    read node_id

  if [ -z "$node_id" ]; then
    node_id=0
    echo "没有输入，节点ID默认为 0"
  else
    echo "您输入的节点ID是：$node_id"
  fi

  # 判断用户输入是否为数字
  if [[ "$node_id" =~ ^[0-9]+$ ]]; then
    valid_input=true
  else 
    echo "输入无效，请重新输入一个有效的数字！"
  fi
done

echo "是否安装v2ray？输入N或n不安装，否则为安装："
if read -t 20 install_v2; then
    if [ "$install_v2" != "N" ] && [ "$install_v2" != "n" ]; then
        echo "您选择的是安装v2ray"
    else
        echo "您选择的是不安装v2ray"
    fi
else
    echo "超时未输入，默认安装v2ray"
fi

# 安装工具
apt update
apt install -y python3-pip libffi-dev libssl-dev git

# 检查是否已安装 curl
if ! command -v curl &> /dev/null; then
    echo "未找到 curl，开始安装..."
    sudo apt-get install curl -y
    echo "curl 安装完成。"
else
    echo "curl 已安装，无需进行安装。"
fi

# 安装 SSR
git clone https://github.com/dgou45/shadowsocks-mod.git
cd shadowsocks-mod/
pip3 install -r requirements.txt
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
cd

# 安装加密
apt-get install build-essential
wget https://github.com/jedisct1/libsodium/releases/download/1.0.18-RELEASE/libsodium-1.0.18.tar.gz
tar xf libsodium-1.0.18.tar.gz && cd libsodium-1.0.18
./configure && make -j2 && make install
ldconfig
cd

# 是否安装v2ray
if [ "$install_v2" != "N" ] && [ "$install_v2" != "n" ]; then
    # 安装v2ray
    cd
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
    # 下载v2ray配置文件
    wget -O /usr/local/etc/v2ray/config.json https://github.com/dgou45/fhs-install-v2ray/raw/ssr/config-v2ray.json
fi

# 开启 BBR
if sysctl net.ipv4.tcp_available_congestion_control | grep -q 'bbr'; then
    echo "BBR 已启用，无需重复开启"
else
    echo "BBR 未启用，正在开启 BBR"
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    sysctl net.ipv4.tcp_available_congestion_control
    lsmod | grep bbr
fi

# 添加定时任务
{ echo "@reboot sh /root/shadowsocks-mod/run.sh"; echo "@reboot /bin/systemctl restart v2ray.service";echo "0 22 * * 0 /sbin/reboot";echo "0 22 * * * /bin/systemctl restart v2ray.service";echo "0 22 * * * sh /root/shadowsocks-mod/stop.sh && sh /root/shadowsocks-mod/run.sh"; } | EDITOR="tee" crontab -

# 修改ssr节点ID
sudo sed -i "s|NODE_ID = 0|NODE_ID = $node_id|" /root/shadowsocks-mod/userapiconfig.py

echo "所有命令执行成功"



