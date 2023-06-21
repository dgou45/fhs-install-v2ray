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
fi

# 删除authorized_keys
sudo sh -c 'cat /dev/null > /root/.ssh/authorized_keys'

# 检查当前用户是否是 root
if [[ $EUID -ne 0 ]]; then
    echo "当前用户不是root。"

    # 尝试切换到root
    if sudo -n true 2>/dev/null; then
        echo "切换到root用户。"
        exec sudo su -
    else
        echo "无法切换到root用户。"

        # 要求用户输入密码以获取sudo权限
        echo "请输入sudo密码："
        if sudo true; then
            echo "切换到root用户。"
            exec sudo su -
        else
            echo "无效的sudo密码。请手动以root权限运行脚本。"
            exit 1
        fi
    fi
else
    echo "当前用户已是root。"
fi
