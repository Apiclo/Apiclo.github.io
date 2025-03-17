
// 配置参数
const CONFIG = {
    DOH_PROVIDERS: [
        'https://dns.alidns.com/resolve',  // 支持 CORS 的 DNS 服务
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
// DNS记录查询
async function getDNSRecords(domain, type = 'A') {
    const recordType = type === 'A' ? 1 : 28; // A 记录类型为 1，AAAA 记录类型为 28

    for (const endpoint of CONFIG.DOH_PROVIDERS) {
        for (let attempt = 0; attempt < CONFIG.RETRY_TIMES; attempt++) {
            try {
                const url = `${endpoint}?name=${domain}&type=${type}`;
                const response = await fetch(url, {
                    headers: { 'Accept': 'application/dns-json' }
                });

                if (!response.ok) continue;

                const data = await response.json();

                // 检查返回状态是否为成功
                if (data.Status !== 0) {
                    console.debug(`DNS查询失败 [${endpoint}]: 状态码 ${data.Status}`);
                    continue;
                }

                // 提取 Answer 字段
                const answers = data.Answer || [];

                // 过滤出指定类型的记录，并提取 IP 地址
                return answers
                    .filter(r => r.type === recordType) // 过滤出 A 或 AAAA 记录
                    .map(r => r.data.replace(/\.$/, '')); // 去除域名末尾的点（如果有）
            } catch (error) {
                console.debug(`DNS查询失败 [${endpoint}]:`, error.message);
            }
        }
    }
    return []; // 如果没有找到记录，返回空数组
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

// IP验证函数
function validateIP(ip) {
    return /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/.test(ip) ||
        /^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$/.test(ip);
}

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

                if (validateIP(ip)) {
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

// 初始化
window.addEventListener('load', () => {
    showDNSInfo();
    getClientIP();
});