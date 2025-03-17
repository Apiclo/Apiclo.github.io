title: CentOS FTP服务配置记录
cover: /img/posts/tux.svg
date: 2025-2-27 15:39:00
tags: [CentOS,Shell,Linux]
categories: [Linux]
-------------------


<style>
        *{
                user-select: none;
        }
</style>
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

# FTP服器务配置记录

## 1、在虚拟服务器安装vsftpd包
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

```
apiclo@bogon ~]$ sudo yum install -y vsftpd

已加载插件：fastestmirror, langpacks

Loading mirror speeds from cached hostfile

正在解决依赖关系

- -> 正在检查事务
- --> 软件包 vsftpd.x86_64.0.3.0.2-29.el7_9 将被 安装
- -> 解决依赖关系完成

依赖关系解决

===================================================================================

Package         架构            版本                       源                大小=

===================================================================================

正在安装:

vsftpd          x86_64          3.0.2-29.el7_9             updates          173 k

事务概要

===================================================================================

安装  1 软件包=

总下载量：173 k

安装大小：353 k

Downloading packages:

No Presto metadata available for updates

vsftpd-3.0.2-29.el7_9.x86_6 0% [                 ]  0.0 B/s |    0 B  --:--:-- ETA

vsftpd-3.0.2-29.el7_9.x86_64.rpm                            | 173 kB  00:00:00

Running transaction check

Running transaction test

Transaction test succeeded

Running transaction

正在安装    : vsftpd-3.0.2-29.el7_9.x86_64                                   1/1

验证中      : vsftpd-3.0.2-29.el7_9.x86_64                                   1/1

已安装:

vsftpd.x86_64 0:3.0.2-29.el7_9

完毕！
```

## 2、关闭虚拟服务器的防火墙和SeLinux
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

```
[apiclo@bogon ~]$ sudo systemctl disable --now firewalld
[apiclo@bogon ~]$ sudo setenforce 0
[apiclo@bogon ~]$ sudo getenforce
Permissive
```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

## 3、开启虚拟服务器的vsftpd服务

```
[apiclo@bogon ~]$ echo 'alias sctl="sudo systemctl"' >> .bashrc
[apiclo@bogon ~]$ source .bashrc
[apiclo@bogon ~]$ sctl start vsftpd
[apiclo@bogon ~]$ sctl status vsftpd
● vsftpd.service - Vsftpd ftp daemon
   Loaded: loaded (/usr/lib/systemd/system/vsftpd.service; disabled; vendor preset: disabled)
   Active: active (running) since 四 2025-02-27 15:13:22 CST; 6s ago
  Process: 18579 ExecStart=/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf (code=exited, status=0/SUCCESS)
 Main PID: 18581 (vsftpd)
    Tasks: 1
   CGroup: /system.slice/vsftpd.service
           └─18581 /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

2月 27 15:13:22 bogon systemd[1]: Starting Vsftpd ftp daemon...
2月 27 15:13:22 bogon systemd[1]: Started Vsftpd ftp daemon.

```

## 4、在客户机上安装FTP客户端
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

```
[siralop@localhost ~]$ sudo yum install ftp
已加载插件：fastestmirror, langpacks
Loading mirror speeds from cached hostfile
正在解决依赖关系
--> 正在检查事务
---> 软件包 ftp.x86_64.0.0.17-67.el7 将被 安装
--> 解决依赖关系完成

依赖关系解决

===================================================================================
 Package         架构               版本                    源                大小
===================================================================================
正在安装:
 ftp             x86_64             0.17-67.el7             base              61 k

事务概要
===================================================================================
安装  1 软件包

总下载量：61 k
安装大小：96 k
Is this ok [y/d/N]: y
Downloading packages:
警告：/var/cache/yum/x86_64/7/base/packages/ftp-0.17-67.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
ftp-0.17-67.el7.x86_64.rpm 的公钥尚未安装
ftp-0.17-67.el7.x86_64.rpm                                  |  61 kB  00:00:00     
从 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 检索密钥
导入 GPG key 0xF4A80EB5:
 用户ID     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 指纹       : 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 软件包     : centos-release-7-9.2009.0.el7.centos.x86_64 (@anaconda)
 来自       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
是否继续？[y/N]：y
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  正在安装    : ftp-0.17-67.el7.x86_64                                         1/1 
  验证中      : ftp-0.17-67.el7.x86_64                                         1/1 

已安装:
  ftp.x86_64 0:0.17-67.el7                                                         

完毕！

```

## 5、使用客户机连接ftp服务器
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

```
[siralop@localhost ~]$ ftp 192.168.20.2
Connected to 192.168.20.2 (192.168.20.2).
220 (vsFTPd 3.0.2)
Name (192.168.20.2:siralop): ftp 
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
227 Entering Passive Mode (192,168,20,2,180,185).
150 Here comes the directory listing.
drwxr-xr-x    2 0        0               6 Jun 09  2021 pub
226 Directory send OK.
ftp> 

```

## 6、在服务器上新建文件
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

```
[apiclo@bogon pub]$ echo "This file is created by Siralop" | sudo tee ftp.txt
This file is created by Siralop
[apiclo@bogon pub]$ 

```

## 7、在客户机上查看文件
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

```
ftp> cd pub
250 Directory successfully changed.
ftp> ls
227 Entering Passive Mode (192,168,20,2,47,0).
150 Here comes the directory listing.
-rw-r--r--    1 0        0              32 Feb 27 07:23 ftp.txt
226 Directory send OK.
ftp> get ftp.txt
local: ftp.txt remote: ftp.txt
227 Entering Passive Mode (192,168,20,2,34,39).
150 Opening BINARY mode data connection for ftp.txt (32 bytes).
226 Transfer complete.
32 bytes received in 5.1e-05 secs (627.45 Kbytes/sec)
ftp> 

```

## 8、客户机上传文件到服务器
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

```
ftp> put index.html
local: index.html remote: index.html
local: index.html: 没有那个文件或目录
ftp> exit
221 Goodbye.
[siralop@localhost ~]$ ls
ftp.txt  公共  模板  视频  图片  文档  下载  音乐  桌面
[siralop@localhost ~]$ echo "<span>This file is created by siralop</span>" > index.html
[siralop@localhost ~]$ ftp 192.168.20.2
Connected to 192.168.20.2 (192.168.20.2).
220 (vsFTPd 3.0.2)
Name (192.168.20.2:siralop): ftp
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> cd pub
250 Directory successfully changed.
ftp> put index.html
local: index.html remote: index.html
227 Entering Passive Mode (192,168,20,2,190,215).
550 Permission denied.
ftp> 

```

`提示权限不足，因为没有开启匿名用户上传权限。`

## 9、编辑主机vsftpd配置
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

关键配置：anon_upload_enable：允许匿名上传

```
[apiclo@bogon pub]$ sudo sed -i '/^#/d' /etc/vsftpd/vsftpd.conf
[apiclo@bogon pub]$ sudo vim /etc/vsftpd/vsftpd.conf
[apiclo@bogon pub]$ cat /etc/vsftpd/vsftpd.conf
anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
anon_upload_enable=YES
anon_mkdir_write_enable=YES
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
[apiclo@bogon pub]$ sctl restart vsftpd

```

## 10、在服务器上添加用户并修改权限
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

关键步骤：权限修改和新增用户

```
[apiclo@bogon pub]$ ls -l /var/ftp/pub
总用量 4
-rw-r--r--. 1 root root 32 2月  27 15:24 ftp.txt
[apiclo@bogon pub]$ sudo chmod o+w /var/ftp/pub
[apiclo@bogon pub]$ sudo adduser stu1
[apiclo@bogon pub]$ sudo adduser stu2
[apiclo@bogon pub]$ sudo passwd stu2
更改用户 stu2 的密码 。
新的 密码：
无效的密码： 密码未通过字典检查 - 过于简单化/系统化
重新输入新的 密码：
passwd：所有的身份验证令牌已经成功更新。

```

## 11、客户机成功通过新建的用户进行登陆
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

关键步骤：用户名使用刚才在服务器创建的用户

```
[siralop@localhost ~]$ ftp 192.168.20.2
Connected to 192.168.20.2 (192.168.20.2).
220 (vsFTPd 3.0.2)
Name (192.168.20.2:siralop): stu2
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.

```
<span style="color: rgba(0,0,0,0)">这篇文章是由Siralop写的</span>

<script src="/services/avatar_fix.js"></script>