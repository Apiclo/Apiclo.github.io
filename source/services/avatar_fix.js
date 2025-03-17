function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
async function () {
    await sleep(3000); // 等待3秒
};

document.addEventListener('DOMContentLoaded', function () {
    const imgElement = document.querySelector('.post-copyright__author_img_front');
    if (imgElement) {
        imgElement.src = '/img/site/ava.jpg';
    } else {
        console.error('图片元素未找到');
    }
});