
        // 使用腾讯云DNS服务
        const DNS_API = 'https://doh.pub/dns-query';

        async function queryDNS(domain, type) {
            try {
                const response = await fetch(`${DNS_API}?name=${domain}&type=${type}`, {
                    headers: { 'Accept': 'application/dns-json' }
                });
                
                if (!response.ok) throw new Error('查询失败');
                const data = await response.json();
                return data.Answer || [];
            } catch (error) {
                console.error(`${type}记录查询失败:`, error);
                return [];
            }
        }

        // 更新卡片状态
        function updateCardStatus(type, status) {
            const indicator = document.querySelector(`#server-${type} ~ .status-indicator`);
            indicator.className = `status-indicator ${status}`;
        }

        // 显示DNS信息
        async function showDNSInfo() {
            const domain = window.location.hostname;
            
            // 并行查询两种记录
            const [ipv4Records, ipv6Records] = await Promise.all([
                queryDNS(domain, 'A'),
                queryDNS(domain, 'AAAA')
            ]);

            // 处理IPv4结果
            const ipv4Element = document.getElementById('server-ipv4');
            if (ipv4Records.length > 0) {
                ipv4Element.innerHTML = ipv4Records.map(r => r.data).join('<br>');
                updateCardStatus('ipv4', 'success');
            } else {
                ipv4Element.textContent = '未找到IPv4记录';
                updateCardStatus('ipv4', 'error');
            }

            // 处理IPv6结果
            const ipv6Element = document.getElementById('server-ipv6');
            if (ipv6Records.length > 0) {
                ipv6Element.innerHTML = ipv6Records.map(r => r.data).join('<br>');
                updateCardStatus('ipv6', 'success');
            } else {
                ipv6Element.textContent = '未找到IPv6记录';
                updateCardStatus('ipv6', 'error');
            }
        }

        // 获取客户端信息（使用国内服务）
        async function getClientIP() {
            try {
                const response = await fetch('https://ip.3322.net/');
                const ip = await response.text();
                
                document.getElementById('client-ip').textContent = ip;
                document.getElementById('connection-type').textContent = 
                    ip.includes(':') ? 'IPv6' : 'IPv4';
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
