var GRD;
var CrDrEntryType;
var MARKET;
var OS_RMK = "";
var hideAbleTr = getUrlParams(url, "hideAbleTr");
var Currentyear = getUrlParams(url, "Currentyear");
var qualcode = getUrlParams(url, "qualcode")??"";
var qualname = getUrlParams(url, "qualname")??"";
var mainqualname = getUrlParams(url, "mainqualname");
var mainscreenname = getUrlParams(url, "mainscreenname");
var sendShareTextBankDetail="";
var login_user=getUrlParams(url,"login_user");
var SHOPNAME=getUrlParams(url,"SHOPNAME");
var groupname=getUrlParams(url,"groupname");

function hideLogoImg() {
    var logoImg = document.getElementById('logoImg');
    logoImg.hidden = true;
}

function AddHeaderTbl() {
    // upiLink().then(function(d){
    var upiButton = "";

    var HTbl = `
    <table id="tblHead" style="">
    
    `;
    var firmAdrs = '';
    var firmAcno = '';
    var logoDiv = '';
    jsGetObjectByKey(DSN, "COMPMST", "").then(function (data) {
        DataCompmst = data;

        if (FIRM != '' && FIRM != null) {
            for (var i = 0; i < DataCompmst.length; i++) {
                if (DataCompmst[i].FIRM == FIRM) {
                    cno = DataCompmst[i].CNO;
                    firmAdrs = DataCompmst[i].ADDRESS1 + "," + DataCompmst[i].ADDRESS2 + "," + DataCompmst[i].CITY1 + " , "+getValueNotDefine(DataCompmst[i].MSME)+" , " + DataCompmst[i].MOBILE+ "," + DataCompmst[i].PHONE1;
                    firmAcno = `<br><br><br><h6 id="firmAcno"align="center"class="panel-title">BANK A/C :<strong>` + getValueNotDefine(DataCompmst[i].ADDRESS3) + `</strong> IFSC : <strong>` + getValueNotDefine(DataCompmst[i].ADDRESS4) + `</strong></h6>`;
                    console.log(firmAdrs);
                    sendShareTextBankDetail += `\n`+ DataCompmst[i].FIRM+`
A/c:- *` + getValueNotDefine(DataCompmst[i].ADDRESS3) + `*
IFSC:- *` + getValueNotDefine(DataCompmst[i].ADDRESS4) + `* \n`;
                }
            }
        } else {
            firmAcno = `<br><br><br>
            <div id="AccountDetails"align="center" class="table-responsive"></div>`;
        }
        // var defultlink = `http://aashaimpex.com/logos/Default.jpeg`;
        // var partyLogolink = `http://aashaimpex.com/logos/` + Clnt + `.jpeg`;
        var partyLogolink = ``;
        logoDiv = `<br><br><br><br><br><br><br>
        <div id="footerbottom" style="width:100%;">                        
                <div style="float:left;text-align:left; margin-left: 4%;margin; margin-top: -5%;">
                </div>
                
                <div style="float:right;text-align:right;margin-right: 2%;">
                        <p style="color:black;" class="hideUNIQUESOFTWARES">Powered By <b>UNIQUE SOFTWARES</b> </p>
                        <p style="color:#588c7e;" class="">Accounting Software by <b>EMPIRE Technocom Pvt Ltd</b></p>
                        <a style="font-size:xx-small;">USER:-` + login_user+ `</a>
                </div> 
        </div>
        `;

        if (FIRM != '' && FIRM != null) {
            HTbl += `
        <tr style="">
        <td align="left"colspan="2"><h2 style="text-align:left; margin-left: 2px;">`+ FIRM + `</h2></td>
        <tr>
        <tr style="">
        <td align="left"colspan="2"><h6 id="firmAdrs"></h6></td>
        <tr>
        <td id="ReportType"align="left"><p></p></td>      
        </tr>
        </tr>`;
        } else {
            HTbl += `
        <tr>
        <td align="left" colspan="2"><h2>`+SHOPNAME.toUpperCase()+`</h2></td>
        </tr>
        <tr>
        <td "align="left"><h5> MERGED COMPANY REPORT</h5></td> 
        </tr>
        <tr>
        <td id="ReportType"align="left"></td> 
        </tr>
        `;

        }


        if (fromdate != '' || todate != '') {
            HTbl += `
        <tr>
        <td align="left"><h6>FROM DATE : <b style="text-decoration: underline;">`+ formatDate(fromdate) + `</b></h6></td>
        <td align="left"><h6>TO DATE : <b style="text-decoration: underline;">`+ formatDate(todate) + `</b></h6></td>
        </tr>
        `;
        }
        if (partyname != '' && partyname != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>PARTY NAME : <b style="text-decoration: underline;">`+ partyname + `</b></h6></td>
        
        </tr>
        `;
        }
        if (CITY != '' && CITY != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>CITY : <b style="text-decoration: underline;">`+ CITY + `</b></h6></td>
        
        </tr>`;
        }

        if (MARKET != '' && MARKET != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>MARKET : <b style="text-decoration: underline;">`+ MARKET + `</b></h6></td>
        
        </tr>`;
        }
        if (qualcode != '' && qualcode != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>ITEM NAME : <b style="text-decoration: underline;">`+ qualcode + `</b></h6></td>
        
        </tr>`;
        }
        if (groupname != '' && groupname != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>GROUP NAME : <b style="text-decoration: underline;">`+ groupname + `</b></h6></td>
        
        </tr>`;
        }
        if (mainqualname != '' && mainqualname != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>MAIN QUALITY NAME : <b style="text-decoration: underline;">`+ mainqualname + `</b></h6></td>
        
        </tr>`;
        }
        if (mainscreenname != '' && mainscreenname != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>MAIN QUALITY NAME : <b style="text-decoration: underline;">`+ mainscreenname + `</b></h6></td>
        
        </tr>`;
        }
        if (broker != '' && broker != null) {
            BrokerArray = getPartyDetailsBySendCode(broker);
            BrokerMo = BrokerArray[0].MO == null || BrokerArray[0].MO == "" ? " " : `<a onclick="dialNo('` + BrokerArray[0].MO + `')"> ` + BrokerArray[0].MO + "</a>,";
            BrokerMo += BrokerArray[0].PH1 == null || BrokerArray[0].PH1 == "" ? " " : `<a onclick="dialNo('` + BrokerArray[0].PH1 + `')"> ` + BrokerArray[0].PH1 + "</a>,";
            BrokerMo += BrokerArray[0].PH2 == null || BrokerArray[0].PH2 == "" ? " " : `<a onclick="dialNo('` + BrokerArray[0].PH2 + `')"> ` + BrokerArray[0].PH2 + "</a>";
            HTbl += `
        <tr>
        <td align="left"><h6>BROKER : <b style="text-decoration: underline;">`+ broker + `</b> ` + BrokerMo + `</a></h6></td>
        </tr>`;
        }
        if (haste != '' && haste != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>HASTE : `+ haste + `</h6></td>
        </tr>`;
        }
        if (GRD != '' && GRD != undefined && GRD != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>PARTY GRADE : <b style="text-decoration: underline;">`+ GRD + `</b></h6></td>
        </tr>`;
        }
        HTbl += `</table>
    `;

        $('.table-responsive').prepend(HTbl);

        var ReportType = getUrlParams(url, "ReportType");
        var Reportname = getUrlParams(url, "ReportType");
        var reporturl = window.location.href;

        if (reporturl.indexOf('OUTSTANDING') > -1) {
            $('body').append(firmAcno);
            ReportType += " OS "
            Reportname += " OUTSTANDING "
            OS_RMK = getValueNotDefine(localStorage.getItem("OS_RMK"));
            if (reporturl.indexOf('PURCHASE') < 0) {
                upiButton = upiLink();
                    if (upiButton != null) {
                        upiButton = upiButton;
                    }
            }
            OS_RMK = upiButton + `<h4 >REMARK : </h4><h4><b style="color:red;">` + getValueNotDefine(OS_RMK) + `</b></h4>`;
        }

        if (reporturl.indexOf('millstock_AJXREPORT') > -1) {
            ReportType = "  MILL STOCK "
            Reportname = " MILL STOCK "
        }
        if (reporturl.indexOf('ITEMWISESALE') > -1) {
            ReportType = "ITEM WISE SALE ";
            Reportname = ReportType;

        }
        if (reporturl.indexOf('PENDINGLR') > -1) {
            ReportType = "PENDING LR";
            Reportname = ReportType;
        }
        if (reporturl.indexOf('PCORDER') > -1) {
          //  ReportType = "ORDER";
            var ORDER_TYPE = getUrlParams(url, "doc_type").toString().toUpperCase().indexOf("ZSO")>-1?"SALES":"PURCHASE";
            Reportname = ORDER_TYPE+" "+ ReportType +" "+ getUrlParams(url, "ReportFilter");
        }
        // if (reporturl.indexOf('PURCHASE')>-1) {
        //     ReportType = "PURCHASE REPORT";
        // }
        if (reporturl.indexOf('LEDGER') > -1) {
            ReportType = "LEDGER";
            Reportname = ReportType;
        }
        if (reporturl.indexOf('SALES_COMM') > -1) {
            ReportType = "SALES COMMISSION";
            Reportname = ReportType;
        }
        if (reporturl.indexOf('millstock') > -1) {
            ReportType = "MILL STOCK";
            Reportname = ReportType;
        }
        if (reporturl.indexOf('PCSSTOCK') > -1) {
            ReportType = "STOCK IN HOUSE";
            Reportname = ReportType;
        }
        if (reporturl.indexOf('bankPassBook') > -1) {
            ReportType = "BANK ENTRY";
            Reportname = ReportType;
            $('body').append(firmAcno);
        }
        if (reporturl.indexOf('orderFormList') > -1) {
            ReportType = getUrlParams(url, "entryType");
            Reportname = ReportType;
            $('body').append(firmAcno);
        }
        if (reporturl.indexOf('JOBWORK_AJXREPORT') > -1) {
            ReportType = ReportType +" "+ getUrlParams(url, "ReportFilter");
            Reportname = ReportType;
            $('body').append(firmAcno);
        }
        partyname = partyname == null ? "" : partyname;
        broker = broker == null ? "" : broker;
        CITY = CITY == null ? "" : CITY;
        document.title = ReportType + " " + partyname + " " + broker + " " + CITY +" "+qualname;
        console.log(ReportType)
        $('#ReportType').html("<h6 style='text-decoration: underline;'><b>" + Reportname + " REPORT</b></h6><h6 id='head1'></h6>");
        if (hideAbleTr == "true") {
            $('#head1').html("<b>SUMMERY</b>");
        }
        $('#firmAdrs').html(firmAdrs);
        if (url.indexOf('orderFormList.html') < 0) {
            $('body').append(logoDiv);
        }
        if (OS_RMK != '' && OS_RMK != null) {
            $('body').append(OS_RMK);
        }
    })
}

function BuildAccountdetaisl(CNOArray) {
    try {
        var div = `<table class="content-table" align="center">
    <tbody style="border:1px solid grey; border-radius: 15px;">
    <tr>
    <th colspan="3"style="background-color: #dddddd; border-top-right-radius: 15px;border-top-left-radius: 15px;"><b>BANK  ACCOUNT DETAILS</b></th>
    </tr>
    
    `;
        var sr = 0;
        sendShareTextBankDetail="";
        for (var i = 0; i < CNOArray.length; i++) {
            var FIRM_Array = getFirmDetailsBySendCode(CNOArray[i]);
            sr += 1
            try {
                sendShareTextBankDetail += `\n`+ FIRM_Array[0].FIRM+`
A/c:- *` + getValueNotDefine(FIRM_Array[0].ADDRESS3) + `*
IFSC:- *` + getValueNotDefine(FIRM_Array[0].ADDRESS4) + `*\n`;
            } catch (error) {
                
            }
            div += ` <tr>
       <td><h6><b>`+ sr + `</b> </h6></td>
       <td><h6><b>FIRM NAME</b></h6></td>
       <td> <h6><b>` + FIRM_Array[0].FIRM + ` </b></h6></td>
        </tr>
        <tr>
       <td><h6></h6></td>
       <td><h6> ACCOUNT NO.</h6> </td>
       <td> <h6>` + getValueNotDefine(FIRM_Array[0].ADDRESS3) + `</h6></td>
        </tr>
        <tr>
       <td><h6></h6></td>
       <td><h6> IFSC CODE</h6></td>
       <td> <h6>` + getValueNotDefine(FIRM_Array[0].ADDRESS4) + `</h6></td>
        </tr>
        <tr>
        <td colspan="2"></td>
        </tr>
        `;
        }
        div += `</tbody></table>`;
        $('#AccountDetails').html(div);

    } catch (error) {

    }
}


// AddHeaderTbl() ;
function loadInHeader() {

}


function upiLink() {
    var upiUrl="";
    var d = getUrlParams(url, "upi");
    try {
    var upiObj = JSON.parse(d);
    upiArr = upiObj[FIRM];
    console.log(JSON.stringify(upiArr)+"======upi====");
        
    var upiContact = upiArr["contact"];
    var upiShopName = upiArr["upiShopName"];
    var upiAddress = upiArr["upi"];
    var upiName = upiArr["upiName"];
    var upiId = upiAddress;
    } catch (error) {
        
    }
    if (upiAddress != null && upiAddress != "" && upiAddress != undefined) {
        url = "https://uniqsoftwares.com/upi/paynow.php?contact=" + upiContact + "&shopName=" + encodeURIComponent(upiShopName) + "&upiId=" + encodeURIComponent(upiId) + "&upiName=" + encodeURIComponent(upiName) + "&upi=" + encodeURIComponent(upiAddress);
        upiUrl = `<DIV style="text-align:left;"">
        <img style="display:none;" src="upi.webp"height="150px"/><a href="` + url + `"class="payNowButton" style="font: bold 40px Arial;
        text-decoration: none;
        background-color: grey;
        color: #ffffff;
        padding: 3px 6px 3px 6px;
        border-top: 1px solid #CCCCCC;
        border-right: 1px solid #333333;
        border-bottom: 1px solid #333333;
        border-left: 1px solid #CCCCCC;">Pay by Upi</a></DIV><br>`;
    }
    return upiUrl;
}