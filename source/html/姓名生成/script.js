import { surnames, girl_names1, boy_names1, girl_names2, boy_names2 } from './strings.js';

const generateFullName = () => {
    // 从 surnames 数组中随机选择一个姓氏
    const surname = surnames[Math.floor(Math.random() * surnames.length)];
    // 使用 Math.random() 生成一个 0 到 1 之间的随机数，如果小于 0.5 则生成女性名字，否则生成男性名字
    const givenName = Math.random() < 0.5
        // 如果随机数小于 0.5，从 girl_names1 和 girl_names2 数组中各随机选择一个部分，拼接成女性名字
        ? girl_names1[Math.floor(Math.random() * girl_names1.length)] + girl_names2[Math.floor(Math.random() * girl_names2.length)]
        // 如果随机数大于等于 0.5，从 boy_names1 和 boy_names2 数组中各随机选择一个部分，拼接成男性名字
        : boy_names1[Math.floor(Math.random() * boy_names1.length)] + boy_names2[Math.floor(Math.random() * boy_names2.length)];
    // 返回拼接后的全名
    return `${surname}${givenName}`;
};

const generateAll = () => {
    return {
        name0: generateFullName(),
        name1: generateFullName(),
        name2: generateFullName(),
        name3: generateFullName(),
        name4: generateFullName()
    };
};

const main = () => {

    const table = document.getElementById("userTable");

    const rows = table.getElementsByTagName('tr');
    while (rows.length > 1) {
        table.deleteRow(1);
    }

    for (let i = 0; i < 200; i++) {
        const profile = generateAll(); // 获取用户数据
        const row = table.insertRow(); // 插入一行
        row.insertCell(0).textContent = profile.name0; // 插入数据
        row.insertCell(1).textContent = profile.name1;
        row.insertCell(2).textContent = profile.name2;
        row.insertCell(3).textContent = profile.name3;
        row.insertCell(4).textContent = profile.name4;
    }

};

// 为按钮绑定点击事件，点击时调用 main 函数
document.getElementById("generateBtn").addEventListener("click", main);
