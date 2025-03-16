// 修改配置参数
const CONFIG = {
    DOH_PROVIDERS: [
        'https://cloudflare-dns.com/dns-query',
        'https://dns.google/resolve',
        'https://doh.opendns.com/dns-query'
    ],
    IP_API_PROVIDERS: {
        ipv4: [
            'https://api.ipify.org?format=json',
            'https://ipv4.icanhazip.com/'
        ],
        ipv6: [
            'https://api6.ipify.org?format=json',
            'https://ipv6.icanhazip.com/'
        ]
    },
    RETRY_TIMES: 2
};

// 新增IP获取方法
async function fetchIP(type) {
    const endpoints = CONFIG.IP_API_PROVIDERS[type];
    for (const endpoint of endpoints) {
        for (let attempt = 0; attempt < CONFIG.RETRY_TIMES; attempt++) {
            try {
                const response = await fetch(endpoint);
                if (!response.ok) continue;
                
                const data = await response.text();
                const ip = data.startsWith('{') 
                    ? JSON.parse(data).ip 
                    : data.trim();

                if (validateIP(ip) {
                    return ip;
                }
            } catch (error) {
                console.debug(`${type} API请求失败 [${endpoint}]:`, error.message);
            }
        }
    }
    return null;
}

// 修改客户端信息获取逻辑
async function getClientIP() {
    try {
        const [ipv4Result, ipv6Result] = await Promise.allSettled([
            fetchIP('ipv4'),
            fetchIP('ipv6')
        ]);

        const ipv4 = ipv4Result.status === 'fulfilled' ? ipv4Result.value : null;
        const ipv6 = ipv6Result.status === 'fulfilled' ? ipv6Result.value : null;

        // 更新显示
        document.getElementById('client-ipv4').textContent = ipv4 || '未检测到';
        document.getElementById('client-ipv6').textContent = ipv6 || '未检测到';
        
        // 控制IPv6显示
        const ipv6Item = document.querySelector('.ipv6-item');
        ipv6Item.style.display = ipv6 ? 'block' : 'none';

        // 更新连接类型
        let connectionType = '未知';
        if (ipv4 && ipv6) {
            connectionType = '双栈网络';
        } else if (ipv4) {
            connectionType = 'IPv4';
        } else if (ipv6) {
            connectionType = 'IPv6';
        }
        document.getElementById('connection-type').textContent = connectionType;

        // 更新状态
        StatusManager.setClientStatus(ipv4 || ipv6 ? 'success' : 'error');
    } catch (error) {
        console.error('客户端信息获取失败:', error);
        StatusManager.setClientStatus('error');
    }
}

// 修改初始化部分（保持原有调用不变）
window.addEventListener('load', () => {
    showDNSInfo();
    getClientIP();
});