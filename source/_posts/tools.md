---
title: 一些之前的纯html小工具
cover: /img/posts/tools.svg
date: 2099-12-31 23:59:59
categories: [Tools]
tags: [Tools,FrontEnd,HTML]
---

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelector('.post-copyright__author_img_front').src = '/img/site/ava.jpg'
    })
</script>
<style>
.btn-container {
    margin: 15px 0;
}

.custom-btn {
    background-color: #425aef;
    border: none;
    color: white;
    padding: 12px 24px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 20px 2px 4px 2px;
    cursor: pointer;
    border-radius: 15px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
}

.custom-btn:hover {
    background-color: #323a8f;
    transform: translateY(-2px);
    box-shadow: 0 6px 8px rgba(0,0,0,0.2);
}
</style>

## 一些之前的纯html小工具

<div class="btn-container">
<a href="/html/ifconfig/"><button class="custom-btn">🌐 网络信息检测</button></a>
<p>提供服务器与客户端的IPV4/IPV6信息</p>
</div>

<div class="btn-container">
<a href="/html/姓名生成/"><button class="custom-btn">📛 随机姓名生成器</button></a>
<p>随机生成虚拟中文姓名</p>
</div>

<div class="btn-container">
<a href="/html/六爻/"><button class="custom-btn">☯ 六爻卦象生成器</button></a>
<p>基于传统易经的随机卦象生成</p>
</div>

<div class="btn-container">
<a href="/html/random/"><button class="custom-btn">🎲 真随机数生成器</button></a>
<p>基于环境噪声的随机种子生成</p>
</div>

<div class="btn-container">
<a href="/html/ram/"><button class="custom-btn">💻 资源压力测试</button></a>
<p>系统性能测试工具，快速填满内存，快速占用CPU</p>
</div>

<div class="btn-container">
<a href="/html/wedding/"><button class="custom-btn">🍟 疯狂星期四模拟器</button></a>
<p>趣味互动小游戏</p>
</div>

<div class="btn-container">
<a href="/html/time/"><button class="custom-btn">🕒 个性化数字时钟</button></a>
<p>支持自定义主题的现代化时钟</p>
</div>

<div class="btn-container">
<a href="/html/clock/"><button class="custom-btn">⏳ 极简兼容时钟</button></a>
<p>适配老旧设备的轻量级时钟</p>
</div>