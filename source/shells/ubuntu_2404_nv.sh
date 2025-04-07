#!/bin/bash
# Ubuntu Nvidia
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'
reset_terminal=$(tput sgr0)
clear

echo -e "${YELLOW}You need a root user to run this script${NC}"
echo -e "${YELLOW}需要root用户来运行此脚本${NC}"
sudo -e echo "${GREEN}Starting Ubuntu Nvidia installation script${NC}"
echo "${GREEN}开始Ubuntu Nvidia安装脚本${NC}"
# 更新软件源
function update() {
    sudo add-apt-repository ppa:graphics-drivers/ppa
    sudo apt update
    sudo apt upgrade -y
    sudo apt dist-upgrade -y
}
# 安装Nvidia驱动
function nvidia() {
    sudo ubuntu-drivers autoinstall
    echo -e "${GREEN}Nvidia driver installation complete${NC}"
    echo -e "${GREEN}Nvidia驱动安装完成${NC}"

}
# 安装CUDA
function cuda() {
    # sudo apt-get install freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libgl1-mesa-glx libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dri
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
    sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.1-570.124.06-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.1-570.124.06-1_amd64.deb
    sudo cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
    sudo apt-get -y install cuda-toolkit-12-8 cuda-drivers

}
# 设置initramfs与引导项目
function initramfs() {
    echo -e "blacklist nouveau\noptions nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
    sudo update-initramfs -u
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nouveau.modeset=0 psi=1 transparent_hugepages=1"/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    sudo update-grub
}
function install() {
    update
    nvidia
    cuda
    initramfs
}
function main() {
    echo -e "${GREEN}Starting installation...${NC}"
    echo -e "${GREEN}开始安装...${NC}"
    install
    echo -e "${RED}Reboot your system to apply the changes${NC}"
    echo -e "${RED}重新启动系统以应用更改${NC}"
    echo -e "${BLUE}Rebooting in 5 seconds...${NC}"
    echo -e "5秒后重新启动..."
    sleep 5
    sudo reboot
}
main
