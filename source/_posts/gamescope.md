title: 为所有Linux发行版添加GamescopeSteam会话
cover: /img/posts/gamescope.jpg
date: 2024-08-7 23:40:00
categories: [Linux]
tags: [Steam,Games,Shell]
-------------------------------

# 前言

Gamescope是一个微混成器，它既可以在现有桌面环境之上作为嵌套会话运行，也可以作为一个独立的会话运行，这篇文章将介绍如何在所有Linux发行版上添加Gamescope-Steam会话。当然前提是你需要有比较强的动手能力，特别是NVIDIA的GPU，可能需要一局文明六的时间才有可能找到问题并解决。
这样做相比在桌面上直接运行Steam的好处是，可以更方便地使用Steam Deck的分辨率伪装功能，可以实现TDP调整。可以更方便地使用AMD FidelityFX™ Super Resolution (FSR)或 NVIDIA Image Scaling (NIS)进行图像上采样。而且可以减少桌面环境带来的不必要的性能开销，可以一定程度上提游戏帧数。 *(AIGC)*
而且在Proton的加持下，很多Windows游戏都可以在Linux上运行，而且性能表现不错。
如果你愿意的话，可以配置一下自动登录策略，这样就可以开机启动SteamOS的大屏模式，实现与SteamDeck的操作系统几乎相同的体验（如果是为了打造纯游戏系统，非常建议将用户名改为deck）。
非常感谢Valve和ChimeraOS的开发者，感谢他们的开源项目，让Linux的游戏环境和生态有了更多可能。如果您愿意支持他们，可以在Steam平台购买游戏、软件或硬件来表示对Valve的支持，[点击这里了解如何为ChimeraOS作出一点贡献](https://chimeraos.org/contribute/)，或者您也可以前往[ChimeraOS](https://github.com/ChimeraOS/chimeraos)和[Gamescope](https://github.com/ValveSoftware/gamescope)的GitHub页面点一下Star。


# 安装流程

如果您使用的是ArchLinux，可以通过AUR进行安装

```bash
paru -S gamescope-plus gamescope-session-plus gamescope-session-steam
# 如果使用的yay或者其它aur工具，请自行替换
```

如果是其它发行版，可以参考以下安装流程，或是使用最后的安装脚本（脚本中的依赖包名是chatGPT生成的，很多都不太准确，需要手动检查下依赖。）

## 一.安装steam

### (1)steam-runtime(建议)

### (2)steam-native(不建议)

ArchWiki原话翻译:
[Steam native runtime](https://wiki.archlinux.org/title/Steam/Troubleshooting#Steam_native_runtime)
警告： 不建议使用 Steam Native Runtime，因为它可能会因为二进制不兼容而导致某些游戏无法运行，也可能会错过 Steam Runtime 中的某些库。steam-native-runtime 软件包依赖于 130 多个软件包，以构成 Steam Runtime 的原生替换，但某些游戏可能仍需要额外的软件包。

## 二.安装gamescope

### ArchWiki介绍

[Gamescope](https://github.com/ValveSoftware/gamescope) 是来自 Valve 并用于 Steam Deck 的 [微混成器](https://wiki.archlinuxcn.org/wiki/Wayland#Compositors "Wayland"). 其目标是提供一种针对游戏量身定制的独立合成器，并支持许多以游戏为中心的功能，例如:

* 分辨率伪装.
* 使用 AMD FidelityFX™ Super Resolution (FSR)或 NVIDIA Image Scaling (NIS)进行图像上采样.
* 限制帧率.

作为一个微混成器，它被设计为在现有桌面环境之上作为嵌套会话运行，尽管也可以将其用作嵌入式混成器。

### 驱动要求

* AMD: Mesa 20.3 或更高
* Intel: Mesa 21.2 或更高
* NVIDIA: 专有驱动 515.43.04 或更高，以及 `nvidia-drm.modeset=1` [内核参数](https://wiki.archlinuxcn.org/wiki/Kernel_parameter "Kernel parameter")

### 安装方式
gamescope可以用两种方式安装，一种是编译安装，另一种是使用包管理器安装。 在两种安装方式中任选其一。
#### 包管理器安装

一些发行版提供了 gamescope 软件包，这样安装的好处是可以通过包管理器补全依赖,可以在这里查一下有没有你在用的发行版，当然，包管理器安装的是ValveSoftware的版本，不是ChimeraOS的版本。
[gamescope package versions - Repology](https://repology.org/project/gamescope/versions)

#### 编译安装

首先检查一下依赖,这是aur中gamescope的PKGBUILD提到的必要依赖,其它发行版的软件包名可能有些差异,但大体上都是一样的,这里以ArchLinux为例。


| pkg name | pkg name       | pkg name          | pkg name             |
| -------- | -------------- | ----------------- | -------------------- |
| gcc-libs | glibc          | libavif           | seatd                |
| libcap   | libdecor       | libdrm            | vulkan-icd-loader    |
| libinput | libpipewire    | libx11            | wayland              |
| libxtst  | libxxf86vm     | sdl2              | xcb-util-errors      |
| libxcb   | libxcomposite  | libxdamage        | xcb-util-wm          |
| libxext  | libxfixes      | libxkbcommon      | xorg-server-xwayland |
| libxmu   | libxrender     | libxres           | benchmark            |
| cmake    | git            | glslang           | meson                |
| ninja    | vulkan-headers | wayland-protocols | mangohud             |

确保依赖完整后就可以开始编译了,gamescope目前有两个比较流行的分支版本,一个是Valve官方的版本,一个是ChimeraOS的版本,也是二选其一。具体区别其实我也不太清楚,我使用的是ChimeraOS的版本.

* (1)gamescope(ValveSoftware)

https://github.com/ValveSoftware/gamescope

```bash
git clone https://github.com/ValveSoftware/gamescope.git
cd gamescope
git submodule update --init
# 编译
meson build/
ninja -C build/
build/gamescope -- <game>
# 安装  
meson install -C build/ --skip-subprojects
```

* (2)gamescope-plus(ChimeraOS)

https://github.com/ChimeraOS/gamescope

```bash
git clone https://github.com/ChimeraOS/gamescope.git
cd gamescope
git submodule update --init
# 编译
meson build/
ninja -C build/
build/gamescope -- <game>
# 安装
meson install -C build/ --skip-subprojects
```



## 三.安装gamescope-session-steam

#### 首先需要安装[gamescope-session-plus](https://github.com/ChimeraOS/gamescope-session)

```bash
git clone https://github.com/ChimeraOS/gamescope-session.git
sudo /bin/cp -r gamescope-session/usr/* /usr/
```

#### 安装之后紧接着安装[gamescope-session-steam](https://github.com/ChimeraOS/gamescope-session-steam)

```bash
git clone https://github.com/ChimeraOS/gamescope-session-steam.git
sudo /bin/cp -r gamescope-session-steam/usr/* /usr/
```
这里的安装实际只是复制文件，详细信息可以参考上面链接中的readme.md
## 四.显示管理器切换会话
全部安装完毕后就可以注销当前桌面会话，在登录界面选择Steam Big Picture会话登录，就可以实现与SteamDeck同样的Steam界面，仔细观察会发现会有很多与桌面上大屏幕模式Steam的不同之处。
正常运行之后就可以删除掉上面步骤在～/克隆过的源代码了,你的～/会有以下文件夹。
```
~/
  |- gamescope/ #步骤二通过编译安装才会有的文件夹
  |- gamescope-session/
  |- gamescope-session-steam/
```

# 故障排除:

## 1.启动steam会话黑屏闪退

### 原因1:gamescope-session-plus没有运行

解决办法1:考虑GPU驱动和Vulkan的问题：如果是笔记本双GPU，需要去BIOS禁用核显；如果没有提供禁用核显的选项，[需要选择特定的设备来运行vulkan](https://wiki.archlinuxcn.org/wiki/Vulkan#%E5%9C%A8%E8%AE%BE%E5%A4%87%E4%B9%8B%E9%97%B4%E5%88%87%E6%8D%A2)，其它发行版也可以参考。

解决办法2：这个办法有点玄学，三、四步骤复制命令使用的通配符，有时候某些文件可能没有复制到，需要手动复制。我在脚本中加入了检查文件是否存在的代码，如果不存在会提示文件丢失。

解决办法3: 查wiki
[Gamescope -ArchWiki](https://wiki.archlinuxcn.org/wiki/Gamescope)
[AMDGPU - ArchWiki](https://wiki.archlinuxcn.org/wiki/AMDGPU)
[NVIDIA - ArchWiki](https://wiki.archlinuxcn.org/wiki/NVIDIA)
[NVIDIA Optimus - ArchWiki](https://wiki.archlinuxcn.org/wiki/NVIDIA_Optimus)
[Wayland - ArchWiki](https://wiki.archlinuxcn.org/wiki/Wayland)
[Vulkan - ArchWiki](https://wiki.archlinuxcn.org/wiki/Vulkan)
其他发行版也可以参考

### 原因2:gamescope缺少依赖

解决办法:检查上文的表格,查一下缺少哪个依赖

## 2.性能监控面板不显示

### 原因:缺少mangohud

解决办法:安装mongohud软件包

# 关于FSR:

gamescope的全局FSR不会主动将你的画面进行低分辨率处理和上采样,如果你的窗口分辨率与物理分辨率相同,FSR是不会任何作用的.

你需要手动将你的窗口分辨率降低后使用Steam的菜单将窗口缩放选择为"适应"

它的实现方式是如果全屏窗口分辨率低于显示器分辨率,FSR会决定窗口的每个像素点应该对应屏幕的哪个像素点,使显示效果不像线性缩放那样模糊.

而且大部分游戏需要在游戏中设置为无边框窗口,且游戏窗口分辨率低于物理分辨率,全局FSR才会介入.

如果某些游戏中选择的独占全屏,就算游戏窗口分辨率低于物理分辨率,FSR也不会起作用.游戏实际输出还是独占的steam客户端中为游戏设置的分辨率.

# 安装脚本
安装脚本会帮你实现上面写到的安装流程中的一部分工作,但是作用有限,如果脚本安装失败,请参考上面的安装流程进行手动安装.
```bash
curl -Ls https://raw.githubusercontent.com/Apiclo/Apiclo.github.io/master/shells/steamos.sh  -o steam-session.sh && /bin/bash steam-session.sh
```

## 脚本内容：[steamos.sh](https://github.com/Apiclo/Apiclo.github.io/blob/master/shells/steamos.sh)




# 题外话：安装deckey插件商店

## 使用Desktop文件安装

首先需要创建一个.desktop文件并赋予执行权限
```bash
touch ~/.local/share/applications/decky.desktop && chmod +x ~/.local/share/applications/decky.desktop
```

然后输入以下内容：
```
#!/usr/bin/env xdg-open
[Desktop Entry]
Name=Decky Installer
Name[zh_CN]=Decky安装器
Exec=sh -c 'rm -f /tmp/user_install_script.sh; if curl -S -s -L -O --output-dir /tmp/ --connect-timeout 60 https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/user_install_script.sh; then bash /tmp/user_install_script.sh; else echo "Something went wrong, please report this if it is a bug"; read; fi'
Icon=steam
Terminal=true
Type=Application
StartupNotify=false
```

保存并退出后，你就可以在软件列表找到Decky安装器了，打开就可以看到一个终端和输入sudo密码的窗口，输入完成即可开始安装。
这个是模仿decky作者使用的方法，他是提供了一个.desktop文件，为了达到下载后可以双击打开的效果。这样的好处是如果decky挂了或者需要更新可以直接在应用列表打开decky安装器进行安装，坏处是会比命令行安装多一步编辑文件的步骤。



## 命令行安装
在终运行这条命令
```bash
curl -sSL https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/user_install_script.sh -o decky.sh && bash decky.sh
```
命令行安装是将decky作者提供的.desktop文件中的Exec进行简化后的命令，这样的好处是可以省下一个用编辑器复制粘贴的步骤，坏处是如果decky挂了或者需要更新需要重新运行这个脚本。
同时说句题外话的题外话，不建议更新的时候直接执行先前的~/decky.sh，这可能不会达到理想的结果，非常建议重新运行上面的curl命令重新获取最新的安装脚本。

两个安装方式都是会弹出一个图形化的窗口，安装时会提示不是在deck上进行安装，可以忽略，如果介意的话，可以将用户名改为deck，然后重新安装。
## 关于decky占用8080端口
decky的运行需要用到steam开发者选项中提到的CEF远程调试，即如果关掉CEF远程调试，decky就会失效，可能需要重新安装才可以解决。同时CEF远程调试会占用8080端口，如果你有业务在后台跑在8080端口，可能会导致decky失效，同样的，安装了decky的steam即使在桌面模式下后台运行也会导致8080被占用。


# 总结

gamescope是一个很好的工具,可以让你在SteamOS上运行Steam游戏,但是需要一些配置和故障排除才能正常工作. *(AIGC)*
