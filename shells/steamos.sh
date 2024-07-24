#!/bin/bash
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
        echo -ne "${YELLOW}文件${1}需要克隆,继续吗？ (y/n): ${NC}" && read is_reclone
		is_reclone=${is_reclone:-y}
        if [ "$is_reclone" = "y" ]; then
            cd ~/gamescope
            rm -rf ${dir_scope} ${dir_steam} &> /dev/null
            git clone $git_scope
            git clone $git_steam
            if [ $? -eq 0 ]; then
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
        reclone "${dir_scope}"
    else
        reclone "全部"
    fi
    cd ~/gamescope
}

function copyFiles {
	dir_scope="gamescope-session"
	dir_steam="gamescope-session-steam"
	steam_session="/usr/share/wayland-sessions/gamescope-session-steam.desktop"
	
	echo -e "${BLUE}需要sudo密码才能继续安装${NC}"
	file11='/usr/bin/export-gpu'
	file12='/usr/bin/gamescope-session-plus'
	file13='/usr/lib/systemd/user/gamescope-session-plus@.service'
	file14='/usr/share/gamescope-session-plus/gamescope-session-plus'
	file15='/usr/share/gamescope-session-plus/device-quirks'
	file21='/usr//bin/jupiter-biosupdate'
	file22='/usr/bin/steam-http-loader'
	file23='/usr/bin/steamos-select-branch'
	file24='/usr/bin/steamos-session-select'
	file25='/usr/bin/steamos-update'
	file26='/usr/bin/steamos-polkit-helpers/jupiter-biosupdate'
	file27='/usr/bin/steamos-polkit-helpers/steamos-select-branch'
	file28='/usr/bin/steamos-polkit-helpers/steamos-update'
	file29='/usr/share/applications/steam_http_loader.desktop'
	file210='/usr/share/applications/gamescope-mimeapps.list'
	file211='/usr/share/gamescope-session-plus/sessions.d/steam'
	file212='/usr/share/polkit-1/actions/org.chimeraos.update.policy'
	file213='/usr/share/wayland-sessions/gamescope-session-steam.desktop'

	sudo cp  ~/gamescope/${dir_scope}${file11}  ${file11}
	sudo cp  ~/gamescope/${dir_scope}${file12}  ${file12}
	sudo cp  ~/gamescope/${dir_scope}${file13}  ${file13}
	sudo cp  ~/gamescope/${dir_scope}${file14}  ${file14}
	sudo cp  ~/gamescope/${dir_scope}${file15}  ${file15}

	sudo cp  ~/gamescope/${dir_steam}${file21}  ${file21}
	sudo cp  ~/gamescope/${dir_steam}${file22}  ${file22}
	sudo cp  ~/gamescope/${dir_steam}${file23}  ${file23}
	sudo cp  ~/gamescope/${dir_steam}${file24}  ${file24}
	sudo cp  ~/gamescope/${dir_steam}${file25}  ${file25}
	sudo cp  ~/gamescope/${dir_steam}${file26}  ${file26}
	sudo cp  ~/gamescope/${dir_steam}${file27}  ${file27}
	sudo cp  ~/gamescope/${dir_steam}${file28}  ${file28}
	sudo cp  ~/gamescope/${dir_steam}${file29}  ${file29}
	sudo cp  ~/gamescope/${dir_steam}${file210}  ${file210}
	sudo cp  ~/gamescope/${dir_steam}${file211}  ${file211}
	sudo cp  ~/gamescope/${dir_steam}${file212}  ${file212}
	sudo cp  ~/gamescope/${dir_steam}${file213}  ${file213}
	sudo chmod +x ${file11}
	sudo chmod +x ${file12}
	sudo chmod +x ${file14}
	sudo chmod +x ${file21}
	sudo chmod +x ${file22}
	sudo chmod +x ${file23}
	sudo chmod +x ${file24}
	sudo chmod +x ${file25}
	sudo chmod +x ${file26}
	sudo chmod +x ${file27}
	sudo chmod +x ${file28}
	sudo chmod +x ${file29}
	sudo chmod +x ${file211}
	sudo chmod +x ${file213}
	
	if [ -f $steam_session ]; then
		sudo sed -i "s/^Name=.*/Name=SteamOS/" "$steam_session"
		sudo chmod +x $steam_session
		sudo sed -i "s/^Comment=.*/Comment=进入SteamDeck下的大屏幕模式/" "$steam_session"
		sudo rm /usr/share/wayland-sessions/gamescope-session.desktop &> /dev/null
		echo -e "${GREEN}安装完毕了!${NC}"
		echo -e "${BLUE}注销后在会话管理中即可进入SteamOS${NC}"
	else
		echo -e "${RED}1.安装失败,请手动将~/gamescope/${dir_scope}复制到/usr${NC}"
		echo -e "${RED}2.安装失败,请手动将~/gamescope/${dir_steam}复制到/usr${NC}"
	fi
}

function cleanDir {
	echo -e "${YELLOW}需要执行清理吗?(n/y)${NC}" && read is_clean
	is_clean=${is_clean:-n}
	if [ "$is_clean" = "y" ]; then
		rm -rf ~/gamescope
		echo -e "${GREEN}清理完毕${NC}"
	else
		echo -e "${BLUE}取消清理${NC}"
		echo -e "${BLUE}已下载的安装文件在~/gamescope,您可以手动删除${NC}"
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
