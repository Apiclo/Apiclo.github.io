---
title: 将虚拟机迁移到物理机记录
cover: /img/posts/v2p.svg
date: 2024-5-18 18:29:39
categories: [Linux]
tags: [Linux, VMware, Windows]
---



将整块物理硬盘挂载到虚拟机内，执行

```bash
sudo dd if=/dev/sda of=/dev/sdb status=progress
```

等待十分钟，迁移完毕

此帖终结(bushi

写这篇文章之前我对Linux的了解并不多，所以才会出现下文中来回折腾的情况，实际只需要上面一条命令就完成了，并不需要那么麻烦…

# 前言

其实一开始用虚拟机感觉没问题，毕竟觉得Linux用的也不多，但是后来重要的生产工具(并没有)都只在虚拟机里搞了，实体机成了只看视频，打游戏的了，而且由于VMware只能用60hz的刷新率，总感觉卡卡的，所以才迁移到物理机。

请先喝杯咖啡，静下来思考三分钟你是否真的很需要Linux虚拟机转移到物理机，虚拟有虚拟的好处，物理机也有物理机的坏处，请权衡利弊后再操作。

我的方法当然不是最好最高效的，肯定会有更好的办法，我只是记录一下我折腾的过程，并不算是”教程”。如果你有更好或更简单的办法可以实现同样的预期成果，你也可以用更好的办法。

# 环境介绍

每个人的设备环境是不一样的，你能看到这篇文章，已经研究迁移虚拟机这种操作了，我相信你是有很强的动手能力和的思考能力的，我相信你会发现我们配置过程中的不同之处的，所以不要完全按我的办法来。

物理机和虚拟机都是EFI引导，如果不是,也无所谓,重建一下引导就好了,到最后都是需要重建引导的。

虚拟机和物理机都是nvme硬盘，如果不是也无所谓,只不过在linux中将nvmeXnYpZ换成sdXY就好了。

虚拟机所在的vmdk是一个文件，没有分多个文件，如果不是也无所谓,使用VMware内建的工具合并一下就好了。

实体机是windows11+windows10,虚拟机是archlinux，这个看每个人需求.我个人需要Windows11玩游戏,Windows10用ENSP,ArchLinux学习(折腾)。

# 准备工作

- [startwind Converter](https://www.starwindsoftware.com/starwind-v2v-converter#download)
- [DiskGenius](https://www.diskgenius.cn/download.php)
- [奥梅分区助手](https://www.disktool.cn/)
- 一个linux Live CD U盘（我用的是archlinux所以用的也是ArchLinux的Live CD）

# 操作步骤

1. 硬盘格式转换

在Windows 做好硬盘处理工作 先[使用startwind Converter将vmdk转换成vhdx](https://zhuanlan.zhihu.com/p/248434837)

2. 挂载虚拟磁盘

使用windows自带的磁盘管理挂[载vhdx](https://zhuanlan.zhihu.com/p/489743140)，这一步会报错，会提示分区损坏，忽略即可。

你会看到VHDX中有两个分区，一个没有损坏的ESP,一个损坏的Linux的根目录(如果你有其它分区，例如/home和/usr，也一并显示出来了)。(这里LinuxFS损坏是正常的,Windows没有做LinuxFS的相关驱动)

3. 创建空白分区

用奥梅分区助手在物理硬盘中分出一个空闲分区，大小不能小于转换后的vhdx文件中的/分区。不要格式化,(如果你Linux的/home分区是独立的,你需要对应的再新建一个分区,存放/home分区)。

4. 克隆分区

用任意硬盘克隆工具将挂载的vhdx硬盘中的/分区和你有其它有用的分区克隆到物理硬盘分区。/boot分区可以直接丢掉了，后续会使用物理机本身的ESP。

5. 重启前检查

检查一下分区有没有错误，一定要看一眼你的物理机ESP分区能不能放得下你Linux本来的/boot挂载点里的这些文件，特别是多内核的小伙伴。因为Windows自带的ESP分区只有300M，勉强才能放下一个Linux内核。如果你虚拟机使用的是/efi挂载点和/boot挂载点分开的话，就看一下能不能放的下/efi挂载点就好了。

6. 进入Live CD环境继续操作

关机，使用LiveCD U盘启动电脑。如果你在Live CD环境看到了audit xxxx在疯狂输出，可以用`audit -e0`让它闭嘴。进入Live CD后先来一手`ls /dev/`和`blkid`，列出所有物理机硬盘和UUID，拍个照或者找支笔记录好这些UUID，这些内容将对你非常重要，我的朋友。

7. 挂载分区

先使用fdisk -l看一下哪个分区是你刚刚克隆好的分区，使用 `mount /dev/nvmeXnYpZ /mnt/` 挂载Linux根目录，之后使用`mount /dev/nvmeXnYpZ /mnt/boot`挂载本就存在的EFI分区(aka:ESP)。

8. 进入系统

使用`arch-chroot /mnt`命令进入刚刚克隆好的文件系统。先编辑fstab，文件内写的UUID还是虚拟机的UUID，和物理机不相同，用vim改成和你物理机相同的UUID, 你也可以在这里挂载你的NTFS分区. 官方指南:[FSTAB](https://wiki.archlinuxcn.org/wiki/Fstab)  这里是一个示例

```jsx
# Static information about the filesystems.
# See fstab(5) for details.
 
# <file system> <dir> <type> <options> <dump> <pass>
# /dev/nvme1n1p2 ArchLinux rootfs
UUID=ea26a20b-fbe0-4be1-88dd-f7af3e9XXXXXX   /                           btrfs   rw,relatime                                                                                            0 1 
 
# /dev/nvme0n1p1 ESP
UUID=DA18-XXXX                              /boot                        vfat   rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,err rs=remount-ro   0 2 
# /dev/nvme0n1p2 Windows11
# UUID=65F33762C1XXXXXX                     /mnt/Windows11               ntfs   defaults                                                                                                0 0
# /dev/nvme0n1p3 Data
UUID=C0123EDB12XXXXXX                       /mnt/data512G                ntfs   uid=1000,gid=1000,rw,user,exec,umask=000                                                                0 0
# /dev/nvme1n1p2 Windows10
# UUID=4A62AE7262XXXXXX                     /mnt/Windows10               ntfs   defaults                                                                                                0 0
# /dev/nvme1n1p3 Data
UUID=4E8DF62023XXXXXX                       /mnt/data2TB                 ntfs   uid=1000,gid=1000,rw,user,exec,umask=000                                                                0 0
 

```

# 重建引导

如果你对重建引导没那么理解，请先[补一下课](https://wiki.archlinuxcn.org/wiki/Arch_%E7%9A%84%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B)

确保你现在屏幕上显示的终端是由Live CD中archiso使用chroot进入的之前虚拟机的终端(刚刚克隆的硬盘)，你可以使用`ls /home`看一下用户名是不是你之前虚拟机的用户名。

## 补全内核

在建立引导之前，原有的initramfs已经没了，先重新安装一个内核，使用`pacman -S linux`(或其它你喜欢的内核名)

## 单系统

如果要单系统重建引导，你将失去原有的Windows引导项(不推荐)。

首先你需要重新格式化/boot分区,然后重新挂载,这里可以直接参考

你可以选择很多引导方式,ArchLinux默认是由[systemd-boot](https://wiki.archlinuxcn.org/wiki/Systemd-boot)引导,其它Linux大多默认[GRUB](https://wiki.archlinuxcn.org/wiki/GRUB).如果是systemd-boot，建议按照ArchLinux的wiki的步骤来，执行`bootctl install`，如果没有出现错误，`ls /boot/EFI`你将会在你的物理机的ESP/EFI看到systemd的文件夹。systemd-boot

安装好systemd-boot后，再次[重建一下initramfs](https://wiki.archlinuxcn.org/wiki/Mkinitcpio)，毕竟很多虚拟机里的模块和钩子在实体机用不到，`vim /etc/mkinitcpio.conf`，将不需要的模块和钩子取消掉，然后运行一下
```bash
mkinitcpio -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img
```


手动编写`/boot/loader/loader.conf`和`/boot/loader/entries/xxxxx.conf`来指定新的启动UUID和启动参数

如果你用的并不是mkinitcpio,或许可以[使用modprobe工具来管理内核模块](https://wiki.archlinuxcn.org/wiki/%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97#%E4%BD%BF%E7%94%A8_/etc/modprobe.d/%E4%B8%AD%E7%9A%84%E6%96%87%E4%BB%B6)。

## 多系统

如果你使用的是多个操作系统,非常推荐使用reFind引导,方便配置,

[reFind官方安装指南](https://www.rodsbooks.com/refind/installing.html)
[ArchLinux reFind安装指南](https://wiki.archlinuxcn.org/wiki/REFInd)
其实只需要使用`pacman -S refind && refind-install`就可以安装完毕
下面是一个示例refind.conf示例
```jsx

# 等待时间
timeout 1
# 使用nvram
use_nvram true

# 我只保留了Windows和下方menuentry中的配置
# systemd-boot已经关掉了
# 这样做的好处是可以避免套娃引导,略过systemd-boot
# 取消自动扫描可以更方便地添加内核参数
dont_scan_files vmlinuz-linux,systemd-bootx64.efi,initramfs-linux-fallback.img,bootx64.efi


# 同上
dont_scan_dirs ESP:/EFI/boot,EFI/systemd

# 多内核扫描 关闭
scan_all_linux_kernels false

# 默认使用Windows开机
default_selection 1 # 这个数字是refind开机菜单中的顺序
default_selection "Microsoft EFI Boot"
default_selection "Microsoft Boot EFI"
default_selection Microsoft

# 默认使用Linux开机

# default_selection 2
# default_selection "Arch Linux"
# default_selection "Linux"

# 分辨率
resolution max

# 开启鼠标
enable_mouse

# 自定义启动菜单
menuentry "Arch Linux" {
    icon     /EFI/refind/icons/os_arch.png
    loader   /vmlinuz-linux
    initrd   /amd-ucode.img 
    # 如果是intel则需要换成 /intel-ucode.img
    initrd   /initramfs-linux.img #这里填写你已有的内核
    options  "root=UUID=ea26xx0b-fbe0-xxe1-xxdd-xxxxxxxxxxxx rw psi=1 quiet splash"
}

# 主题配置,这个就需要你自己研究怎样为rEFInd配置一个漂亮的主题了
include theme/glassy/theme.conf
```
开机后就可以准备安装驱动或者使用其它物理机的相关内容,比如smbios,acpi这些.
迁移过程就结束了，这篇文章的思路太混乱了，当时是凌晨三点钟操作的，脑子睡着一半了，所以操作的很乱。