// var BILLDET;
// jsGetObjectByKey(DSN, "DET", "").then(function (data) {
//     BILLDET = data;
//     // console.log(BILLDET);
// });
//  function getBillDetailsByIDE(IDE){
//             BILLDET = BILLDET.filter(function(bill){
//                 return ((bill.IDE).toUpperCase())== IDE.toUpperCase() ;
//             });
//             // console.log(BILLDET);
//         return BILLDET;
// }
// var BILLS;
// async function getBILLData(cno,partycode,bcode,city,fromdate,todate){
//     BILLS = await jsGetObjectByKey(DSN, "BLS", "").then(function (data) {
//     return data;
//     });
//      BILLS = BILLS.filter(function(bill){
//                 return ((bill.TYPE).toUpperCase()).indexOf('S') >-1 &&
//                        ((bill.TYPE).toUpperCase()).indexOf('O')<0 &&
//                        ((bill.SERIES).toUpperCase()).indexOf('RETURN')<0 &&
//                        ((bill.ACCODE).toUpperCase()).indexOf('RETURN')<0 &&
//                        ((bill.SERIES).toUpperCase()).indexOf('DEBIT')<0;
//             });
//     //console.log(BILLS);
//         if(cno!==''){
//             BILLS = BILLS.filter(function(bill){
//                 return bill.CNO == cno;
//             });
//         }
//     //console.log(BILLS);
//         if(partycode!==''){
//             BILLS = BILLS.filter(function(bill){
//                 return bill.code == partycode;
//             });
//         } 
//     //console.log(BILLS);
//         if(bcode!==''){
//             BILLS = BILLS.filter(function(bill){
//                 return bill.BCODE == bcode;
//             });
//         } 
//     //console.log(BILLS); 
//         if(city!==''){
//             BILLS = BILLS.filter(function(bill){
//                 return bill.CITY == city;
//             });
//         } 
//     //console.log(BILLS);
//         if(fromdate!==''){
//             BILLS = BILLS.filter(function(bill){
//                 return bill.DATE.getTime() >= fromdate.getTime();
//             });
//         } 
//     //console.log(BILLS);
//         if(todate!==''){
//             BILLS = BILLS.filter(function(bill){
//                 return bill.DATE.getTime() <= todate.getTime();
//             });
//         } 
//         var BILLSarry = [];
//         partyname=null;
//         for (var i = 0; i < BILLS.length; i++) {
          
            
//         }
//     console.log("---BILLS-filter",BILLS);
    
//     return BILLS;
// }
