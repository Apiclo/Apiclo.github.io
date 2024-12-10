#!/bin/bash
server_ip=12.23.34.45
log="captive.log"
# 学号
userid=0123456789
# 密码
password="password"
touch ${log}
url="http://${server_ip}/eportal/InterFace.do?method=login"
timemark=$(date +"%Y年%m月%d日 %H:%M:%S")
function ConnectionCheck {
    captiveresp=$(curl -Ls --connect-timeout 10 http://captive.apple.com)
    if [[ ${captiveresp} == *"Success"* ]]; then
        connection="1"
    else
        connection="0"
    fi
}
function Captive {
    portalresp=$(curl -s "$url" \
        -H 'Connection: keep-alive' \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36 Edg/112.0.1722.68' \
        -H 'sec-ch-ua: "Google Chrome";v="126", "Chromium";v="126", "Not=A?Brand";v="24"' \
        -H 'sec-ch-ua-mobile: ?0' \
        -H 'sec-ch-ua-platform: "Windows"' \
        -H 'Accept: */*' \
        -H 'Cookie: EPORTAL_AUTO_LAND=true; EPORTAL_COOKIE_SAVELANINFO=true; EPORTAL_COOKIE_SAVEPASSWORD=true;' \
        -H "Referer: http://${server_ip}/" \
        -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
        --data-raw "userId=${userid}&password=${password}&service=&queryString=passwordEncrypt=false")
}
function Logger {
    if [[ ${connection} == "1" ]]; then
        result="网络正常"
    else
        if [[ ${portalresp} == *"已经在线"* ]]; then
            result="当前设备已登陆"
        elif [[ ${portalresp} == *'用户数量上限'* ]]; then
            result="其它设备已登陆"

        elif [[ ${portalresp} == *'"result":"success","message":""'* ]]; then
            result="认证成功"
        elif [[ ${portalresp} == *'欠费'* ]] || [[ ${portalresp} == *'缴费'* ]]; then
            result="账户已欠费,脚本停止\n若需要重新运行，请手动将loader.sh中# bash /root/captive.sh前的#删除\n并删除整行exit 0"
            echo -e '#!/bin/bash\nexit0\n# bash captive.sh' >loader.sh

        else
            result="认证失败，服务器返回:\n${portalresp}"
        fi
    fi
    echo -e "--------------------------------\n操作时间:${timemark}\n网络状态:${result}\n\n" >>${log}
}
function Clog {
    if [[ $(date +"%d") == "01" ]]; then
        echo -e "日志已经在${timemark}刷新\n" >${log}
    fi
}
function Run {
    ConnectionCheck
    if [[ ${connection} == "0" ]]; then
        Captive
    fi
    Logger
    Clog
    cat ${log}
    exit 0
}
Run
