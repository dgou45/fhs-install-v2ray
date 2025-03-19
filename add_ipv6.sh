#!/bin/bash

# 删除脚本自身
rm -- "$0"

# 验证 IPv6 地址格式的函数（确保输入不包含 /64）
validate_ipv6() {
    if [[ $1 =~ ^([0-9a-fA-F:]+:+)+[0-9a-fA-F]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# 获取 IPv6 地址
while true; do
    read -p "请输入IPv6地址: " IPv6
    IPv6=$(echo "$IPv6" | sed 's#/64##')  # 移除可能的 /64
    if validate_ipv6 "$IPv6"; then
        echo "IPv6 地址有效: $IPv6"
        break
    else
        echo "无效的 IPv6 地址，请重新输入！"
    fi
done

# 获取网关
while true; do
    read -p "请输入网关地址: " gateway
    gateway=$(echo "$gateway" | sed 's#/64##')  # 移除可能的 /64
    if validate_ipv6 "$gateway"; then
        echo "网关地址有效: $gateway"
        break
    else
        echo "无效的网关地址，请重新输入！"
    fi
done

# 禁用 cloud-init 网络管理，防止下次启动时覆盖网络配置
if [ ! -f "/etc/cloud/cloud-init.disabled" ]; then
    sudo touch /etc/cloud/cloud-init.disabled
    echo "已禁用 cloud-init"
fi

# 目标 Netplan 配置文件
NETPLAN_CONFIG="/etc/netplan/01-netcfg.yaml"

# 备份原配置
if [ -f "$NETPLAN_CONFIG" ]; then
    sudo cp "$NETPLAN_CONFIG" "$NETPLAN_CONFIG.bak"
    echo "已备份原配置文件到 $NETPLAN_CONFIG.bak"
fi

# 写入新的 Netplan 配置
sudo tee "$NETPLAN_CONFIG" > /dev/null <<EOF
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      dhcp6: false
      addresses:
        - $IPv6/64
      routes:
        - to: ::/0
          via: $gateway
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
          - 9.9.9.9
          - 2001:4860:4860::8888
          - 2606:4700:4700::1111
EOF

echo "新配置已写入 $NETPLAN_CONFIG"

# 设置正确权限
sudo chmod 600 "$NETPLAN_CONFIG"

# 应用 Netplan 配置
sudo netplan apply
echo "Netplan 配置已应用"

# 查看IPv6
IPv6=$(ip -6 addr show scope global | grep -v temporary | grep -oP '(?<=inet6\s)[0-9a-f:]+')
echo "您的公网IPv6地址是: $IPv6"

echo "......"
echo "......"
echo "......"
echo -e "\033[32m恭喜您，\033[33m所有命令执行成功！\033[0m"




