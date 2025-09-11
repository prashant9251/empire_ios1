

function checkAllEntry(ele) {
    var checkboxes = document.getElementsByTagName('input');
    if (ele.checked) {
        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].type == 'checkbox') {
                checkboxes[i].checked = true;
            }
        }
    } else {
        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].type == 'checkbox') {
                checkboxes[i].checked = false;
            }
        }
    }
}

function filterSelected() {
    var SelectList = [];
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
    SelectList = SelectList.filter(function (d) {
        return d.CNO != undefined;
    })
    FilteringData(SelectList);
}


function FilteringData(SelectList) {
    var MainArry = Data;

    MainArry = MainArry.map(function (subdata) {
        return {
            partyName: subdata.partyName,
            ccode: subdata.ccode,
            COD: subdata.COD,
            ATP: subdata.ATP,
            CT: subdata.CT,
            CG: subdata.CG,
            billDetails: getFilteredBillDetails(subdata.billDetails, SelectList)
        }
    })
    loadCall(MainArry)
    hideselectBoxReport();
}

function getFilteredBillDetails(billDetails, SelectList) {
    return billDetails.filter((el) => {
        return SelectList.some((f) => {
            return f.CNO === el.CNO && f.TYPE === el.TYPE && f.VNO === el.VNO;
        });
    });
}