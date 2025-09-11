
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
                obj.SD = Data[i].billDetails[j].SD;
                obj.sft = Data[i].billDetails[j].sft;
                obj.year = Data[i].billDetails[j].year;
                obj.CNO = Data[i].billDetails[j].CNO;
                obj.TYPE = Data[i].billDetails[j].TYPE;
                obj.VNO = Data[i].billDetails[j].VNO;
                obj.S = Data[i].billDetails[j].S;
                obj.C = Data[i].billDetails[j].C;
                obj.B = Data[i].billDetails[j].B;
                obj.BD = Data[i].billDetails[j].BD;
                obj.LR = Data[i].billDetails[j].LR;
                obj.CL = Data[i].billDetails[j].CL;
                obj.D = Data[i].billDetails[j].D;
                obj.DA = Data[i].billDetails[j].DA;
                obj.BO = Data[i].billDetails[j].BO;
                obj.FA = Data[i].billDetails[j].FA;
                obj.DFA = Data[i].billDetails[j].DFA;
                obj.DD = Data[i].billDetails[j].DD;
                obj.DN = Data[i].billDetails[j].DN;
                obj.OR = Data[i].billDetails[j].OR;
                obj.CR = Data[i].billDetails[j].CR;
                obj.CM = Data[i].billDetails[j].CM;
                obj.G = Data[i].billDetails[j].G;
                obj.TC = Data[i].billDetails[j].TC;
                obj.RC = Data[i].billDetails[j].RC;
                obj.T = Data[i].billDetails[j].T;
                obj.TRC = Data[i].billDetails[j].TRC;
                obj.DF = Data[i].billDetails[j].DF;
                obj.RD = Data[i].billDetails[j].RD;
                obj.CQ = Data[i].billDetails[j].CQ;
                obj.RR = Data[i].billDetails[j].RR;
                obj.BV = Data[i].billDetails[j].BV;
                obj.DR = Data[i].billDetails[j].DR;
                obj.BA = Data[i].billDetails[j].BA;
                obj.OD = Data[i].billDetails[j].OD;
                MainArr.push(obj);
            }
        }
    }
    // console.log(MainArr);
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
            <td class="hideSLIP_NO" >SLIP_NO</td>
            <td class="hideSLIP_DATE" >SLIP DATE&nbsp;&nbsp;&nbsp;</td>
            <td class="hideCUST" >CUST.</td>
            <td class="hideSUPP" >SUPP</td>
            <td class="hideDRAFT_AMT" >DRAFT AMT</td>
            <td class="hideDD_DATE" >DD DATE&nbsp;&nbsp;&nbsp;</td>
            <td class="hideDOC" >DOC</td>
            <td class="hideDAYS" >DAYS</td>
            <td class="hideRMK" >RMK</td>
            <td class="hideCOMM" >COMM%</td>
            <td class="hideCOMM_AMT" >COMM AMT</td>
            <td class="hideGST" >GST</td>
            <td class="hideTOT_COMM" >TOT. COMM</td>
            <td class="hideREC_COMM" >REC COMM</td>
            <td class="hideTDS_AMT" >TDS AMT</td>
            <td class="hideTOT_REC_AMT" >TOT. REC. AMT</td>
            <td class="hideREC_DATE" >REC DATE&nbsp;&nbsp;&nbsp;</td>
            <td class="hideCHQ_NO" >CHQ NO</td>
            <td class="hideREC_RMK" >REC RMK</td>
            <td class="hideBILL_VNO" >BILL VNO</td>
            <td class="hideBILL_NO" style="display:none;" >BILL.NO</td>
            <td class="hideBILL_DATE"style="display:none;" >BILL DATE&nbsp;&nbsp;&nbsp;</td>
            <td class="hideBILL_AMT"style="display:none;" >BILL AMT</td>
             <td class="hideBILL_DISC"style="display:none;" >BILL DISC</td>
             <td class="hideGR"style="display:none;" >GR</td>
             <td class="hideDISC" style="display:none;" >DISC</td>
             <td class="hideDISC_AMT"style="display:none;" >DISC AMT</td>
             <td class="hideBC_OTH" style="display:none;" >BC_OTH</td>
             <td class="hideDIFF_AMT"style="display:none;" >DIFF AMT</td>
             <td class="hideDIFF_RMK"style="display:none;" >DIFF RMK</td>
             <td class="hideFAMT"style="display:none;" >FAMT.</td>
             </tr>  `;

        var IDE_prev = 0;
        var total_draft_amt = 0;
        var total_comm_amt=0;
        var total_tot_comm_amt=0;
        var total_rec_comm_amt=0;
        var total_tds=0;
        var total_TOT_REC_AMT=0;
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
            var SLIP_DATE = '';
            var billbutton = '';
            var dd_date='';
            var doc="";
            var comm_rate='';
            var comm_amt='';
            var gst='';
            var total_comm='';
            var rec_comm='';
            var tds='';
            var total_rec_comm='';
            var rec_date='';
            var chq_no='';
            var rec_rmk='';
            var bill_vno='';
            var diff_amt='';
            var diff_rmk='';
            var draft_Amt='';
            if (IDE !== IDE_prev) {
                CMA = parseFloat((Data[i].CMA == null) || (Data[i].CMA == "") ? 0 : Data[i].CMA);
                CPA = parseFloat((Data[i].CPA == null) || (Data[i].CPA == "") ? 0 : Data[i].CPA);
                CCD = (Data[i].ccd);
                CSA = parseFloat(Data[i].CSA == null || Data[i].CSA == '' ? 0 : Data[i].CSA);
                CQA = parseFloat(Data[i].CQA == null || Data[i].CQA == '' ? 0 : Data[i].CQA);
                TDA = parseFloat(Data[i].TDA == null || Data[i].TDA == '' ? 0 : Data[i].TDA);
                DFA = parseFloat(Data[i].DFA == null || Data[i].DFA == '' ? 0 : Data[i].DFA);
                LDA = parseFloat(Data[i].LDA == null || Data[i].LDA == '' ? 0 : Data[i].LDA);
                SLIP_DATE = formatDate(Data[i].SD);
                console.log(SLIP_DATE); 
                VNO = Data[i].VNO;
                IDE_prev = IDE;
                FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].CNO, Data[i].TYPE, Data[i].VNO, getFirmDetailsBySendCode(Data[i].CNO)[0].FIRM, Data[i].IDE);
                var paymentSlipPdf = FdataUrl.replace("Billpdf", "paymentSlip");
                billbutton = `<a target="_blank" href="` + paymentSlipPdf + `"><button class="PrintBtnHide">` + (Data[i].VNO) + `</button></a>`;
                dd_date=formatDate(Data[i].DD);
                doc=getValueNotDefine(Data[i].DN);
                comm_rate=getValueNotDefine(Data[i].CR);
                comm_amt=getValueNotDefine(Data[i].CM);
                gst=getValueNotDefine(Data[i].G);
                total_comm=getValueNotDefine(Data[i].TC);
                rec_comm=getValueNotDefine(Data[i].RC);
                tds=getValueNotDefine(Data[i].T);
                total_rec_comm=getValueNotDefine(Data[i].TRC);
                rec_date=formatDate(Data[i].RD);
                chq_no=getValueNotDefine(Data[i].CQ);
                rec_rmk=getValueNotDefine(Data[i].RR);
                bill_vno=getValueNotDefine(Data[i].BV);
                diff_amt=getValueNotDefine(Data[i].DF);
                diff_rmk=getValueNotDefine(Data[i].DR);
                total_comm_amt +=parseFloat(comm_amt);
                total_tot_comm_amt +=parseFloat(getValueNotDefineNo(total_comm));
                total_rec_comm_amt +=parseFloat(getValueNotDefineNo(rec_comm));
                total_tds +=parseFloat(getValueNotDefineNo(tds));
                total_TOT_REC_AMT +=parseFloat(getValueNotDefineNo(total_rec_comm));
                draft_Amt=getValueNotDefine(Data[i].DFA);
                total_draft_amt +=parseFloat(draft_Amt)
            } else {

            }
            ccode = getPartyDetailsBySendName(Data[i].COD);
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
            
            <td class="hideSLIP_NO">` + billbutton + `</td>
            <td class="hideSLIP_DATE">` + SLIP_DATE + `</td>
            <td class="hideCUST" onclick="openSubR('`+ Data[i].COD + `','`+ Data[i].C + `')">`+ Data[i].C + `</td>
            <td class="hideSUPP" onclick="openSubR('`+ Data[i].COD + `')">`+ Data[i].COD + `</td>
            <td class="hideDRAFT_AMT" onclick="openSubR('`+ Data[i].COD + `')">`+draft_Amt+`</td>
            <td class="hideDD_DATE" onclick="openSubR('`+ Data[i].COD + `')">`+ dd_date + `</td>
            <td class="hideDOC" onclick="openSubR('`+ Data[i].COD + `')">`+doc+`</td>
            <td class="hideDAYS" onclick="openSubR('`+ Data[i].COD + `')">`+getDaysDif(Data[i].OD, nowDate)+`</td>
            <td class="hideRMK" onclick="openSubR('`+ Data[i].COD + `')">`+getValueNotDefine(Data[i].OR)+`</td>
            <td class="hideCOMM" onclick="openSubR('`+ Data[i].COD + `')">`+comm_rate+`</td>
            <td class="hideCOMM_AMT" onclick="openSubR('`+ Data[i].COD + `')">`+comm_amt+`</td>
            <td class="hideGST" onclick="openSubR('`+ Data[i].COD + `')">`+gst+`</td>
            <td class="hideTOT_COMM" onclick="openSubR('`+ Data[i].COD + `')">`+total_comm+`</td>
            <td class="hideREC_COMM" onclick="openSubR('`+ Data[i].COD + `')">`+rec_comm+`</td>
            <td class="hideTDS_AMT" onclick="openSubR('`+ Data[i].COD + `')">`+tds+`</td>
            <td class="hideTOT_REC_AMT" onclick="openSubR('`+ Data[i].COD + `')">`+total_rec_comm+`</td>
            <td class="hideREC_DATE" onclick="openSubR('`+ Data[i].COD + `')">`+rec_date+`</td>
            <td class="hideCHQ_NO" onclick="openSubR('`+ Data[i].COD + `')">`+chq_no+`</td>
            <td class="hideREC_RMK" onclick="openSubR('`+ Data[i].COD + `')">`+rec_rmk+`</td>
            <td class="hideBILL_VNO" onclick="openSubR('`+ Data[i].COD + `')">`+bill_vno+`</td>
            <td class="hideBILL_NO" style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+ Data[i].B + `</td>
            <td class="hideBILL_DATE"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+ formatDate(Data[i].BD) + `</td>
            <td class="hideBILL_AMT"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+getValueNotDefine(Data[i].BA)+`</td>
            <td class="hideBILL_DISC"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+getValueNotDefine(Data[i].LR)+`</td>
            <td class="hideGR"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+getValueNotDefine(Data[i].CL)+`</td>
            <td class="hideDISC" style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+getValueNotDefine(Data[i].D)+`</td>
            <td class="hideDISC_AMT"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+getValueNotDefine(Data[i].DA)+`</td>
            <td class="hideBC_OTH" style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+getValueNotDefine(Data[i].BO)+`</td>
            <td class="hideDIFF_AMT"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+diff_amt+`</td>
            <td class="hideDIFF_RMK"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+diff_rmk+`</td>                                 
            <td class="hideFAMT"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">`+getValueNotDefine(Data[i].FA)+`</td>                                 
            </tr> `;
        }
        tr += `
        <tbody>
        <tr class="tfootcard" style="font-weight:500;font-weight:bold;"align="center"> 
        <td class="hideSLIP_NO">TOTAL</td>
        <td class="hideSLIP_DATE"></td>
        <td class="hideCUST"></td>
        <td class="hideSUPP"></td>
        <td class="hideDRAFT_AMT">`+parseFloat(total_draft_amt).toFixed(2)+`</td>
        <td class="hideDD_DATE"></td>
        <td class="hideDOC"></td>
        <td class="hideDAYS"></td>
        <td class="hideRMK"></td>
        <td class="hideCOMM"></td>
        <td class="hideCOMM_AMT">`+parseFloat(total_comm_amt).toFixed(2)+`</td>
        <td class="hideGST"></td>
        <td class="hideTOT_COMM">`+parseFloat(total_tot_comm_amt).toFixed(2)+`</td>
        <td class="hideREC_COMM">`+parseFloat(total_rec_comm_amt).toFixed(2)+`</td>
        <td class="hideTDS_AMT">`+parseFloat(total_tds).toFixed(2)+`</td>
        <td class="hideTOT_REC_AMT">`+parseFloat(total_TOT_REC_AMT).toFixed(2)+`</td>
        <td class="hideREC_DATE"></td>
        <td class="hideCHQ_NO"></td>
        <td class="hideREC_RMK"></td>
        <td class="hideBILL_VNO"></td>
        <td class="hideBILL_NO" style="display:none;"></td>
        <td class="hideBILL_DATE"style="display:none;"></td>
        <td class="hideBILL_AMT"style="display:none;"></td>
         <td class="hideBILL_DISC"style="display:none;"></td>
         <td class="hideGR"style="display:none;"></td>
         <td class="hideDISC" style="display:none;"></td>
         <td class="hideDISC_AMT"style="display:none;"></td>
         <td class="hideBC_OTH" style="display:none;"></td>
         <td class="hideDIFF_AMT"style="display:none;"></td>
         <td class="hideDIFF_RMK"style="display:none;"></td>
         <td class="hideFAMT"style="display:none;"></td>
        </tr>  `;

        $('#result').html(tr);
        $("#loader").removeClass('has-loader');
        AddHeaderTbl();
        devideTablesFieldWidth(20);
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
