function showCopySuccess() {
    const notionDiv = document.getElementById("copy-success");
    notionDiv.innerText = "复制成功"
    notionDiv.className = "copy-success-show"; // 显示提示框

    // 1秒后自动隐藏
    setTimeout(() => {
        notionDiv.className = "copy-success-hidden";
    }, 1000);
}
function showCopyFailed() {
    const notionDiv = document.getElementById("copy-failed");
    notionDiv.innerText = "复制失败"
    notionDiv.className = "copy-failed-show"; // 显示提示框
    // 1秒后自动隐藏
    setTimeout(() => {
        notionDiv.className = "copy-failed-hidden";
    }, 1000);
}
//生成从minNum到maxNum的随机数
function copyText(elementId) {
    const copyText = document.getElementById(elementId).innerText;
    navigator.clipboard.writeText(copyText).then(() => {
        showCopySuccess(); // 显示复制成功提示
    }).catch(err => {
        showCopyFailed();
    });
}
function randomNum(minNum = 0, maxNum = 100) {
    return Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum;
}
function generateRandomNumbers(count) {
    for (let i = 0; i < count; i++) {
        const randomNumValue = randomNum(-9223372036854775808, 9223372036854775807);
        document.getElementById(`random_num${i}`).innerHTML = randomNumValue;
    }
}

// 初始化生成5个随机数
generateRandomNumbers(5);