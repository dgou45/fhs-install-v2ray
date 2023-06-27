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


# 比较 web_transfer 和 tcprelay 是否相同
if cmp -s "$web_transfer" "$web_transfer01" && cmp -s "$tcprelay" "$tcprelay01"; then
    wget -O /root/shadowsocks-mod/web_transfer.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/web_transfer1.py
    wget -O /root/shadowsocks-mod/shadowsocks/tcprelay.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/tcprelay1.py
    echo "web_transfer 与 web_transfer02 相同，且 tcprelay 与 tcprelay02 相同，替换完成！"
elif cmp -s "$web_transfer" "$web_transfer02" && cmp -s "$tcprelay" "$tcprelay02"; then
    wget -O /root/shadowsocks-mod/web_transfer.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/web_transfer2.py
    wget -O /root/shadowsocks-mod/shadowsocks/tcprelay.py https://github.com/dgou45/fhs-install-v2ray/raw/ssr/update/tcprelay2.py
    echo "web_transfer 与 web_transfer02 相同，且 tcprelay 与 tcprelay02 相同，替换完成！"
else
    echo "web_transfer 或 tcprelay 与任何类型都不相同！"
    exit 0
fi

cd /root/shadowsocks-mod && ./stop.sh && ./run.sh && cd
echo "重启服务..."

rm web_transfer*
rm tcprelay*
echo "删除文件成功！"

echo "所有命令执行成功！"




