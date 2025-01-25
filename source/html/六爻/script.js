const hexagramItems = document.querySelectorAll('.hexagram-item');
const resultItems = document.querySelectorAll('.result-item');
const hexagramExplanation = document.getElementById('hexagram-explanation');

const hexagramExplanations = {
    "111111": "乾为天",
    "111110": "天风姤",
    "111100": "天山遁",
    "111000": "天地否",
    "110000": "风地观",
    "100000": "山地剥",
    "101000": "火地晋",
    "101111": "火天大有",
    "001001": "震为雷",
    "001000": "雷地豫",
    "001010": "雷水解",
    "001110": "雷风恒",
    "000110": "地风升",
    "010110": "水风井",
    "011110": "泽风大过",
    "011001": "泽雷随",
    "010010": "坎为水",
    "010011": "水泽节",
    "010001": "水雷屯",
    "010101": "水火未济",
    "011101": "泽火革",
    "001101": "雷火丰",
    "000101": "地火明夷",
    "000010": "地水师",
    "100100": "艮为山",
    "100101": "山火贲",
    "100111": "山天大畜",
    "100011": "山泽损",
    "101011": "泽火睽",
    "111011": "天泽履",
    "110011": "风泽中孚",
    "110100": "风山渐",
    "000000": "坤为地",
    "000001": "地雷复",
    "000011": "地泽临",
    "000111": "地天泰",
    "001111": "雷天大壮",
    "011111": "泽天决",
    "010111": "水天需",
    "010000": "水地比",
    "110110": "巽为风",
    "110111": "风天小畜",
    "110101": "风火家人",
    "110001": "风雷益",
    "111001": "天雷无妄",
    "101001": "火雷噬嗑",
    "100001": "山雷颐",
    "100110": "山风盅",
    "101101": "离为火",
    "101100": "火山旅",
    "101110": "火风鼎",
    "101010": "水火未济",
    "100010": "山水蒙",
    "110010": "风水涣",
    "111010": "天水讼",
    "111101": "天火同人",
    "011011": "兑为泽",
    "011010": "泽水困",
    "011000": "泽地萃",
    "011100": "泽山咸",
    "010100": "山水寒",
    "000100": "地山谦",
    "001100": "雷山小过",
    "001011": "雷泽归妹"
};

let selectedHexagram = '';

// 事件监听点击的卦象项
hexagramItems.forEach((item, index) => {
    item.addEventListener('click', () => {
        if (item.textContent === "阳") {
            item.textContent = "阴";  // 变为阴
            item.className = 'hexagram-item selected';
            updateSelectedHexagram(); // 更新卦象结果
        } else {
            item.textContent = "阳";  // 变为阳
            item.className = 'hexagram-item unselected';
            updateSelectedHexagram(); // 更新卦象结果
        }

    });
});

// 更新选中的卦象
function updateSelectedHexagram() {
    selectedHexagram = '';
    hexagramItems.forEach((item) => {
        selectedHexagram += item.textContent === "阳" ? '1' : '0'; // 阳为1，阴为0
    });

    // 将选择的结果从左到右反转
    selectedHexagram = selectedHexagram.split('').reverse().join('');

    // 更新结果显示
    resultItems.forEach((item, index) => {
        item.textContent = selectedHexagram[index];
    });

    // 显示卦象解释
    const explanation = hexagramExplanations[selectedHexagram] || '未找到对应的卦象解释';
    hexagramExplanation.textContent = explanation;
}