
var ReportType = getUrlParams(url, "ReportType");
var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
var MainBilldetails = [];
function getMainBilldetails(ccd) {
    return MainBilldetails.filter(function (d) {
        return d.C == ccd;
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
        var BLL;
        var FdataUrl
        var DL = Data.length;
        if (DL > 0) {
            tr = "<tbody>";

            var grandtotal_draft_amt = 0;
            var grandtotal_comm_amt = 0;
            var grandtotal_tot_comm_amt = 0;
            var grandtotal_rec_comm_amt = 0;
            var grandtotal_tds = 0;
            var grandtotal_TOT_REC_AMT = 0;

            var total_draft_amt = 0;
            var total_comm_amt = 0;
            var total_tot_comm_amt = 0;
            var total_rec_comm_amt = 0;
            var total_tds = 0;
            var total_TOT_REC_AMT = 0;

            var subtotal_draft_amt = 0;
            var subtotal_comm_amt = 0;
            var subtotal_tot_comm_amt = 0;
            var subtotal_rec_comm_amt = 0;
            var subtotal_tds = 0;
            var subtotal_TOT_REC_AMT = 0;
            for (var i = 0; i < DL; i++) {
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
                var rowTr = "";

                rowTr += `<tr class="trPartyHead"onclick="trOnClick('` + Data[i].COD + `','` + city + `','` + broker + `');">
                          <th colspan="30" class="trPartyHead">` + lbl + label + `<a href="tel:` + MO + `"><button>MO:` + getValueNotDefine(MO) + `</button></a></th>
                        </tr>
                        `;

                MainBilldetails = Data[i].billDetails;
                var ccdList = [];
                var ccdFlg = [];
                Data[i].billDetails = Data[i].billDetails.sort(function (a, b) {
                    return a['C'] > b['C'] ? -1 : 1;
                })
                Data[i].billDetails = Data[i].billDetails.filter(function (a) {
                    if (!ccdFlg[a['C']]) {
                        ccdList.push(a['C']);
                        ccdFlg[a['C']] = true;
                    }
                    return true;
                })
                ccdList = ccdList.sort(function (a, b) {
                    return a < b ? -1 : 1;
                })
                for (let m = 0; m < ccdList.length; m++) {
                    var subtotalrowTr = "";
                    subtotalrowTr += `<tr class="trPartyHead2" style="height:40px">  
                            <th colspan="30" class="trPartyHead2" onclick="openSubR('`+ Data[i].COD + `','` + ccdList[m] + `')">` + ccdList[m] + `</th> 
                            </tr>
                            
                            <tr class="" style="font-weight:500;font-weight:bold;"align="center"> 
                            <td class="hideSLIP_NO" >SLIP_NO</td>
                            <td class="hideSLIP_DATE" >SLIP DATE&nbsp;&nbsp;&nbsp;</td>
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
                        IDE = supBillDetails[n].IDE;
                        var VNO = '';
                        var CCD = '';
                        var CDT = '';
                        var billbutton = "";

                        var VNO = '';
                        var CCD = '';
                        var SLIP_DATE = '';
                        var billbutton = '';
                        var dd_date = '';
                        var doc = "";
                        var comm_rate = '';
                        var comm_amt = '';
                        var gst = '';
                        var total_comm = '';
                        var rec_comm = '';
                        var tds = '';
                        var total_rec_comm = '';
                        var rec_date = '';
                        var chq_no = '';
                        var rec_rmk = '';
                        var bill_vno = '';
                        var diff_amt = '';
                        var diff_rmk = '';
                        var draft_Amt = '';
                        if (IDE !== IDE_prev) {

                            CMA = parseFloat((supBillDetails[n].CMA == null) ? 0 : supBillDetails[n].CMA);
                            CPA = parseFloat((supBillDetails[n].CPA == null) ? 0 : supBillDetails[n].CPA);
                            CCD = (supBillDetails[n].ccd);
                            CSA = parseFloat(supBillDetails[n].CSA == null || supBillDetails[n].CSA == '' ? 0 : supBillDetails[n].CSA);
                            CQA = parseFloat(supBillDetails[n].CQA == null || supBillDetails[n].CQA == '' ? 0 : supBillDetails[n].CQA);
                            TDA = parseFloat(supBillDetails[n].TDA == null || supBillDetails[n].TDA == '' ? 0 : supBillDetails[n].TDA);
                            DFA = parseFloat(supBillDetails[n].DFA == null || supBillDetails[n].DFA == '' ? 0 : supBillDetails[n].DFA);
                            LDA = parseFloat(supBillDetails[n].LDA == null || supBillDetails[n].LDA == '' ? 0 : supBillDetails[n].LDA);
                            CDT = formatDate(supBillDetails[n].CDT);
                            VNO = supBillDetails[n].VNO;
                            IDE_prev = IDE;
                            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(supBillDetails[n].CNO, supBillDetails[n].TYPE, supBillDetails[n].VNO, getFirmDetailsBySendCode(supBillDetails[n].CNO)[0].FIRM, supBillDetails[n].IDE);
                            var paymentSlipPdf = FdataUrl.replace("Billpdf", "paymentSlip");
                            dd_date = formatDate(supBillDetails[n].DD);
                            doc = getValueNotDefine(supBillDetails[n].DN);
                            comm_rate = getValueNotDefine(supBillDetails[n].CR);
                            comm_amt = getValueNotDefine(supBillDetails[n].CM);
                            gst = getValueNotDefine(supBillDetails[n].G);
                            total_comm = getValueNotDefine(supBillDetails[n].TC);
                            rec_comm = getValueNotDefine(supBillDetails[n].RC);
                            tds = getValueNotDefine(supBillDetails[n].T);
                            total_rec_comm = getValueNotDefine(supBillDetails[n].TRC);
                            rec_date = formatDate(supBillDetails[n].RD);
                            chq_no = getValueNotDefine(supBillDetails[n].CQ);
                            rec_rmk = getValueNotDefine(supBillDetails[n].RR);
                            bill_vno = getValueNotDefine(supBillDetails[n].BV);
                            diff_amt = getValueNotDefine(supBillDetails[n].DF);
                            diff_rmk = getValueNotDefine(supBillDetails[n].DR);
                            subtotal_comm_amt += parseFloat(comm_amt);
                            subtotal_tot_comm_amt += parseFloat(getValueNotDefineNo(total_comm));
                            subtotal_rec_comm_amt += parseFloat(getValueNotDefineNo(rec_comm));
                            subtotal_tds += parseFloat(getValueNotDefineNo(tds));
                            subtotal_TOT_REC_AMT += parseFloat(getValueNotDefineNo(total_rec_comm));
                            billbutton = `<a target="_blank" href="` + paymentSlipPdf + `"><button class="PrintBtnHide">` + (supBillDetails[n].VNO) + `</button></a>`;
                            var SLIP_DATE = formatDate(supBillDetails[n].SD);
                            draft_Amt = getValueNotDefine(supBillDetails[n].DFA);
                            subtotal_draft_amt += parseFloat(draft_Amt)
                        } else { }

                        var row = `  <tr class="hideAbleTr"align="center"style="">
                        <td class="hideSLIP_NO">` + billbutton + `</td>
                        <td class="hideSLIP_DATE">` + SLIP_DATE + `</td>
                        <td class="hideDRAFT_AMT" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + draft_Amt + `</td>
                        <td class="hideDD_DATE" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + dd_date + `</td>
                        <td class="hideDOC" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + doc + `</td>
                        <td class="hideDAYS" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + getDaysDif(supBillDetails[n].OD, nowDate) + `</td>
                        <td class="hideRMK" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + getValueNotDefine(supBillDetails[n].OR) + `</td>
                        <td class="hideCOMM" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + comm_rate + `</td>
                        <td class="hideCOMM_AMT" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + comm_amt + `</td>
                        <td class="hideGST" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + gst + `</td>
                        <td class="hideTOT_COMM" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + total_comm + `</td>
                        <td class="hideREC_COMM" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + rec_comm + `</td>
                        <td class="hideTDS_AMT" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + tds + `</td>
                        <td class="hideTOT_REC_AMT" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + total_rec_comm + `</td>
                        <td class="hideREC_DATE" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + rec_date + `</td>
                        <td class="hideCHQ_NO" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + chq_no + `</td>
                        <td class="hideREC_RMK" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + rec_rmk + `</td>
                        <td class="hideBILL_VNO" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + bill_vno + `</td>
                        <td class="hideBILL_NO" style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + supBillDetails[n].B + `</td>
                        <td class="hideBILL_DATE"style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + formatDate(supBillDetails[n].BD) + `</td>
                        <td class="hideBILL_AMT"style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + getValueNotDefine(supBillDetails[n].BA) + `</td>
                        <td class="hideBILL_DISC"style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + getValueNotDefine(supBillDetails[n].LR) + `</td>
                        <td class="hideGR"style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + getValueNotDefine(supBillDetails[n].CL) + `</td>
                        <td class="hideDISC" style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + getValueNotDefine(supBillDetails[n].D) + `</td>
                        <td class="hideDISC_AMT"style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + getValueNotDefine(supBillDetails[n].DA) + `</td>
                        <td class="hideBC_OTH" style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + getValueNotDefine(supBillDetails[n].BO) + `</td>
                        <td class="hideDIFF_AMT"style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + diff_amt + `</td>
                        <td class="hideDIFF_RMK"style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + diff_rmk + `</td>                                 
                        <td class="hideFAMT"style="display:none;" onclick="openSubR('`+ supBillDetails[n].COD + `')">` + getValueNotDefine(supBillDetails[n].FA) + `</td>                                 
                        </tr> `;
                        subtotalrowTr += row;


                    }
                    if (ccdList.length > 1) {

                        subtotalrowTr += `
                    <tbody>
                    <tr class="tfootcard" style="font-weight:500;font-weight:bold;"align="center"> 
                    <td class="hideSLIP_NO">SUBTOTAL</td>
                    <td class="hideSLIP_DATE"></td>
                    <td class="hideDRAFT_AMT">`+ parseFloat(subtotal_draft_amt).toFixed(2) + `</td>
                    <td class="hideDD_DATE"></td>
                    <td class="hideDOC"></td>
                    <td class="hideDAYS"></td>
                    <td class="hideRMK"></td>
                    <td class="hideCOMM"></td>
                    <td class="hideCOMM_AMT">`+ parseFloat(subtotal_comm_amt).toFixed(2) + `</td>
                    <td class="hideGST"></td>
                    <td class="hideTOT_COMM">`+ parseFloat(subtotal_tot_comm_amt).toFixed(2) + `</td>
                    <td class="hideREC_COMM">`+ parseFloat(subtotal_rec_comm_amt).toFixed(2) + `</td>
                    <td class="hideTDS_AMT">`+ parseFloat(subtotal_tds).toFixed(2) + `</td>
                    <td class="hideTOT_REC_AMT">`+ parseFloat(subtotal_TOT_REC_AMT).toFixed(2) + `</td>
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
                    }

                    rowTr += subtotalrowTr;

                    total_draft_amt += subtotal_draft_amt;
                    total_comm_amt += subtotal_comm_amt;
                    total_tot_comm_amt += subtotal_tot_comm_amt;
                    total_rec_comm_amt += subtotal_rec_comm_amt;
                    total_tds += subtotal_tds;
                    total_TOT_REC_AMT += subtotal_TOT_REC_AMT;

                    subtotal_draft_amt = 0;
                    subtotal_comm_amt = 0;
                    subtotal_tot_comm_amt = 0;
                    subtotal_rec_comm_amt = 0;
                    subtotal_tds = 0;
                    subtotal_TOT_REC_AMT = 0;

                }

                rowTr += `
                <tbody>
                <tr class="tfootcard" style="font-weight:500;font-weight:bold;"align="center"> 
                <td class="hideSLIP_NO">TOTAL</td>
                <td class="hideSLIP_DATE"></td>
                <td class="hideDRAFT_AMT">`+ parseFloat(total_draft_amt).toFixed(2) + `</td>
                <td class="hideDD_DATE"></td>
                <td class="hideDOC"></td>
                <td class="hideDAYS"></td>
                <td class="hideRMK"></td>
                <td class="hideCOMM"></td>
                <td class="hideCOMM_AMT">`+ parseFloat(total_comm_amt).toFixed(2) + `</td>
                <td class="hideGST"></td>
                <td class="hideTOT_COMM">`+ parseFloat(total_tot_comm_amt).toFixed(2) + `</td>
                <td class="hideREC_COMM">`+ parseFloat(total_rec_comm_amt).toFixed(2) + `</td>
                <td class="hideTDS_AMT">`+ parseFloat(total_tds).toFixed(2) + `</td>
                <td class="hideTOT_REC_AMT">`+ parseFloat(total_TOT_REC_AMT).toFixed(2) + `</td>
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
                tr += rowTr;
                grandtotal_draft_amt += total_draft_amt;
                grandtotal_comm_amt += total_comm_amt;
                grandtotal_tot_comm_amt += total_tot_comm_amt;
                grandtotal_rec_comm_amt += total_rec_comm_amt;
                grandtotal_tds += total_tds;
                grandtotal_TOT_REC_AMT += total_TOT_REC_AMT;

                total_draft_amt = 0;
                total_comm_amt = 0;
                total_tot_comm_amt = 0;
                total_rec_comm_amt = 0;
                total_tds = 0;
                total_TOT_REC_AMT = 0;
            }
            if (Data.length > 1) {

                tr += `
                <tbody>
                <tr class="tfootcard" style="font-weight:500;font-weight:bold;"align="center"> 
                <td class="hideSLIP_NO">GRAND TOTAL</td>
                <td class="hideSLIP_DATE"></td>
                <td class="hideDRAFT_AMT">`+ parseFloat(grandtotal_draft_amt).toFixed(2) + `</td>
                <td class="hideDD_DATE"></td>
                <td class="hideDOC"></td>
                <td class="hideDAYS"></td>
                <td class="hideRMK"></td>
                <td class="hideCOMM"></td>
                <td class="hideCOMM_AMT">`+ parseFloat(grandtotal_comm_amt).toFixed(2) + `</td>
                <td class="hideGST"></td>
                <td class="hideTOT_COMM">`+ parseFloat(grandtotal_tot_comm_amt).toFixed(2) + `</td>
                <td class="hideREC_COMM">`+ parseFloat(grandtotal_rec_comm_amt).toFixed(2) + `</td>
                <td class="hideTDS_AMT">`+ parseFloat(grandtotal_tds).toFixed(2) + `</td>
                <td class="hideTOT_REC_AMT">`+ parseFloat(grandtotal_TOT_REC_AMT).toFixed(2) + `</td>
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
            devideTablesFieldWidth(20);

        } else {
            $('#result').html('<h1>No Data Found</h1>');
            $("#loader").removeClass('has-loader');

        }


    } catch (e) {
        noteError(e);
    }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);
