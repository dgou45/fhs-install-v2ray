#!/bin/bash
set -e

# 删除脚本自身
rm -- "$0"

# 检查是否已经安装了sudo
if ! command -v sudo &> /dev/null; then
    echo "sudo 未安装，正在安装..."
    # 安装sudo
    apt-get update
    apt-get install -y sudo
else
    echo "sudo 已经安装。"
fi

# 与用户交互输入新密码
read -s -p "请输入新的 root 密码，回车跳过：" new_password
echo

# 检查用户是否取消输入
if [[ -z "$new_password" ]]; then
    echo "没有输入，取消修改密码。"
else
    # 使用输入的密码修改 root 密码
    echo -e "$new_password\n$new_password" | sudo passwd root

    # 检查修改密码的结果
    if [[ $? -eq 0 ]]; then
        echo "root 密码已成功修改。"
    else
        echo "修改 root 密码失败。"
        exit 1
    fi
fi

# 获取节点ID
valid_input=false
while [ "$valid_input" = false ]; do
    echo "请输入节点ID（默认为 0 ），回车跳过："
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
    echo "输入无效，请重新输入一个有效的数字，或按下确认键（默认为 0）！"
  fi
done

# 询问是否安装v2ray
read -p "是否安装v2ray？输入 N 或 n 不安装，否则为安装：" install_v2

if [[ "$install_v2" == "N" || "$install_v2" == "n" ]]; then
    echo "不安装v2ray。"
else
    echo "安装v2ray。"
fi

# 检查防火墙状态
if sudo ufw status | grep "Status: active"; then
    echo "防火墙已开启，将关闭防火墙..."
    sudo ufw disable
    echo "防火墙已关闭。"
else
    echo "防火墙未开启。"
fi

# 安装工具
apt update
apt install -y python3-pip libffi-dev libssl-dev git

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
    cd
    # 检查是否已安装 curl
    if ! command -v curl &> /dev/null; then
        echo "未找到 curl，开始安装..."
        sudo apt-get install curl -y
        echo "curl 安装完成。"
    else
        echo "curl 已安装，无需重复安装。"
    fi

    # 安装v2ray
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

# 设置IPv4优先
if [ -f "/etc/gai.conf" ]; then
    # 使用grep命令查找文件中是否包含搜索行
    if ! grep -qx "precedence ::ffff:0:0/96  100" "/etc/gai.conf"; then
        if grep -qx "#precedence ::ffff:0:0/96  100" "/etc/gai.conf"; then
            echo "修改IPv4优先设置"
            sudo sed -i "s|#precedence ::ffff:0:0/96  100|precedence ::ffff:0:0/96  100|" "/etc/gai.conf"
        else
            echo "添加IPv4优先设置"
            echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf
        fi
    else
        echo "IPv4优先已经存在，无需设置"
    fi
else
    echo "文件/etc/gai.conf不存在，无需设置IPv4优先"
fi

# 修改userapiconfig.py 
sudo sed -i "s|NODE_ID = 0|NODE_ID = $node_id|" /root/shadowsocks-mod/userapiconfig.py
sudo sed -i "s|MU_SUFFIX = 'zhaoj.in'|MU_SUFFIX = 'microsoft.com,www.icloud.com,www.apple.com,www.office.com,www.jd.hk,www.bing.com,cloudfront.com,cloudflare.com,ajax.microsoft.com'|" /root/shadowsocks-mod/userapiconfig.py 

if [ -n "$1" ]; then
    sudo sed -i "s|WEBAPI_URL = 'https://demo.sspanel.host'|WEBAPI_URL = $1|" /root/shadowsocks-mod/userapiconfig.py
else
    echo -e "\033[31m没有获取到修改userapiconfig.py的参数1，请手动修改！\033[0m"
fi

if [ -n "$2" ]; then
    sudo sed -i "s|WEBAPI_TOKEN = 'sspanel'|WEBAPI_TOKEN = $2|" /root/shadowsocks-mod/userapiconfig.py
else
    echo -e "\033[31m没有获取到修改userapiconfig.py的参数2，请手动修改！\033[0m"
fi

# 修改v2ray config
if [ "$install_v2" != "N" ] && [ "$install_v2" != "n" ]; then
    if [ -n "$3" ]; then
    	sudo sed -i "s|uuid-123456789|$3|" /usr/local/etc/v2ray/config.json
    else
    	echo -e "\033[31m没有获取到修改v2ray config的参数3，请手动修改！\033[0m"
    fi
fi

# 添加定时任务
(echo "@reboot sh /root/shadowsocks-mod/run.sh") | crontab -
(crontab -l ; echo "@reboot /bin/systemctl restart v2ray.service") | crontab -
(crontab -l ; echo "0 22 * * 0 /sbin/reboot") | crontab -
(crontab -l ; echo "0 22 * * * /bin/systemctl restart v2ray.service") | crontab -
(crontab -l ; echo "0 22 * * * sh /root/shadowsocks-mod/stop.sh && sh /root/shadowsocks-mod/run.sh") | crontab -

# 启动ssr
cd /root/shadowsocks-mod && ./stop.sh && ./run.sh && cd

# 启动v2ray
if [ "$install_v2" != "N" ] && [ "$install_v2" != "n" ]; then
    service v2ray restart
fi

echo "......"
echo "......"
echo "......"
echo -e "\033[32m恭喜您，\033[33m所有命令执行成功！\033[0m"





