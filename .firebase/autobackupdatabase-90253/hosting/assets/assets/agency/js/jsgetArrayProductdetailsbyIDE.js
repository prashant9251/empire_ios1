var BILLDET;
jsGetObjectByKey(DSN, "DET", "").then(function (data) {
    BILLDET = data;
    // console.log(BILLDET);
}); 
function jsgetArrayProductdetailsbyIDE(IDE) {
    return BILLDET.filter(function (BILLDET) {
        return BILLDET.IDE == IDE;
    }).map(function (BILLDET) {
        return  BILLDET.billDetails
        
    });
}


