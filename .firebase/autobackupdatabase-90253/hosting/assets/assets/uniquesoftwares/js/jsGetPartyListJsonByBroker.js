var BLS;
function getPartyListBySendBrokerCode(BCODE) {
    jsGetObjectByKey(Db, "BLS", "").then(function(data) {
        BLS = data;        
        BLS = BLS.filter(function (data) {
            return data.BCODE == BCODE;
        }).map(function (value) {
              value.code
          })  
    });   
    console.log(BLS)
    return BLS;
}
