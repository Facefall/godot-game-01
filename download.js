

async function download(base64data, imageName = 'image.png') {
    var blob = base64ToBlob(base64data);
    var downloadLink = document.createElement('a');
    downloadLink.href = URL.createObjectURL(blob);
    downloadLink.download = imageName;
    downloadLink.click();
    URL.revokeObjectURL(downloadLink.href);
    function base64ToBlob(base64data) {
        var arr = base64data.split(',');
        var mime = arr[0].match(/:(.*?);/)[1];
        var bstr = atob(arr[1]);
        var n = bstr.length;
        var u8arr = new Uint8Array(n);
        while (n--) {
            u8arr[n] = bstr.charCodeAt(n);
        }
        return new Blob([u8arr], { type: mime });
    }
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
    
let a = async () => {
    for (let index = 0; index < imgs.length; index++) {
        await sleep(1000);
        download(imgs[index].src, index + '.png')
    }
}