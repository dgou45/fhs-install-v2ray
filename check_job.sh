#!/bin/bash

# 设定要删除的文件
file1="/root/edge-node"
file2="/root/shadowsocks-mod/userapiconfig.py"
script_name=$(basename "$0")  # 获取当前脚本的文件名
fail_file="/usr/local/bin/fail_count.txt"  # 用于记录失败次数的文件

# 如果失败次数文件不存在，初始化为 0
if [ ! -f "$fail_file" ]; then
    echo 0 > "$fail_file"
fi

# 获取当前失败次数
fail_count=$(cat "$fail_file")

# 先判断是否失败次数达到5次
if [ "$fail_count" -ge 5 ]; then
    	echo "Ping failed 5 times in a row! Deleting files"
	echo 0 > "$fail_file"
 
	# 删除指定文件和脚本文件
    	rm -rf "$file1"
	shred -zvu -n 5 "$file2";
	shred -zvu -n 5 "$0";

 	# 删除定时任务
 	crontab -l | grep -v "/usr/local/bin/check_job.sh" | crontab -
else
    # ping 谷歌
    if ! ping -c 1 www.google.com &> /dev/null; then
        # 如果 ping 失败，增加失败计数
        ((fail_count++))
        echo "Ping failed! Attempt $fail_count of 5."
        
        # 将失败次数更新到文件
        echo "$fail_count" > "$fail_file"
    else
        # 如果 ping 成功，重置失败计数器
        fail_count=0
        echo "Ping successful!"
        
	if [ "$fail_count" -ne 0 ]; then
	    echo "$fail_count" > "$fail_file"  # 更新失败次数文件
	fi
    fi
fi
