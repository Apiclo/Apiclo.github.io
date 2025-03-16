// 配置参数
const CONFIG = {
    DOH_PROVIDERS: [
        'https://cloudflare-dns.com/dns-query',
        'https://dns.google/resolve',
        'https://doh.opendns.com/dns-query'
    ],
    IP_API_PROVIDERS: [
        'https://api.ipify.org?format=json',
        'https://ipv4.icanhazip.com/',
        'https://ipv6.icanhazip.com/'
    ],
    RETRY_TIMES: 2
};

// 状态管理对象
const StatusManager = {
    setStatus: (type, status) => {
        const indicator = document.querySelector(`.status-indicator[data-type="${type}"]`);
        if (indicator) {
            indicator.className = `status-indicator ${status}`;
        }
    },
    
    setClientStatus: (status) => {
        StatusManager.setStatus('client', status);
    }
};

// DNS记录查询
async function getDNSRecords(domain, type = 'A') {
    const recordType = type === 'A' ? 1 : 28;
    
    for (const endpoint of CONFIG.DOH_PROVIDERS) {
        for (let attempt = 0; attempt < CONFIG.RETRY_TIMES; attempt++) {
            try {
                const url = `${endpoint}?name=${domain}&type=${type}`;
                const response = await fetch(url, {
                    headers: { 'Accept': 'application/dns-json' }
                });

                if (!response.ok) continue;
                
                const data = await response.json();
                const answers = data.Answer || data.answers || [];
                
                return answers
                    .filter(r => r.type === recordType)
                    .map(r => r.data.replace(/\.$/, ''));
            } catch (error) {
                console.debug(`DNS查询失败 [${endpoint}]:`, error.message);
            }
        }
    }
    return [];
}

// 更新IP显示
function updateIPDisplay(containerId, values, type) {
    const container = document.getElementById(containerId);
    container.innerHTML = '';
    
    if (values.length > 0) {
        values.forEach(ip => {
            const pre = document.createElement('pre');
            pre.textContent = ip;
            container.appendChild(pre);
        });
        StatusManager.setStatus(type, 'success');
    } else {
        const error = document.createElement('div');
        error.className = 'ip-error';
        error.textContent = `未找到${type.toUpperCase()}记录`;
        container.appendChild(error);
        StatusManager.setStatus(type, 'error');
    }
}

// 获取服务器信息
async function showDNSInfo() {
    const currentDomain = window.location.hostname;
    
    try {
        const [ipv4List, ipv6List] = await Promise.all([
            getDNSRecords(currentDomain, 'A'),
            getDNSRecords(currentDomain, 'AAAA')
        ]);

        updateIPDisplay('server-ipv4-list', ipv4List, 'ipv4');
        updateIPDisplay('server-ipv6-list', ipv6List, 'ipv6');
    } catch (error) {
        console.error('DNS查询失败:', error);
        updateIPDisplay('server-ipv4-list', [], 'ipv4');
        updateIPDisplay('server-ipv6-list', [], 'ipv6');
    }
}

// 获取客户端信息
async function getClientIP() {
    try {
        for (const api of CONFIG.IP_API_PROVIDERS) {
            try {
                const response = await fetch(api);
                const data = await response.text();
                const ip = data.startsWith('{') ? JSON.parse(data).ip : data.trim();

                if (validateIP(ip)) {
                    document.getElementById('client-ip').textContent = ip;
                    document.getElementById('connection-type').textContent = 
                        ip.includes(':') ? 'IPv6' : 'IPv4';
                    StatusManager.setClientStatus('success');
                    return;
                }
            } catch (error) {
                console.debug(`IP API失败 [${api}]:`, error.message);
            }
        }
        throw new Error('所有API请求失败');
    } catch (error) {
        console.error('客户端IP获取失败:', error);
        document.getElementById('client-ip').textContent = '获取失败';
        StatusManager.setClientStatus('error');
    }
}

// IP验证函数
function validateIP(ip) {
    return /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/.test(ip) || 
           /^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$/.test(ip);
}

// 初始化
window.addEventListener('load', () => {
    showDNSInfo();
    getClientIP();
});