#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'
reset_terminal=$(tput sgr0)
clear

function get_user_input {
    local prompt_message=$1
    local user_input=""
    # 只能输入 y/n|z/f
    while true; do
        echo -ne "$prompt_message" && read -r -p ":" user_input
        user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
        case "$user_input" in
        zff | fzf | ffz | zzz)
            echo "0"
            return 0
            ;;
        zzf | fzz | zfz | fff)
            echo "1"
            return 0
            ;;
        *)
            echo "无效输入，请输入 'z'或'f'."
            ;;
        esac
    done
}
function Shake {
    echo -e "${YELLOW}正为z,反为f,例如“反正反”应为"fzf"${NC}"
    echo -e "${BLUE}摇第一次${NC}" && onest=$(get_user_input)
    echo -e "${BLUE}摇第二次${NC}" && twond=$(get_user_input)
    echo -e "${BLUE}摇第三次${NC}" && threerd=$(get_user_input)
    echo -e "${BLUE}摇第四次${NC}" && fourth=$(get_user_input)
    echo -e "${BLUE}摇第五次${NC}" && fiveth=$(get_user_input)
    echo -e "${BLUE}摇第六次${NC}" && sixth=$(get_user_input)
    yao_result=${sixth}${fiveth}${fourth}${threerd}${twond}${onest}
    # yao_result="111111"
    echo -e "${GREEN}摇卦结果${NC}" $yao_result
    echo -e "${RED} 0为阴 1为阳${NC}"
}
function ShowResult {
    declare -A hexagrams=(
        [111111]="乾为天"
        [111110]="天风姤"
        [111100]="天山遁"
        [111000]="天地否"
        [110000]="风地观"
        [100000]="山地剥"
        [101000]="火地晋"
        [101111]="火天大有"
        [001001]="震为雷"
        [001000]="雷地豫"
        [001010]="雷水解"
        [001110]="雷风恒"
        [000110]="地风升"
        [010110]="水风井"
        [011110]="泽风大过"
        [011001]="泽雷随"
        [010010]="坎为水"
        [010011]="水泽节"
        [010001]="水雷屯"
        [010101]="水火未济"
        [011101]="泽火革"
        [001101]="雷火丰"
        [000101]="地火明夷"
        [000010]="地水师"
        [100100]="艮为山"
        [100101]="山火贲"
        [100111]="山天大畜"
        [100011]="山泽损"
        [101011]="泽火睽"
        [111011]="天泽履"
        [110011]="风泽中孚"
        [110100]="风山渐"
        [000000]="坤为地"
        [000001]="地雷复"
        [000011]="地泽临"
        [000111]="地天泰"
        [001111]="雷天大壮"
        [011111]="泽天决"
        [010111]="水天需"
        [010000]="水地比"
        [110110]="巽为风"
        [110111]="风天小畜"
        [110101]="风火家人"
        [110001]="风雷益"
        [111001]="天雷无妄"
        [101001]="火雷噬嗑"
        [100001]="山雷颐"
        [100110]="山风盅"
        [101101]="离为火"
        [101100]="火山旅"
        [101110]="火风鼎"
        [100010]="山水蒙"
        [110010]="风水涣"
        [111010]="天水讼"
        [111101]="天火同人"
        [011011]="兑为泽"
        [011010]="泽水困"
        [011000]="泽地萃"
        [011100]="泽山咸"
        [010100]="山水寒"
        [000100]="地山谦"
        [001100]="雷山小过"
        [001011]="雷泽归妹"
    )
    echo -e "${GREEN}您的结果是：${NC}${YELLOW}${hexagrams[$yao_result]}${NC}"
}
function run {
    Shake
    ShowResult
}
run
