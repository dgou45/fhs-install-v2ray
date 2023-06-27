#!/bin/bash
set -e

# 删除脚本自身
rm -- "$0"

wget -O /root/web_transfer01.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/web_transfer01.py
wget -O /root/web_transfer02.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/web_transfer02.py

wget -O /root/tcprelay01.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/tcprelay01.py
wget -O /root/tcprelay02.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/tcprelay02.py

web_transfer01="/root/web_transfer01.py"
web_transfer02="/root/web_transfer02.py"
web_transfer="/root/shadowsocks-mod/web_transfer.py"

tcprelay01="/root/tcprelay01.py"
tcprelay02="/root/tcprelay02.py"
tcprelay="/root/shadowsocks-mod/shadowsocks/tcprelay.py"


# 比较 tcprelay 是否相同
if cmp -s "$tcprelay01" "$tcprelay"; then
    echo "与 tcprelay01 相同，开启替换"
    wget -O /root/shadowsocks-mod/web_transfer.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/web_transfer1.py
    wget -O /root/shadowsocks-mod/shadowsocks/tcprelay.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/tcprelay1.py
elif cmp -s "$tcprelay02" "$tcprelay"; then
    echo "与 tcprelay02 相同，开启替换"
    wget -O /root/shadowsocks-mod/web_transfer.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/web_tranfer2.py
    wget -O /root/shadowsocks-mod/shadowsocks/tcprelay.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/tcprelay2.py
else
    echo "tcprelay 与任何类型都不相同"
    exit 0
fi

cd /root/shadowsocks-mod && ./stop.sh && ./run.sh && cd


rm web_transfer*
rm tcprelay*

echo "所有命令执行成功！"




