title: KDE Plasma美化思路指南
cover: /img/posts/plasma_tweak.jpg
date: 2024-8-10 23:00:00
tags: [KDE,Plasma,Linux]
categories: [Linux]
-------------------

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelector('.post-copyright__author_img_front').src = '/img/site/ava.jpg'
    })
</script>
# 前言

这篇文章主要面对刚开始使用KDE的新手，简单介绍下有哪些地方是可以使用KDE设置进行直接美化，哪些地方是可以使用其他工具进行美化，主题的获取方法。还有如果对一个主题大体满意但是有一些小细节不满意，如何修改已安装的主题。
这篇文章中所列出的软件包或工具有一部分是来自GitHub的，GitHub中的页面和KDE Store都是英文页面，国内访问可能会出现网络问题。

# 可自定义的元素

### 在KDE Plasma 的“颜色和主题”设置项中自定义的元素

- 颜色：包括桌面背景、窗口装饰、图标、文本等元素的配色方案。
- 应用程序外观样式：包括QT窗口的标准控件、菜单栏、按钮等元素的外观。
- Plasma外观样式：仅调整Plasma桌面外观，例如面板的样式。
- 窗口装饰元素：仅调整窗口标题栏样式。
- 图标：顾名思义，影响全局的图标样式
- 光标：影响全局的光标样式
- 欢迎屏幕：即在SDDM输入密码点击登陆后，显示桌面前的动画
- 登陆屏幕SDDM：调整登录界面样式（）
- 启动屏幕：通过Plymouth实现的开机动画（需要plymouth和plymouth-kcm软件包）

### 可在KDE Plasma 的“窗口管理”设置项中自定义的元素

- 窗口虚化：实现半透明窗口虚化（不支持圆角，不支持黑白名单）
- 窗口打开关闭动画：顾名思义
- 其他设置：前面的区域，以后再来探索吧

### 可以通过其他方式进行自定义的元素

- 使用原生面板实现dock外观：在底部面板仅保留应用程序菜单、图标任务管理器，将dock改为悬浮，剧中即可。（应用菜单推荐Andromeda Launcher，可实app面板现居中显示）。
- 自定义应用程序外观样式：在KDE设置中只有四个选项，可以通过Kvantum主题管理工具或者通过编译安装其它主题来获取更多主题样式（例如Klassy）。
- 动态壁纸：Wallpaper Engine for Kde或 Smart Video Wallpaper Reborn

# 主题获取方式

- 系统设置/全局主题中每一子设置项页面的右上角
- Discover商店中的Plasma 附加组件
- 桌面右键菜单/编辑模式/添加挂件/获取新挂件
- [KDE Store](https://store.kde.org/)
- [Kvantum主题](https://store.kde.org/browse?cat=123)
在访问Discover商店时，建议先[将flathub源替换为国内镜像源](https://mirror.sjtu.edu.cn/docs/flathub)以提升下载速度

方式1：
```bash
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
```
方式2：
```bash
wget https://mirror.sjtu.edu.cn/flathub/flathub.gpg
sudo flatpak remote-modify --gpg-import=flathub.gpg flathub
```
# 常用工具

### kvamtum

kvantum是一个开源的Qt样式引擎，可以用来修改应用程序的外观样式。Kvantum主题管理工具可以用来安装和管理Kvantum主题。
安装方式:[kvantum](https://github.com/tsujan/Kvantum/blob/master/Kvantum/INSTALL.md)
### 动态壁纸

- [Wallpaper Engine for Kde](https://github.com/catsout/wallpaper-engine-kde-plugin)安装方法在GitHub页面中可以找到,可以通过Steam的Wallpaper Engine创意工坊页面下载壁纸,不需要打开Wallpaper Engine本体.
- [Smart Video Wallpaper Reborn](https://store.kde.org/p/2139746)可以在KDE壁纸设置中的获取新插件中找到


# 自用主题搭配

- 应用程序外观样式： Kvantum/Orchis-dark
- 图标：Reversal-dark+[自己部分修改](https://github.com/Apiclo/app-svg-icons)
- Plasma外观样式：Mac Ventura 暗黑苹果
- 窗口装饰元素：Klassy
- 光标：GoogleDot-Black
- 登录屏幕SDDM：Materia Dark
# 修改已安装主题
修改主题需要你了解一定的svg、QML、Qt等方面的知识，如果对这些并不熟练的话，修改前记得备份原来的文件。
### 修改图标
1. 如果对一个图标包中的个别图标不满意，其实可以在`~/.local/share/applications/`文件夹中找到一部分软件的.desktop“快捷方式”
2. 通过文本编辑工具可以找到其`icon=xxx`字段对应的即是它的图标名称，如果想对其进行修改，需要先在`~/.local/share/icons`找到你的图标包
3. 在其中找到对应的svg文件“如果是符号链接需要再找到链接的目标文件”，找到之后将其复制到一个你喜欢的地方
4. 使用一个你喜欢的svg编辑工具打开你复制的文件，编辑成你喜欢的样子之后保存
5. 修改步骤1中.desktop文件的`icon=xxx`字段,将xxx修改为你编辑过的图标的绝对路径。

### 修改kvantum主题
1. 按照以上方法以此类推，就可以编辑大部分以svg为基础的主题样式。
2. kvantum主题文件夹在`～/.config/Kvantum/`，其主体结构一般为一个kvconfig文件和一张svg图片。
3. 建议先通过kvantum manager编辑kvconfig，如果不能达到预期再考虑手动修改，kvconfig中的字段比较直观，手动编辑没什么大问题。
4. svg文件中的每一个图层对应的即是一个组件的样式，需要在图层内编辑。这里是[kvantum的主题设计文档](https://github.com/tsujan/Kvantum/blob/master/Kvantum/doc/Theme-Making.pdf)

### 修改Plasma外观样式
1. Plasma主题样式路径在`~/.local/share/plasma/desktoptheme/`
2. 由于直接编辑文件过于复杂，其实不建议编辑了，如果觉得不好看就换一个是更简单方便的选择。
3. 如果真的需要修改，可以考虑[看下这个](https://develop.kde.org/docs/plasma/theme/quickstart/)
### 修改开机动画
1. 在大部分Linux发行版中开机动画是依靠Plymouth实现的，可以通过你的包管理器安装plymouth软件包来实现开机动画，
2. 安装之后需要在你的启动参数中添加 `quiet splash`
以rEFInd引导举例：
```
menuentry "Arch Linux" {
    icon     /EFI/refind/theme/glassy/icons/os_arch.png
    loader   /vmlinuz-linux
    initrd   /amd-ucode.img
    initrd   /initramfs-linux.img
    options  "root=UUID=uuiduuid-uuid-uuid-uuid-uuiduuiduuid rw quiet splash"
}
```
3. 

3. 如果要更换主题，简单点就是通过`plymouth-kcm`软件包来更换一个主题。
4. 命令行更换主题可以通过`sudo plymouth-set-default-theme -R theme-name`来更换主题。
3. 如果向给某个主题简单换一个图标，可以在`/usr/share/plymouth/`找到，记得去`/etc/plymouth/plymouthd.conf`看一下Theme字段是否是你喜欢的主题。
#### 注意
plymouth在更换主题或编辑主题完成之后，需要加载内核钩子,在Arch Linux中的mkinitcpio举例：
```
MODULES=(...)
BINARIES=(...)
FILES=(...)
HOOKS=(... plymouth ...)

```
还需要重新编译initramfs，以`sudo mkinitcpio -p *kernel-name*`来更新initramfs。
