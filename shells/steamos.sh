#! /bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'
reset_terminal=$(tput sgr0)
clear
function checkDir {
	cd ~/
	if [ -d "gamescope" ]; then
		cd ~/gamescope
	else
		mkdir ~/gamescope && cd ~/gamescope
	fi
}

function checkGit() {
	git_scope="https://github.com/ChimeraOS/gamescope-session.git"
	git_steam="https://github.com/ChimeraOS/gamescope-session-steam.git"
	dir_scope="gamescope-session"
	dir_steam="gamescope-session-steam"
    function reclone() {
        echo -ne "${YELLOW}文件${1}需要克隆,继续吗？ (y/n): ${NC}" && read is_reclone && is_reclone=${is_reclone:-y}
        if [ "$is_reclone" = "y" ]; then
            cd ~/gamescope
            rm -rf ${dir_scope} ${dir_steam} &> /dev/null
            git clone $git_scope
            git clone $git_steam
            if [ $?=0 ]; then
				git_status="full"
			else
				git_status="broken"
			fi
        else
            echo "取消克隆"
            return 1
        fi
    }
	echo -e "${BLUE}获取安装内容...${NC}"
    if [ -d "$dir_scope" ] && [ -d "$dir_steam" ]; then
        echo -e "${GREEN}源码已就绪${NC}" && git_status="full"

    elif [ -d "$dir_scope" ]; then
		reclone "${dir_steam}"
    elif [ -d "$dir_steam" ]; then
        reclone "${YELLOW}${dir_scope}"
    else
        reclone "全部"
    fi
    cd ~/gamescope
}
function copyFiles {

	steam_session="/usr/share/wayland-sessions/gamescope-session-steam.desktop"
	echo -e "${BLUE}需要sudo密码才能继续安装${NC}"
	sudo cp -r ~/gamescope/${dir_scope}/usr/* /usr/
	sudo cp -r ~/gamescope/${dir_steam}/usr/* /usr/
	if [ -f $steam_session ]; then
		sudo sed -i "s/^Name=.*/Name=SteamOS/" "$steam_session"
		sudo chmod +x $steam_session
		sudo sed -i "s/^Comment=.*/Comment=进入SteamDeck下的大屏幕模式/" "$steam_session"
		echo -e "${GREEN}安装完毕了!${NC}"
		echo -e "${BLUE}注销后在会话管理中即可进入SteamOS${NC}"
	else
		echo -e "${RED}1.安装失败,请手动将~/gamescope/${dir_scope}复制到/usr${NC}"
		echo -e "${RED}2.安装失败,请手动将~/gamescope/${dir_steam}复制到/usr${NC}"
	fi
}
function cleanDir {
	echo -e "${YELLOW}需要执行清理吗?(n/y)${NC}" && read is_clean && is_clean=${is_clean:-n}
	if [ "$is_clean" = "y" ]; then
		rm -rf ~/gamescope
		echo -e "${GREEN}清理完毕${NC}"
	else
		echo -e "${BLUE}取消清理${NC}"
	fi

}
function main {
	checkDir
	checkGit
	if [ "${git_status}" = "full" ]; then
		copyFiles
	else
		echo -e "${RED}安装文件不完整,停止运行${NC}"
	fi
	if [ -d ~/gamescope ]; then
		cleanDir
	else
		echo -e "${BLUE}无残留文件,跳过安装后清理${NC}"
	fi
}
main

