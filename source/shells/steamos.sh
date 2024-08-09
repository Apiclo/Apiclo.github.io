#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'
reset_terminal=$(tput sgr0)
clear

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
            echo "无效输入，请输入 'y'或'n'."
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
            echo "无法检测操作系统发行版"
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

    echo -e "${BLUE}操作系统:${NC} $os_type"
    echo -e "${BLUE}发行版:${NC} $os_release"
    echo -e "${BLUE}处理器架构:${NC} $os_architecture"
    echo -e "${BLUE}内核:${NC} $os_kernel"
    echo -e "${BLUE}显卡品牌:${NC} $(detectGPU)"
    echo -e "${BLUE}主机名:${NC} $os_hostname"
    echo -e "${BLUE}内网IP地址:${NC} $os_internal_ip"
    # 写在这里是为了就算网络不好也可以回声前几行内容
    gpu=$(detectGPU)
    if [ "$gpu" = "amd" ]; then
        echo -e "${GREEN}您使用的是AMD显卡${NC}"
    elif [ "$gpu" = "nvidia" ]; then
        echo -e "${GREEN}您使用的是NVIDIA显卡,虽然Valve确认gamescope在NVIDIA下运行良好,但是由于gamescope-session创建在wayland会话下,可能会出现界面黑屏或者退回Display Manager的情况${NC}"
    else
        echo -e "${GREEN}您使用的是Intel显卡或虚拟设备${NC}"
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
    echo -e "${BLUE}\n开始检测运行环境...${NC}"
    gamescope_status='not_installed'
    env_status='broken'
    if gamescope --version &>/dev/null; then
        echo -e "${GREEN}gamescope已经安装${NC}" && gamescope_status='installed'
    else
        echo -e "${RED}gamescope未安装${NC}"
    fi

    if [ "$gamescope_status" = 'installed' ]; then
        echo -e "${GREEN}执行下一步骤${NC}" && env_status='full'
    else
        echo -e "${RED}运行环境不完整,尝试安装依赖和gamescope${NC}"
        echo -e "${YELLOW}依赖安装完成后需要重新运行脚本!${NC}"
        # 安装Gamescope
        function installGamescope() {
            selected_url=""
            # 选择安装源
            function chooseSource() {
                echo -e "${BLUE}gamescope有两个可选\n${NC}"
                echo -e "${BLUE}ValveSoftware:${NC} \n      https://github.com/ValveSoftware/gamescope"
                echo -e "${BLUE}ChimeraOS:${NC}\n      https://github.com/ChimeraOS/gamescope"
                echo -ne "${BLUE}\n选择gamescope分支${NC} \n (1:ValveSoftware, 2:ChimeraOS)"
                gs_source=""
                gs_source=$(get_user_input)
                if [ "$gs_sources" = "y" ]; then
                    echo -e "${BLUE}选择了ValveSoftware${NC}"
                    selected_url='https://github.com/ValveSoftware/gamescope.git'
                else
                    echo -e "${BLUE}选择了ChimeraOS${NC}"
                    selected_url='https://github.com/ChimeraOS/gamescope.git'
                fi
            }
            echo -e "${BLUE}开始安装gamescope${NC}"
            chooseSource
            cd ~/gamescope/git
            git clone ${selected_url}
            cd gamescope
            git submodule update --init
            meson build/
            ninja -C build/
            meson install -C build/ --skip-subprojects
            if [ $? -eq 0 ]; then
                echo -e "${BLUE}gamescope安装完毕${NC}"
                cd ~/gamescope
                gamescope_status='installed'
                env_status='full'
            else
                echo -e "${RED}gamescope似乎安装失败了${NC}"
                cd ~/gamescope
                gamescope_status='broken'
                env_status='broken'
            fi
        }
        # 确认依赖安装情况
        function confirm {
            if [ ${dependencies} = 'full' ]; then
                echo -e "${GREEN}依赖似乎已经安装完毕${NC}"
                installGamescope
            else
                echo -e "${YELLOW}依赖似乎不完整${NC}"
                echo -ne "${YELLOW}手动确认依赖是否安装成功${NC}(y:成功; n:未成功)" && is_gs_success=""
                is_gs_success=$(get_user_input)

                if [ ${is_gs_success} = 'y' ]; then
                    echo -e "执行后续步骤..."
                    installGamescope
                else
                    echo -e "${YELLOW}建议确保依赖完整!${NC}"
                    echo -e "${BLUE}你可能需要以下包(以pacman的包举例,数据来自AUR):${NC}"
                    echo "gcc-libs glibc libavif libcap.so=2-64 libdecor libdrm libinput libpipewire-0.3.so=0-64 libx11 libxcb libxcomposite libxdamage libxext libxfixes libxkbcommon.so=0-64 libxmu libxrender libxres libxtst libxxf86vm sdl2 seatd vulkan-icd-loader wayland xcb-util-errors xcb-util-wm xorg-server-xwayland"
                    echo "\n"
                    echo -ne "${YELLOW}要强行安装gamescope吗${NC}" && is_force_install=""
                    is_force_install=$(get_user_input "(y/n)")
                    if [ ${is_force_install} = 'y' ]; then
                        echo -e "${YELLOW}您可能会面临gamescope安装失败,steamOS会话黑屏等问题${NC}"
                        installGamescope
                    else
                        echo "取消安装"
                        exit 0
                    fi
                fi
            fi
        }

        case "$os_release" in
        arch | manjaro | blackarch)
            echo "使用的是pacman包管理器, 使用pacman进行安装必要依赖"
            sudo pacman -Syyu --noconfirm
            sudo pacman -S --noconfirm gcc-libs glibc libavif libcap.so=2-64 libdecor libdrm libinput libpipewire-0.3.so=0-64 libx11 libxcb libxcomposite libxdamage libxext libxfixes libxkbcommon.so=0-64 libxmu libxrender libxres libxtst libxxf86vm sdl2 seatd vulkan-icd-loader wayland xcb-util-errors xcb-util-wm xorg-server-xwayland
            if [ $? -eq 0 ]; then
                dependencies='full'
            else
                dependencies='broken'
            fi
            confirm
            ;;
        ubuntu | debian | deepin)
            echo "使用的是apt包管理器, 使用apt进行安装必要依赖"
            sudo apt-get update
            sudo apt-get install -y wayland-client meson libbenchmark1.8.3 libdisplay-info1 libevdev-dev libgav1-1 libgudev-1.0-dev libmtdev-dev libseat1 libstb0t64 libwacom-dev libxcb-ewmh2 libxcb-shape0-dev libxcb-xfixes0-dev libxmu-headers libyuv0 libx11-xcb-dev libxres-dev libxmu-dev libseat-dev libinput-dev libxcb-composite0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-res0-dev libcap-dev
            if [ $? -eq 0 ]; then
                dependencies='full'
            else
                dependencies='broken'
            fi
            confirm
            ;;
        fedora)
            echo "使用的是dnf包管理器, 使用dnf进行安装必要环境"
            sudo dnf update -y
            sudo dnf install libavif benchmark xorg-x11-utils libevdev-devel libgav1 gudev1-devel mtdev-devel libseat stb libwacom-devel libxcb-ewmh libxcb-devel libXmu-devel libyuv libX11-devel libXres-devel libseat-devel libinput-devel libxcb-ewmh-devel libxcb-icccm-devel libcap-devel
            if [ $? -eq 0 ]; then
                dependencies='full'
            else
                dependencies='broken'
            fi
            confirm
            ;;
        centos | rhel)
            echo "使用的是yum包管理器, 使用yum进行安装必要环境"
            sudo yum update -y
            sudo yum install -y libavif benchmark xorg-x11-utils libevdev-devel libgav1 libgudev1-devel mtdev-devel libseat stb libwacom-devel libxcb-ewmh libxcb-devel libXmu-devel libyuv libX11-devel libXres-devel libseat-devel libinput-devel libxcb-ewmh-devel libxcb-icccm-devel libcap-devel
            if [ $? -eq 0 ]; then
                dependencies='full'
            else
                dependencies='broken'
            fi
            confirm
            ;;
        suse | opensuse)
            echo "使用的是zypper包管理器, 使用zypper进行安装必要环境"
            sudo zypper refresh
            sudo zypper install -y libavif benchmark libdisplay-info libevdev-devel libgav1 libgudev-1_0-devel libmtdev-devel libseat libstb libwacom-devel libxcb-ewmh2 libxcb-shape0-devel libxcb-xfixes0-devel libxmu-headers libyuv libx11-xcb-devel libXRes-devel libXmu-devel libseat-devel libinput-devel libxcb-composite0-devel libxcb-ewmh-devel libxcb-icccm4-devel libxcb-res0-devel libcap-devel
            if [ $? -eq 0 ]; then
                dependencies='full'
            else
                dependencies='broken'
            fi
            confirm
            ;;
        gentoo)
            echo "使用的是emerge包管理器, 使用emerge进行安装必要环境"
            sudo emerge --sync
            sudo emerge -av sys-libs/libcap x11-libs/xcb-util x11-libs/xcb-util-wm x11-libs/xcb-util-wm x11-libs/libxcb dev-libs/libinput sys-libs/libseat x11-libs/libXres x11-libs/libX11 media-libs/libyuv x11-libs/libXmu x11-libs/xcb-util x11-libs/libxcb x11-libs/xcb-util-wm dev-libs/libwacom media-libs/stb media-libs/libavif dev-cpp/benchmark media-libs/libdisplay-info dev-libs/libevdev media-libs/libgav1 dev-libs/libgudev dev-libs/mtdev sys-libs/libseat
            if [ $? -eq 0 ]; then
                dependencies='full'
            else
                dependencies='broken'
            fi
            confirm
            ;;
        alpine)
            echo "使用的是apk包管理器, 使用apk进行安装必要环境"
            sudo apk update
            apk add libavif benchmark libevdev libgav1 libgudev libmtdev libseat libstb libwacom libxcb-ewmh libxcb libxmu libyuv libx11 libxres libinput libcap
            if [ $? -eq 0 ]; then
                dependencies='full'
            else
                dependencies='broken'
            fi
            confirm
            ;;
        solus)
            echo "使用的是eopkg包管理器, 使用eopkg进行安装必要环境"
            sudo eopkg update-repo
            sudo eopkg install -y libavif libbenchmark libdisplay-info libevdev libgav1 libgudev libmtdev libseat libstb libwacom libxcb-ewmh libxcb-shape libxcb-xfixes libxmu-headers libyuv libx11-xcb libxres libxmu libseat libinput libxcb-composite libxcb-ewmh libxcb-icccm libxcb-res libcap
            if [ $? -eq 0 ]; then
                dependencies='full'
            else
                dependencies='broken'
            fi
            confirm
            ;;
        void)
            echo "使用的是xbps包管理器, 使用xbps进行安装必要环境"
            sudo xbps-install -Syu
            sudo xbps-install -S libavif libbenchmark libdisplay-info libevdev-devel libgav1 libgudev-devel libmtdev-devel libseat libstb libwacom-devel libxcb-ewmh libxcb-shape-devel libxcb-xfixes-devel libxmu-headers libyuv libx11-xcb-devel libxres-devel libxmu-devel libseat-devel libinput-devel libxcb-composite-devel libxcb-ewmh-devel libxcb-icccm4-devel libxcb-res-devel libcap-devel
            if [ $? -eq 0 ]; then
                dependencies='full'
            else
                dependencies='broken'
            fi
            confirm
            ;;
        *)
            echo -e "${RED}未支持的发行版,跳过依赖安装,直接安装gamescope${NC}"
            confirm
            ;;
        esac

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
        echo -ne "${YELLOW}文件${1}需要克隆,继续吗?${NC}(y/n)" && is_reclone=""
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
            echo "取消克隆"
            return 1
        fi
    }

    echo -e "${BLUE}\n检查安装内容...${NC}"

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

# 处理安装文件
function copyFiles {
    dir_scope="gamescope-session"
    dir_steam="gamescope-session-steam"
    steam_session="/usr/share/wayland-sessions/gamescope-session-steam.desktop"

    echo -e "${BLUE}\n需要sudo密码才能继续安装${NC}"
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
    sudo echo -e "${BLUE}\n正在处理文件...${NC}"
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
        echo -e "${BLUE}正在处理执行权限...${NC}"
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
        file_status="full"
    else
        echo -e "${RED}\n1.安装文件不完整,请手动将~/gamescope/${dir_scope}/usr 复制到/usr${NC}"
        echo -e "${RED}2.安装文件不完整,请手动将~/gamescope/${dir_steam}/usr 复制到/usr${NC}"
        echo -e "${RED}\n安装文件缺失,请检查~/gamescope中是否存在上文cp命令中的文件${NC}"
        echo -e "${YELLOW}如果不存在,您可以尝试:更换一个可以顺畅连接到GitHub的网络之后运行以下命令:\n /bin/sh ~/steam-session.sh${NC}"
        echo -e "${BLUE}\n如果你使用的是Arch Linux,非常建议您通过AUR来安装\n paru -S gamescope-session-steam-git ${NC}"
        file_status="broken"
    fi
    if [ $file_status = "full" ]; then
        # 修改 Display Manager显示内容
        sudo sed -i "s/^Name=.*/Name=SteamOS/" "$steam_session"
        sudo chmod +x $steam_session
        sudo sed -i "s/^Comment=.*/Comment=进入SteamDeck下的大屏幕模式/" "$steam_session"
        sudo sed -i "s|^Exec=.*|Exec=/usr/bin/gamescope-session-plus steam|" "$steam_session"
        # 重载服务
        sudo systemctl --user daemon-reload
        # 删除符号链接
        sudo rm /usr/share/wayland-sessions/gamescope-session.desktop &>/dev/null

        echo -e "${GREEN}安装完毕了!${NC}"
        echo -e "${BLUE}注销后在会话管理中即可进入SteamOS${NC}"
    else
        echo -e "${RED}\n文件缺失,未成功安装${NC}"
    fi
}
# 清理工作目录
function cleanDir {
    echo -ne "${YELLOW}\n需要清理安装残留文件吗?(y/n)${NC}" && is_clean=""
    is_clean=$(get_user_input "")
    if [ "$is_clean" = "y" ]; then
        rm -rf ~/gamescope
        echo -e "${GREEN}清理完毕${NC}"
    else
        echo -e "${BLUE}取消清理${NC}"
        echo -e "${BLUE}已下载的安装文件在~/gamescope,您可以手动删除${NC}"
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

# 运行
main
