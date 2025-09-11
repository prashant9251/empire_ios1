function getValueNotDefineNo(value) {
    var Rvalue;
    if (value == undefined || value == null  || value == '') {
        Rvalue = 0;
    } else {
        Rvalue = value
    }
    return Rvalue;
}

function ifValNullGetBlank(value, string) {
    if (value == 0) {
        return "";
    } else {
        return string + value;
    }
}

function addCommas(nStr)
{
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}