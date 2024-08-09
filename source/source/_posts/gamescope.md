---
title: 为所有Linux发行版添加GamescopeSteam会话
---

# 安装流程

## 1.安装steam

### (1).steam-runtime(建议)

### (2)steam-native(不建议)

ArchWiki原话翻译:

Steam Native Runtime
警告： 不建议使用**** Steam Native Runtime，因为它可能会因为二进制不兼容而导致某些游戏无法运行，也可能会错过 Steam Runtime 中的某些库。
steam-native-runtime 软件包依赖于 130 多个软件包，以构成 Steam Runtime 的原生替换，但某些游戏可能仍需要额外的软件包。

该软件包提供了 Steam Native 脚本，在启动 Steam 时使用 STEAM_RUNTIME=0 环境变量，使其忽略运行时，只使用系统库。

您也可以只手动安装所需的软件包，在不安装 steam-native-runtime 的情况下使用 Steam 原生运行时。

## 2.安装gamescope

### ArchWiki介绍

[Gamescope](https://github.com/ValveSoftware/gamescope) 是来自 Valve 并用于 [Steam Deck](https://wiki.archlinuxcn.org/wzh/index.php?title=Steam_Deck&action=edit&redlink=1 "Steam Deck（页面不存在）") 的 [微混成器](https://wiki.archlinuxcn.org/wiki/Wayland#Compositors "Wayland"). 其目标是提供一种针对游戏量身定制的独立合成器，并支持许多以游戏为中心的功能，例如:

* 分辨率伪装.
* 使用 AMD FidelityFX™ Super Resolution (FSR)或 NVIDIA Image Scaling (NIS)进行图像上采样.
* 限制帧率.

作为一个微混成器，它被设计为在现有桌面环境之上作为嵌套会话运行，尽管也可以将其用作嵌入式混成器。

### 驱动要求

* AMD: Mesa 20.3 或更高
* Intel: Mesa 21.2 或更高
* NVIDIA: 专有驱动 515.43.04 或更高，以及 `nvidia-drm.modeset=1` [内核参数](https://wiki.archlinuxcn.org/wiki/Kernel_parameter "Kernel parameter")

### (1)gamescope(ValveSoftware)

https://github.com/ValveSoftware/gamescope

### (2)gamescope-plus(ChimeraOS)

https://github.com/ChimeraOS/gamescope

ValveSoftware或ChimeraOS二选一,各自有不同的特性

## 3.安装gamescope-session

gamescope-session-plus(ChimeraOS)

https://github.com/ChimeraOS/gamescope-session

## 4.安装gamescope-session-steam

https://github.com/ChimeraOS/gamescope-session-steam

## 5.显示管理器切换会话

# 故障排除:

## 1.启动steam会话黑屏闪退

### 原因1:gamescope-session-plus没有运行

解决办法1:先在wayland桌面环境下运行gamescope-session-plus steam,大概率会闪退,检查gamescope是否正常,gamescope --version.如果正常,就需要重新安装gamesscope

### **原因2:gamescope缺少依赖******

这是aur中gamescope的PKGBUILD提到的必要依赖,逐个检查,看看缺少哪一个


| gcc-libs | glibc          | libavif           | seatd                |
| -------- | -------------- | ----------------- | -------------------- |
| libcap   | libdecor       | libdrm            | vulkan-icd-loader    |
| libinput | libpipewire    | libx11            | wayland              |
| libxtst  | libxxf86vm     | sdl2              | xcb-util-errors      |
| libxcb   | libxcomposite  | libxdamage        | xcb-util-wm          |
| libxext  | libxfixes      | libxkbcommon      | xorg-server-xwayland |
| libxmu   | libxrender     | libxres           | benchmark            |
| cmake    | git            | glslang           | meson                |
| ninja    | vulkan-headers | wayland-protocols | mangohud             |

## 2.性能监控面板不显示

### 原因:缺少mangohud

解决办法:安装mongohud软件包

# 须知:

gamescope的全局FSR不会主动将你的画面进行低分辨率处理和上采样,如果你的窗口分辨率与物理分辨率相同,FSR是不会任何作用的.

你需要手动将你的窗口分辨率降低后使用Steam的菜单将窗口缩放选择为"适应"

它的实现方式是如果全屏窗口分辨率低于显示器分辨率,FSR会决定窗口的每个像素点应该对应屏幕的哪个像素点,使显示效果不像线性缩放那样模糊.

而且大部分游戏需要在游戏中设置为无边框窗口,且游戏窗口分辨率低于物理分辨率,全局FSR才会介入.

如果某些游戏中选择的独占全屏,就算游戏窗口分辨率低于物理分辨率,FSR也不会起作用.游戏实际输出还是独占的steam客户端中为游戏设置的分辨率.

详见
