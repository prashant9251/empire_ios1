function getValueNotDefine(value) {
    var Rvalue;
    if (value == 'undefined' || value == null || value == '') {
        Rvalue = '';
    } else {
        Rvalue = value
    }
    return Rvalue;
}

function getValueNotDefineNo(value) {
    var Rvalue;
    if (value == undefined || value == null  || value == '') {
        Rvalue = 0;
    } else {
        Rvalue = value
    }
    return Rvalue;
}