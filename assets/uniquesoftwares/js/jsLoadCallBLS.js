var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsLoadCallBLS_SUMMERY.js');
document.head.appendChild(my_awesome_script);


var GRD;
var groupname;
var url = window.location.href;
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);
var hideAbleTr = getUrlParams(url, "hideAbleTr");
var smArray = [];


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
  smArray = [];
  // console.log("grd", Data);
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
  var grandtotalParcel;

  var totalGrossAmt;
  var totalFinalAmt;
  var DL = Data.length;
  var BLL;
  var totalsr = 0;
  if (DL > 0) {
    grandTotalGrossAmt = 0;
    grandTotalfinalAmt = 0;
    grandtotalMTS = 0;
    grandtotalParcel = 0;
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
                          <th  class="trPartyHead" colspan="15">` + label + `</th>                                    
                        </tr>`;
      tr += `<tr style="font-weight:500;"align="center">
                    
                        <th class="pdfBtnHide">PDF</th>
                        <td class="selectBoxReport" style="display:none;">
                         SELECT<input type="checkbox" checked onchange="checkAllEntry(this);"/>
                         </td>
                        <th>BILL</th>
                        <th class="hideBWPWDATE">BILL&nbsp;DATE</th>
                        <th class="hideBWPWFIRM">FIRM</th>
                        <th class="hideBWPWGROSSAMT">GROSS.AMT</th>
                        <th class="hideBWPWGST">GST</th>
                        <th class="hideBWPWTYPE">TYPE</th>
                        <th class="hideBWPWQUAL hqual">QUAL</th>
                        <th class="hideBWPWRATE" style="display:none;">RATE</th>
                        <th class="hideBWPWMTS" style="display:none;">MTS</th>
                        <th class="hideBWPWPARCEL" style="display:none;">PARCEL</th>
                        <th class="hideBWPWFINALAMT">BILL AMT</th>
                        <th class="hideBWPWPAID">PAID</th>
                        <th class="hideBWPWAGHASTE">AG./HASTE</th>
                        <th class="hideBWPWTRANSPORT">TRANSPORT</th>
                        <th class="hideBWPWLRNO">LR NO</th>
                        <th class="hideBWPWDAYS"style="display:none;" >DAYS</th>
                        <th class="hideBWPWGRADE" style="display:none;">GRADE</th>
                        <th class="hideBWPWRMK" style="display:none;">RMK</th>
                        <th class="hideBWPWEWB" style="display:none;">EWB</th>
                        <th class="hideBWPWPAYMENTDATE" style="display:none;">PAYMENT DATE</th>
                        <th class="hideBWPWPAYMENTDAYS" style="display:none;">PAYMENT DAYS</th>
                        </tr>`;
      BLL = Data[i].billDetails.length;
      var totalEntry = 0;
      var totalPaymentDays = 0;
      var totalPaymentEntry = 0;
      if (BLL > 0) {

        totalGrossAmt = 0;
        totalFinalAmt = 0;
        totalMTS = 0;
        totalParcel = 0;
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
          const PARCEL = Data[i].billDetails[j].PRCL;
          totalParcel += parseInt(PARCEL);
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
          var paymentDate = Data[i].billDetails[j].PAYDET;
          var paymentInDays = "";
          if (paymentDate != null && paymentDate != undefined && paymentDate != '') {
            paymentInDays = getDaysDif(paymentDate, nowDate);
            paymentDate = formatDate(paymentDate);
            totalPaymentEntry += 1;
          }
          totalEntry += 1;
          totalPaymentDays += paymentInDays;
          tr += `<tr align="center"class="hideAbleTr">
                        <th class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                        <td class="selectBoxReport" style="display:none;">      <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + Data[i].billDetails[j].CNO + `"DTYPE="` + Data[i].billDetails[j].TYPE + `"VNO="` + Data[i].billDetails[j].VNO + `"/></td>
                        <td><a href="`+ FdataUrl + `" target="_blank"><button>` + Data[i].billDetails[j].BILL + `</button><a></td>
                        <td class="hideBWPWDATE" onclick="openSubR('`+ Data[i].code + `')">` + formatDate(Data[i].billDetails[j].DATE) + `</td>
                        <td class="hideBWPWFIRM" onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].FRM + `</td>
                        <td class="hideBWPWGROSSAMT" onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(grsAmt) + `</td>
                        <td class="hideBWPWGST" onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(GST) + `</td>
                        <td class="hideBWPWTYPE" onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].SERIES + `</td>
                        <td class="hideBWPWQUAL hqual" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].QUAL) + `</td>
                        <td class="hideBWPWRATE" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].GRT) + `</td>
                        <td class="hideBWPWMTS" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + TMTS + `</td>
                        <td class="hideBWPWPARCEL"style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + (PARCEL) + `</td>
                        <td class="hideBWPWFINALAMT" onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(fnlAmt) + `</td>
                        <td class="hideBWPWPAID" onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].paid + `</td>
                        <td class="hideBWPWAGHASTE" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                        <td class="hideBWPWTRANSPORT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].TRNSP) + `</td>
                        <td class="hideBWPWLRNO" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].RRNO) + `</td>
                        <td class="hideBWPWDAYS"style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + getDaysDif(Data[i].billDetails[j].DATE, nowDate) + `</td>
                        <td class="hideBWPWGRADE" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].GRD) + ` </td>
                        <td class="hideBWPWRMK" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].RMK) + ` </td>
                        <td class="hideBWPWEWB" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].EWB) + ` </td>
                        <td class="hideBWPWPAYMENTDAYS" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + paymentDate + ` </td>
                        <td class="hideBWPWPAYMENTDATE" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + paymentInDays + ` </td>
                        </tr>`;


          if (productDet == 'Y') {
            // console.log(Data[i].billDetails[j].IDE);
            tr += jsgetArrayProductdetailsbyIDE(Data[i].billDetails[j].IDE);

          }
        }
      }
      grandTotalGrossAmt += totalGrossAmt;
      grandTotalfinalAmt += totalFinalAmt;
      grandtotalMTS += totalMTS;
      grandtotalParcel += totalParcel;
      obj = {};
      obj.label = label;
      obj.code = Data[i].code;
      obj.sr = sr;
      obj.totalMTS = totalMTS;
      obj.totalFinalAmt = totalFinalAmt;
      smArray.push(obj);
      var avgDays = totalPaymentDays / totalPaymentEntry;

      tr += `<tr class="tfootcard">
        <th class="pdfBtnHide"></th>
        <th class="selectBoxReport" style="display:none;"></th>
                      <th></th>
                      <th class="hideBWPWDATE" >TOTAL</th>
                        <th class="hideBWPWFIRM" >(`+ sr + `)</th>
                        <th class="hideBWPWGROSSAMT">`+ valuetoFixed(totalGrossAmt) + `</th>
                        <th class="hideBWPWGST" ></th>
                        <th class="hideBWPWTYPE"></th>
                        <th class="hideBWPWQUAL hqual" ></th>                        
                        <th class="hideBWPWRATE" style="display:none;" ></th>                        
                        <th class="hideBWPWMTS" style="display:none;" >`+ valuetoFixed(totalMTS) + `</th>
                        <th class="hideBWPWPARCEL" style="display:none;" >`+ totalParcel + `</th>
                        <th class="hideBWPWFINALAMT" >`+ valuetoFixed(totalFinalAmt) + `</th>
                        <th class="hideBWPWPAID" ></th>
                        <th class="hideBWPWAGHASTE" ></th>
                        <th class="hideBWPWTRANSPORT" ></th>
                        <th class="hideBWPWLRNO" ></th>
                        <th class="hideBWPWDAYS"style="display:none;" ></th>
                        <th class="hideBWPWGRADE" style="display:none;"></th>
                        <th class="hideBWPWRMK" style="display:none;"></th>
                        <th class="hideBWPWEWB" style="display:none;"></th>
                        <th class="hideBWPWPAYMENTDATE" style="display:none;"></th>
                        <th class="hideBWPWPAYMENTDAYS " style="display:none;text-align:center;"> `+ parseInt(avgDays) + `</th>
                        </tr>`;

      totalsr += sr;
    }
    tr += `
                    <tr class="tfootcard">
        <th class="pdfBtnHide"></th>
        <th class="selectBoxReport" style="display:none;"></th>
                      <th></th>
                      <th class="hideBWPWDATE">GRAND TOTAL</th>
                    <th class="hideBWPWFIRM">(`+ totalsr + `)</th>
                    <th class="hideBWPWGROSSAMT">`+ valuetoFixed(grandTotalGrossAmt) + `</th>
                    <th class="hideBWPWGST"></th>
                    <th class="hideBWPWTYPE"></th>
                    <th class="hideBWPWQUAL hqual"></th>
                    <th class="hideBWPWRATE" style="display:none;" ></th>                        
                    <th class="hideBWPWMTS" style="display:none;">`+ valuetoFixed(grandtotalMTS) + `</th>
                    <th class="hideBWPWPARCEL" style="display:none;">`+ grandtotalParcel + `</th>
                    <th class="hideBWPWFINALAMT">`+ valuetoFixed(grandTotalfinalAmt) + `</th>
                    <th class="hideBWPWPAID"></th>
                    <th class="hideBWPWAGHASTE"></th>
                    <th class="hideBWPWTRANSPORT"></th>
                    <th class="hideBWPWLRNO"></th>
                    <th class="hideBWPWDAYS"style="display:none;"></th>
                    <th class="hideBWPWGRADE" style="display:none;"></th>
                    <th class="hideBWPWRMK" style="display:none;"></th>
                    <th class="hideBWPWEWB" style="display:none;"></th>
                    <th class="hideBWPWPAYMENTDATE" style="display:none;"></th>
                    <th class="hideBWPWPAYMENTDAYS" style="display:none;"></th>
                        </tr></tbody>`;

    var hideAbleTr = getUrlParams(url, "hideAbleTr");
    if (hideAbleTr == "true") {
      createBLSSummeryReport();
    } else {
      $('#result').html(tr);
      $("#loader").removeClass('has-loader');
    }
    //    if ((url).indexOf('ALLSALE_AJXREPORT') < 0) {
    //      $(".TRNSPT").css("display", "none");
    //    }


    if (url.indexOf('PURCHASE_AJXREPORT') < 0) {
      $('').css("display", "none");
      $('.hqual').css("display", "none");
    }

    hideList();
    var PDFStore = getUrlParams(url, "PDFStore");
    if (PDFStore == "true") {
      directPdfCreateOnLoad();
    }

    var PDFStorePermission = getUrlParams(url, "PDFStorePermission");
    if (PDFStorePermission == "true") {
      UrlSendToAndroid(Data);
    }

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







