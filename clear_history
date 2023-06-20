#!/bin/bash

# 删除脚本自身
rm -- "$0"

# 删除命令历史
rm -rf ~/.bash_history
history -c

# 重启
if [ "$1" != "N" ] && [ "$1" != "n" ]; then
    echo "正在重启..."
    echo "所有命令执行成功"
    reboot
else
    echo "取消重启"
    echo "所有命令执行成功"
fi
