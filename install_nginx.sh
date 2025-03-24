#!/bin/bash

set -e  # 遇到错误立即退出

# 检查是否以root权限运行
if [ "$(id -u)" != "0" ]; then
   echo -e "\033[31m此脚本需要 root 权限，请使用 sudo 运行。\033[0m"
   exit 1
fi

# 检查参数
if [ $# -lt 1 ]; then
    echo -e "\033[31m命令没有提供下载 stream_port.conf 的链接，请检查！\033[0m"
    exit 1
fi

echo "检查 Nginx 是否安装..."
if nginx -v >/dev/null 2>&1; then
    echo "Nginx 已经安装，版本：$(nginx -v 2>&1)"
	# 询问是否卸载
	read -p "是否重装 Nginx？（按下确定默认重装）[Y/n] " reinstall

	if [[ "$reinstall" == "N" || "$reinstall" == "n" ]]; then
		echo "不重装Nginx，退出脚本"
		exit 0
	else
		echo "重装Nginx..."
	fi
fi

echo "开始更新系统软件包..."
apt update -y

echo "安装 nginx..."
apt install -y nginx-full

echo "检查 Nginx 是否安装成功..."
if nginx -v >/dev/null 2>&1; then
    echo "Nginx 安装成功，版本：$(nginx -v 2>&1)"
else
    echo "Nginx 安装失败"
    exit 1
fi

echo "启动并设置 Nginx 开机自启..."
systemctl enable nginx
systemctl restart nginx

echo -e "\033[32mNginx 安装完成！\033[0m"

# 修改nginx，插入stream模块
CONFIG_FILE="/etc/nginx/nginx.conf"
BACKUP_FILE="/etc/nginx/nginx.conf.bak"

# 先备份
cp "$CONFIG_FILE" "$BACKUP_FILE"

# 检查是否已经包含 stream 配置
if grep -q "stream\s*{" "$CONFIG_FILE" && grep -q "resolver" "$CONFIG_FILE"; then
    echo "配置中已包含 stream 配置块，无需重复插入。"
else 
	# 临时文件
	TMP_FILE=$(mktemp)

	awk '
	/^[ \t]*http[ \t]*\{/ && !found {
		print "stream {"
		print "    # 解析器设置"
		print "    resolver 8.8.8.8 8.8.4.4 [2001:4860:4860::8888] [2001:4860:4860::8844] valid=60s ipv6=on;"
		print "    resolver_timeout 10s;"
		print ""
		print "    include /etc/nginx/stream_ports.conf;"
		print "}"
		print ""
		found = 1
	}
	{ print }
	' "$CONFIG_FILE" > "$TMP_FILE"

	mv "$TMP_FILE" "$CONFIG_FILE"

	echo -e "\033[32mNginx stream模块修改成功！\033[0m"
fi

wget -O /etc/nginx/stream_ports.conf $1

# 检查Nginx语法
echo "检查Nginx配置语法..."
if nginx -t; then
	echo "Nginx 配置语法正确，启动 Nginx"
	systemctl restart nginx && systemctl status nginx
else
	echo -e "\033[31mNginx 配置语法错误，请检查！\033[0m"
fi


echo "......"
echo "......"
echo "......"
echo -e "\033[32m恭喜您，\033[33m所有命令执行成功！\033[0m"

