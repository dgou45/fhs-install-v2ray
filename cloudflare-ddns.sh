#!/bin/bash
set -e

# 删除脚本自身
rm -- "$0"

# 与用户交互输入域名
echo "请输入域名（tw1.example.com）："
read domain

# 检查用户是否取消输入
if [[ -z "$domain" ]]; then
    echo "没有输入，退出脚本。"
    exit 0
fi

# 下载脚本
curl https://gist.githubusercontent.com/benkulbertis/fff10759c2391b6618dd/raw > /usr/local/bin/cf-ddns.sh && chmod +x /usr/local/bin/cf-ddns.sh

# 修改域名
sudo sed -i "s/^#*record_name=.*/record_name= $domain/" /usr/local/bin/cf-ddns.sh

# 新增定时任务
(crontab -l ; echo "* * * * * /usr/local/bin/cf-ddns.sh >/dev/null 2>&1") | crontab -






