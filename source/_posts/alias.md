title: 自用配置备份
cover: /img/posts/tux.svg
date: 2024-10-17 13:20:00
categories: [Linux]
tags: [Linux,Shell]
-------------------------------


<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelector('.post-copyright__author_img_front').src = '/img/site/ava.jpg'
    })
</script>
# zsh基本配置

```bash
# 语言
export LANG=zh_CN.UTF-8

# NVM设置
[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec

# p10k配置
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh配置
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git history)
autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zshistory
HISTSIZE=10000
SAVEHIST=10000
# End of lines configured by zsh-newuser-install
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
```

# Alias

```bash

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
alias epems="zsh ${apiclo}/Desktop/EPEMS/init.sh"
alias sbr="cd ${apiclo}/Desktop/EPEMS/epems/ && mvn spring-boot:run"
alias nrs="cd ${apiclo}/Desktop/EPEMS/epems_front/ && npm run serve"
alias nrb="cd ${apiclo}/Desktop/EPEMS/epems_front/ && npm run build"

# 网络服务
alias frpc="${apiclo}/.git/frpc/frpc_linux_amd64 -u u -p p"
alias router="ssh root@192.168.100.1"
alias captive="ssh root@192.168.100.1 \"bash portal.sh\""
alias caplog="ssh root@192.168.100.1 \"cat portal.log\""



```

# 绑定常用按键

```bash
# 按键重新绑定
# key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history

# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

# Fix numeric keypad
# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[On" "."
bindkey -s "^[OM" "^M"
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + - * /
bindkey -s "^[Ol" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"


```

# 某不知名软件配置规则
```yaml
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
