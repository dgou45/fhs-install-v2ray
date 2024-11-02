#!/bin/bash
set -e

# 更新脚本1.03
cd /root
wget -N https://github.com/dgou45/fhs-install-v2ray/releases/download/v2ray/update-v2ray.sh

# 授予脚本权限
chmod +x update-v2ray.sh

echo "......"
echo "......"
echo "......"
echo -e "\033[32m恭喜您，\033[33m所有命令执行成功！\033[0m"
