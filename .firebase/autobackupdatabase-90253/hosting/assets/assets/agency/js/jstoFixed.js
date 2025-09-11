function valuetoFixed(value) {
    value = value == null || value == '' || value == undefined ? 0 : value;
    var n = parseFloat(value).toFixed(2) + "/-";
    return n;
}


function hide0(value) {
    if (value == 0) {
        return "";
    }else{
        return value;
    }
}
