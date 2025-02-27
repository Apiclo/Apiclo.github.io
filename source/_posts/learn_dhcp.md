title: CentOS DHCP服务配置记录
cover: /img/posts/tux.svg
date: 2025-2-27 11:59:00
tags: [CentOS,Shell,Linux]
categories: [Linux]
-------------------
<style>
        *{
                user-select: none;
        }
</style>
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

# 一、环境准备
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

主机配置

| 网卡 | 属性 | IP |
| --- | --- | --- |
| vmnet8 | NAT | 192.168.50.1 |
| vmnet1 | HOST Only | none |
| WWAN | DHCP | 10.7.126.8 |

虚拟服务器配置

| 网卡 | 属性 | IP | 与主机连接 |
| --- | --- | --- | --- |
| ens33 | DHCP | 192.168.50.128 | vmnet8 |
| ens36 | static | 192.168.20.2 | vmnet1 |

虚拟主机配置

| 网卡 | 属性 | IP | 与主机连接 |
| --- | --- | --- | --- |
| ens33 | DHCP | 192.168.50.129 | vmnet8 |
| ens36 | DHCP | 192.168.20.10 | vmnet1 |

## 1.修改虚拟网卡的设置,关闭原有DHCP服务
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

步骤要点:打开虚拟网络编辑器,将仅主机网络的DHCP服务关闭


# 二、虚拟服务器需要做的事情
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 1.编辑网卡配置

步骤要点1：将HOST Only网卡设置中的BOOTPROTO的属性值修改为static
步骤要点2：为网卡添加一个IP地址、网关、和子网掩码

步骤命令：sudo vim /etc/sysconfig/network-scripts/ifcfg-ens36

修改完成的ifcfg-ens36文件内容

```
HWADDR=00:0C:29:9C:BE:67
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens36
DEVICE=ens36
UUID=a9743b5f-1be0-3ca9-a875-29cb86741dc3
ONBOOT=yes
AUTOCONNECT_PRIORITY=-999
IPADDR=192.168.20.2
NETMASK=255.255.255.0
PREFIX=24
GATEWAY=192.168.20.1

```

## 2.安装dhcp软件包
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

步骤命令：sudo yum install dhcp

## 3、编辑dhcp配置文件
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

步骤要点：全是要点

步骤命令：sudo vim /etc/dhcp/dhcpd.conf

修改好的dhcpd.conf文件内容:

```
subnet 192.168.20.0 netmask 255.255.255.0
{
        range 192.168.20.10 192.168.20.100;
        option routers 192.168.20.2;
        option broadcast-address 192.168.20.255;
        default-lease-time 7200;
        max-lease-time infinite;
}          
```

## 4、启动dhcpd服务
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

步骤命令：sudo systemctl start dhcpd

```
[apiclo@bogon ~]$ sudo systemctl status dhcpd.service
● dhcpd.service - DHCPv4 Server Daemon
   Loaded: loaded (/usr/lib/systemd/system/dhcpd.service; disabled; vendor preset: disabled)
   Active: active (running) since 四 2025-02-27 13:51:00 CST; 9min ago
     Docs: man:dhcpd(8)
           man:dhcpd.conf(5)
 Main PID: 17215 (dhcpd)
   Status: "Dispatching packets..."
    Tasks: 1
   CGroup: /system.slice/dhcpd.service
           └─17215 /usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid

2月 27 13:51:00 bogon dhcpd[17215]: ** Ignoring requests on ens33.  If this is not what
2月 27 13:51:00 bogon dhcpd[17215]:    you want, please write a subnet declaration
2月 27 13:51:00 bogon dhcpd[17215]:    in your dhcpd.conf file for the network segment
2月 27 13:51:00 bogon dhcpd[17215]:    to which interface ens33 is attached. **
2月 27 13:51:00 bogon dhcpd[17215]: 
2月 27 13:51:00 bogon dhcpd[17215]: Sending on   Socket/fallback/fallback-net
2月 27 13:51:08 bogon dhcpd[17215]: DHCPDISCOVER from 00:0c:29:87:26:09 via ens36
2月 27 13:51:09 bogon dhcpd[17215]: DHCPOFFER on 192.168.20.10 to 00:0c:29:87:26:09 via ens36
2月 27 13:51:09 bogon dhcpd[17215]: DHCPREQUEST for 192.168.20.10 (192.168.20.1) from 00:0c:29:...ns36
2月 27 13:51:09 bogon dhcpd[17215]: DHCPACK on 192.168.20.10 to 00:0c:29:87:26:09 via ens36
Hint: Some lines were ellipsized, use -l to show in full.

```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>
# 二、客户端需要做的事情

## 1、查看虚拟客户机获取到的地址

步骤命令：ifconfig | grep inet && ifconfig
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

看到虚拟客户机的HOST Only网卡(ens36)成功获取到IP地址
```
[siralop@localhost ~]$ ifconfig | grep inet
        inet 192.168.50.129  netmask 255.255.255.0  broadcast 192.168.50.255
        inet6 fe80::aee8:ef05:68:a090  prefixlen 64  scopeid 0x20<link>
        inet6 fd15:4ba5:5a2b:1008:58be:690d:e07e:38b0  prefixlen 64  scopeid 0x0<global>
        inet 192.168.20.10  netmask 255.255.255.0  broadcast 192.168.20.255
        inet6 fe80::3fa5:781f:b026:f27f  prefixlen 64  scopeid 0x20<link>
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        inet 192.168.122.1  netmask 255.255.255.0  broadcast 192.168.122.255
[siralop@localhost ~]$ ifconfig
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.50.129  netmask 255.255.255.0  broadcast 192.168.50.255
        inet6 fe80::aee8:ef05:68:a090  prefixlen 64  scopeid 0x20<link>
        inet6 fd15:4ba5:5a2b:1008:58be:690d:e07e:38b0  prefixlen 64  scopeid 0x0<global>
        ether 00:0c:29:87:26:ff  txqueuelen 1000  (Ethernet)
        RX packets 2680  bytes 280767 (274.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2518  bytes 249462 (243.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens36: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.20.10  netmask 255.255.255.0  broadcast 192.168.20.255
        inet6 fe80::3fa5:781f:b026:f27f  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:87:26:09  txqueuelen 1000  (Ethernet)
        RX packets 796  bytes 86066 (84.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 936  bytes 155225 (151.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 2、检查客户机当前IP的来源：

步骤命令：sudo dhclient -v ens36

可以看到DHCP服务器在192.168.20.1
```
[siralop@localhost ~]$ sudo dhclient -v ens36
Internet Systems Consortium DHCP Client 4.2.5
Copyright 2004-2013 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

Listening on LPF/ens36/00:0c:29:87:26:09
Sending on   LPF/ens36/00:0c:29:87:26:09
Sending on   Socket/fallback
DHCPDISCOVER on ens36 to 255.255.255.255 port 67 interval 3 (xid=0x24b00029)
DHCPREQUEST on ens36 to 255.255.255.255 port 67 (xid=0x24b00029)
DHCPOFFER from 192.168.20.1
DHCPACK from 192.168.20.1 (xid=0x24b00029)
bound to 192.168.20.10 -- renewal in 3594 seconds.

```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>
