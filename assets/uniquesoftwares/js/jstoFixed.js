function valuetoFixed(value) {
    var n = parseFloat(value).toFixed(2)+"/-";
    return n;
}



function getValueNotDefineNo(value) {
    var Rvalue;
    if (value == 'undefined'||value==null) {
        Rvalue = 0;
    } else {
        Rvalue =value
    }
    return Rvalue;
}