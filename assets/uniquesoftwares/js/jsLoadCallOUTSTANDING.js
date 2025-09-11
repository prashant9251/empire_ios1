var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsLoadCallOUTSTANDING_SUMMERY.js');
document.head.appendChild(my_awesome_script);




var smArray = [];

var GRD;
function loadCall(data) {

  var CNOArray = [];
  var flgCno = [];
  try {
    sendShareText = "";
    smArray = [];

    Data = data;

    var ccode;
    var bcode;
    var grandtotalNETBILLAMT;
    var grandtotalGROSSAMT;
    var grandtotalGOODSRETURN;
    var grandtotalPAIDAMT;
    var grandtotalAmount;
    var grandtotalInterestAmt = 0;
    var grandtotalAmtAfterInterest = 0;
    var totalNETBILLAMT;
    var totalGROSSAMT;
    var totalGOODSRETURN;
    var totalPAIDAMT;
    var totalAmount;
    var totalInterestAmt = 0;
    var totalAmtAfterInterest = 0;
    var totalGST;
    var BLL;
    var FdataUrl
    var DL = Data.length;
    if (DL > 0) {
      tr = "";
      grandtotalNETBILLAMT = 0;
      grandtotalGROSSAMT = 0;
      grandtotalGOODSRETURN = 0;
      grandtotalPAIDAMT = 0;
      grandtotalAmount = 0;
      grandtotalInterestAmt = 0;
      grandtotalAmtAfterInterest = 0;
      var row = '';
      for (var i = 0; i < DL; i++) {
        totalNETBILLAMT = 0;
        totalGROSSAMT = 0;
        totalGOODSRETURN = 0;
        totalPAIDAMT = 0;
        totalAmount = 0;
        totalInterestAmt = 0;
        totalAmtAfterInterest = 0;
        totalGST = 0;
        ccode = (Data[i].ccode);
        var pcode = "";
        var city = "";
        var broker = "";
        var label = "";
        var MO = "";
        var EML = "";
        if (ccode.length > 0) {
          pcode = ccode[0].partyname;
          city = ccode[0].city;
          broker = ccode[0].broker;
          label = ccode[0].label;
          MO = ccode[0].MO;
          EML = ccode[0].EML;
        }
        sendShareText += "\n\nDear *" + Data[i].code + "*";
        sendShareText += "\n\nYour bill No. \n";
        row = `<tr class="trPartyHead"onclick="trOnClick('` + Data[i].code + `','` + city + `','` + broker + `');">
                          <th colspan="210" class="trPartyHead">` + label + `<a onclick="dialNo('` + MO + `')"><button> MO:` + getValueNotDefine(MO) + `</button></a></th>
                        </tr>
                        <tr style="font-weight:500;"align="center">                        
                         <th  class="pdfBtnHide">BILL</th>
                         <th  class="selectBoxReport" style="display:none;">
                         SELECT<input type="checkbox" checked onchange="checkAllEntry(this);"/>
                         </th>
                         <th  class="hideBILLNO">BILL NO.</th>
                         <th  class="hideFIRM">FIRM</th>
                         <th  class="hideDATE">BILL&nbsp;DATE</th>
                         <th  class="hideGROSSAMT">GROSS AMT</th>
                         <th  class="hideGST">GST</th>
                         <th  class="hideNETBILLAMT">NET BILL AMT</th>
                         <th  class="hideGOODSRET">GOODS RET.</th>
                         <th  class="hidePAIDAMT">PAID AMT.</th>
                         <th  class="hidePENDAMT">PEND AMT.</th>
                         <th  class="hideDAYS"> DAYS</th>
                         <th  class="hideAGHASTE">AGENT</th>
                         <th  class="hideHASTE" style="display:none;">HASTE</th>
                        <th  class="GRD">GRADE</th>
                        <th  class="hideTDSTCS" style="display:none;">TCS/TDS</th>
                        <th  class="hideTRASNPORT" style="display:none;">TRASNPORT</th>
                        <th  class="hideLRNO" style="display:none;">L.R</th>
                        <th  class="hideL1R" style="display:none;">RMK1</th>
                        <th  class="hideL1P" style="display:none;">DIS1</th>
                        <th  class="hideL1A" style="display:none;">DIS1.AMT.</th>
                        <th  class="hideL2R" style="display:none;">RMK2</th>
                        <th  class="hideL2P" style="display:none;">DIS2</th>
                        <th  class="hideL2A" style="display:none;">DIS2.AMT.</th>
                        <th  class="hideL3R" style="display:none;">RMK3</th>
                        <th  class="hideL3P" style="display:none;">DIS3</th>
                        <th  class="hideL3A" style="display:none;">DIS3.AMT.</th>
                        <th  class="hideRMK" style="display:none;">RMK</th>
                        <th  class="hideBAL" style="display:none;">BAL</th>
                        <th  class="hideVNO" style="display:none;">VNO</th>
                        <th  class="hideINTEREST_RATE" style="display:none;">INTEREST\nRATE</th>
                        <th  class="hideINTEREST_DAYS" style="display:none;">INTEREST\nDAYS</th>
                        <th  class="hideINTEREST_AMT" style="display:none;">INTEREST\nAMT.</th>
                        <th  class="hideAMT_AFTER_INTEREST" style="display:none;">AMT.AFTER\nINTEREST</th>
                          </tr>
                        `;

        BLL = Data[i].billDetails.length;
        if (BLL > 0) {
          var totalEntry = 0;
          var totalDays = 0;
          for (j = 0; j < BLL; j++) {
            totalEntry += 1;
            var Days = parseInt(getDaysDif(Data[i].billDetails[j].DATE, nowDate));
            totalDays += Days;


            var GRSAMT = Data[i].billDetails[j].GRSAMT == null || Data[i].billDetails[j].GRSAMT == "" ? 0 : Data[i].billDetails[j].GRSAMT;
            var GST = Data[i].billDetails[j].GST == null || Data[i].billDetails[j].GST == "" ? 0 : Data[i].billDetails[j].GST;
            // try {
            //   if (Data[i].billDetails[j].DT.trim() != "os") {
            //     GRSAMT = 0;
            //     GST = 0;
            //   }
            // } catch (error) {

            // }

            var FAMT = Data[i].billDetails[j].FAMT == null || Data[i].billDetails[j].FAMT == "" ? 0 : Data[i].billDetails[j].FAMT;
            var CLAIMS = Data[i].billDetails[j].CLAIMS == null || Data[i].billDetails[j].CLAIMS == "" ? 0 : Data[i].billDetails[j].CLAIMS;
            var RECAMT = Data[i].billDetails[j].RECAMT == null || Data[i].billDetails[j].RECAMT == "" ? 0 : Data[i].billDetails[j].RECAMT;
            var PAMT = Data[i].billDetails[j].PAMT == null || Data[i].billDetails[j].RECAMT == "" ? 0 : Data[i].billDetails[j].PAMT;
            totalGROSSAMT += parseFloat(getValueNotDefineNo(GRSAMT));
            totalGST += parseFloat(getValueNotDefineNo(GST));
            totalNETBILLAMT += parseFloat(getValueNotDefineNo(FAMT));
            totalGOODSRETURN += parseFloat(getValueNotDefineNo(CLAIMS));
            totalPAIDAMT += parseFloat(getValueNotDefineNo(RECAMT));
            totalAmount += parseFloat(getValueNotDefineNo(PAMT));
            var UrlPaymentSlip = getUrlPaymentSlip(Data[i].billDetails[j].CNO, (Data[i].billDetails[j].TYPE).replace("ZS", ""), Data[i].billDetails[j].VNO, (Data[i].billDetails[j].IDE).replace("ZS", ""), MO);
            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE, MO, EML);
            var urlopen = '';
            var TYPEforLink = (Data[i].billDetails[j].TYPE).toUpperCase();
            if (TYPEforLink.indexOf('B') > -1 || TYPEforLink.indexOf('XX') > -1) {
              urlopen = UrlPaymentSlip;
            } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
              urlopen = FdataUrl;
            }
            var BrokerHaste = '';
            var HST = Data[i].billDetails[j].HST;
            BrokerHaste = Data[i].billDetails[j].BCODE;
            bcode = Data[i].billDetails[j].BCODE;
            var ID = Data[i].billDetails[j].CNO + Data[i].billDetails[j].TYPE + Data[i].billDetails[j].VNO;
            var color = daysWiseColoring == "Y" ? colorByDaysFormate(Days) : "";
            if (Data[i].billDetails[j].DT.toUpperCase().indexOf("OS") > -1) {
              sendShareText += `` + getValueNotDefine(Data[i].billDetails[j].BILL) + `   ` + formatDate(Data[i].billDetails[j].DATE) + ` = *` + getValueNotDefine(Data[i].billDetails[j].PAMT) + "/-* Days " + Days + `\n`;
            }
            if (!flgCno[Data[i].billDetails[j].CNO]) {
              CNOArray.push(Data[i].billDetails[j].CNO);
              flgCno[Data[i].billDetails[j].CNO] = true;
            }
            var paymentDateDays = getDaysDif(Data[i].billDetails[j].DATE, Date.parse(PaymentDate));
            var tillTodaysDay = paymentDateDays + 1;
            var interestDays = tillTodaysDay - graceDays;
            var interestAmt = PAMT * parseInt(interestDays) / daysInYear * interestRate / 100;
            if (boolInterestCalculate != true) {
              interestRate = 0;
              tillTodaysDay = 0;
              interestDays = 0;
              interestAmt = 0;
            }
            totalInterestAmt += parseFloat(interestAmt);
            var amtAfterInterest = parseFloat(PAMT) + parseFloat(interestAmt);
            totalAmtAfterInterest += parseFloat(amtAfterInterest);
            row += ` 
                              
                                <tr align="center"style="`+ color + `">
                                <td class="pdfBtnHide"><a href="`+ urlopen + `" target="_blank"><button>PDF</button></a></td>
                                <td  class="selectBoxReport" style="display:none;">
                                <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + Data[i].billDetails[j].CNO + `"DTYPE="` + Data[i].billDetails[j].TYPE + `"VNO="` + Data[i].billDetails[j].VNO + `"/>
                                </td>
                                <td  class="hideBILLNO"><a target="_blank" href="` + urlopen + `"><button>` + getValueNotDefine(Data[i].billDetails[j].BILL) + `</button></a></td>
                                <td  class="hideFIRM" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].FRM) + `</td>
                                <td  class="hideDATE" onclick="openSubR('`+ Data[i].code + `')">` + formatDate(Data[i].billDetails[j].DATE) + `</td>
                                <td  class="hideGROSSAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(GRSAMT) + `</td>
                                <td  class="hideGST" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(GST) + `</td>
                                <td  class="hideNETBILLAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(FAMT) + `</td>
                                <td  class="hideGOODSRET" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(CLAIMS) + `</td>
                                <td  class="hidePAIDAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(RECAMT) + `</td>
                                <td  class="hidePENDAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(PAMT) + `</td>
                                <td  class="hideDAYS" onclick="openSubR('`+ Data[i].code + `')">` + Days + ` </td>
                                <td  class="hideAGHASTE" onclick="openBrokerSupR('`+ BrokerHaste + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                                <td  class="hideHASTE" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].HST) + ` </td>
                                <td  onclick="openSubR('`+ Data[i].code + `')"class="GRD">` + getValueNotDefine(Data[i].billDetails[j].GRD) + ` </th>                                d 
                                <td  class="hideTDSTCS" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].T) + `</td>
                                <td  class="hideTRASNPORT" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].TR) + `</td>
                                <td  class="hideLRNO" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].RR) + `</td>
                                <td  class="hideL1R" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].L1R) + `</td>
                                <td  class="hideL1P" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].L1P) + `%</td>
                                <td  class="hideL1A" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + parseFloat(Data[i].billDetails[j].L1A).toFixed(2) + `%</td>
                                <td  class="hideL2R" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].L2R) + `</td>
                                <td  class="hideL2P" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].L2P) + `%</td>
                                <td  class="hideL2A" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + parseFloat(Data[i].billDetails[j].L2A).toFixed(2) + `%</td>
                                <td  class="hideL3R" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].L3R) + `</td>
                                <td  class="hideL3P" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].L3P) + `%</td>
                                <td  class="hideL3A" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + parseFloat(Data[i].billDetails[j].L3A).toFixed(2) + `%</td>
                                <td  class="hideRMK" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].R1) + `</td>
                                <td  class="hideBAL" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + valuetoFixed(totalAmount) + `</td>
                                <td  class="hideVNO" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(Data[i].billDetails[j].VNO) + `</td>
                                <td  class="hideINTEREST_RATE" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + interestRate + `</td>
                                <td  class="hideINTEREST_DAYS" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + interestDays + `</td>
                                <td  class="hideINTEREST_AMT" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + parseFloat(interestAmt).toFixed(2) + `</td>
                                <td  class="hideAMT_AFTER_INTEREST" style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + parseFloat(amtAfterInterest).toFixed(2) + `</td>
                                </tr>`;

            if (productDet == 'Y') {
              var DETAILSDET = jsgetArrayProductdetailsbyIDE(Data[i].billDetails[j].IDE);
              row += DETAILSDET;
            }
          }
          grandtotalNETBILLAMT += totalNETBILLAMT;
          grandtotalGROSSAMT += totalGROSSAMT;
          grandtotalGOODSRETURN += totalGOODSRETURN;
          grandtotalPAIDAMT += totalPAIDAMT;
          grandtotalAmount += totalAmount;
          grandtotalInterestAmt += totalInterestAmt;
          grandtotalAmtAfterInterest += totalAmtAfterInterest;

          var avgDays = totalDays / totalEntry;


          sendShareText += "\n is PENDING \n Total of Amount: *" + totalAmount + "/-*";
          row += `<tr class="tfootcard">
                                <th  class="pdfBtnHide"></th>
                                <th  class="selectBoxReport" style="display:none;"></th>
                                <th  class="hideBILLNO"> TOTAL</th>
                                <th  class="hideFIRM"></th>
                                <th  class="hideDATE"></th>
                                <th  class="hideGROSSAMT">` + parseFloat(totalGROSSAMT).toFixed(2) + `</th>
                                <th  class="hideGST">`+ parseFloat(totalGST).toFixed(2) + `</th>
                                <th  class="hideNETBILLAMT">` + parseFloat(totalNETBILLAMT).toFixed(2) + `</th>
                                <th  class="hideGOODSRET">` + parseFloat(totalGOODSRETURN).toFixed(2) + `</th>
                                <th  class="hidePAIDAMT">` + parseFloat(totalPAIDAMT).toFixed(2) + `</th>
                                <th  class="hidePENDAMT">` + parseFloat(totalAmount).toFixed(2) + `</th>
                                <th   class="hideDAYS"><b class="hideAvgDays">`+ parseInt(avgDays) + `</b></th>
                                <th   class="hideAGHASTE"></th>
                                <th   class="hideHASTE" style="display:none;"></th>
                                <th  class="GRD"></th>
                                <th  class="hideTDSTCS" style="display:none;"></th>
                                <th  class="hideTRASNPORT" style="display:none;"></th>
                                <th  class="hideLRNO" style="display:none;"></th>
                                <th  class="hideL1R" style="display:none;"></th>
                                <th  class="hideL1P" style="display:none;"></th>
                                <th  class="hideL1A" style="display:none;"></th>
                                <th  class="hideL2R" style="display:none;"></th>
                                <th  class="hideL2P" style="display:none;"></th>
                                <th  class="hideL2A" style="display:none;"></th>
                                <th  class="hideL3R" style="display:none;"></th>
                                <th  class="hideL3P" style="display:none;"></th>
                                <th  class="hideL3A" style="display:none;"></th>
                                <th  class="hideRMK" style="display:none;"></th>
                                <th  class="hideBAL" style="display:none;">`+ parseFloat(totalAmount).toFixed(2) + `</th>
                                <th  class="hideVNO" style="display:none;"></th>
                                <th  class="hideINTEREST_RATE" style="display:none;"></th>
                                <th  class="hideINTEREST_DAYS" style="display:none;"></th>
                                <th  class="hideINTEREST_AMT" style="display:none;">`+ parseFloat(totalInterestAmt).toFixed(2) + `</th>
                                <th  class="hideAMT_AFTER_INTEREST" style="display:none;">` + parseFloat(totalAmtAfterInterest).toFixed(2) + `</th>
                                </tr>`;

        }

        if (totalAmount == 0) {

          row = "";
        } else {
          obj = {};

          obj.ccode = ccode;
          obj.bcode = bcode;
          obj.label = label;
          obj.code = Data[i].code;
          obj.ATYPE_NAME = Data[i].ATYPE_NAME;
          obj.totalGROSSAMT = totalGROSSAMT;
          obj.totalGST = totalGST;
          obj.totalNETBILLAMT = totalNETBILLAMT;
          obj.totalGOODSRETURN = totalGOODSRETURN;
          obj.totalPAIDAMT = totalPAIDAMT;
          obj.totalAmount = totalAmount;
          smArray.push(obj);
        }

        tr += row;
      }
      tr += `<tr class="tfootcard">
    <th  class="pdfBtnHide"></th>
    <th  class="selectBoxReport" style="display:none;"></th>
    <th  class="hideBILLNO">GRAND TOTAL</th>
    <th  class="hideFIRM"></th>
    <th  class="hideDATE"></th>
    <th  class="hideGROSSAMT">` + parseFloat(grandtotalGROSSAMT).toFixed(2) + `</th>
    <th  class="hideGST"></th>
    <th  class="hideNETBILLAMT">` + parseFloat(grandtotalNETBILLAMT).toFixed(2) + `</th>
    <th  class="hideGOODSRET">` + parseFloat(grandtotalGOODSRETURN).toFixed(2) + `</th>
    <th  class="hidePAIDAMT">` + parseFloat(grandtotalPAIDAMT).toFixed(2) + `</th>
    <th  class="hidePENDAMT">` + parseFloat(grandtotalAmount).toFixed(2) + `</th>
    <th  class="hideDAYS"></th>
    <th  class="hideAGHASTE"></th>
    <th  class="hideHASTE" style="display:none;"></th>
    <th  class="GRD"></th>
    <th  class="hideTDSTCS" style="display:none;"></th>
    <th  class="hideTRASNPORT" style="display:none;"></th>
    <th  class="hideLRNO" style="display:none;"></th>
    <th  class="hideL1R" style="display:none;"></th>
    <th  class="hideL1P" style="display:none;"></th>
    <th  class="hideL1A" style="display:none;"></th>
    <th  class="hideL2R" style="display:none;"></th>
    <th  class="hideL2P" style="display:none;"></th>
    <th  class="hideL2A" style="display:none;"></th>
    <th  class="hideL3R" style="display:none;"></th>
    <th  class="hideL3P" style="display:none;"></th>
    <th  class="hideL3A" style="display:none;"></th>
    <th  class="hideRMK" style="display:none;"></th>
    <th  class="hideBAL" style="display:none;">`+ parseFloat(grandtotalAmount).toFixed(2) + `</th>
    <th  class="hideVNO" style="display:none;"></th>
    <th  class="hideINTEREST_RATE" style="display:none;"></th>
    <th  class="hideINTEREST_DAYS" style="display:none;"></th>
    <th  class="hideINTEREST_AMT" style="display:none;">`+ parseFloat(grandtotalInterestAmt).toFixed(2) + `</th>
    <th  class="hideAMT_AFTER_INTEREST" style="display:none;">` + parseFloat(grandtotalAmtAfterInterest).toFixed(2) + `</th>
    </tr>`;

      var hideAbleTr = getUrlParams(url, "hideAbleTr");
      if (hideAbleTr == "true") {
        createOUTSTANDINGSummeryReport();
      } else {
        $('#result').html(tr);
        $("#loader").removeClass('has-loader');
      }
      if (GRD == '' || GRD == null) {
        $('.GRD').css("display", "none");
      }


      hideList().then(function () {



        var PDFStore = getUrlParams(url, "PDFStore");
        if (PDFStore == "true") {
          directPdfCreateOnLoad();
        }

        var PDFStorePermission = getUrlParams(url, "PDFStorePermission");
        if (PDFStorePermission == "true") {
          UrlSendToAndroid(Data);
        }
        // alert(sendShareText)
        BuildAccountdetaisl(CNOArray);
        sendShareText += "\n\nBank Details";
        sendShareText += sendShareTextBankDetail;
        // sendShareText += `\n\n From *` + SHOPNAME.toUpperCase() + `*\n\n\n\n`;
        sendShareTextToApp(encodeURIComponent(sendShareText), "");
        // Forcefully apply column visibility after loading all HTML
        if (boolInterestCalculate == true) {
          $(".hideGST").css("display", "none");
          $(".hideGOODSRET").css("display", "none");
          $(".hidePAIDAMT").css("display", "none");
          $(".hideHASTE").css("display", "none");
          $(".hideGROSSAMT").css("display", "none");
          $(".hideINTEREST_RATE").css("display", "");
          $(".hideINTEREST_DAYS").css("display", "");
          $(".hideINTEREST_AMT").css("display", "");
          $(".hideAMT_AFTER_INTEREST").css("display", "");
          Reportname = "SALE OUTSTANDING INTEREST REPORT";
          document.title = Reportname;
          $('#ReportType').html("<h6 style='text-decoration: underline;'><b>" + Reportname + "</b></h6><h6 id='head1'></h6>")
        }
      });
    } else {
      $('#result').html('<h1 align="center">No Data Found</h1>');
      $("#loader").removeClass('has-loader');

    }
  } catch (e) {
    noteError(e);
  }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

