#!/bin/bash
set -e

# 查询v2ray版本
v2ray version

# 安裝執行檔和 .dat 資料檔
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

# 重启v2ray
cd && service v2ray restart


echo "......"
echo "......"
echo "......"
echo -e "\033[32m恭喜您，\033[33m所有命令执行成功！\033[0m"
