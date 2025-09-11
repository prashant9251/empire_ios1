var masterData;
var acgroupData;
jsGetObjectByKey(DSN, "MST", "").then(function (data) {
    masterData = data;

})
jsGetObjectByKey(DSN, "ACGROUP", "").then(function (data) {
    acgroupData = data;

})
function getGroupDetailsBySendCode(code) {
    return acgroupData.filter(function (data) {
        return data.value == code;
    })
}

function getGroupDetailsBySendName(partyname) {
    return acgroupData.filter(function (data) {
        return data.partyname == partyname;
    })
}


function getPartyDetailsBySendCode(code) {
    return masterData.filter(function (data) {
        return data.value == code;
    })
}
function getPartyDetailsBySendName(partyname) {
    return masterData.filter(function (data) {
        return data.partyname == partyname;
    })
}

var FirmData;
jsGetObjectByKey(DSN, "COMPMST", "").then(function (data) {

    FirmData = data;
})
function getFirmDetailsBySendCode(CNO) {
    return FirmData.filter(function (data) {
        return data.CNO == CNO;
    })
    // console.log(FirmDetails);

}

// console.log(SERIESData);
function getSeriesDetailsBySendType(TYPE) {
    return SERIESData.filter(function (data) {
        return data.SERIESCODE == TYPE;
    })
}


var compair = (Curentyearforlocalstorage.substring(0, 2));
compair = (parseInt(compair) - 1).toString() + ((compair));
function getFullDataLinkByCnoTypeVnoFirm(CNO, TYPE, VNO, FIRM, IDE) {
    var url;
    var SetVNO = VNO;
    var IDE = IDE.toUpperCase();
    var IDEYEAR = IDE.substring(IDE.length - 4, IDE.length);
    YearChange = IDEYEAR;
    if (parseInt(getYearChange(IDEYEAR, 1)) >= compair) {
        if (VNO > 100000 && VNO < 200000) {
            SetVNO = parseInt(VNO) - 100000;
            YearChange = getYearChange(IDEYEAR, 1);
        }
    }
    if (parseInt(getYearChange(IDEYEAR, 1)) < compair) {
        if (VNO > 200000) {
            YearChange = "";
        }
    }
    
    url =
    "Billpdf.html?ntab=NTAB&CNO=" +
    encodeURI(CNO) +
    "&TYPE=" +
    encodeURI(TYPE) +
    "&VNO=" +
    encodeURI(SetVNO) +
    "&FIRM=" +
    encodeURI(FIRM) +
    "&IDE=" +
    encodeURI(IDE) +
    "&YearChange=" +
    encodeURI(YearChange);
    // console.log(url);
    return url;
}

function getPurchaseFullDataLinkByCnoTypeVnoFirm(CNO, TYPE, VNO, FIRM, IDE) {
    var url;
    var SetVNO = VNO;
    var IDE = IDE.toUpperCase();
    var IDEYEAR = IDE.substring(IDE.length - 4, IDE.length);
    YearChange = IDEYEAR;
    if (parseInt(getYearChange(IDEYEAR, 1)) >= compair) {
        if (VNO > 100000 && VNO < 200000) {
            SetVNO = parseInt(VNO) - 100000;
            YearChange = getYearChange(IDEYEAR, 1);
        }
    }
    if (parseInt(getYearChange(IDEYEAR, 1)) < compair) {
        if (VNO > 200000) {
            YearChange = "";
        }
    }
    
    url =
        "BillpdfPurchase.html?ntab=NTAB&CNO=" +
        encodeURI(CNO) +
        "&TYPE=" +
        encodeURI(TYPE) +
        "&VNO=" +
        encodeURI(SetVNO) +
        "&FIRM=" +
        encodeURI(FIRM) +
        "&IDE=" +
        encodeURI(IDE) +
        "&YearChange=" +
        encodeURI(YearChange);
    // console.log(url);
    return url;
}


function getPartyTypeLabelByAtype(ATYPE) {
    var LABEL = '';
    if (ATYPE == 1) {
        LABEL = " CUSTOMER ";
    } else if (ATYPE == 2) {
        LABEL = " SUPPLIER ";
    } else {
        LABEL = " PARTY NAME";
    }
    return LABEL;
}




if(IosPlateForm=="true"){
    $('head').append('<meta name="viewport"content="width=device-width, initial-scale=.6, user-scalable=yes" />');
}else{
    $('head').append('<meta name="viewport"content="width=device-width, initial-scale=1, user-scalable=yes" />');
}