title: SangFor基础业务场景实机配置记录
cover: /img/posts/sangfor.png
date: 2025-3-17 12:56:00
tags: [SangFor,Server,Network]
categories: [Server]
-------------------
# 实验要求
 ## 组网实验五 真机实验
 ### 需求客户现有拓扑环境如下：
 1. 出口申请了主电信外网线路（为 50M 带宽）。
 2. 内网有 web 服务器（linux 172.16.100.10）运行 http 服务，内外网用户通过出口设备公网地址访问 web 服务
 3. windows 2012 服务器（172.16.100.20）对内提供域服务，管理员在外网通过远程桌面管理服务器。
 ### 客户需求
 1. 实现内网PC能够外出通信。
 2. 外网PC能够访问内网web服务和AD的RDP服务。
 3. 完成需求后重置设备，注意设备重置后帐号密码为：admin/admin
# AF配置过程
### 接口配置
服务器设备连接到eth2网口，外网客户端连接到eth3网口，配置如下：

|设备|IP|连接到AF接口|角色|
|---|---|---|---|
|eth2|172.16.100.10/24|eth2|WEB|
|eth2|172.16.100.20/24|eth2|RDP|
|eth3|202.96.137.100/24|eth3|Client|

![AF接口配置信息](/img/posts/sangfor/af_image1.png)

### 防火墙路由配置
![AF路由配置信息](/img/posts/sangfor/af_image2.png)

### 防火墙策略配置
![AF策略配置信息](/img/posts/sangfor/af_image3.png)

### 防火墙地址转换配置
![AF地址转换配置信息](/img/posts/sangfor/af_image4.png)

# 内网服务器配置


### WEB服务器IP配置

![web服务器的ip信息（ip address）](/img/posts/sangfor/srv_image1.png)

```jsx
[apiclo@latitude ~]$ ip address | grep eno1
3: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 172.16.100.10/24 brd 172.16.100.255 scope global noprefixroute eno1
[apiclo@latitude ~]$ 

```

![web服务器的ip信息（plasma-nm）](/img/posts/sangfor/srv_image2.png)

![web服务器的ip信息（plasma-nm）](/img/posts/sangfor/srv_image3.png)

### AD、RDP 服务器的IP配置

![RDP服务器的ip信息（control）](/img/posts/sangfor/srv_image4.png)

![RDP服务器的ip信息（uwp-settings）](/img/posts/sangfor/srv_image5.png)

![RDP服务器的ip信息（ipconfig）](/img/posts/sangfor/srv_image6.png)


### 服务与连接测试
先试用本地同一内网测试服务是否正常，使用AD服务器访问WEB服务器

![局域网访问WEB服务器](/img/posts/sangfor/srv_image8.png)


内网ping防火墙网关,与防火墙通信正常

![服务器Ping防火墙网关](/img/posts/sangfor/srv_image7.png)

```jsx
[apiclo@latitude ~]$ ping 172.16.100.254
PING 172.16.100.254 (172.16.100.254) 56(84) 字节的数据。
64 字节，来自 172.16.100.254: icmp_seq=1 ttl=64 时间=0.680 毫秒
64 字节，来自 172.16.100.254: icmp_seq=2 ttl=64 时间=0.533 毫秒
64 字节，来自 172.16.100.254: icmp_seq=3 ttl=64 时间=0.633 毫秒
64 字节，来自 172.16.100.254: icmp_seq=4 ttl=64 时间=0.695 毫秒
^C
--- 172.16.100.254 ping 统计 ---
已发送 4 个包， 已接收 4 个包, 0% packet loss, time 3097ms
rtt min/avg/max/mdev = 0.533/0.635/0.695/0.063 ms
[apiclo@latitude ~]$ 

```





# 结果测试

### 外网客户端Ping防火墙网关
![外网客户端Ping防火墙网关](/img/posts/sangfor/client_image1.png)

### 外网客户端访问WEB服务器
![外网客户端访问WEB服务器](/img/posts/sangfor/client_image2.png)

### 外网客户端访问AD服务器
![外网客户端访问AD服务器](/img/posts/sangfor/client_image3.png)

### 内网客户端访问外网

![image.png](/img/posts/sangfor/srv_image9.png)