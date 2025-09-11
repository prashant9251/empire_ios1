var masterData;
// jsGetObjectByKey(DSN, "MST", "").then(function (data) {
//     masterData = data;

// })
var ATYPE_ARR=[];
function getAtypeDetails(ATYPE) {
    return ATYPE_ARR.filter(function (data) {
        return data.ATYPE == ATYPE;
    })
}
function getPartyDetailsBySendCode(ccode) {
    var v= masterData.filter(function (data) {
        return data.value.trim() == ccode.trim();
    })
    return v;
}

function getPartyAtypeDetails(atype) {
    // console.log("====ATYPE==="+JSON.stringify(DataATYPE[0]));
    return DataATYPE.filter(function (data) {
        return data.ATYPE == atype;
    })
}



function getBankName(ATYPE) {
    return masterData.filter(function (d) {
        return d.ATYPE == ATYPE;
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

var SERIESData;
jsGetObjectByKey(DSN, "SERIES", "").then(function (data) {

    SERIESData = data;
})
function getSeriesDetailsBySendType(TYPE) {
    return SERIESData.filter(function (data) {
        return data.SERIESCODE == TYPE;
    })
}


function getFullDataLinkByCnoTypeVnoFirm(CNO, TYPE, VNO, FIRM, IDE, MO, partyEmail) {
    var url;
    var mobileNo = MO == null ? '' : MO;
    var partyEmail = partyEmail == null ? '' : partyEmail;
    var SetVNO = VNO;
    var IDEYEAR = IDE.substring(IDE.length - 4, IDE.length);
    YearChange = IDEYEAR;
    if (parseInt(getYearChange(IDEYEAR, 1)) >= 2021) {
        if (VNO > 100000 && VNO < 200000) {
            SetVNO = parseInt(VNO) - 100000;
            YearChange = getYearChange(IDEYEAR, 1);
        }
    }
    if (parseInt(getYearChange(IDEYEAR, 1)) < 2021) {
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
        encodeURI(YearChange) +
        "&mobileNo=" +
        encodeURI(mobileNo) +
        "&partyEmail=" +
        encodeURI(partyEmail);
    // console.log(url);
    return url;
}

function getUrlPaymentSlip(CNO, TYPE, VNO, IDE, mobileNo) {
    return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO + "&mobileNo=" + encodeURI(mobileNo);
}

function UrlSendToAndroid(Array) {
    UrlForSend = window.location.href;
    UrlForSend = UrlForSend.replace("PDFStorePermission", "")
    UrlForSend = SubPartylinkReplace(UrlForSend);
    ArrayToSendAndroid = [];
    for (i = 0; i < Array.length; i++) {
        ArrayToSendAndroid.push(UrlForSend + "&partyname=" + encodeURIComponent(Array[i].code) + "&partycode=" + encodeURIComponent(Array[i].code) + "&PDFStore=true");
    }
    Android.sendData(JSON.stringify(ArrayToSendAndroid));
}

function UrlSendToAndroidFromTodaysDueList(Array) {
    UrlForSend = window.location.href;
    UrlForSend = UrlForSend.replace("toDaysDueList", "OUTSTANDING_AJXREPORT")
    UrlForSend = UrlForSend.replace("PDFStorePermission", "")
    UrlForSend = SubPartylinkReplace(UrlForSend);
    ArrayToSendAndroid = [];
    for (i = 0; i < Array.length; i++) {
        ArrayToSendAndroid.push(UrlForSend + "&partyname=" + encodeURIComponent(Array[i].code) + "&partycode=" + encodeURIComponent(Array[i].code) + "&PDFStore=true");
    }
    // console.log(ArrayToSendAndroid)
    Android.sendData(JSON.stringify(ArrayToSendAndroid));
}

function exportTableToExcel(tableID, filename = '') {
    var downloadLink;
    var dataType = 'application/octet-stream';
    var tableSelect = document.getElementById(tableID);
    var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');
    filename = filename ? filename + '.xls' : 'excel_data.xls';
    downloadLink = document.createElement("a");
    document.body.appendChild(downloadLink);
    if (navigator.msSaveOrOpenBlob) {
        var blob = new Blob(['\ufeff', tableHTML], {
            type: dataType
        });
        navigator.msSaveOrOpenBlob(blob, filename);
    } else {
        downloadLink.href = 'data:' + dataType + ', ' + tableHTML;
        downloadLink.download = filename;
        downloadLink.click();
    }
}


function filterSelectedBulkPdfBill() {
    var SelectList = [];
    billNos="";
    var CNO=cno;
    $('input[type=checkbox]').each(function () {
        var CNO = $(this).attr('CNO');
        var TYPE = $(this).attr('DTYPE');
        var VNO = $(this).attr('VNO');
        if ($(this).is(':checked')) {
            var obj = {};
            obj.CNO = CNO;
            obj.TYPE = TYPE;
            obj.VNO = VNO;
            SelectList.push(obj);
            if(VNO!=undefined){
            billNos+=VNO+",";
            this.cno=CNO;}
        } else {
        }
    });
    var path = window.location.pathname;
    var page = path.split("/").pop();
    // console.log(page);
    var url = window.location.href;
    url = url.replace(page, "Billpdf.html") + `?ntab=Ntab&billNos=`+billNos;
    url=url.replace("CNO","");
    url +="&CNO="+cno;
    url +="&PDFBILLTYPE=BULK_FILTERED";
    // console.log("======filter======"+url);
    // document.getElementById("BulkBillpdfLink").href = url;
    window.open(url, "_BLANK");
    localStorage.setItem("BulkPdfBillList", JSON.stringify(SelectList))
}



if(deviceIsIos=="true"){
    $('head').append('<meta name="viewport"content="width=device-width, initial-scale=.6, user-scalable=yes" />');
}else{
    $('head').append('<meta name="viewport"content="width=device-width, initial-scale=1, user-scalable=yes" />');
}