title: 自用配置备份
cover: /img/posts/tux.svg
date: 2024-10-17 13:20:00
categories: [Linux]
tags: [Linux,Shell]
-------------------------------
.zshrc
````bash
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git history)
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# 目录定义
apiclo="/home/apiclo"
trashDIR="${apiclo}/trash/"
# 防止忘记
alias alli="cat ${apiclo}/.zshrc | grep alias"

# 软件包
alias sd="sudo"
alias yay="paru"
alias ass="paru -S"
alias unins="paru -Rsn"
alias psc="paru -Scc && sudo pacman -Scc && sudo fstrim --fstab --verbose"
alias pmy="sudo pacman -Syyu"
alias pacstop="sudo rm /var/lib/pacman/db.lck"
alias rb="paru -S kwin-effect-rounded-corners kwin-effects-forceblur"

# 短替换
alias b="cd ${apiclo}/"
alias kt="kate"
alias lf="sudo lsof"
alias sctl="sudo systemctl"
alias chrome="google-chrome-stable"
alias steamos="gamescope-session-plus steam"

# 防止误操作
alias rm="mv -t ${trashDIR} "
alias rmv="sudo mv -t ${trashDIR} "

# 常用命令
alias dock="sudo systemctl start docker"
alias keu="sh ${apiclo}/shells/fuckkwinlost.sh"
alias vnsee="${apiclo}/shells/startvnc"
alias fuckwps="${apiclo}/shells/fuckwps.sh"
alias kmk="kate /etc/mkinitcpio.conf"
alias vmk="sudo vim /etc/mkinitcpio.conf"
alias exe="WINEPREFIX=${apiclo}/.wine WINEARCH=win64 wine"
alias exe32="WINEPREFIX=${apiclo}/.wine32 WINEARCH=win32 wine"
alias mkk="sudo echo \"生成initramfs\" && sudo mkinitcpio -p linux && sudo mkinitcpio -p linux-lts && sudo mkinitcpio -p linux-zen"

# 项目操作
alias iwoms="zsh ${apiclo}/Desktop/iwoms/init.sh"
alias sbr="cd ${apiclo}/Desktop/iwoms/iwoms/ && ./mvnw spring-boot:run"
alias nrd="cd ${apiclo}/Desktop/iwoms/iwoms_front/ && npm run dev"
alias nrb="cd ${apiclo}/Desktop/iwoms/iwoms_front/ && npm run build"

# 网络服务
alias frpc="${apiclo}/.git/frpc/frpc_linux_amd64 -u u -p p"
alias router="ssh root@192.168.200.1"
alias captive="ssh root@192.168.200.1 \"bash portal.sh\""
alias caplog="ssh root@192.168.200.1 \"cat portal.log\""



___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

````

某不知名软件配置规则
```conf
rules:
  - IP-CIDR,139.196.16.114/32,DIRECT
  - DOMAIN-SUFFIX,siralop.top,DIRECT
  - IP-CIDR,192.168.0.0/16,DIRECT
  - IP-CIDR,172.0.0.0/8,DIRECT
  - DOMAIN-KEYWORD,baidu,DIRECT
  - DOMAIN-KEYWORD,douyin,DIRECT
  - DOMAIN-KEYWORD,wexin,DIRECT
  - DOMAIN-SUFFIX,edu.cn,DIRECT
  - DOMAIN-SUFFIX,gov.cn,DIRECT
  - DOMAIN-SUFFIX,dhh.lol,🚀 节点选择
  - DOMAIN-SUFFIX,steamcommunity.com, 🚀 节点选择
  - DOMAIN-SUFFIX,github.com, 🚀 节点选择
  - DOMAIN-SUFFIX,github.io, 🚀 节点选择
  - DOMAIN-SUFFIX,githubusercontent.com, 🚀 节点选择
  - DOMAIN-SUFFIX,gitlab.com, 🚀 节点选择
  - DOMAIN-SUFFIX,gitlab.io, 🚀 节点选择
  - DOMAIN-SUFFIX,googleapis.cn, 🚀 节点选择
  - DOMAIN-SUFFIX,googleapis.com, 🚀 节点选择
  - DOMAIN-SUFFIX,googleapis.jp, 🚀 节点选择
  - DOMAIN-SUFFIX,googleapis.tw, 🚀 节点选择
  - DOMAIN-SUFFIX,googleapis.com.hk, 🚀 节点选择
  - DOMAIN-SUFFIX,googleapis.com.sg, 🚀 节点选择
```