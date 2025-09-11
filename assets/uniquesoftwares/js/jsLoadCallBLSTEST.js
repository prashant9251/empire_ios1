var GRD;
var groupname;
var url = window.location.href;
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);
function getDaysDif(Date1, Date2) {
    var date1 = new Date(Date1);
    var date2 = new Date(Date2);
    var DiffTime = date2.getTime() - date1.getTime();
    var DiffDays = DiffTime / (1000 * 3600 * 24);
    return parseInt(DiffDays);
}
function loadCall(Data) {
    //---------------
    // Data = Data.filter(function (data) {
    //   return data.billDetails.some((bill) => (bill.DT) != null);
    // }).map(function (subdata) {
    //   return {
    //     code: subdata.code,
    //     billDetails: subdata.billDetails.filter(function (bill) {
    //       return (bill.DT) != null;
    //     })
    //   }
    // })

    console.log("grd", Data);
    var GST;
    var FdataUrl;
    var DETAILSDET;
    var ccode;
    var pcode;
    var city;
    var broker;
    var label;
    var grandTotalGrossAmt;
    var grandTotalfinalAmt;
    var grandtotalMTS;

    var totalGrossAmt;
    var totalFinalAmt;
    var DL = Data.length;
    var BLL;
    var totalsr = 0;
    if (DL > 0) {
        grandTotalGrossAmt = 0;
        grandTotalfinalAmt = 0;
        grandtotalMTS = 0;
        tr = "<tbody>";
        for (i = 0; i < DL; i++) {
            ccode = getPartyDetailsBySendCode(Data[i].code);
            // console.log(Data[i].code+"-",ccode);
            pcode = getValueNotDefine(ccode[0].partyname);
            city = getValueNotDefine(ccode[0].city);
            broker = getValueNotDefine(ccode[0].broker);
            label = getValueNotDefine(ccode[0].label);
            tr += `
                <tr class="trPartyHead"  onclick="trOnClick('` + Data[i].code + `','` + city + `','` + broker + `');">
                          <th  class="trPartyHead" colspan="14">` + label + `</th>                                    
                        </tr>`;
            tr += `<tr style="font-weight:500;"align="center">
                    
                        <th class="pdfBtnHide">DAYS DIFF</th>
                        <th class="pdfBtnHide">PDF</th>
                        <th class="selectBoxReport" style="display:none;">SELECT</th>
                        <th>BILL</th>
                        <th class="hideBWPWDATE">DATE</th>
                        <th class="hideBWPWFIRM">FIRM</th>
                        <th class="hideBWPWGROSSAMT">GROSS.AMT</th>
                        <th class="hideBWPWGST">GST</th>
                        <th class="hideBWPWTYPE">TYPE</th>
                        <th class="hideBWPWQUAL hqual">QUAL</th>
                        <th class="hideBWPWMTS hmts">MTS</th>
                        <th class="hideBWPWFINALAMT">FINAL AMT</th>
                        <th class="hideBWPWPAID">PAID</th>
                        <th class="hideBWPWAGHASTE">AG./HASTE</th>
                        <th class="hideBWPWTRANSPORT">TRANSPORT</th>
                        <th class="hideBWPWLRNO">LR NO</th>
                        <th class="hideBWPWGRADE">GRADE</th>
                        <th class="hideBWPWRMK">RMK</th>
                        </tr>`;
            BLL = Data[i].billDetails.length;
            if (BLL > 0) {

                totalGrossAmt = 0;
                totalFinalAmt = 0;
                totalMTS = 0;
                sr = 0;
                for (j = 0; j < BLL; j++) {
                    sr += 1;
                    var grsAmt = 0;
                    var fnlAmt = 0;
                    if (Data[i].billDetails[j].DT != null && Data[i].billDetails[j].DT != "") {
                        if (Data[i].billDetails[j].DT.toUpperCase().indexOf('CN')) {
                            grsAmt = +Math.abs(Data[i].billDetails[j].grsamt);
                            fnlAmt = +Math.abs(Data[i].billDetails[j].BAMT);
                        } else if (Data[i].billDetails[j].DT.toUpperCase().indexOf('DN')) {
                            grsAmt = -Math.abs(Data[i].billDetails[j].grsamt);
                            fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
                        } else if (Data[i].billDetails[j].DT.toUpperCase().indexOf('OS')) {
                            grsAmt = -Math.abs(Data[i].billDetails[j].grsamt);
                            fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
                        } else {
                            grsAmt = -Math.abs(Data[i].billDetails[j].grsamt);
                            fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
                        }
                    } else {
                        grsAmt = -Math.abs(Data[i].billDetails[j].grsamt);
                        fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
                    }
                    TMTS = Data[i].billDetails[j].TMTS == null ? 0 : parseFloat(Data[i].billDetails[j].TMTS);
                    totalGrossAmt += parseFloat(grsAmt);
                    totalFinalAmt += parseFloat(fnlAmt);
                    totalMTS += TMTS;
                    GST = parseFloat(Data[i].billDetails[j].VTAMT) + parseFloat(Data[i].billDetails[j].ADVTAMT);
                    FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE, ccode[0].MO, ccode[0].EML);

                    var BrokerHaste = '';
                    var HST = Data[i].billDetails[j].haste;
                    if (HST != '' && HST != null && HST != undefined) {
                        BrokerHaste = HST;
                    } else {
                        BrokerHaste = Data[i].billDetails[j].BCODE;
                    }
                    var ID = Data[i].billDetails[j].CNO + Data[i].billDetails[j].TYPE + Data[i].billDetails[j].VNO;
                    var nowDate = new Date();
                    var DIFFDAYS = parseInt(getDaysDif(Data[i].billDetails[j].DATE, nowDate));

                    tr += `<tr align="center"class="hideAbleTr">
          <td class="hideBWPWDATE" onclick="openSubR('`+ Data[i].code + `')">` + DIFFDAYS + `</td>
                        <th class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                        <td class="selectBoxReport" style="display:none;">      <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + Data[i].billDetails[j].CNO + `"DTYPE="` + Data[i].billDetails[j].TYPE + `"VNO="` + Data[i].billDetails[j].VNO + `"/></td>
                        <td><a href="`+ FdataUrl + `" target="_blank"><button>` + Data[i].billDetails[j].BILL + `</button><a></td>
                        <td class="hideBWPWDATE" onclick="openSubR('`+ Data[i].code + `')">` + formatDate(Data[i].billDetails[j].DATE) + `</td>
                        <td class="hideBWPWFIRM" onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].FRM + `</td>
                        <td class="hideBWPWGROSSAMT" onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(grsAmt) + `</td>
                        <td class="hideBWPWGST" onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(GST) + `</td>
                        <td class="hideBWPWTYPE" onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].SERIES + `</td>
                        <td class="hideBWPWQUAL hqual" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].QUAL) + `</td>
                        <td class="hideBWPWMTS hmts" onclick="openSubR('`+ Data[i].code + `')">` + TMTS + `</td>
                        <td class="hideBWPWFINALAMT" onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(fnlAmt) + `</td>
                        <td class="hideBWPWPAID" onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].paid + `</td>
                        <td class="hideBWPWAGHASTE" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                        <td class="hideBWPWTRANSPORT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].TRNSP) + `</td>
                        <td class="hideBWPWLRNO" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].RRNO) + `</td>
                        <td class="hideBWPWGRADE" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].GRD) + ` </td>
                        <td class="hideBWPWRMK" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].RMK) + ` </td>
                        </tr>`;
                    if (productDet == 'Y') {
                        // console.log(Data[i].billDetails[j].IDE);
                        DETAILSDET = jsgetArrayProductdetailsbyIDE(Data[i].billDetails[j].IDE);
                        // console.log(DETAILSDET);
                        if (DETAILSDET.length > 0) {

                            tr += `

                      <tr>
                          <td><strong></strong></td>
                          <td class="text-center">ITEM</td>
                          <td class="text-center"><strong>PCS</strong></td>
                          <td class="text-center"><strong>PACK</strong></td>
                          <td class="text-center"><strong>UNIT</strong></td>
                          <td class="text-center"><strong>CUT</strong></td>
                          <td class="text-center"><strong>RATE</strong></td>
                          <td class="text-center"><strong>MTS</strong></td>
                          <td class="text-right"><strong>AMT</strong></td>
                      </tr>
                      `;
                            for (m = 0; m < DETAILSDET[0].length; m++) {
                                tr += `<tr class="hideBWPWAbleTr">
                            <td class="text-center"></td>
                            <td class="text-center">`+ DETAILSDET[0][m]['qual'] + `</td>
                            <td class="text-center">`+ Number(DETAILSDET[0][m]['PCS']) + `</td>
                          <td class="text-center">`+ DETAILSDET[0][m]['PCK'] + `</td>
                          <td class="text-center">`+ DETAILSDET[0][m]['UNIT'] + `</td>
                          <td class="text-center">`+ DETAILSDET[0][m]['CUT'] + `</td>
                          <td class="text-center">`+ valuetoFixed(DETAILSDET[0][m]['RATE']) + `</td>
                          <td class="text-center">`+ valuetoFixed(DETAILSDET[0][m]['MTS']) + `</td>
                          <td class="text-center">`+ valuetoFixed(DETAILSDET[0][m]['AMT']) + `</td>
                          </tr>`;

                                if (DETAILSDET[0][m].DET != undefined && DETAILSDET[0][m].DET != null && DETAILSDET[0][m].DET != "") {
                                    tr += `<tr class="hideBWPWAbleTr">
                        <td class="text-center" colspan="9">REMARK : `+ DETAILSDET[0][m]['DET'] + `</td>
                        </tr>`;
                                }
                            }
                        }
                    }
                }
            }
            grandTotalGrossAmt += totalGrossAmt;
            grandTotalfinalAmt += totalFinalAmt;
            grandtotalMTS += totalMTS;
            tr += `<tr class="tfootcard">
        <th class="pdfBtnHide"></th>
        <th class="selectBoxReport" style="display:none;"></th>
                        <th class="hideBWPWDATE" >TOTAL</th>
                        <th class="hideBWPWFIRM" ></th>
                        <th class="hideBWPWGROSSAMT" >(`+ sr + `)<th>
                        <th class="hideBWPWGST" >`+ valuetoFixed(totalGrossAmt) + `</th>
                        <th class="hideBWPWTYPE" ></th>
                        <th class="hideBWPWQUAL hqual" ></th>                        
                        <th class="hideBWPWMTS hmts" >`+ valuetoFixed(totalMTS) + `</th>
                        <th class="hideBWPWFINALAMT" >`+ valuetoFixed(totalFinalAmt) + `</th>
                        <th class="hideBWPWPAID" ></th>
                        <th class="hideBWPWAGHASTE" ></th>
                        <th class="hideBWPWTRANSPORT" ></th>
                        <th class="hideBWPWLRNO" ></th>
                        <th class="hideBWPWGRADE"></th>
                        <th class="hideBWPWRMK"></th>
                        </tr>`;

            totalsr += sr;
        }
        tr += `
                    <tr class="tfootcard">
        <th class="pdfBtnHide"></th>
        <th class="selectBoxReport" style="display:none;"></th>
                    <th class="hideBWPWDATE">GRAND TOTAL</th>
                    <th class="hideBWPWFIRM"></th>
                    <th class="hideBWPWGROSSAMT">(`+ totalsr + `)<th>
                    <th class="hideBWPWGST">`+ valuetoFixed(grandTotalGrossAmt) + `</th>
                    <th class="hideBWPWTYPE"></th>
                    <th class="hideBWPWQUAL hqual"></th>
                    <th class="hideBWPWMTS hmts">`+ valuetoFixed(grandtotalMTS) + `</th>
                    <th class="hideBWPWFINALAMT">`+ valuetoFixed(grandTotalfinalAmt) + `</th>
                    <th class="hideBWPWPAID"></th>
                    <th class="hideBWPWAGHASTE"></th>
                    <th class="hideBWPWTRANSPORT"></th>
                    <th class="hideBWPWLRNO"></th>
                    <th class="hideBWPWGRADE"></th>
                        <th class="hideBWPWRMK"></th>
                        </tr></tbody>`;

        $('#result').html(tr);
        $("#loader").removeClass('has-loader');
        //    if ((url).indexOf('ALLSALE_AJXREPORT') < 0) {
        //      $(".TRNSPT").css("display", "none");
        //    }


        var hideAbleTr = getUrlParams(url, "hideAbleTr");
        if (hideAbleTr == "true") {
            $('.hideAbleTr').css("display", "none");
        }
        if (url.indexOf('PURCHASE_AJXREPORT') < 0) {
            $('.hmts').css("display", "none");
            $('.hqual').css("display", "none");
        }

        var PDFStore = getUrlParams(url, "PDFStore");
        if (PDFStore == "true") {
            alert("PDFStore=true");
        }

        var PDFStorePermission = getUrlParams(url, "PDFStorePermission");
        if (PDFStorePermission == "true") {
            UrlSendToAndroid(Data);
        }
        hideList();
    } else {
        $('#result').html('<h1 align="center">No Data Found</h1>');
        $("#loader").removeClass('has-loader');

    }
    // try { } catch (error) {
    //   alert(error)
    // $('#result').html(tr);
    // $("#loader").removeClass('has-loader');

    // }
}
