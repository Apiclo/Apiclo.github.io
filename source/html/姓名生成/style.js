// 获取按钮和背景的“开”字元素
const generateBtn = document.getElementById("generateBtn");
const userTable = document.getElementById("userTable");
const Title = document.getElementById("title");
const body = document.body;

// 创建巨大的“开”字
const bigText = document.createElement("div");
bigText.classList.add("big-text");
bigText.innerText = "开";
body.appendChild(bigText);

// 为按钮添加点击事件
generateBtn.addEventListener("click", () => {
    // 当点击按钮时显示巨大的“开”字，并更改背景颜色
    bigText.style.display = "block";
    userTable.style.display = "table";
    body.style.backgroundColor = "#fefefe";  // 你可以修改成任何你喜欢的颜色
    // 隐藏按钮
    generateBtn.className = "shieldBtn";
    generateBtn.innerText = "刷新";
    Title.style.display = "none";
});
