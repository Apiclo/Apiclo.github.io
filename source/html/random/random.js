function showCopySuccess() {
    const successDiv = document.getElementById("copy-success");
    successDiv.className = "copy-success-show"; // 显示提示框

    // 1秒后自动隐藏
    setTimeout(() => {
        successDiv.className = "copy-success-hidden";
    }, 1000);
}
//生成从minNum到maxNum的随机数
function copyText(elementId) {
    const copyText = document.getElementById(elementId).innerText;
    navigator.clipboard.writeText(copyText).then(() => {
        showCopySuccess(); // 显示复制成功提示
    }).catch(err => {
        console.error("复制失败: ", err);
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