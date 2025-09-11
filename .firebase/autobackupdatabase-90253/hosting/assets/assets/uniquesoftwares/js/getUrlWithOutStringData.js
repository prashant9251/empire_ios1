

function getUrlWithOutStringData(url) {
    var a = url.indexOf("?");
    var b = url.substring(a);
    var c = url.replace(b, "");
    url = c;
    return url;
}