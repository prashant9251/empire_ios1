function filterSelected() {
    var SelectList = [];
    $('input[type=checkbox]').each(function () {
        var partycode = $(this).attr('partycode');
        var ccd = $(this).attr('ccd');
        if ($(this).is(':checked')) {
            var obj = {};
            obj.partycode = partycode;
            obj.ccd = ccd;
            SelectList.push(obj);
        } else {
        }
    });
    console.log(SelectList);
    FilteringData(SelectList);
}

function FilteringData(SelectList) {
    var MainArry = Data;
    console.log(MainArry);

    MainArry = MainArry.map(function (subdata) {
        return {
            COD: subdata.COD,
            ATP: subdata.ATP,
            CT: subdata.CT,
            CG: subdata.CG,
            billDetails: getFilteredBillDetails(subdata.billDetails, SelectList)
        }
    })
    console.log(MainArry);
    hideAbleTr='false';
    loadCall(MainArry)
}

function getFilteredBillDetails(billDetails, SelectList) {
    return billDetails.filter((el) => {
        return SelectList.some((f) => {
            return f.ccd === el.ccd;
        });
    });
}

var SelectList = [];
function filterLedgerSelected() {
    SelectList = [];
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
        } else {
        }
    });
    console.log(SelectList);
    FilteringLedgerData(SelectList);
}

function FilteringLedgerData(SelectList) {
    var MainArry = Data;
    console.log(MainArry);

    MainArry = MainArry.filter((el) => {
        return SelectList.some((f) => {
            return f.CNO === el.CNO && f.TYPE === el.TYPE && f.VNO === el.VNO;
        });
    });
    console.log(MainArry);
    loadCall(MainArry)
    hideselectBoxReport();
}