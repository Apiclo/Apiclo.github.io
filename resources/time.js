// 睡大觉函数
function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// 时间显示
var timeEl = document.getElementById("text");
setInterval(function showTime() {
    var d = new Date();
    timeEl.innerHTML = d.toTimeString().substring(0, 8); // 修正时间显示
}, 1000);

// 防止息屏
var wakeLock = null;
function canWL() {
    return 'wakeLock' in navigator;
}
function setWL() {
    if (!canWL()) {
        console.error('不支持 WakeLock API');
        return;
    }
    if (wakeLock) {
        return;
    }
    navigator.wakeLock.request('screen').then(lock => {
        wakeLock = lock;
        console.log('Wake Lock activated!');
        wakeLock.addEventListener('release', () => {
            wakeLock = null;
            console.log('Wake Lock released!');
        });
    }).catch(err => {
        console.error(`Wake Lock failed: ${err.message}`);
    });
}
setWL();

if (canWL()) {
    document.addEventListener('visibilitychange', () => {
        if (!wakeLock && document.visibilityState === 'visible') {
            setWL();
        }
    });
}

// 全屏
var htmlEl = document.querySelector('html');
var fsBtn = document.getElementById('full-screen-btn');
fsBtn.onclick = () => {
    if (htmlEl.requestFullscreen) {
        htmlEl.requestFullscreen();
    } else if (htmlEl.webkitRequestFullscreen) { // Safari
        htmlEl.webkitRequestFullscreen();
    } else if (htmlEl.mozRequestFullScreen) { // Firefox
        htmlEl.mozRequestFullScreen();
    } else if (htmlEl.msRequestFullscreen) { // IE/Edge
        htmlEl.msRequestFullscreen();
    }
}

// 字体粗细
var fwPlusBtn = document.getElementById('font-weight-plus');
var fwMinusBtn = document.getElementById('font-weight-minus');

const chgFW = (inc) => {
    let currW = parseInt(getComputedStyle(timeEl).fontWeight, 10);
    let newW = Math.max(100, Math.min(currW + inc, 900));
    newW = Math.round(newW / 100) * 100;  // 确保字体重量为100的倍数

    const weights = {
        100: 'Thin', 200: 'ExLt', 300: 'Light', 400: 'Normal',
        500: 'Medium', 600: 'SeBd', 700: 'Bold', 800: 'ExBd', 900: 'Heavy'
    };

    timeEl.style.fontWeight = newW;
    console.log(`当前字重: ${newW} ${weights[newW]}`);
};

fwPlusBtn.onclick = () => chgFW(100);
fwMinusBtn.onclick = () => chgFW(-100);

// 字体颜色
var clrBtn = document.getElementById('font-color-switch');
var colors = ["#ffffff", "#101010", "#efeee9", "#619ac3", "#df669a",
    "#2f5a62", "#f8df72", "#3c1a4c", "#eea2a4", "#404040"];
let idx = 0, btnIdx = 1;

const chgColor = () => {
    idx = (idx + 1) % colors.length;
    btnIdx = (btnIdx + 1) % colors.length;

    let currClr = getComputedStyle(timeEl).color;
    console.log(`#################\n当前字体色彩: ${currClr}
        \n时间字体色彩: ${idx}; \n按钮字体色彩: ${btnIdx}`);

    let newClr = colors[idx];
    let btnClr = colors[btnIdx];

    timeEl.style.color = newClr;
    timeEl.style.textShadow = `0px 2px 1px ${newClr}`;
    clrBtn.style.backgroundColor = newClr;
    clrBtn.style.border = `solid 1px ${btnClr}`;
    clrBtn.style.color = btnClr;
    clrBtn.style.transition = '1s';
    clrBtn.style.boxShadow = `0px 1px 4px ${newClr}`;

    console.log(`时间字体色彩: ${newClr}; \n按钮字体色彩: ${btnClr}`);
};

clrBtn.onclick = chgColor;
