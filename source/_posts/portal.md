title: 一个使用路由器向服务器发起Portal认证的脚本
cover: /img/posts/portal.jpg
date: 2024-09-17 21:40:00
categories: [Linux]
tags: [Network,Linux,Shell]
-------------------------------

# 前言

Portal认证一般指客户端连接某个网络时通过一个网页认证系统，通过认证后才能访问互联网。比如学校内网，需要先通过认证。本文将介绍如何使用路由器向服务器发起Portal认证。
一般情况下，在进行认证时，会向服务器发送一个POST请求，请求中包含用户名和密码等信息。服务器会验证这些信息，如果验证通过，则返回一个认证成功的响应，否则返回一个认证失败的响应。所以只需要在路由器上模拟这个POST请求即可。一般做法是在路由器上执行一个curl来模拟POST请求，所以只需要写一个脚本定义好服务器需要的参数并循环执行即可。
# 环境介绍
路由器型号：Xiaomi Redmi AC2100(RM2100)
路由器操作系统：OpenWrt 21.02-SNAPSHOT
网络环境：路由器WAN侧接入校园网RJ45面板，路由器LAN侧发射AP信号
# 必要条件
* 一台可以使用SSH客户端的设备
* 一个可以作为SSH服务器和执行Bash脚本的路由器（建议OpenWrt）
# 脚本功能介绍

1. 根据网络连接状态判断是否执行登陆认证操作
2. 每两分钟识别一次网络状态
3. 自动记录日志，可在ssh内输入cat captive.log来查看日志
4. 每个月1号会自动删除日志，不必担心日志文件过大，经过计算，最大只会达到1.63MiB
5. 欠费自动停止
# 食用方法：
1. 准备openwrt路由器，使用ssh连接路由器:在powershell中输入以下内容:ssh root@192.168.n.n(具体数字是路由器的IP)或安卓JuiceSSH连接路由器的SSH，出现[yes/no]时输入yes,要求密码时输入路由器后台管理密码。
2. 在路由器安装bash:`opkg update && opkg install bash`
3. 先创建一个文件：`echo -e "#!/bin/ash\nbash captive.sh" >loader.sh && chmod a+x loader.sh`
4. 使用vi编辑另一个文件:操作方式是先复制整个脚本，按以下按键(以|隔开)`vi captive.sh|i|粘贴|esc|:|wq|chmod a+x captive.sh`，关于粘贴快捷键:(powershell是鼠标右键，手机长按屏幕后在菜单选择粘贴)，[vi编辑器具体使用方法](https://www.runoob.com/linux/linux-vim.html)
5. 修改脚本内容，将`server_ip`改为Portal服务器的IP，`userid`改为你的学号，`password`改为你的密码。
6. 最后在路由器设置面板的crontab(aka:计划任务)写下这些:`*/2 * * * * /root/loader.sh`
# 脚本内容

```bash
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
    if [[ ${captiveresp} == *"<BODY>Success</BODY>"* ]]; then
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
        elif [[ ${portalresp} == *'欠费'* ]]; then
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

```

如果你对shell(bash方言)语法并不了解，请尽量不要更改注释,学号和密码以外的内容