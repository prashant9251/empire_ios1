
    function loadIDE(){
        var typeSelected=$("#type").val();
        // alert(typeSelected);
        var val=$("#firm").val();
        var firmName=getFirmDetailsByCno(val);
        if(firmName.length>0){
            try {                
            localStorage.setItem(DSN+"MCNO_SELECT",firmName[0].FIRM);
            } catch (error) {
                
            }
        }
        localStorage.setItem(DSN+"_FIND_BILL_TYPE",typeSelected);
        IDE = getIDE();
        loadCall(IDE);  
    }
    var COMPMST=[];
    var MCNO_SELECT = localStorage.getItem(DSN+"MCNO_SELECT");
    function getFirmDetailsByFirm(MCNO_SELECT) {
        return NMFIRM = COMPMST.filter(function (data) {       
            return data.FIRM.trim() == MCNO_SELECT.trim();
        })
    }
    function getFirmDetailsByCno(CNO) {
        return NMFIRM = COMPMST.filter(function (data) {       
            return data.CNO.trim() == CNO.trim();
        })
    }


    function SelectFirmOptions(IdFirmOptions) {
        jsGetObjectByKey(DSN, "COMPMST", "").then(function (data) {
    
            COMPMST = data;
            COMPMST = COMPMST.sort(function (a, b) {
                a.label=a.FIRM;
                if (a.FIRM > b.FIRM) { return -1; }
                if (a.FIRM < b.FIRM) { return 1; }
                return 0;
            });
            var xfirm = document.getElementById(IdFirmOptions);
    
            if (COMPMST.length > 0) {
                COMPMST.forEach(function (element, index) {
                    var option = document.createElement("option");
                    option.value = element.CNO;
                    option.text = element.FIRM;
                    xfirm.add(option, xfirm[0]);
                    //  alert(element.FIRM);
                });
            
            }
       
        var option = document.createElement("option");
        option.value = "";
        option.text = "ALL";
        xfirm.add(option, xfirm[0]);
        var FIX_FIRM = AllUrlString["FIX_FIRM"];
    var MCNO = AllUrlString["MCNO"];
    if(FIX_FIRM!=null && FIX_FIRM!= ""){
        // alert(getFirmDetailsByCno(FIX_FIRM)[0].FIRM);
        
        $('#firm').css('display', "none");
        try {
            
            document.getElementById("firm").value = getFirmDetailsByCno(FIX_FIRM)[0].CNO;
        } catch (error) {            
        }
    }else{
        try {
            document.getElementById(IdFirmOptions).value = getFirmDetailsByFirm(MCNO_SELECT)[0].CNO;
        } catch (error) {        
        }}
        }) 
    }
     
    function openNav() {
        document.getElementById("mySidenav").style.width = "250px";
    }

    function closeNav() {
        document.getElementById("mySidenav").style.width = "0";
    }

    function getIDE() {
        CNO = document.getElementById('firm').value
        TYPE = document.getElementById('type').value
        VNO = document.getElementById('billNo').value
        Firmdetails = getFirmDetailsBySendCode(CNO);
        FIRM = document.getElementById('firm').value;
        Currentyear = getUrlParams(url, "Currentyear");;
        sft = 1
        IDE = CNO + TYPE + VNO + sft + Currentyear;
        console.log(IDE);
        return IDE;
    }
    function callBackbill() {
        var CurrentBNo = parseInt($('#billNo').val()) - 1;

        $('#billNo').val(CurrentBNo);
        IDE = getIDE();
        loadCall(IDE);
    }
    function callNextbill() {
        var CurrentBNo = parseInt($('#billNo').val()) + 1;

        $('#billNo').val(CurrentBNo);
        IDE = getIDE();
        loadCall(IDE);
}
$(document).keydown(function (e) {
    if (event.keyCode == 39) {
        callNextbill(); //on left arrow, click next (since your next is on the left)
    } else if (event.keyCode == 37) {
        callBackbill(); //on right arrow, click prev
    }
  });