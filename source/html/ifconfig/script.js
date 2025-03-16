
    // 国内可用API列表
    const DNS_APIS = [
        'https://dns.alidns.com/resolve',
        'https://doh.360.cn/resolve'
    ];

    const IP_APIS = [
        'https://ip.seeing.cz/json',
        'https://forge.speedtest.cn/api/location/ip',
        'https://ip.useragentinfo.com/json'
    ];

    // 随机选择可用API
    function getRandomAPI(apis) {
        return apis[Math.floor(Math.random() * apis.length)];
    }

    // DNS查询方法（支持重试）
    async function queryDNSWithRetry(domain, type, retries = 2) {
        for (let i = 0; i < retries; i++) {
            try {
                const api = getRandomAPI(DNS_APIS);
                const response = await fetch(`${api}?name=${domain}&type=${type}`, {
                    headers: { 'Accept': 'application/dns-json' }
                });
                
                if (!response.ok) throw new Error('DNS查询失败');
                const data = await response.json();
                
                if (data.Status === 0 && data.Answer) {
                    return data.Answer.map(record => record.data);
                }
            } catch (error) {
                if (i === retries - 1) throw error;
            }
        }
        return [];
    }

    // 更新卡片状态
    function updateCardStatus(type, status) {
        const indicator = document.querySelector(`#server-${type} ~ .status-indicator`);
        indicator.className = `status-indicator ${status}`;
    }

    // 显示DNS信息（优化版）
    async function showDNSInfo() {
        const domain = window.location.hostname;
        
        try {
            const [ipv4Records, ipv6Records] = await Promise.all([
                queryDNSWithRetry(domain, 'A'),
                queryDNSWithRetry(domain, 'AAAA')
            ]);

            // 处理IPv4结果
            const ipv4Element = document.getElementById('server-ipv4');
            if (ipv4Records.length > 0) {
                ipv4Element.innerHTML = ipv4Records.join('<br>');
                updateCardStatus('ipv4', 'success');
            } else {
                ipv4Element.textContent = '未找到IPv4记录';
                updateCardStatus('ipv4', 'error');
            }

            // 处理IPv6结果
            const ipv6Element = document.getElementById('server-ipv6');
            if (ipv6Records.length > 0) {
                ipv6Element.innerHTML = ipv6Records.join('<br>');
                updateCardStatus('ipv6', 'success');
            } else {
                ipv6Element.textContent = '未找到IPv6记录';
                updateCardStatus('ipv6', 'error');
            }
        } catch (error) {
            console.error('DNS查询失败:', error);
            document.getElementById('server-ipv4').textContent = '查询失败';
            document.getElementById('server-ipv6').textContent = '查询失败';
            updateCardStatus('ipv4', 'error');
            updateCardStatus('ipv6', 'error');
        }
    }

    // 获取客户端IP（优化版）
    async function getClientIP() {
        try {
            // 尝试多个API直到成功
            for (const api of IP_APIS) {
                try {
                    const response = await fetch(api);
                    if (!response.ok) continue;
                    
                    const data = await response.json();
                    const ip = data.ip || data.data || data.ipaddress;
                    if (ip) {
                        document.getElementById('client-ip').textContent = ip;
                        document.getElementById('connection-type').textContent = 
                            ip.includes(':') ? 'IPv6' : 'IPv4';
                        return;
                    }
                } catch (e) {
                    continue;
                }
            }
            throw new Error('所有IP API均失败');
        } catch (error) {
            console.error('客户端信息获取失败:', error);
            document.getElementById('client-ip').textContent = '获取失败';
            document.getElementById('connection-type').textContent = '检测失败';
        }
    }

    // 页面加载初始化
    window.addEventListener('load', () => {
        showDNSInfo();
        getClientIP();
    });