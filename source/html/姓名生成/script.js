import { surnames, girl_names1, boy_names1, girl_names2, boy_names2 } from './strings.js';

const generateFullName = () => {
    const surname = surnames[Math.floor(Math.random() * surnames.length)];
    const isMale = Math.random() < 0.5;
    
    let givenName;
    if (isMale) {
        // 防叠词循环验证
        let second, third;
        do {
            second = boy_names1[Math.floor(Math.random() * boy_names1.length)];
            third = boy_names2[Math.floor(Math.random() * boy_names2.length)];
        } while (
            // 排除叠字组合 (如"宇宇") 和双空格
            second.trim() === third.trim() || 
            (second.trim() === "" && third.trim() === "")
        );
        givenName = second + third;
    } else {
        givenName = 
            girl_names1[Math.floor(Math.random() * girl_names1.length)] + 
            girl_names2[Math.floor(Math.random() * girl_names2.length)];
    }

    // 清理连续空格 (如"张  伟"→"张伟")
    return `${surname}${givenName.replace(/ {2,}/g, '')}`;
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
