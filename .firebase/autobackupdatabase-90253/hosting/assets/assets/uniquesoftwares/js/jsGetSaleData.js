var EMP;
function getSaleData(cno, partycode, bcode, city, fromdate, todate) {
    jsGetObjectByKey(DSN, "EMP", "").then(function (data) {
        EMP = data;
        getBillsfilter(cno, partycode, bcode, city, fromdate, todate);
    });
}

function getBillsfilter(cno, partycode, bcode, city, fromdate, todate) {
    if (partycode != '') {
        EMP = EMP.filter(function (bill) {
            return bill.code == partycode;
        });
    }

    EMP = EMP.filter(function (bill) {
        var BLS = bill.BLS;
        BLS = BLS.filter(function (BLS) {
            return BLS.BILLS.length > 0;
        })
        console.log(BLS.length);
    });
}