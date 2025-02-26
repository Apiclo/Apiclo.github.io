title: CentOS DNS服务配置记录
cover: /img/posts/tux.svg
date: 2025-2-26 15:39:00
tags: [CentOS,Shell,Linux]
categories: [Linux]
-------------------

# 你可能需要知道的:
[vim文本编辑器的使用方法](https://www.runoob.com/linux/linux-vim.html)


# 准备
## 切换国内软件源
vim repo.sh
文件内容:
```bash
sudo sed -i.bak \
  -e 's|^mirrorlist=|#mirrorlist=|g' \
  -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos-vault/centos|g' \
  /etc/yum.repos.d/CentOS-Base.repo
```
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
...
```
## 配置区域文件
sudo vim /etc/named.rfc1912.zones
文件内容
```plaintext
zone "k3k5.com" IN {
        type master;
        file "k3k5.com.zone";
};
zone "localhost.localdomain" IN {
        type master;
        file "named.localhost";
        allow-update { none; };
};
zone "56.168.192.in-addr.arpa" IN {
        type master;
        file "56.168.192.zone";
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
dns     A    192.168.56.XXX
test1    A    192.168.56.201
test2    A    192.168.56.202
testc   CNAME   test1

```
## 创建反向解析文件
sudo cp -p /var/named/named.empty /var/named/56.168.192.zone
sudo vim /var/named/56.168.192.zone
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
## 重启DNS服务
sudo systemctl restart named.service
出现错误,开始排错
```plaintext
Job for named.service failed because the control process exited with error code. See "systemctl status named.service" and "journalctl -xe" for details.

```

```plaintext
2月 26 15:12:50 bogon bash[127386]: _default/k3k5.com/IN: unknown class/type
2月 26 15:12:50 bogon bash[127386]: zone localhost.localdomain/IN: loaded serial 0
2月 26 15:12:50 bogon bash[127386]: 56.168.192.zone:8: unknown RR type 'dns.k3k5.com.'
2月 26 15:12:50 bogon bash[127386]: zone 56.168.192.in-addr.arpa/IN: loading from master file 56.168.192.zone f
2月 26 15:12:50 bogon bash[127386]: zone 56.168.192.in-addr.arpa/IN: not loaded due to errors.
2月 26 15:12:50 bogon bash[127386]: _default/56.168.192.in-addr.arpa/IN: unknown class/type
2月 26 15:12:50 bogon bash[127386]: zone localhost/IN: loaded serial 0
2月 26 15:12:50 bogon bash[127386]: zone 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.ar
2月 26 15:12:50 bogon bash[127386]: zone 1.0.0.127.in-addr.arpa/IN: loaded serial 0
2月 26 15:12:50 bogon bash[127386]: zone 0.in-addr.arpa/IN: loaded serial 0
2月 26 15:12:50 bogon systemd[1]: named.service: control process exited, code=exited status=1
2月 26 15:12:50 bogon systemd[1]: Failed to start Berkeley Internet Name Domain (DNS).
-- Subject: Unit named.service has failed
-- Defined-By: systemd

```

## 错误分析
1. **反向区域文件中的NS记录格式错误**：
   - 原始配置：`NS dns.k3k5.com.`
   - 错误原因：缺少记录类型前的`@ IN`，导致解析器误认为`NS`是域名，而`dns.k3k5.com.`是无效的RR类型。
   - 正确格式应为：`@ IN NS dns.k3k5.com.`

2. **PTR记录未使用完全限定域名（FQDN）**：
   - 例如`test1.k3k5.com`未以点结尾，会被解析为`test1.k3k5.com.56.168.192.in-addr.arpa`。
   - 正确格式应为：`test1.k3k5.com.`（末尾加点）。

## 修复步骤
1. **修正反向区域文件`56.168.192.zone`**：
```plaintext
$TTL 3H
@  IN SOA dns.k3k5.com. root.k3k5.com. (
1    ; serial
1D   ; refresh
1H   ; retry
1W   ; expire
3H )  ; minimum
@ IN NS dns.k3k5.com.
201   PTR   test1.k3k5.com.
202   PTR   test2.k3k5.com.
202   PTR   testc.k3k5.com.
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
dns     A    192.168.56.200  # 确保XXX替换为实际IP
test1   A    192.168.56.201
test2   A    192.168.56.202
testc   CNAME test1
```




3. **验证配置文件并重启服务**：
```bash
sudo named-checkconf /etc/named.conf # 检查主配置
sudo named-checkzone k3k5.com /var/named/k3k5.com.zone # 检查正向区域
sudo named-checkzone 56.168.192.in-addr.arpa /var/named/56.168.192.zone # 检查反向区域
sudo systemctl restart named
```

