#!/bin/bash
log="err.log"
touch ${log}
timemark=$(date +"%Y年%m月%d日 %H:%M:%S")
function ConnectionCheck {
    captiveresp=$(curl -Ls --connect-timeout 10 https://apiclo.github.io/services/captive/)
    if [[ ${captiveresp} == *"<!--Connected-->"* ]]; then
        connection="1"
    else
        connection="0"
    fi
}

function Logger {
    if [[ ${connection} == "1" ]]; then
        result="网络正常"
        echo -e "--------------------------------\n检测时间:${timemark}\n网络状态:${result}\n\n" >>${log}
    else
        result="网络异常"
        echo -e "--------------------------------\n检测时间:${timemark}\n网络状态:${result}\n\n" >>${log}
    fi

}
function Clog {
    if [[ $(date +"%m") -eq "01" ]]; then
        if [[ $(date +"%d") -eq "01" ]]; then
            if [[ $(date +"%H") -eq "00" ]]; then
                if [[ $(date +"%M") -eq "00" ]]; then
                    echo -e "日志已经在${timemark}刷新\n" >${log}
                fi
            fi
        fi
    fi
}
function Run {
    ConnectionCheck
    Logger
    Clog
    cat ${log}
    if [[ ${connection} == "0" ]]; then
        reboot
    fi
    exit 0
}
Run
