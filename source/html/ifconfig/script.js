
    // 获取当前访问域名
    const currentDomain = window.location.hostname;
    
    // 国内DNS服务（腾讯云DNSPod）
    async function getDNSRecords(domain, type = 'A') {
        try {
            const response = await fetch(
                `https://doh.pub/dns-query?name=${domain}&type=${type}`,
                {
                    headers: { 'Accept': 'application/dns-json' }
                }
            );
            
            if (!response.ok) throw new Error('DNS查询失败');
            const data = await response.json();
            return data.Answer ? data.Answer.map(record => record.data) : [];
        } catch (error) {
            console.error(`DNS ${type}记录查询失败:`, error);
            return [];
        }
    }

    // 显示DNS信息到独立卡片
    async function showDNSInfo() {
        try {
            // 获取卡片元素
            const ipv4Card = document.getElementById('server-ipv4');
            const ipv6Card = document.getElementById('server-ipv6');
            const statusIPv4 = document.querySelector('#server-ipv4 ~ .status-indicator');
            const statusIPv6 = document.querySelector('#server-ipv6 ~ .status-indicator');

            // 显示加载状态
            ipv4Card.textContent = '正在查询...';
            ipv6Card.textContent = '正在查询...';
            statusIPv4.className = 'status-indicator loading';
            statusIPv6.className = 'status-indicator loading';

            // 并行查询
            const [ipv4List, ipv6List] = await Promise.all([
                getDNSRecords(currentDomain, 'A'),
                getDNSRecords(currentDomain, 'AAAA')
            ]);

            // 更新IPv4卡片
            if (ipv4List.length > 0) {
                ipv4Card.innerHTML = ipv4List.join('<br>');
                statusIPv4.className = 'status-indicator success';
            } else {
                ipv4Card.textContent = '未找到IPv4记录';
                statusIPv4.className = 'status-indicator error';
            }

            // 更新IPv6卡片
            if (ipv6List.length > 0) {
                ipv6Card.innerHTML = ipv6List.join('<br>');
                statusIPv6.className = 'status-indicator success';
            } else {
                ipv6Card.textContent = '未找到IPv6记录';
                statusIPv6.className = 'status-indicator error';
            }

        } catch (error) {
            console.error('DNS查询失败:', error);
            document.getElementById('server-ipv4').textContent = '查询失败';
            document.getElementById('server-ipv6').textContent = '查询失败';
            document.querySelectorAll('.status-indicator').forEach(
                el => el.className = 'status-indicator error'
            );
        }
    }

    // 获取客户端IP（优化版）
    async function getClientIP() {
        try {
            // 尝试多个API
            const apis = [
                'https://www.taobao.com/help/getip.php',
                'https://ip.3322.net/',
                'https://v6.ip.zxinc.org/getip'
            ];

            for (const api of apis) {
                try {
                    const response = await fetch(api);
                    const text = await response.text();
                    
                    // 处理不同API响应
                    let ip = '';
                    if (api.includes('taobao')) {
                        const match = text.match(/"ip":"([^"]+)"/);
                        ip = match ? match[1] : null;
                    } else {
                        ip = text.trim();
                    }

                    if (ip && /\d+\.\d+\.\d+\.\d+/.test(ip) || /:/.test(ip)) {
                        document.getElementById('client-ip').textContent = ip;
                        document.getElementById('connection-type').textContent = 
                            ip.includes(':') ? 'IPv6' : 'IPv4';
                        return;
                    }
                } catch (e) { continue; }
            }
            throw new Error('所有API均失败');

        } catch (error) {
            console.error('客户端信息获取失败:', error);
            document.getElementById('client-ip').textContent = '获取失败';
            document.getElementById('connection-type').textContent = '检测失败';
        }
    }

    // 初始化
    window.addEventListener('load', () => {
        showDNSInfo();
        getClientIP();
    });