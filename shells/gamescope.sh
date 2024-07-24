#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'
reset_terminal=$(tput sgr0)
clear
function checkOS() {
    os_type=$(uname -s)
    if [ "$os_type" = "Linux" ]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            os_release=$ID
        else
            echo "无法检测操作系统发行版"
            exit 1
        fi
    else
        os_release="unknown"
    fi
    os_architecture=$(uname -m)
    os_kernel=$(uname -r)
    os_hostname=$(uname -n)
    os_internal_ip=$(hostname -i | awk '{print $1}')
	function detectGPU {
    	vga_info=$(lspci | grep -i vga)
    	brand=$(echo "$vga_info" | grep -o -i 'AMD\|NVIDIA\|Intel' | tr '[:upper:]' '[:lower:]')
    	echo $brand
	}

    echo -e "${BLUE}操作系统:${NC} $os_type"
    echo -e "${BLUE}发行版:${NC} $os_release"
    echo -e "${BLUE}处理器架构:${NC} $os_architecture"
    echo -e "${BLUE}内核:${NC} $os_kernel"
	echo -e "${BLUE}显卡品牌:${NC} $(detectGPU)"
    echo -e "${BLUE}主机名:${NC} $os_hostname"
    echo -e "${BLUE}内网IP地址:${NC} $os_internal_ip"
    # 写在这里是为了就算网络不好也可以回声前几行内容
    os_external_ip=$(curl -s http://myip.ipip.net/ | sed 's/[：, ]/:/g' | cut -f 3 -d ":")
    os_dns=$(grep -E "\<nameserver[ ]+" /etc/resolv.conf | awk '{print $NF}')
    echo -e "${BLUE}公网IP地址:${NC} $os_external_ip"
    echo -e "${BLUE}指定的DNS:${NC} $os_dns"
	echo -ne "${BLUE}GitHub连通性:${NC}"
    ping_add='github.com'
    os_connected=$(ping -c 2 $ping_add &> /dev/null && echo "可连接至GitHub" || echo "GitHub不可达")
    echo  "$os_connected"
}

function checkEnviroment {
    echo -e "${BLUE}开始检测运行环境...${NC}"
    gamescope_status='not_installed'
    env_status='broken'
    if gamescope --version &> /dev/null; then
        echo -e "${GREEN}gamescope已经安装${NC}" && gamescope_status='installed'
    else 
        echo -e "${RED}gamescope未安装${NC}"
    fi
    
    if [ "$gamescope_status" == 'installed' ]; then
        echo -e "${GREEN}运行环境完整${NC}" && env_status='full'
    else
        echo -e "${RED}运行环境不完整,尝试安装${NC}"
        os_release=$(grep -Eo 'ID=[a-z]+' /etc/os-release | cut -d '=' -f 2)
        gpu_brand=$(detectGPU)
        
        case "$os_release" in
            arch|manjaro|blackarch)
                echo "使用的是pacman包管理器, 使用pacman进行安装必要环境"
                sudo pacman -Syyu --noconfirm
                if [ "$gpu_brand" == "amd" ]; then
                    sudo pacman -S --noconfirm gamescope
                elif [ "$gpu_brand" == "nvidia" ]; then
                    sudo pacman -S --noconfirm gamescope
                else
                    sudo pacman -S --noconfirm gamescope
                fi
                ;;
            ubuntu|debian|deepin)
                echo "使用的是apt包管理器, 使用apt进行安装必要环境"
                sudo apt-get update
                if [ "$gpu_brand" == "amd" ]; then
                    sudo apt-get install -y gamescope
                elif [ "$gpu_brand" == "nvidia" ]; then
                    sudo apt-get install -y gamescope
                else
                    sudo apt-get install -y gamescope
                fi
                ;;
            fedora)
                echo "使用的是dnf包管理器, 使用dnf进行安装必要环境"
                sudo dnf update -y
                if [ "$gpu_brand" == "amd" ]; then
                    sudo dnf install -y gamescope
                elif [ "$gpu_brand" == "nvidia" ]; then
                    sudo dnf install -y gamescope
                else
                    sudo dnf install -y gamescope
                fi
                ;;
            centos|rhel)
                echo "使用的是yum包管理器, 使用yum进行安装必要环境"
                sudo yum update -y
                if [ "$gpu_brand" == "amd" ]; then
                    sudo yum install -y gamescope
                elif [ "$gpu_brand" == "nvidia" ]; then
                    sudo yum install -y gamescope
                else
                    sudo yum install -y gamescope
                fi
                ;;
            suse|opensuse)
                echo "使用的是zypper包管理器, 使用zypper进行安装必要环境"
                sudo zypper refresh
                if [ "$gpu_brand" == "amd" ]; then
                    sudo zypper install -y gamescope
                elif [ "$gpu_brand" == "nvidia" ]; then
                    sudo zypper install -y gamescope
                else
                    sudo zypper install -y gamescope
                fi
                ;;
            gentoo)
                echo "使用的是emerge包管理器, 使用emerge进行安装必要环境"
                sudo emerge --sync
                sudo emerge -av gamescope
                ;;
            alpine)
                echo "使用的是apk包管理器, 使用apk进行安装必要环境"
                sudo apk update
                sudo apk add gamescope
                ;;
            solus)
                echo "使用的是eopkg包管理器, 使用eopkg进行安装必要环境"
                sudo eopkg update-repo
                sudo eopkg install -y gamescope
                ;;
            void)
                echo "使用的是xbps包管理器, 使用xbps进行安装必要环境"
                sudo xbps-install -Syu
                sudo xbps-install -y gamescope
                ;;
            *)
                echo -e "${RED}未支持的操作系统,请手动安装以下包:${NC}"
                echo "gamescope"
                return
                ;;
        esac

        exec "$SHELL" -l
    fi
}

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
	echo -e "${BLUE}正在处理文件...${NC}"

	sudo /bin/cp -rf ~/gamescope/${dir_scope}${file11}  ${file11}
	sudo /bin/cp -rf ~/gamescope/${dir_scope}${file12}  ${file12}
	sudo /bin/cp -rf ~/gamescope/${dir_scope}${file13}  ${file13}
	sudo /bin/cp -rf ~/gamescope/${dir_scope}${file14}  ${file14}
	sudo /bin/cp -rf ~/gamescope/${dir_scope}${file15}  ${file15}

	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file21}  ${file21}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file22}  ${file22}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file23}  ${file23}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file24}  ${file24}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file25}  ${file25}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file26}  ${file26}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file27}  ${file27}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file28}  ${file28}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file29}  ${file29}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file210}  ${file210}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file211}  ${file211}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file212}  ${file212}
	sudo /bin/cp -rf ~/gamescope/${dir_steam}${file213}  ${file213}
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
	echo -e "${BLUE}文件处理完毕${NC}"
	if [ -f $steam_session ]; then
		sudo sed -i "s/^Name=.*/Name=SteamOS/" "$steam_session"
		sudo chmod +x $steam_session
		sudo sed -i "s/^Comment=.*/Comment=进入SteamDeck下的大屏幕模式/" "$steam_session"
		sudo sed -i "s|^Exec=.*|Exec=/usr/bin/gamescope-session-plus steam|" "$steam_session"
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
	checkOS
	checkEnviroment
	checkDir
	if [ "${env_status}" = "full" ]; then
		checkGit
	else
		echo -e "${RED}您没有安装gamescope,请手动安装,停止运行${NC}"
		git_status="broken"
	fi
	
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
