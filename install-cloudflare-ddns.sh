#!/bin/bash
set -e

# 删除脚本自身
rm -- "$0"

# 与用户交互输入域名
echo "请输入子域名，例如域名是 tw1.example.com，就输入 tw1："
read domain

# 检查用户是否取消输入
if [[ -z "$domain" ]]; then
    echo "没有输入，退出脚本。"
    exit 0
fi

# 下载脚本
curl https://gist.githubusercontent.com/benkulbertis/fff10759c2391b6618dd/raw > /usr/local/bin/cf-ddns.sh && chmod +x /usr/local/bin/cf-ddns.sh

# 修改域名
sudo sed -i "s|record_name=\"www.example.com\"|record_name=\"$domain.$3\"|" /usr/local/bin/cf-ddns.sh

# 修改auth
if [ -n "$1" ]; then
	sudo sed -i "s|auth_email=\"user@example.com\"|auth_email=$1|" /usr/local/bin/cf-ddns.sh
else
	echo -e "\033[31m没有获取到参数1，请手动修改！\033[0m"
fi

if [ -n "$2" ]; then
	sudo sed -i "s|auth_key=\"c2547eb745079dac9320b638f5e225cf483cc5cfdda41\"|auth_key=$2|" /usr/local/bin/cf-ddns.sh
else
	echo -e "\033[31m没有获取到参数2，请手动修改！\033[0m"
fi

if [ -n "$3" ]; then
	sudo sed -i "s|zone_name=\"example.com\"|zone_name=$3|" /usr/local/bin/cf-ddns.sh
else
	echo -e "\033[31m没有获取到参数3，请手动修改！\033[0m"
fi

# 运行脚本
bash /usr/local/bin/cf-ddns.sh

# 新增定时任务
(crontab -l ; echo "* * * * * /usr/local/bin/cf-ddns.sh >/dev/null 2>&1") | crontab -

echo -e "\033[32m恭喜您，\033[33m所有命令执行成功！\033[0m"






