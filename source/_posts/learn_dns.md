title: CentOS DNS服务配置记录
cover: /img/posts/tux.svg
date: 2025-2-26 15:39:00
tags: [CentOS,Shell,Linux]
categories: [Linux]
-------------------
<style>
        *{
                user-select: none;
        }
</style>

# 你现在的主要任务是学会怎么用VIM打开和编辑文件
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

|期望操作|输入方式|
|---|---|
|打开某个文件|在shell中输入vim /文件路径/文件名|
|从主模式进入编辑模式|在主模式中输入i（英文字母i）|
|退出编辑模式\进入主模式|在任意模式按下ESC（这是左上角的ESC，不是依次按键盘的e、s、c）|
|从主模式进入命令模式|在主模式中输入:（冒号）|
|保存并退出|在命令模式输入wq|
|强制退出|在命令模式输入q!|

[点击这里了解vim文本编辑器的具体使用方法](https://www.runoob.com/linux/linux-vim.html)

<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

# 实验环境：

### 主机
|属性|值|
|---|---|
|操作系统|ArchLinux|
|角色|物理机|
|IP地址|192.168.50.1|
|用户名|apiclo|
|虚拟化软件|VMWare|

### CentOS虚拟机1
|属性|值|
|---|---|
|操作系统|CentOS 7.9|
|角色|虚拟-服务器|
|IP地址|192.168.50.128|
|用户名|apiclo|
|DNS服务软件|bind|


<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span> 

### CentOS虚拟机2
|属性|值|
|---|---|
|操作系统|CentOS 7.9|
|角色|虚拟-客户端|
|IP地址|192.168.50.129|
|用户名|siralop|
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

# 准备
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 主机连接虚拟机
### 主机输入以下命令：
```bash
sudo ip link set vmnet8 up
sudo ip addr add 192.168.50.1/24 dev vmnet8
sudo ip route add default via 192.168.50.1
```
### 虚拟机输入以下命令：

```bash
sudo ip link set ens33 up
sudo ip addr add 192.168.50.128/24 dev ens33
```
### ssh连接虚拟机 
```bash
ssh apiclo@192.168.50.128
```
# 以下内容为SSH连接虚拟机后执行
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 切换国内软件源
vim repo.sh
文件内容:
```bash
sudo sed -i.bak \
  -e 's|^mirrorlist=|#mirrorlist=|g' \
  -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos-vault/centos|g' \
  /etc/yum.repos.d/CentOS-Base.repo
```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

chmod +x repo.sh
./repo.sh
sudo yum makecache
sudo yum update
## 安装DNS必要软件包
sudo yum install -y bind bind-utils
## 防火墙放行53端口
sudo firewall-cmd --add-port=53/tcp --zone=public
sudo firewall-cmd --add-port=53/udp --zone=public
# 编辑DNS配置文件
## 编辑主配置文件
sudo vim /etc/named.conf
文件内容:
```plaintext
options {
        listen-on port 53 { any; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        recursing-file  "/var/named/data/named.recursing";
        secroots-file   "/var/named/data/named.secroots";
        allow-query     { any; };
        recursion yes;
        dnssec-enable yes;
        dnssec-validation yes;
        bindkeys-file "/etc/named.root.key";
        managed-keys-directory "/var/named/dynamic";
        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";

```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 配置区域文件
sudo vim /etc/named.rfc1912.zones
文件内容
```plaintext
//需要新增的域名
zone "k3k5.com" IN {
        type master;
        file "k3k5.com.zone";
};
//需要新增的域名
zone "50.168.192.in-addr.arpa" IN {
        type master;
        file "50.168.192.zone";
};
//以下是系统内建内容
zone "localhost.localdomain" IN {
        type master;
        file "named.localhost";
        allow-update { none; };
};
zone "localhost" IN {
        type master;
        file "named.localhost";
        allow-update { none; };
};

zone "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa" IN {
        type master;
        file "named.loopback";
        allow-update { none; };
};

zone "1.0.0.127.in-addr.arpa" IN {
        type master;
        file "named.loopback";
        allow-update { none; };
};

zone "0.in-addr.arpa" IN {
        type master;
        file "named.empty";
        allow-update { none; };
};

```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 创建正向解析文件
sudo cp -p /var/named/named.localhost /var/named/k3k5.com.zone
sudo vim /var/named/k3k5.com.zone
文件内容:
```plaintext
$TTL 1D
@    IN SOA k3k5.com. root.k3k5.com. (
1    ; serial
1D   ; refresh
1H   ; retry
1W   ; expire
3H )  ; minimum
NS   dns.k3k5.com.
dns     A    192.168.50.XXX
test1    A    192.168.50.201
test2    A    192.168.50.202
testc   CNAME   test1

```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 创建反向解析文件
sudo cp -p /var/named/named.empty /var/named/50.168.192.zone
sudo vim /var/named/50.168.192.zone
文件内容
```plaintext
$TTL 3H
@  IN SOA k3k5.com. root.k3k5.com. (
1    ; serial
1D   ; refresh
1H   ; retry
1W   ; expire
3H )  ; minimum
NS   dns.k3k5.com.
201   PTR   test1.k3k5.com.
202   PTR   test2.k3k5.com.
202   PTR   testc.k3k5.com.
```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 重启DNS服务
sudo systemctl restart named.service
出现以下错误信息
```plaintext
Job for named.service failed because the control process exited with error code. See "systemctl status named.service" and "journalctl -xe" for details.

```
查看日志,开始排错
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>
sudo journalctl -xe

```plaintext
2月 26 15:12:50 bogon bash[127386]: _default/k3k5.com/IN: unknown class/type
2月 26 15:12:50 bogon bash[127386]: zone localhost.localdomain/IN: loaded serial 0
2月 26 15:12:50 bogon bash[127386]: 50.168.192.zone:8: unknown RR type 'dns.k3k5.com.'
2月 26 15:12:50 bogon bash[127386]: zone 50.168.192.in-addr.arpa/IN: loading from master file 50.168.192.zone f
2月 26 15:12:50 bogon bash[127386]: zone 50.168.192.in-addr.arpa/IN: not loaded due to errors.
2月 26 15:12:50 bogon bash[127386]: _default/50.168.192.in-addr.arpa/IN: unknown class/type
2月 26 15:12:50 bogon bash[127386]: zone localhost/IN: loaded serial 0
2月 26 15:12:50 bogon bash[127386]: zone 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.ar
2月 26 15:12:50 bogon bash[127386]: zone 1.0.0.127.in-addr.arpa/IN: loaded serial 0
2月 26 15:12:50 bogon bash[127386]: zone 0.in-addr.arpa/IN: loaded serial 0
2月 26 15:12:50 bogon systemd[1]: named.service: control process exited, code=exited status=1
2月 26 15:12:50 bogon systemd[1]: Failed to start Berkeley Internet Name Domain (DNS).
-- Subject: Unit named.service has failed
-- Defined-By: systemd

```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 错误分析
1. **反向区域文件中的NS记录格式错误**：
   - 原始配置：`NS dns.k3k5.com.`
   - 错误原因：缺少记录类型前的`@ IN`，导致解析器误认为`NS`是域名，而`dns.k3k5.com.`是无效的RR类型。
   - 正确格式应为：`@ IN NS dns.k3k5.com.`
   <span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

2. **PTR记录未使用完全限定域名（FQDN）**：
   - 例如`test1.k3k5.com`未以点结尾，会被解析为`test1.k3k5.com.50.168.192.in-addr.arpa`。
   - 正确格式应为：`test1.k3k5.com.`（末尾加点）。
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 修复步骤
1. **修正反向区域文件`50.168.192.zone`**：
```plaintext
$TTL 3H
@  IN SOA dns.k3k5.com. root.k3k5.com. (
1    ; serial
1D   ; refresh
1H   ; retry
1W   ; expire
3H )  ; minimum
@ IN NS dns.k3k5.com.
128   PTR   test1.k3k5.com.
128   PTR   test2.k3k5.com.
128   PTR   testc.k3k5.com.
```
2. **修正正向区域文件`k3k5.com.zone`中的NS记录**：
```plaintext
$TTL 1D
@    IN SOA dns.k3k5.com. root.k3k5.com. (
1    ; serial
1D   ; refresh
1H   ; retry
1W   ; expire
3H )  ; minimum
@ IN NS dns.k3k5.com.
dns     A    192.168.50.128  # 确保XXX替换为实际IP
test1   A    192.168.50.128
test2   A    192.168.50.128
testc   CNAME test1
```

<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>


3. **验证配置文件并重启服务**：
```bash
sudo named-checkconf /etc/named.conf # 检查主配置
sudo named-checkzone k3k5.com /var/named/k3k5.com.zone # 检查正向区域
sudo named-checkzone 50.168.192.in-addr.arpa /var/named/50.168.192.zone # 检查反向区域
sudo systemctl restart named
```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

# CentOS2(虚拟客户机)需要做的事情
### 以下命令为虚拟客户机2执行
1. **修改解析文件**：
```bash
sudo vim/etc/resolv.conf
```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

文件内容：
```plaintext
nameserver 192.168.50.128
```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

2. **测试解析**：
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

```plaintext
[siralop@localhost ~]$ nslookup test1.k3k5.com
Server:         192.168.50.128
Address:        192.168.50.128#53

Name:   test1.k3k5.com
Address: 192.168.50.128

[siralop@localhost ~]$ nslookup testc.k3k5.com
Server:         192.168.50.128
Address:        192.168.50.128#53

testc.k3k5.com  canonical name = test1.k3k5.com.
Name:   test1.k3k5.com
Address: 192.168.50.128

[siralop@localhost ~]$ nslookup test2.k3k5.com
Server:         192.168.50.128
Address:        192.168.50.128#53

Name:   test2.k3k5.com
Address: 192.168.50.128
```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>