
function getDaysDif(Date1,Date2) {
    // if(Date1==null || Date1=="" || date2 ==null || date2 == ""){
    //     return "";
    // }
    // alert(Date2);
    var date1 = new Date(Date1); 
    var date2 = new Date(Date2); 
    var DiffTime = date2.getTime() - date1.getTime(); 
    var DiffDays = DiffTime / (1000 * 3600 * 24); 
    return parseInt(DiffDays);
}