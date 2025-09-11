function getValueNotDefine(value) {
    var Rvalue;
    if (value == undefined ||value == "undefined" || value == null) {
        Rvalue = '';
    } else {
        Rvalue = value
    }
    return Rvalue;
}
function getValueNotDefineNo(value) {
    var Rvalue;
    if (value == 'undefined' || value == null || value == '') {
        Rvalue = 0;
    } else {
        Rvalue = value
    }
    return (Rvalue);
}


function StringToFloat2(value) {
    var Rvalue;
    if (value == 'undefined' || value == null || value == '') {
        Rvalue = 0;
    } else {
        Rvalue = parseFloat(value).toFixed(2);
    }
    return (Rvalue);
}
