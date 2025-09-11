var firstLoad = false;
var GRD;
var CrDrEntryType;
var partynamegrp;
var ccdgrp;
var ccd;
var Currentyear = getUrlParams(url, "Currentyear");
ACTYPE = getUrlParams(url, "ACTYPE");
var login_user=getUrlParams(url,"login_user");
var search_FromRecDate=getUrlParams(url,"search_FromRecDate");
var search_ToRecDate=getUrlParams(url,"search_ToRecDate");
var SHOPNAME=getUrlParams(url,"SHOPNAME");



function hideLogoImg() {
    var logoImg = document.getElementById('logoImg');
    logoImg.hidden = true;
}

function AddHeaderTbl() {
    // Clnt = DSN.replace(Currentyear, "");
    // Clnt = atob(Clnt);
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
                    firmAdrs = getValueNotDefine(DataCompmst[i].ADDRESS1) + "," + getValueNotDefine(DataCompmst[i].ADDRESS2) + "," + getValueNotDefine(DataCompmst[i].CITY1) + ","+getValueNotDefine(DataCompmst[i].MSME)+" ," + getValueNotDefine(DataCompmst[i].MOBILE) + "," + getValueNotDefine(DataCompmst[i].COMPANY_GSTIN);
                    var partyLogolink = `http://aashaimpex.com/logos/` + Clnt + `.jpeg`;
                    var defultlink = `http://aashaimpex.com/logos/Default.jpeg`;
                    firmAcno = `<br><br><br><h5 id="firmAcno"align="center"class="panel-title">BANK A/C :<strong>` + getValueNotDefine(DataCompmst[i].ADDRESS3) + `</strong> IFSC : <strong>` + getValueNotDefine(DataCompmst[i].ADDRESS4) + `</strong></h5>`;
                    logoDiv = `<br><br><br><br><br><br><br>
                    <div id="footerbottom" style="width:100%;">                        
                            <div style="float:left;text-align:left; margin-left: 4%;margin; margin-top: -5%;">
                            <img src="`+ partyLogolink + `"id="logoImg"  onerror="hideLogoImg();"alt=""width="200" style=""height="100">
                            </div>
                            
                            <div style="float:right;text-align:right;margin-right: 2%;">
                                    <p style="color:black;">Powered By <b>UNIQUE SOFTWARES</b></p>
                                    <p style="color:#588c7e;" class="">Accounting Software by <b>EMPIRE Technocom Pvt Ltd</b></p>

                        <a style="font-size:xx-small;">USER:-` + login_user+ `</a>

                            </div> 
                    </div>`;
                    console.log(firmAdrs);
                }
            }
        }

        if (FIRM != '' && FIRM != null) {
            HTbl += `
        <tr style="">
        <td align="center"colspan="2"><h2>`+ FIRM + `</h2></td>
        <tr>
        <tr style="">
        <td align="center"colspan="2"><h6 id="firmAdrs"></h6></td>
        <tr>
        <td id="ReportType"align="left"></td>        
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
        <td id="ReportType"align="left"colspan="2"></td>        
        </tr>`;

        }


        if ((fromdate != '' && fromdate != null) || (todate != '' && todate != null)) {
            if (fromdate == null || fromdate == '') {
                fromDateText = '_____________'
            } else {
                fromDateText = formatDate(fromdate);
            }
            if (todate == null || todate == '') {
                todateText = '_____________'
            } else {
                todateText = formatDate(todate);
            }
            HTbl += `
        <tr>
        <td align="left"colspan="2"><h6>FROM DATE : <b style="text-decoration: underline;"> `+ fromDateText + `</b> TO DATE : <b style="text-decoration: underline;">` + todateText + `</b></h6></td>
        </tr>
        `;
        }
        

        if ((search_FromRecDate != '' && search_FromRecDate != null) || (search_ToRecDate != '' && search_ToRecDate != null)) {
            if (search_FromRecDate == null || search_FromRecDate == '') {
                search_FromRecDateText = '_____________'
            } else {
                search_FromRecDateText = formatDate(search_FromRecDate);
            }
            if (search_ToRecDate == null || search_ToRecDate == '') {
                search_ToRecDateText = '_____________'
            } else {
                search_ToRecDateText = formatDate(search_ToRecDate);
            }
            HTbl += `
        <tr>
        <td align="left"colspan="2"><h6>FROM DATE : <b style="text-decoration: underline;"> `+ search_FromRecDateText + `</b> TO DATE : <b style="text-decoration: underline;">` + search_ToRecDateText + `</b></h6></td>
        </tr>
        `;
        }
        var ADDRESS;
        if (partycode != '' && partycode != null) {
            var pcode = getPartyDetailsBySendCode(partycode);
            console.log(partycode, pcode);
            partyname = pcode[0].partyname;
            ATYPE = pcode[0].ATYPE;
            LABEL = getPartyTypeLabelByAtype(ATYPE);
            ADDRESS = '';
            ADDRESS += ' , ' + getValueNotDefine(pcode[0].AD1);
            ADDRESS += ' , ' + getValueNotDefine(pcode[0].AD2);
            ADDRESS += ' , ' + getValueNotDefine(pcode[0].city);
            ADDRESS += ',<a href="tel:' + getValueNotDefine(pcode[0].MO) + '">' + getValueNotDefine(pcode[0].MO) + '</a>';
            HTbl += `
        <tr>
        <td align="left" colsoan="3"><h6>`+ LABEL + ` : <b style="text-decoration: underline;">` + partyname + `</b></h6></td>
        
        </tr>
        `;
        } else {
            partyname = "";
        }
        if (ccd != '' && ccd != null) {
            var pcode = getPartyDetailsBySendName(ccd);
            console.log(ccd, pcode);
            partyname = pcode[0].partyname;
            ATYPE = pcode[0].ATYPE;
            LABEL = getPartyTypeLabelByAtype(ATYPE);
            ADDRESS = '';
            ADDRESS += ' , ' + getValueNotDefine(pcode[0].AD1);
            ADDRESS += ' , ' + getValueNotDefine(pcode[0].AD2);
            ADDRESS += ' , ' + getValueNotDefine(pcode[0].city);
            ADDRESS += ',<a href="tel:' + getValueNotDefine(pcode[0].MO) + '">' + getValueNotDefine(pcode[0].MO) + '</a>';
            HTbl += `
        <tr>
        <td align="left"><h6>`+ LABEL + ` : <b style="text-decoration: underline;">` + partyname + `</b></h6></td>
        
        </tr>
        `;
        } else {
            partyname = "";
        }
        if (partynamegrp != '' && partynamegrp != null) {
            var pcode = getGroupDetailsBySendName(partynamegrp);
            partyname = pcode[0].partyname;
            ATYPE = pcode[0].ATYPE;
            LABEL = getPartyTypeLabelByAtype(ATYPE);

            HTbl += `
        <tr>
        <td align="left"><h6>`+ LABEL + ` GROUP : <b style="text-decoration: underline;">` + partyname + `</b></h6></td>
        
        </tr>
        `;
        } else {
            partyname = "";
        }
        if (ccdgrp != '' && ccdgrp != null) {
            var pcode = getGroupDetailsBySendName(ccdgrp);
            partyname = pcode[0].partyname;
            ATYPE = pcode[0].ATYPE;
            LABEL = getPartyTypeLabelByAtype(ATYPE);

            HTbl += `
        <tr>
        <td align="left"><h6>`+ LABEL + ` GROUP : <b style="text-decoration: underline;">` + partyname + `</b></h6></td>
        
        </tr>
        `;
        } else {
            partyname = "";
        }
        if (CITY != '' && CITY != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>CITY : <b style="text-decoration: underline;">`+ CITY + `</b></h6></td>
        
        </tr>`;
        } else {
            CITY = "";
        }
        if (broker != '' && broker != null) {
            HTbl += `
        <tr>
        <td align="left"><h6>BROKER : <b style="text-decoration: underline;">`+ broker + `</b></h6></td>
        </tr>`;
        } else {
            broker = "";
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
        if (!firstLoad) {

            $('.table-responsive').prepend(HTbl);

            var ReportType = getUrlParams(url, "ReportType");


            var reporturl = window.location.href;

            if (reporturl.indexOf('OUTSTANDING') > -1) {
                if (ACTYPE.indexOf("AGENCY") < 0) {
                    $('body').append(firmAcno);
                }
                ReportType += " OUTSTANDING "
            }
            if (reporturl.indexOf('ITEMWISESALE') > -1) {
                ReportType = "ITEM WISE SALE ";
            }
            if (reporturl.indexOf('PENDINGLR') > -1) {
                ReportType = "PENDING LR";
            }
            if (reporturl.indexOf('PCORDER') > -1) {
                var ReportFilter=getUrlParams(url,"ReportFilter");
                ReportType = "ORDER "+ReportFilter;
            }
            // if (reporturl.indexOf('PURCHASE')>-1) {
            //     ReportType = "PURCHASE REPORT";
            // }
            if (reporturl.indexOf('LEDGER') > -1) {
                ReportType = "LEDGER";
            }
            if (reporturl.indexOf('millstock') > -1) {
                ReportType = "MILL STOCK";
            }
            if (reporturl.indexOf('PCSSTOCK') > -1) {
                ReportType = "STOCK IN HOUSE";
            }
            if (reporturl.indexOf('bankPassBook') > -1) {
                ReportType = "BANK ENTRY";
                // $('body').append(firmAcno);
            }
            document.title = ReportType + " " + partyname + " " + broker + " " + CITY;
            $('#ReportType').html("<h6 style='text-decoration: underline;'><b>" + ReportType + " REPORT</b></h6>");
            $('#firmAdrs').html(firmAdrs);
            $('body').append(logoDiv);

            firstLoad = true;
        }
    })
    hideList();
}


function devideTablesFieldWidth(devideIn){
    var ratio=100/devideIn;
    $(`td`).css("max-width",ratio+"%");
}