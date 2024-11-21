#!/bin/bash
set -e

# 删除脚本自身
rm -- "$0"

file="/root/shadowsocks-mod/webapi_utils.py"

# 检查文件是否存在
if [ -f "$file" ]; then
    echo "文件 $file 存在."

    # 计算文件的 MD5 和 SHA1 校验值
    md5=$(md5sum "$file" | awk '{print $1}')
    sha1=$(sha1sum "$file" | awk '{print $1}')

    echo "MD5 校验值为: $md5"
    echo "SHA1 校验值为: $sha1"

    # 预设的MD5和SHA1值
    expected_md5="e96c6f729e4017f9b3bbc713946d7c06"
    expected_sha1="3b35483d3217e1c541e8842b47387769ff7e922d"

    # 比较校验和
    if [ "$md5" = "$expected_md5" ]; then
        echo "MD5 校验通过"
    else
        echo -e "\033[31mMD5 MD5 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
        echo -e "\033[31mMD5 MD5 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
        echo -e "\033[31mMD5 MD5 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
	echo -e "\a"  # 发出警告音
	exit 1
    fi

    if [ "$sha1" = "$expected_sha1" ]; then
        echo "SHA1 校验通过"
    else
        echo -e "\033[31mSHA1 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
        echo -e "\033[31mSHA1 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
        echo -e "\033[31mSHA1 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
	echo -e "\a"  # 发出警告音
	exit 1
    fi
else
    	echo "文件 $file 不存在."
     	echo -e "\a"  # 发出警告音
	exit 1
fi

file="/root/shadowsocks-mod/web_transfer.py"

# 检查文件是否存在
if [ -f "$file" ]; then
    echo "文件 $file 存在."

    # 计算文件的 MD5 和 SHA1 校验值
    md5=$(md5sum "$file" | awk '{print $1}')
    sha1=$(sha1sum "$file" | awk '{print $1}')

    echo "MD5 校验值为: $md5"
    echo "SHA1 校验值为: $sha1"

    # 预设的MD5和SHA1值
    expected_md5="90c11f451690fa94930c85c8281686c2"
    expected_sha1="9dafae633fb6e83a7d3a6744b56d9a1027d8ee1d"

    # 比较校验和
    if [ "$md5" = "$expected_md5" ]; then
        echo "MD5 校验通过"
    else
        echo -e "\033[31mMD5 MD5 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
        echo -e "\033[31mMD5 MD5 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
        echo -e "\033[31mMD5 MD5 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
	echo -e "\a"  # 发出警告音
	exit 1
    fi

    if [ "$sha1" = "$expected_sha1" ]; then
        echo "SHA1 校验通过"
    else
        echo -e "\033[31mSHA1 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
        echo -e "\033[31mSHA1 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
        echo -e "\033[31mSHA1 校验不匹配 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
	echo -e "\a"  # 发出警告音
	exit 1
    fi
else
    	echo "文件 $file 不存在."
     	echo -e "\a"  # 发出警告音
	exit 1
fi


echo "......"
echo "......"
echo "......"
echo -e "\033[32m恭喜您，\033[33m所有命令执行成功！\033[0m"