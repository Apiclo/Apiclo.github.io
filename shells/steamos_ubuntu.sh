#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'
reset_terminal=$(tput sgr0)
clear
# 英文且只供ubuntu使用
# 因为在尝试只在Ubuntu Server 22.04 LTS 中使用，中文无法显示
# 优化用户输入方法
function get_user_input {
    local prompt_message=$1
    local user_input=""
    # 只能输入 y/n|1/2
    while true; do
        echo -ne "$prompt_message" && read -r -p ":" user_input
        user_input=${user_input:-y}
        user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')

        case "$user_input" in
        y | 1)
            echo "y"
            return 0
            ;;
        n | 2)
            echo "n"
            return 0
            ;;
        *)
            echo "Invalid input，Please input 'y' or 'n'."
            ;;
        esac
    done
}
# 检查操作系统
function checkOS() {
    os_type=$(uname -s)
    if [ "$os_type" = "Linux" ]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            os_release=$ID
        else
            echo "Can't detect your distro"
        fi
    else
        os_release="unknown"
    fi
    os_architecture=$(uname -m)
    os_kernel=$(uname -r)
    os_hostname=$(uname -n)
    os_internal_ip=$(hostname -i | awk '{print $1}')
    # 获取显卡信息
    function detectGPU {
        vga_info=$(lspci | grep -i vga)
        brand=$(echo "$vga_info" | grep -o -i 'AMD\|NVIDIA\|Intel' | tr '[:upper:]' '[:lower:]')
        echo $brand
    }

    echo -e "${BLUE}OS:${NC} $os_type"
    echo -e "${BLUE}Distro:${NC} $os_release"
    echo -e "${BLUE}Arch:${NC} $os_architecture"
    echo -e "${BLUE}Kernel:${NC} $os_kernel"
    echo -e "${BLUE}GPU Brand:${NC} $(detectGPU)"
    echo -e "${BLUE}Hostname:${NC} $os_hostname"
    echo -e "${BLUE}Local IP:${NC} $os_internal_ip"
    # 写在这里是为了就算网络不好也可以回声前几行内容
    gpu=$(detectGPU)
    if [ "$gpu" = "amd" ]; then
        echo -e "${GREEN}You are using an AMD GPU${NC}"
    elif [ "$gpu" = "nvidia" ]; then
        echo -e "${GREEN}You are using a NVIDIA显卡,Valve indeed confirmed that gamescope works well on NVIDIA,But beacause of gamescope-session is a wayland session,you may see black screen or jump back to your Desktop Manager${NC}"
    else
        echo -e "${GREEN}You are using an Intel GPU or Dual GPUs or Virtual GPU${NC}"
    fi
    if [os_release != "ubuntu"]; then
        echo -e "${RED}This shell script only works on Ubuntu GNU/Linux${NC}"
        exit 1
    fi
}
# 检查工作目录
function checkDir {
    cd ~/
    if [ -d ~/gamescope/git ]; then
        cd ~/gamescope
        if [ -d git ]; then
            cd ~/gamescope
        else
            mkdir -p ~/gamescope/git
            cd ~/gamescope
        fi
    else
        mkdir -p ~/gamescope
        mkdir -p ~/gamescope/git
        cd ~/gamescope

    fi
}
# 检查运行环境
function checkEnviroment {
    echo -e "${BLUE}\n Checking OS Environment...${NC}"
    gamescope_status='not_installed'
    env_status='broken'
    if gamescope --version &>/dev/null; then
        echo -e "${GREEN}gamescope has already installed!${NC}" && gamescope_status='installed'
    else
        echo -e "${RED}gamescope did not installed!${NC}"
    fi

    if [ "$gamescope_status" = 'installed' ]; then
        echo -e "${GREEN}Still working...${NC}" && env_status='full'
    else
        echo -e "${RED}your environment is brocken ,please check gamescope installtion or 运行环境不完整,尝试安装依赖和gamescope${NC}"
        echo -e "${YELLOW}依赖安装完成后需要重新运行脚本!${NC}"
        # 安装Gamescope
        function installGamescope() {
            selected_url=""
            # 选择安装源
            function chooseSource() {
                echo -e "${BLUE}There are 2 versions of gamescope package\n${NC}"
                echo -e "${BLUE}ValveSoftware:${NC} \n      https://github.com/ValveSoftware/gamescope"
                echo -e "${BLUE}ChimeraOS:${NC}\n      https://github.com/ChimeraOS/gamescope"
                echo -ne "${BLUE}\n Choose a gamescope version:${NC} \n (1:ValveSoftware, 2:ChimeraOS)"
                gs_source=""
                gs_source=$(get_user_input)
                if [ "$gs_sources" = "y" ]; then
                    echo -e "${BLUE}You have choosen ValveSoftware version${NC}"
                    selected_url='https://github.com/ValveSoftware/gamescope.git'
                else
                    echo -e "${BLUE}You have choosen ChimeraOS version${NC}"
                    selected_url='https://github.com/ChimeraOS/gamescope.git'
                fi
            }
            echo -e "${BLUE}Install gamescope${NC}"
            chooseSource
            cd ~/gamescope/git
            git clone ${selected_url}
            cd gamescope
            git submodule update --init
            meson build/
            ninja -C build/
            meson install -C build/ --skip-subprojects
            if [ $? -eq 0 ]; then
                echo -e "${BLUE}Install gamescope complete!${NC}"
                cd ~/gamescope
                gamescope_status='installed'
                env_status='full'
            else
                echo -e "${RED}Install gamescope failed!${NC}"
                cd ~/gamescope
                gamescope_status='broken'
                env_status='broken'
            fi
        }
        # 确认依赖安装情况
        function confirm {
            if [ ${dependencies} = 'full' ]; then
                echo -e "${GREEN}Seems dependencies  have installed correctly!${NC}"
                installGamescope
            else
                echo -e "${YELLOW}Seems dependencies  have not installed!${NC}"
                echo -ne "${YELLOW}confirm that all dependices have installed? ${NC}(y:Yes; n:No)" && is_gs_success=""
                is_gs_success=$(get_user_input)

                if [ ${is_gs_success} = 'y' ]; then
                    echo -e "Still working..."
                    installGamescope
                else
                    echo -e "${YELLOW}Please ensure dependices have fully installed!${NC}"
                    echo -e "${BLUE}You may need install these packages(以pacman的包举例,数据来自AUR):${NC}"
                    echo "mangohud ninja-build meson libavif libbenchmark libdisplay-info1 libevdev-dev libgav1-1 libgudev-1.0-dev libmtdev-dev libseat1 libstb0 libwacom-dev libxcb-ewmh2 libxcb-shape0-dev libxcb-xfixes0-dev libxmu-headers libyuv0 libx11-xcb-dev libxres-dev libxmu-dev libseat-dev libinput-dev libxcb-composite0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-res0-dev libcap-dev"
                    echo "\n"
                    echo -ne "${YELLOW}You are trying to force install gamescope,continue?${NC}" && is_force_install=""
                    is_force_install=$(get_user_input "(y/n)")
                    if [ ${is_force_install} = 'y' ]; then
                        echo -e "${YELLOW}gamescope may install failed,steamOS session may not work!${NC}"
                        installGamescope
                    else
                        echo "stoped"
                        exit 0
                    fi
                fi
            fi
        }

        sudo apt-get update
        sudo apt install -y git mangohud meson ninja-build libavif libbenchmark libdisplay-info1 libevdev-dev libgav1-1 libgudev-1.0-dev libmtdev-dev libseat1 libstb0 libwacom-dev libxcb-ewmh2 libxcb-shape0-dev libxcb-xfixes0-dev libxmu-headers libyuv0 libx11-xcb-dev libxres-dev libxmu-dev libseat-dev libinput-dev libxcb-composite0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-res0-dev libcap-dev
        sudo apt-get install -y wayland-client meson libbenchmark1.8.3 libdisplay-info1 libevdev-dev libgav1-1 libgudev-1.0-dev libmtdev-dev libseat1 libstb0t64 libwacom-dev libxcb-ewmh2 libxcb-shape0-dev libxcb-xfixes0-dev libxmu-headers libyuv0 libx11-xcb-dev libxres-dev libxmu-dev libseat-dev libinput-dev libxcb-composite0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-res0-dev libcap-dev
        if [ $? -eq 0 ]; then
            dependencies='full'
        else
            dependencies='broken'
        fi
        confirm
        exec "$SHELL" -l
    fi
}

# 检查gamescope-session仓库
function checkGit() {
    git_scope="https://github.com/ChimeraOS/gamescope-session.git"
    git_steam="https://github.com/ChimeraOS/gamescope-session-steam.git"
    dir_scope="gamescope-session"
    dir_steam="gamescope-session-steam"
    # 询问函数
    function reclone() {
        cd ~/gamescope
        echo -ne "${YELLOW} file: ${1} need clone,continue?${NC}(y/n)" && is_reclone=""
        is_reclone=$(get_user_input)
        if [ "$is_reclone" = "y" ]; then
            cd ~/gamescope
            rm -rf ${dir_scope} ${dir_steam} &>/dev/null
            git clone $git_scope
            git clone $git_steam
            if [ $? -eq 0 ]; then
                git_status="full"
            else
                git_status="broken"
            fi
        else
            echo "cancel"
            return 1
        fi
    }

    echo -e "${BLUE}\n Checking content to install...${NC}"

    if [ -d "$dir_scope" ] && [ -d "$dir_steam" ]; then
        echo -e "${GREEN}source code is ready!${NC}" && git_status="full"
    elif [ -d "$dir_scope" ]; then
        reclone "${dir_steam}"
    elif [ -d "$dir_steam" ]; then
        reclone "${dir_scope}"
    else
        reclone "All files"
    fi
    cd ~/gamescope
}

# 处理安装文件
function copyFiles {
    dir_scope="gamescope-session"
    dir_steam="gamescope-session-steam"
    steam_session="/usr/share/wayland-sessions/gamescope-session-steam.desktop"

    echo -e "${BLUE}\n You need input your sudo password to continue!${NC}"
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
    sudo echo -e "${BLUE}\n Copy files...${NC}"
    # 复制基本文件
    sudo /bin/cp -rf ~/gamescope/${dir_scope}${file11} ${file11}
    sudo /bin/cp -rf ~/gamescope/${dir_scope}${file12} ${file12}
    sudo /bin/cp -rf ~/gamescope/${dir_scope}${file13} ${file13}
    sudo /bin/cp -rf ~/gamescope/${dir_scope}${file14} ${file14}
    sudo /bin/cp -rf ~/gamescope/${dir_scope}${file15} ${file15}
    # 复制steam会话文件
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file21} ${file21}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file22} ${file22}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file23} ${file23}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file24} ${file24}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file25} ${file25}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file26} ${file26}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file27} ${file27}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file28} ${file28}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file29} ${file29}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file210} ${file210}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file211} ${file211}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file212} ${file212}
    sudo /bin/cp -rf ~/gamescope/${dir_steam}${file213} ${file213}

    if [ -f "$file11" ] && [ -f "$file12" ] && [ -f "$file13" ] && [ -f "$file14" ] && [ -f "$file15" ] && [ -f "$file21" ] && [ -f "$file22" ] && [ -f "$file23" ] && [ -f "$file24" ] && [ -f "$file25" ] && [ -f "$file26" ] && [ -f "$file27" ] && [ -f "$file28" ] && [ -f "$file29" ] && [ -f "$file210" ] && [ -f "$file211" ] && [ -f "$file212" ] && [ -f "$file213" ]; then
        echo -e "${BLUE}Set permittion...${NC}"
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
        echo -e "${BLUE}complete!${NC}"
        file_status="full"
    else
        echo -e "${RED}\n1.files have broken,please copy files in ~/gamescope/${dir_scope}/usr to /usr${NC} by manual"
        echo -e "${RED}\n1.files have broken,please copy files in ~/gamescope/${dir_steam}/usr to /usr${NC} by manual"
        echo -e "${RED}\nfiles have broken,please check files that appered in "cp" command wether exist in ~/gamescope folder ${NC}"
        echo -e "${YELLOW}if not,you can try:change a network which can connect to GitHub,and then type this in your terminel:\n /bin/sh ~/steam-session.sh${NC}"
        file_status="broken"
    fi
    if [ $file_status = "full" ]; then
        # 修改 Display Manager显示内容
        sudo sed -i "s/^Name=.*/Name=SteamOS/" "$steam_session"
        sudo chmod +x $steam_session
        sudo sed -i "s/^Comment=.*/Comment=Take you to the SteamDeckLike big screen mode/" "$steam_session"
        sudo sed -i "s|^Exec=.*|Exec=/usr/bin/gamescope-session-plus steam|" "$steam_session"
        # 重载服务
        sudo systemctl --user daemon-reload
        # 删除符号链接
        sudo rm /usr/share/wayland-sessions/gamescope-session.desktop &>/dev/null

        echo -e "${GREEN}Complete!${NC}"
        echo -e "${BLUE}You can see the SteamOS session in lightDM after you logout${NC}"
    else
        echo -e "${RED}\n Files have lost ,installtion failed${NC}"
    fi
}
# 清理工作目录
function cleanDir {
    echo -ne "${YELLOW}\n Wanna remove files that cloned just now?(y/n)${NC}" && is_clean=""
    is_clean=$(get_user_input "")
    if [ "$is_clean" = "y" ]; then
        rm -rf ~/gamescope
        echo -e "${GREEN}Complete${NC}"
    else
        echo -e "${BLUE}Cancled${NC}"
        echo -e "${BLUE}files that cloned lays in ~/gamescope,you can remove by manual${NC}"
    fi
}
# 主要函数
function main {
    checkOS
    checkDir
    checkEnviroment
    if [ "${env_status}" = "full" ]; then
        checkGit
    else
        echo -e "${RED}you hav not installed gamescope,please install by manual,stop install!${NC}"
        git_status="broken"
    fi

    if [ "${git_status}" = "full" ]; then
        copyFiles
    else
        echo -e "${RED}files are broken!${NC}"
    fi
    if [ -d ~/gamescope ]; then
        cleanDir
    else
        echo -e "${BLUE}Done!${NC}"
    fi
}

# 运行
main
