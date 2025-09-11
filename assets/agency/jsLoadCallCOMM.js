
var ReportType = getUrlParams(url, "ReportType");
var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
var MainBilldetails = [];
function getMainBilldetails(ccd) {
    return MainBilldetails.filter(function (d) {
        return d.ccd == ccd;
    })
}
var GRD;
function loadCall(data) {

    try {

        Data = data;

        var ccode;
        var pcode;
        var city;
        var broker;
        var label;
        var grandtotalPDA = 0;
        var grandtotalCMA = 0;
        var grandtotalCSA = 0;
        var grandtotalCQA = 0;
        var grandtotalTDA = 0;
        var grandtotalDFA = 0;
        var grandtotalLDA = 0;
        var grandtotalCPA = 0;
        var totalCMA = 0;
        var totalPDA = 0;
        var totalCSA = 0;
        var totalCQA = 0;
        var totalTDA = 0;
        var totalDFA = 0;
        var totalLDA = 0;
        var totalCPA = 0;
        var subtotalCMA = 0;
        var subtotalCSA = 0;
        var subtotalCQA = 0;
        var subtotalTDA = 0;
        var subtotalDFA = 0;
        var subtotalLDA = 0;
        var subtotalCPA = 0;
        var subtotalPDA = 0;
        var BLL;
        var FdataUrl
        var DL = Data.length;
        console.log(Data.length);
        if (DL > 0) {
            grandtotalCMA = 0;
            grandtotalPDA = 0;
            grandtotalCSA = 0;
            grandtotalCQA = 0;
            grandtotalTDA = 0;
            grandtotalDFA = 0;
            grandtotalLDA = 0;
            grandtotalCPA = 0;
            tr = "<tbody>";

            for (var i = 0; i < DL; i++) {
                ccode = getPartyDetailsBySendCode(Data[i].COD);
                lbl = "";
                if (ccode.length > 0) {
                    pcode = getValueNotDefine(ccode[0].partyname);
                    city = getValueNotDefine(ccode[0].city);
                    broker = getValueNotDefine(ccode[0].broker);
                    label = getValueNotDefine(ccode[0].label);
                    MO = getValueNotDefine(ccode[0].MO);
                    ATYPE = getValueNotDefine(ccode[0].ATYPE);
                    lbl = parseInt(ATYPE) == 1 ? "CUST : " : parseInt(ATYPE) == 2 ? "SUPP : " : "";

                }
                var rowTr = "";

                rowTr += `<tr class="trPartyHead"onclick="trOnClick('` + Data[i].COD + `','` + city + `','` + broker + `');">
                          <th colspan="17" class="trPartyHead">` + lbl + label + `<a href="tel:` + MO + `"><button>MO:` + getValueNotDefine(MO) + `</button></a></th>
                        </tr>
                        `;

                MainBilldetails = Data[i].billDetails;
                var ccdList = [];
                var ccdFlg = [];
                Data[i].billDetails = Data[i].billDetails.sort(function (a, b) {
                    return a['ccd'] > b['ccd'] ? -1 : 1;
                })
                Data[i].billDetails = Data[i].billDetails.filter(function (a) {
                    if (!ccdFlg[a['ccd']]) {
                        ccdList.push(a['ccd']);
                        ccdFlg[a['ccd']] = true;
                    }
                    return true;
                })
                ccdList = ccdList.sort(function (a, b) {
                    return a < b ? -1 : 1;
                })
                for (let m = 0; m < ccdList.length; m++) {
                    var subtotalrowTr = "";
                    subtotalrowTr += `<tr class="trPartyHead2" style="height:40px">  
                            <th colspan="17" class="trPartyHead2" onclick="openSubR('`+ Data[i].COD + `','` + ccdList[m] + `')">` + ccdList[m] + `</th> 
                            </tr>
                            
                            <tr style="font-weight:500;font-weight:bold;"align="center">                    
                            <td class="hidePWBILL">BILL</td>
                            <td class="hidePWCHQDATE">CHQ REC&nbsp; DATE</td>
                            <td class="hidePWFIRM">FIRM</td>
                            <td class="hidePWRECDATE">REC.&nbsp;DATE</td>
                            <td class="hidePWVNO">VNO</td>
                            <td class="hidePWAMT">AMT</td>
                            <td class="hidePWCOMAMT">COM.<BR>AMT</td>
                            <td class="hidePWCASHAMT">CASH<BR>AMT</td>
                            <td class="hidePWCHQAMT">CHQ<BR>AMT</td>
                            <td class="hidePWTDSAMT">TDS<BR>AMT</td>
                            <td class="hidePWDIFFAMT">DIFF.<BR>AMT</td>
                            <td class="hidePWCHQNO">CHQ<BR>NO</td>
                            <td class="hidePWCOM.PENDAMT">COM.PEND<BR>AMT</td>
                            <td class="hidePWRMK">RMK</td>
                            </tr> `;
                    var supBillDetails = getMainBilldetails(ccdList[m]);
                    var IDE_prev = 0;

                    for (var n = 0; n < supBillDetails.length; n++) {

                        FdataUrl = getFullDataLinkByCnoTypeVnoFirm(supBillDetails[n].CNO, supBillDetails[n].TYPE, supBillDetails[n].VNO, getFirmDetailsBySendCode(supBillDetails[n].CNO)[0].FIRM, supBillDetails[n].IDE);
                        var urlopen = '';
                        var TYPEforLink = (supBillDetails[n].TYPE).toUpperCase();
                        if (TYPEforLink.indexOf('B') > -1) {

                        } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
                            urlopen = FdataUrl;
                        }

                        var CMA = 0;
                        var CSA = 0;
                        var CQA = 0;
                        var TDA = 0;
                        var DFA = 0;
                        var LDA = 0;
                        var CPA = 0;
                        var PDA = 0;
                        IDE = supBillDetails[n].IDE;
                        var VNO = '';
                        var CCD = '';
                        var CDT = '';
                        var billbutton = "";
                        if (IDE !== IDE_prev) {

                            CMA = parseFloat((supBillDetails[n].CMA == null) ? 0 : supBillDetails[n].CMA);
                            CPA = parseFloat((supBillDetails[n].CPA == null) ? 0 : supBillDetails[n].CPA);
                            CCD = (supBillDetails[n].ccd);
                            CSA = parseFloat(supBillDetails[n].CSA == null || supBillDetails[n].CSA == '' ? 0 : supBillDetails[n].CSA);
                            CQA = parseFloat(supBillDetails[n].CQA == null || supBillDetails[n].CQA == '' ? 0 : supBillDetails[n].CQA);
                            TDA = parseFloat(supBillDetails[n].TDA == null || supBillDetails[n].TDA == '' ? 0 : supBillDetails[n].TDA);
                            DFA = parseFloat(supBillDetails[n].DFA == null || supBillDetails[n].DFA == '' ? 0 : supBillDetails[n].DFA);
                            LDA = parseFloat(supBillDetails[n].LDA == null || supBillDetails[n].LDA == '' ? 0 : supBillDetails[n].LDA);
                            PDA = parseFloat(supBillDetails[n].PDA == null || supBillDetails[n].PDA == '' ? 0 : supBillDetails[n].PDA);
                            CDT = formatDate(supBillDetails[n].CDT);
                            VNO = supBillDetails[n].VNO;
                            IDE_prev = IDE;
                            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(supBillDetails[n].CNO, supBillDetails[n].TYPE, supBillDetails[n].VNO, getFirmDetailsBySendCode(supBillDetails[n].CNO)[0].FIRM, supBillDetails[n].IDE);
                            var paymentSlipPdf = FdataUrl.replace("Billpdf", "paymentSlip");
                        } else { }
                        billbutton = `<a target="_blank" href="` + paymentSlipPdf + `"><button class="PrintBtnHide">` + (supBillDetails[n].BLL) + `</button></a>`;
                        subtotalCMA += (CMA);
                        subtotalCPA += (CPA);
                        subtotalPDA +=PDA;
                        console.log(PDA);
                        var row = `                               
                            <tr class="hideAbleTr"align="center"style="">
                            <td  class="hidePWBILL">` + billbutton + `</td>
                            <td  class="hidePWCHQDATE" onclick="openSubR('`+ Data[i].COD + `')">` + CDT + `</td>
                            <td  class="hidePWFIRM" onclick="openSubR('`+ Data[i].COD + `')">` + (supBillDetails[n].FRM) + `</td>
                            <td  class="hidePWRECDATE" onclick="openSubR('`+ Data[i].COD + `')">` + formatDate(supBillDetails[n].RDT) + `</td>
                            <td  class="hidePWVNO" onclick="openSubR('`+ Data[i].COD + `')">` + (VNO) + `</td>
                            <td  class="hidePWAMT" onclick="openSubR('`+ Data[i].COD + `')">` + hide0(parseFloat(PDA).toFixed(2)) + `</td>
                            <td  class="hidePWCOMAMT" onclick="openSubR('`+ Data[i].COD + `')">` + hide0(parseFloat(CMA).toFixed(2)) + `</td>
                            <td  class="hidePWCASHAMT" onclick="openSubR('`+ Data[i].COD + `')">` + hide0(parseFloat(CSA).toFixed(2)) + `</td>
                            <td  class="hidePWCHQAMT" onclick="openSubR('`+ Data[i].COD + `')">` + hide0(parseFloat(CQA).toFixed(2)) + `</td>
                            <td  class="hidePWTDSAMT" onclick="openSubR('`+ Data[i].COD + `')">` + hide0(parseFloat(TDA).toFixed(2)) + `</td>
                            <td  class="hidePWDIFFAMT" onclick="openSubR('`+ Data[i].COD + `')">` + hide0(parseFloat(DFA).toFixed(2)) + `</td>
                            <td  class="hidePWCHQNO" onclick="openSubR('`+ Data[i].COD + `')">` + (supBillDetails[n].CQN) + `</td>
                            <td  class="hidePWCOM.PENDAMT" onclick="openSubR('`+ Data[i].COD + `')">` + hide0(parseFloat(CPA).toFixed(2)) + `</td>                                    
                            <td  class="hidePWRMK" onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(supBillDetails[n].RR) + `</td>                                    
                            </tr>`;
                        if (ReportType == "COMMISSION PENDING") {
                            if (CPA > 0) {
                                subtotalrowTr += row;
                            }
                        } else {
                            subtotalrowTr += row;
                        }

                    }
                    if (ccdList.length > 1) {

                        subtotalrowTr += `  
                    <tr class="hidePWSubTotal tfootcard"style="text-align: center;">
                    <td class="hidePWBILL hideAbleTr">SUBTOTAL</td>
                    <td class="hidePWCHQDATE"></td>
                    <td class="hidePWFIRM"></td>
                    <td class="hidePWRECDATE"></td>
                    <td class="hidePWVNO"></td>
                    <td class="hidePWAMT">`+valuetoFixed(subtotalPDA)+`</td>
                    <td class="hidePWCOMAMT">`+ valuetoFixed(subtotalCMA) + `</td>                        
                    <td class="hidePWCASHAMT"></td>
                    <td class="hidePWCHQAMT"></td>
                    <td class="hidePWTDSAMT"></td>
                    <td class="hidePWDIFFAMT"></td>
                    <td class="hidePWCHQNO"></td>
                    <td class="hidePWCOM.PENDAMT">`+ valuetoFixed(subtotalCPA) + `</td>
                    <td class="hidePWRMK"></td>
                    </tr>  `;
                    }

                    if (ReportType == "COMMISSION PENDING") {
                        if (subtotalCPA > 0) {
                            rowTr += subtotalrowTr;
                        }
                    } else {
                        rowTr += subtotalrowTr;
                    }
                    totalPDA += subtotalPDA;
                    totalCMA += subtotalCMA;
                    totalCPA += subtotalCPA;
                    subtotalCMA = 0;
                    subtotalCPA = 0;
                    subtotalPDA = 0;

                }
                grandtotalCMA += totalCMA;
                grandtotalCPA += totalCPA;
                grandtotalPDA += totalPDA;

                rowTr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
                <td  class="hidePWBILL">TOTAL </td>
                <td  class="hidePWCHQDATE"></td>
                <td  class="hidePWFIRM"></td>
                <td  class="hidePWRECDATE"></td>
                <td  class="hidePWVNO"></td>
                <td  class="hidePWAMT">`+ valuetoFixed(totalPDA) + `</td>
                <td class="hidePWCOMAMT">`+ valuetoFixed(totalCMA) + `</td>
                <td class="hidePWCASHAMT"></td>
                <td class="hidePWCHQAMT"></td>
                <td class="hidePWTDSAMT"></td>
                <td class="hidePWDIFFAMT"></td>
                <td class="hidePWCHQNO"></td>
                <td class="hidePWCOM.PENDAMT">`+ valuetoFixed(totalCPA) + `</td>
                <td class="hidePWRMK"></td>
                </tr>`;
                if (ReportType == "COMMISSION PENDING") {
                    if (totalCPA > 0) {
                        tr += rowTr;
                    }
                } else {
                    tr += rowTr;
                }
                totalCMA = 0;
                totalCPA = 0;
                totalPDA = 0;
            }
            if (Data.length > 1) {

                tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;color:#080844;">
                <td  class="hidePWBILL">GRAND TOTAL</td>
                <td  class="hidePWCHQDATE"></td>
                <td  class="hidePWFIRM"></td>
                <td  class="hidePWRECDATE"></td>
                <td  class="hidePWVNO"></td>
                <td  class="hidePWAMT">`+ valuetoFixed(grandtotalPDA) + `</td>
                <td class="hidePWCOMAMT">`+ valuetoFixed(grandtotalCMA) + `</td>
                <td class="hidePWCASHAMT"></td>
                <td class="hidePWCHQAMT"></td>
                <td class="hidePWTDSAMT"></td>
                <td class="hidePWDIFFAMT"></td>
                <td class="hidePWCHQNO"></td>
                <td class="hidePWCOM.PENDAMT">`+ valuetoFixed(grandtotalCPA) + `</td>
                <td class="hidePWRMK"></td>
                </tr>`;
            }

            $('#result').html(tr);
            $("#loader").removeClass('has-loader');

            var hideAbleTr = getUrlParams(url, "hideAbleTr");
            if (hideAbleTr == "true") {
                $('.hideAbleTr').css("display", "none");
                $('.unhideAbleTr').css("display", "");
            } else {
                $('.unhideAbleTr').css("display", "none");
            }

            AddHeaderTbl();

        } else {
            $('#result').html('<h1>No Data Found</h1>');
            $("#loader").removeClass('has-loader');

        }


    } catch (e) {
        var shareText = "Error in : " + e;
        $('#result').html(`<h5>error:` + e + `<br> please send this error screen shot to whatsApp No. <a href="https://wa.me/918469190530?text=` + encodeURIComponent(shareText) + `">8469190530</a></h5>`);
        $("#loader").removeClass('has-loader');

    }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);
