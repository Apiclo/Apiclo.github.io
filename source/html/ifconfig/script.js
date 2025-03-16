// 配置参数
const DNS_PROVIDERS = [
    'https://cloudflare-dns.com/dns-query',
    'https://dns.google/resolve',
    'https://doh.opendns.com/dns-query'
];
const IP_APIS = [
    'https://api.ipify.org?format=json',
    'https://ipv4.icanhazip.com/',
    'https://ipv6.icanhazip.com/'
];

// 增强版DNS查询
async function getDNSRecords(domain, type = 'A') {
    const recordType = type === 'A' ? 1 : 28;
    
    for (const endpoint of DNS_PROVIDERS) {
        try {
            const response = await fetch(`${endpoint}?name=${domain}&type=${type}`, {
                headers: { 'Accept': 'application/dns-json' }
            });
            
            if (!response.ok) continue;
            
            const data = await response.json();
            const answers = data.Answer || data.answers || [];
            
            return answers
                .filter(r => r.type === recordType)
                .map(r => r.data.replace(/\.$/, ''));
        } catch (error) {
            console.debug(`DNS查询失败 [${endpoint}]:`, error);
        }
    }
    return [];
}

// 服务器信息查询
async function showDNSInfo() {
    const currentDomain = window.location.hostname;
    const setStatus = (element, status) => {
        element.className = `status-indicator ${status}`;
    };

    const ipv4Element = document.getElementById('server-ipv4');
    const ipv6Element = document.getElementById('server-ipv6');
    const statusIPv4 = document.querySelector('#server-ipv4 ~ .status-indicator');
    const statusIPv6 = document.querySelector('#server-ipv6 ~ .status-indicator');

    // 保持原有DOM操作逻辑
    ipv4Element.textContent = '正在查询...';
    ipv6Element.textContent = '正在查询...';
    statusIPv4.className = 'status-indicator loading';
    statusIPv6.className = 'status-indicator loading';

    try {
        const [ipv4List, ipv6List] = await Promise.all([
            getDNSRecords(currentDomain, 'A'),
            getDNSRecords(currentDomain, 'AAAA')
        ]);

        // 保持原有更新方式
        ipv4Element.innerHTML = ipv4List.length 
            ? ipv4List.join('<br>') 
            : '未找到IPv4记录';
        statusIPv4.className = `status-indicator ${ipv4List.length ? 'success' : 'error'}`;

        ipv6Element.innerHTML = ipv6List.length 
            ? ipv6List.join('<br>') 
            : '未找到IPv6记录';
        statusIPv6.className = `status-indicator ${ipv6List.length ? 'success' : 'error'}`;
    } catch (error) {
        console.error('DNS查询失败:', error);
        ipv4Element.textContent = '查询失败';
        ipv6Element.textContent = '查询失败';
        statusIPv4.className = 'status-indicator error';
        statusIPv6.className = 'status-indicator error';
    }
}

// 优化版客户端IP获取
async function getClientIP() {
    const ipElement = document.getElementById('client-ip');
    const typeElement = document.getElementById('connection-type');

    for (const api of IP_APIS) {
        try {
            const response = await fetch(api);
            const data = await response.text();
            const ip = data.startsWith('{') 
                ? JSON.parse(data).ip 
                : data.trim();

            if (/^(\d+\.){3}\d+$/.test(ip)) {  // IPv4
                ipElement.textContent = ip;
                typeElement.textContent = 'IPv4';
                return;
            }
            if (/^([\da-fA-F]{1,4}:){7}[\da-fA-F]{1,4}$/.test(ip)) {  // IPv6
                ipElement.textContent = ip;
                typeElement.textContent = 'IPv6';
                return;
            }
        } catch (error) {
            console.debug(`IP API失败 [${api}]:`, error);
        }
    }
    
    ipElement.textContent = '获取失败';
    typeElement.textContent = '检测失败';
}

// 初始化逻辑保持不变
window.addEventListener('load', () => {
    showDNSInfo();
    getClientIP();
});