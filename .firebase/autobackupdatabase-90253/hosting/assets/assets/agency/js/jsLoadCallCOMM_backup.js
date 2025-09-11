
var ReportType = getUrlParams(url, "ReportType");
var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");

var GRD;
var MainArr = [];
function loadCall(data) {


    Data = data;
    var DtArray = [];
    for (i = 0; i < Data.length; i++) {
        if (Data[i].billDetails.length > 0) {
            for (j = 0; j < Data[i].billDetails.length; j++) {
                var obj = {};
                obj.COD = Data[i].COD;
                obj.ATP = Data[i].ATP;
                obj.IDE = Data[i].billDetails[j].IDE;
                obj.sft = Data[i].billDetails[j].sft;
                obj.year = Data[i].billDetails[j].year;
                obj.ccd = Data[i].billDetails[j].ccd;
                obj.FRM = Data[i].billDetails[j].FRM;
                obj.CNO = Data[i].billDetails[j].CNO;
                obj.TYPE = Data[i].billDetails[j].TYPE;
                obj.VNO = Data[i].billDetails[j].VNO;
                obj.BLL = Data[i].billDetails[j].BLL;
                obj.BDT = Data[i].billDetails[j].BDT;
                obj.CDT = Data[i].billDetails[j].CDT;
                obj.DT = Data[i].billDetails[j].DT;
                obj.BA = Data[i].billDetails[j].BA;
                obj.CL = Data[i].billDetails[j].CL;
                obj.RDT = Data[i].billDetails[j].RDT;
                obj.PDA = Data[i].billDetails[j].PDA;
                obj.CMR = Data[i].billDetails[j].CMR;
                obj.CMA = Data[i].billDetails[j].CMA;
                obj.CSA = Data[i].billDetails[j].CSA;
                obj.TDA = Data[i].billDetails[j].TDA;
                obj.CQA = Data[i].billDetails[j].CQA;
                obj.DFA = Data[i].billDetails[j].DFA;
                obj.LDA = Data[i].billDetails[j].LDA;
                obj.CQN = Data[i].billDetails[j].CQN;
                obj.CPA = Data[i].billDetails[j].CPA;
                obj.DDA = Data[i].billDetails[j].DDA;
                obj.RR = Data[i].billDetails[j].RR;

                MainArr.push(obj);
            }
        }
    }
    console.log(MainArr);
    MainArr = MainArr.sort(function (a, b) {
        return parseInt(a.VNO) - parseInt(b.VNO);
    })
    Data = MainArr;
    var ccode;
    var pcode;
    var city;
    var broker;
    var label;
    var grandtotalCMA = 0;
    var grandtotalCSA = 0;
    var grandtotalCQA = 0;
    var grandtotalTDA = 0;
    var grandtotalDFA = 0;
    var grandtotalLDA = 0;
    var grandtotalCPA = 0;
    var totalCMA = 0;
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
    var BLL;
    var FdataUrl
    var DL = Data.length;
    console.log(Data.length);
    if (DL > 0) {
        tr += `
            <tbody>
             <tr class="trPartyHead" style="font-weight:500;font-weight:bold;"align="center">                    
            <td>BILL</td>
            <td class="hideDWCHQRECDATE">CHQ REC.&nbsp;DATE</td>
            <td class="hideDWCUST">CUST.</td>
            <td class="hideDWSUPP">SUPP.</td>
            <td class="hideDWFIRM">FIRM</td>
            <td class="hideDWBILL">BILL</td>
            <td class="hideDWRECDATE">REC.&nbsp;DATE</td>
            <td class="hideDWVNO">VNO</td>
            <td class="hideDWAMT">AMT</td>
            <td class="hideDWCOMAMT">COM.<BR>AMT</td>
            <td class="hideDWCASHAMT">CASH<BR>AMT</td>
            <td class="hideDWCHQAMT">CHQ<BR>AMT</td>
            <td class="hideDWTDSAMT">TDS<BR>AMT</td>
            <td class="hideDWDIFFAMT">DIFF.<BR>AMT</td>
            <td class="hideDWCHQNO">CHQ<BR>NO</td>
            <td class="hideDWCOMPENDAMT">COM.PEND<BR>AMT</td>
            <td class="hideDWRMK">RMK</td>
            </tr>  `;

        var IDE_prev = 0;
        for (let i = 0; i < Data.length; i++) {
            var CMA = 0;
            var CSA = 0;
            var CQA = 0;
            var TDA = 0;
            var DFA = 0;
            var LDA = 0;
            var CPA = 0;
            IDE = Data[i].IDE;
            var VNO = '';
            var CCD = '';
            var CDT = '';
            var billbutton='';
            if (IDE !== IDE_prev) {
                CMA = parseFloat((Data[i].CMA == null) || (Data[i].CMA == "") ? 0 : Data[i].CMA);
                CPA = parseFloat((Data[i].CPA == null) || (Data[i].CPA == "") ? 0 : Data[i].CPA);
                CCD = (Data[i].ccd);
                CSA = parseFloat(Data[i].CSA == null || Data[i].CSA == '' ? 0 : Data[i].CSA);
                CQA = parseFloat(Data[i].CQA == null || Data[i].CQA == '' ? 0 : Data[i].CQA);
                TDA = parseFloat(Data[i].TDA == null || Data[i].TDA == '' ? 0 : Data[i].TDA);
                DFA = parseFloat(Data[i].DFA == null || Data[i].DFA == '' ? 0 : Data[i].DFA);
                LDA = parseFloat(Data[i].LDA == null || Data[i].LDA == '' ? 0 : Data[i].LDA);
                CDT = formatDate(Data[i].CDT);
                VNO = Data[i].VNO;
                IDE_prev = IDE;
                FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].CNO, Data[i].TYPE, Data[i].VNO, getFirmDetailsBySendCode(Data[i].CNO)[0].FIRM, Data[i].IDE);
                var paymentSlipPdf = FdataUrl.replace("Billpdf", "paymentSlip");
                billbutton = `<a target="_blank" href="` + paymentSlipPdf + `"><button class="PrintBtnHide">` + (Data[i].BLL) + `</button></a>`;

            } else {

            }
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
            tr += `  <tr class="hideAbleTr"align="center"style="">
    <td>` + billbutton + `</td>
    <td  class="hideDWCHQRECDATE"  onclick="openSubR('`+ Data[i].COD + `')">` + CDT + `</td>
    <td  class="hideDWCUST" onclick="openSubR('`+ Data[i].COD + `','` + Data[i].ccd + `')">` + Data[i].ccd + `</td>
    <td  class="hideDWSUPP"  onclick="openSubR('`+ Data[i].COD + `')">` + pcode + `</td>
    <td  class="hideDWFIRM"  onclick="openSubR('`+ Data[i].COD + `')">` + (Data[i].FRM) + `</td>
    <td  class="hideDWBILL"  onclick="openSubR('`+ Data[i].COD + `')">` + (Data[i].BLL) + `</td>
    <td  class="hideDWRECDATE"  onclick="openSubR('`+ Data[i].COD + `')">` + formatDate(Data[i].RDT) + `</td>
    <td  class="hideDWVNO"  onclick="openSubR('`+ Data[i].COD + `')">` + (VNO) + `</td>
    <td  class="hideDWAMT"  onclick="openSubR('`+ Data[i].COD + `')">` + (Data[i].PDA) + `</td>
    <td  class="hideDWCOMAMT"  onclick="openSubR('`+ Data[i].COD + `')">` + (CMA) + `</td>
    <td  class="hideDWCASHAMT"  onclick="openSubR('`+ Data[i].COD + `')">` + (CSA) + `</td>
    <td  class="hideDWCHQAMT"  onclick="openSubR('`+ Data[i].COD + `')">` + (CQA) + `</td>
    <td  class="hideDWTDSAMT"  onclick="openSubR('`+ Data[i].COD + `')">` + (TDA) + `</td>
    <td  class="hideDWDIFFAMT"  onclick="openSubR('`+ Data[i].COD + `')">` + (DFA) + `</td>
    <td  class="hideDWCHQNO"  onclick="openSubR('`+ Data[i].COD + `')">` + (Data[i].CQN) + `</td>
    <td  class="hideDWCOMPENDAMT"  onclick="openSubR('`+ Data[i].COD + `')">` + (CPA) + `</td>                                    
    <td  class="hideDWCOMPENDAMT"  onclick="openSubR('`+ Data[i].COD + `')">` +getValueNotDefine(Data[i].RR) + `</td>                                    
    </tr> `;

            grandtotalCMA += CMA;
            grandtotalCPA += CPA;
        }
        tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;color:#080844;">
<td>GRAND TOTAL</td>
<td  class="hideDWCHQRECDATE"></td>
<td  class="hideDWCUST"></td>
<td  class="hideDWSUPP"></td>
<td  class="hideDWFIRM"></td>
<td  class="hideDWBILL"></td>
<td  class="hideDWRECDATE"></td>
<td  class="hideDWVNO">`+ grandtotalCMA + `</td>
<td  class="hideDWAMT"></td>
<td  class="hideDWCOMAMT"></td>
<td  class="hideDWCASHAMT"></td>
<td  class="hideDWCHQAMT"></td>
<td  class="hideDWTDSAMT"></td>
<td  class="hideDWDIFFAMT"></td>
<td  class="hideDWCHQNO"></td>
<td  class="hideDWCOMPENDAMT">`+ grandtotalCPA + `</td>
</tr>`;


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

    try {

    } catch (e) {
        var shareText = "Error in : " + e;
        $('#result').html(`<h5>error:` + e + `<br> please send this error screen shot to whatsApp No. <a href="https://wa.me/918469190530?text=` + encodeURIComponent(shareText) + `">8469190530</a></h5>`);
        $("#loader").removeClass('has-loader');

    }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);
