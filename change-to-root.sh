#!/bin/bash
set -e

# 删除脚本自身
rm -- "$0"

# 检查当前用户是否为root
if [ "$(id -u)" -ne 0 ]; then
    echo "当前用户不是 root 用户，正在进行权限设置..."

    # 修改 PasswordAuthentication 配置
    sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

    # 修改 PermitRootLogin 配置
    sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

    # 重启 SSH 服务
    sudo service sshd restart

    echo "权限设置完成。"
else
    echo "当前用户已经是 root 用户，无需进行权限设置。"
fi

# 与用户交互输入新密码
read -s -p "请输入新的 root 密码：" new_password
echo

# 检查用户是否取消输入
if [[ -z "$new_password" ]]; then
    echo "用户取消输入密码。"
    exit 0
fi

# 使用输入的密码修改 root 密码
echo -e "$new_password\n$new_password" | sudo passwd root

# 检查修改密码的结果
if [[ $? -eq 0 ]]; then
    echo "root 密码已成功修改。"
else
    echo "修改 root 密码失败。"
    exit 0
fi

# 检测操作系统类型，删除ssh key
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ $ID == "ubuntu" ]]; then
        # Ubuntu 系统执行命令1
        sudo sh -c 'cat /dev/null > /root/.ssh/authorized_keys'
        echo "删除Ubuntu authorized_keys成功"
    elif [[ $ID == "debian" ]]; then
        # Debian 系统执行命令2
        sudo sh -c 'cat /dev/null > /home/admin/.ssh/authorized_keys'
        echo "删除Debian authorized_keys成功"
    else
        echo "不受支持的操作系统"
        exit 1
    fi
else
    echo "未知的操作系统"
    exit 1
fi

echo -e "\033[32m恭喜您，\033[33m所有命令执行成功！\033[0m"






