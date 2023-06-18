#!/bin/bash

# 删除脚本自身
rm -- "$0"

# 清空命令历史
clear_command_history() {
  history -c
  rm -rf "$HISTFILE"
  history -w
  history -c
}


# 删除执行清除脚本的命令历史记录
delete_clear_script_command_history() {
  local clear_script_command="wget https://github.com/dgou45/fhs-install-v2ray/raw/ssr/clear.sh && chmod +x clear.sh && ./clear.sh"
  local line_number=$(history | grep -n "$clear_script_command" | awk '{print $1}' FS=":")
  
  if [ -n "$line_number" ]; then
    history -d "$line_number"
  fi
}

# 重启
echo "是否重启以彻底删除数据？输入N或n不重启，否则为重启："
read -t 10 isDo

# 删除ssr-mod+libsodium
shred -zvu -n 5 /root/shadowsocks-mod/userapiconfig.py
rm -rf /root/shadowsocks-mod
rm -rf /root/libsodium*
rm -rf /root/bbr.sh
rm -rf /root/install_bbr.log

# 删除V2ray
shred -zvu -n 5 /usr/local/etc/v2ray/config.json
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove
rm -rf /usr/local/etc/v2ray
rm -rf /var/log/v2ray

# 删除定时任务
crontab -r

# 删除命令历史
rm -rf ~/.bash_history
history -c

# 重启
if [ "$isDo" != "N" ] && [ "$isDo" != "n" ]; then
    echo "正在重启..."
    echo "所有命令执行成功"
    clear_command_history
    reboot
else
    echo "取消重启"
    echo "所有命令执行成功"
    clear_command_history
fi



