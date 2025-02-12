// 权重数组生成器
const createWeightedArray = (configs, total) => {
  let arr = [];
  configs.forEach(([char, count]) => arr.push(...Array(count).fill(char)));
  while(arr.length < total) arr.push('');
  return arr.slice(0, total);
};

// ===================== 姓氏库（1000元素） =====================
let surnames = [
  ...createWeightedArray([
    ["李",120], ["王",120], ["张",90], ["刘",90],
    ["陈",60], ["杨",60], ["黄",45], ["周",45],
    ["吴",30], ["徐",30], ["孙",30], ["马",30],
    ["朱",15], ["胡",15], ["郭",15], ["何",12],
    ["高",12], ["林",12], ["罗",10], ["梁",10],
    ["宋",10], ["郑",8], ["谢",8], ["唐",8]
  ], 630),
  
  // 新增姓氏（每个出现5次）
  ...createWeightedArray([
    ["萧",5], ["季",5], ["乔",5], ["龚",5], ["殷",5],
    ["钱",5], ["黎",5], ["段",5], ["施",5], ["邵",5],
    ["卢",5], ["傅",5], ["尤",5], ["贺",5], ["邹",5],
    ["顾",5], ["孟",5], ["平",5], ["白",5], ["崔",5],
    ["康",5], ["毛",5], ["许",5]
  ], 115),

  // 其他常见姓氏
  "蔡","谭","石","侯","武","孔","汤","常","文","樊",
  "向","赖","史","万","韩","冯","于","董","程","曹",
  "严","杜","苏","魏","蒋","邓","范","方","余","潘",
  "曾","戴","夏","钟","吕","陆","田","邱","彭","贾"
];

// ===================== 女生名字部分 =====================
let girl_names1 = [
  ...createWeightedArray([
    ["婷",145], ["欣",115], ["雅",90], ["琳",90],
    ["雨",60], ["萌",65], ["洁",60], ["怡",60],
    ["雯",45], ["月",45], ["  ",30], ["妍",15],
    ["璐",15], ["雪",15], ["芳",15], ["莹",15],
    ["瑶",15], ["静",5], ["敏",5], ["娜",5],
    ["萍",5], ["琪",5], ["楚",5], ["玲",5]
  ], 860),
  
  // 新增字（每个5次）
  ...createWeightedArray([
    ["芸",5], ["钰",5], ["颖",5], ["莉",5], ["茜",5],
    ["媛",5], ["菲",5], ["梦",5], ["诗",5], ["婉",5],
    ["若",5], ["思",5], ["清",5], ["宁",5]
  ], 70),

  // 冷门字（每个1次）
  "媞","婠","嬅","嫊","嬑","妶","姈","嫙","嬟","姌",
  "嫝","珂","双","媄","嫭","菁","娅","紫","琦","冉"
];

let girl_names2 = [
  ...createWeightedArray([
    ["婷",175], ["琳",115], ["瑶",90], ["欣",90],
    ["怡",60], ["洁",60], ["芳",45], ["雪",45],
    ["佳",30], ["璇",15], ["彤",15], ["萱",15],
    ["月",15], ["莹",15], ["妮",15], ["丽",15],
    ["淑",15], ["慧",15], ["娟",5], ["梅",5]
  ], 860),
  
  // 新增字
  ...createWeightedArray([
    ["云",5], ["琪",5], ["宁",5], ["琦",5], ["冉",5],
    ["雯",5], ["娅",5], ["钰",5], ["颖",5], ["紫",5]
  ], 50),

  // 冷门字
  "嬟","姀","媙","嬅","婋","媖","嫛","昉","妶","姌"
];

// ===================== 男生名字部分 =====================
let boy_names1 = [
  ...createWeightedArray([
    ["晓",145], ["浩",115], ["宇",90], ["轩",90],
    ["杰",60], ["睿",60], ["航",60], ["泽",45],
    ["  ",30], ["博",15], ["昊",15], ["阳",15],
    ["明",15], ["哲",15], ["勇",5], ["凯",15]
  ], 860),
  
  // 新增字
  ...createWeightedArray([
    ["峰",5], ["旭",5], ["伟",5], ["强",5], ["磊",5],
    ["一",5], ["鹏",5], ["超",5], ["辉",5], ["龙",5],
    ["林",5], ["诚",5], ["平",5], ["建",5]
  ], 70),

  // 冷门字
  "昪","翀","劼","行","赟","振","邈","珩","翊","子",
  "昶","瑞","珅","骁","守","劭","奇","益","岐","峤"
];

let boy_names2 = [
  ...createWeightedArray([
    ["杰",145], ["阳",115], ["然",90], ["宇",90],
    ["浩",60], ["辰",60], ["轩",45], ["东",45],
    ["磊",30], ["洋",15], ["涛",15], ["辉",15],
    ["文",15], ["彬",15], ["超",15], ["龙",15]
  ], 860),
  
  // 新增字
  ...createWeightedArray([
    ["鹏",5], ["林",5], ["诚",5], ["峰",5], ["昊",5],
    ["旭",5], ["凯",5], ["安",5], ["闯",5], ["建",5],
    ["华",5], ["明",5], ["博",5], ["强",5]
  ], 70),

  // 冷门字
  "弢","嵩","达","劭","翔","珅","骁","山","珩","昶"
];

export { surnames, girl_names1, girl_names2, boy_names1, boy_names2 };