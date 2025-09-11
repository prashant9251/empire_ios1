function valuetoFixedNo(value) {
    value = value == null || value == '' || value == undefined ? 0 : value;
    var n = Number(value);
    return n;
}
