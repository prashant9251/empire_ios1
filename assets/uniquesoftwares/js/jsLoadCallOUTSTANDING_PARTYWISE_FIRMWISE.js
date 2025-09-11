
function filterBy(oncode, CNO) {
  return BLLDATA.filter(function (d) {
    return d[oncode] == CNO;
  });
}

//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
var GRD;
function jsLoadCallOUTSTANDING_PARTYWISE_FIRMWISE(data) {
  tr = '';
  try {
    Data = data;
    var ccode;
    var pcode;
    var city;
    var broker;
    var label;
    var grandtotalNETBILLAMT;
    var grandtotalGROSSAMT;
    var grandtotalGOODSRETURN;
    var grandtotalPAIDAMT;
    var grandtotalAmount;
    var totalNETBILLAMT;
    var totalGROSSAMT;
    var totalGOODSRETURN;
    var totalPAIDAMT;
    var totalAmount;
    var BLL;
    var FdataUrl
    var DL = Data.length;
    if (DL > 0) {

      grandtotalNETBILLAMT = 0;
      grandtotalGROSSAMT = 0;
      grandtotalGOODSRETURN = 0;
      grandtotalPAIDAMT = 0;
      grandtotalAmount = 0;
      var CNOArray = [];
      var flgCno = [];
      var row;
      for (var i = 0; i < DL; i++) {
        ccode = getPartyDetailsBySendCode(Data[i].code);
        pcode = ccode[0].partyname;
        city = ccode[0].city;
        broker = ccode[0].broker;
        label = ccode[0].label;

        row = `<tr class="trPartyHead"onclick="trOnClick('` + Data[i].code + `','` + city + `','` + broker + `');">
                          <th colspan="22" class="trPartyHead">` + label + `<a href="tel:` + ccode[0].MO + `"><button>MO:` + getValueNotDefine(ccode[0].MO) + `</button></a></th>
                        </tr>
                       
                        `;

        BLL = Data[i].billDetails.length;
        if (BLL > 0) {
          BLLDATA = Data[i].billDetails;
          BLLDATA = BLLDATA.sort(function (a, b) {
            return a.CNO - b.CNO;
          });

          var DtArray = [];
          for (j = 0; j < BLLDATA.length; j++) {
            if (DtArray.indexOf(BLLDATA[j].CNO) < 0) {
              DtArray.push(BLLDATA[j].CNO);
            }
          }
          var DtArrayLength = DtArray.length;
          totalNETBILLAMT = 0;
          totalGROSSAMT = 0;
          totalGOODSRETURN = 0;
          totalPAIDAMT = 0;
          totalAmount = 0;
          for (var l = 0; l < DtArray.length; l++) {
            subtotalNETBILLAMT = 0;
            subtotalGROSSAMT = 0;
            subtotalGOODSRETURN = 0;
            subtotalPAIDAMT = 0;
            subtotalAmount = 0;
            FIRM_Array = getFirmDetailsBySendCode(DtArray[l]);

            // Distinct FIRM  SELECTION
            FIRM_NAME = FIRM_Array[0].FIRM
            if (!flgCno[DtArray[l]]) {
              CNOArray.push(DtArray[l]);
              flgCno[DtArray[l]] = true;
            }
            row += ` 
              <tr style="font-weight:500;"align="center">                        
              <td colspan="17" align="left"><b style="color:#c107a2;font-size: 18px;"
               onclick="openSubRByPartyAndFirm('` + Data[i].code + `','` + FIRM_NAME + `')" >` + FIRM_NAME + `</b></td>
                </tr>
                <tr style="font-weight:700;"align="center">     
                <td class="selectBoxReport" style="display:none;">
                SELECT<input type="checkbox" checked onchange="checkAllEntry(this);"/>
                </td>                   
                <td class="pdfBtnHide">BILL</td>
                <td>BILL NO.</td>
                <td class="hidePWFWFIRM">FIRM</td>
                <td class="hidePWFWBILLDATE">BILL&nbsp;DATE</td>
                <td class="hidePWFWGROSSAMT">GROSS AMT</td>
                <td class="hidePWFWNETBILLAMT">NET BILL AMT</td>
                <td class="hidePWFWGOODSRET.">GOODS RET.</td>
                <td class="hidePWFWPAIDAMT">PAID AMT.</td>
                <td class="hidePWFWPENDAMT">PEND AMT.</td>
                <td class="hidePWFWDAYS">DAYS</td>
                <td class="hidePWFWAGHASTE">AG./HASTE</td>
                <td class="GRD">GRADE</td>
                <td class="hidePWFWTDSTCS" style="display:none;">TCS/TDS</td>
                <td class="hidePWFWTRASNPORT" style="display:none;">TRASNPORT</td>
                <td class="hidePWFWLR" style="display:none;">LR</td>
                <td class="hidePWFWL1R" style="display:none;">RMK1</td>
                <td class="hidePWFWL1P" style="display:none;">DIS1</td>
                <td class="hidePWFWL2R" style="display:none;">RMK2</td>
                <td class="hidePWFWL2P" style="display:none;">DIS2</td>
                <td class="hidePWFWL3R" style="display:none;">RMK3</td>
                <td class="hidePWFWL3P" style="display:none;">DIS3</td>
                <td class="hidePWFWRMK" style="display:none;">RMK</td>
                <td class="hidePWFWBAL" style="display:none;">BAL</td>
                <td class="hidePWFWVNO" style="display:none;">VNO</td>
                  </tr>`;

            var WiseBills = filterBy("CNO", DtArray[l]);
            for (j = 0; j < WiseBills.length; j++) {
              var GRSAMT = WiseBills[j].GRSAMT == null ? 0 : WiseBills[j].GRSAMT;
              var GST = Data[i].billDetails[j].GST == null ? 0 : Data[i].billDetails[j].GST;
              // try {
              //   if (WiseBills[j].DT.trim() != "os") {
              //     GRSAMT = 0;
              //     GST = 0;
              //   }
              // } catch (error) {

              // }
              var GST = WiseBills[j].GST == null ? 0 : WiseBills[j].GST;
              var FAMT = WiseBills[j].FAMT == null ? 0 : WiseBills[j].FAMT;
              var CLAIMS = WiseBills[j].CLAIMS == null ? 0 : WiseBills[j].CLAIMS;
              var RECAMT = WiseBills[j].RECAMT == null ? 0 : WiseBills[j].RECAMT;
              var PAMT = WiseBills[j].PAMT == null ? 0 : WiseBills[j].PAMT;

              subtotalGROSSAMT += parseFloat(GRSAMT);
              subtotalNETBILLAMT += parseFloat(FAMT);
              subtotalGOODSRETURN += parseFloat(CLAIMS);
              subtotalPAIDAMT += parseFloat(RECAMT);
              subtotalAmount += parseFloat(PAMT);
              var UrlPaymentSlip = getUrlPaymentSlip(WiseBills[j].CNO, (WiseBills[j].TYPE).replace("ZS", ""), WiseBills[j].VNO, (WiseBills[j].IDE).replace("ZS", ""));
              FdataUrl = getFullDataLinkByCnoTypeVnoFirm(WiseBills[j].CNO, WiseBills[j].TYPE, WiseBills[j].VNO, getFirmDetailsBySendCode(WiseBills[j].CNO)[0].FIRM, WiseBills[j].IDE, ccode[0].MO);
              var urlopen = '';
              var TYPEforLink = (WiseBills[j].TYPE).toUpperCase();
              if (TYPEforLink.indexOf('B') > -1) {

                urlopen = UrlPaymentSlip;
              } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
                urlopen = FdataUrl;
              }
              var BrokerHaste = '';
              var HST = WiseBills[j].HST;

              BrokerHaste = WiseBills[j].BCODE;

              var ID = WiseBills[j].CNO + WiseBills[j].TYPE + WiseBills[j].VNO;
              var Days = parseInt(getDaysDif(WiseBills[j].DATE, nowDate));
              var color = daysWiseColoring == "Y" ? colorByDaysFormate(Days) : "";

              row += ` 
                              
                                <tr class="hideAbleTr"align="center"style="`+ color + `">
                                <th   class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                                <td class="selectBoxReport" style="display:none;">
                                <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + WiseBills[j].CNO + `"DTYPE="` + WiseBills[j].TYPE + `"VNO="` + WiseBills[j].VNO + `"/></td>                               
                                <td><a target="_blank" href="` + FdataUrl + `"><button>` + getValueNotDefine(WiseBills[j].BILL) + `</button></a></td>
                                    <td class="hidePWFWFIRM" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(WiseBills[j].FRM) + `</td>
                                    <td class="hidePWFWBILLDATE" onclick="openSubR('`+ Data[i].code + `')">` + formatDate(WiseBills[j].DATE) + `</td>
                                    <td class="hidePWFWGROSSAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(GRSAMT) + `</td>
                                    <td class="hidePWFWNETBILLAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(FAMT) + `</td>
                                    <td class="hidePWFWGOODSRET." onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(CLAIMS) + `</td>
                                    <td class="hidePWFWPAIDAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(RECAMT) + `</td>
                                    <td class="hidePWFWPENDAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(PAMT) + `</td>
                                    <td class="hidePWFWDAYS" onclick="openSubR('`+ Data[i].code + `')">` + Days + ` </td>
                                    <td class="hidePWFWAGHASTE" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                                    <td onclick="openSubR('`+ Data[i].code + `')"class="GRD">` + getValueNotDefine(WiseBills[j].GRD) + ` </td>
                                    <td class="hidePWFWTDSTCS" style="display:none;">` + getValueNotDefine(WiseBills[j].T) + `</td>
                                    <td class="hidePWFWTRASNPORT" style="display:none;">` + getValueNotDefine(WiseBills[j].TR) + `</td>
                                    <td class="hidePWFWLR" style="display:none;">` + getValueNotDefine(WiseBills[j].RR) + `</td>
                                    <td class="hidePWFWL1R" style="display:none;">` + getValueNotDefine(WiseBills[j].L1R) + `</td>
                                    <td class="hidePWFWL1P" style="display:none;">` + getValueNotDefine(WiseBills[j].L1P) + `%</td>
                                    <td class="hidePWFWL2R" style="display:none;">` + getValueNotDefine(WiseBills[j].L2R) + `</td>
                                    <td class="hidePWFWL2P" style="display:none;">` + getValueNotDefine(WiseBills[j].L2P) + `%</td>
                                    <td class="hidePWFWL3R" style="display:none;">` + getValueNotDefine(WiseBills[j].L3R) + `</td>
                                    <td class="hidePWFWL3P" style="display:none;">` + getValueNotDefine(WiseBills[j].L3P) + `%</td>
                                    <td class="hidePWFWRMK" style="display:none;">` + getValueNotDefine(WiseBills[j].R1) + `</td>
                                    <td class="hidePWFWBAL" style="display:none;">`+ valuetoFixed(totalAmount) + `</td>
                                    <td class="hidePWFWVNO" style="display:none;">`+ getValueNotDefine(WiseBills[j].VNO) + `</td>
                                </tr>`;
              if (productDet == 'Y') {
                DETAILSDET = jsgetArrayProductdetailsbyIDE(WiseBills[j].IDE);
                if (DETAILSDET.length > 0) {
                  // var row='';
                  row += `
                                    
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
                    row += `<tr class="hideAbleTr">
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
                      row += `<tr class="hideAbleTr">
                                                            <td class="text-center" colspan="9">REMARK : `+ DETAILSDET[0][m]['DET'] + `</td>
                                                            </tr>`;
                    }
                  }
                }
              }

            }

            totalGROSSAMT += subtotalGROSSAMT;
            totalNETBILLAMT += subtotalNETBILLAMT;
            totalGOODSRETURN += subtotalGOODSRETURN;
            totalPAIDAMT += subtotalPAIDAMT;
            totalAmount += subtotalAmount;

            row += `<tr class="tfootcard">
                                  <td class="pdfBtnHide"></td>
                                  <td >SUB TOTAL</td>
                                  <td class="hidePWFWFIRM"></td>
                                  <td class="hidePWFWBILLDATE"></td>
                                  <td class="hidePWFWGROSSAMT">` + valuetoFixed(subtotalGROSSAMT) + `</td>
                                  <td class="hidePWFWNETBILLAMT">` + valuetoFixed(subtotalNETBILLAMT) + `</td>
                                  <td class="hidePWFWGOODSRET.">` + valuetoFixed(subtotalGOODSRETURN) + `</td>
                                  <td class="hidePWFWPAIDAMT">` + valuetoFixed(subtotalPAIDAMT) + `</td>
                                  <td class="hidePWFWPENDAMT">` + valuetoFixed(subtotalAmount) + `</td>
                                  <td class="hidePWFWDAYS" ></td>
                                  <td class="hidePWFWAGHASTE" ></td>
                                  <td class="GRD"></td>
                                  <td class="hidePWFWTDSTCS" style="display:none;"></td>
                                  <td class="hidePWFWTRASNPORT" style="display:none;"></td>
                                  <td class="hidePWFWLR" style="display:none;"></td>
                                  <td class="hidePWFWL1R" style="display:none;"></td>
                                  <td class="hidePWFWL1P" style="display:none;"></td>
                                  <td class="hidePWFWL2R" style="display:none;"></td>
                                  <td class="hidePWFWL2P" style="display:none;"></td>
                                  <td class="hidePWFWL3R" style="display:none;"></td>
                                  <td class="hidePWFWL3P" style="display:none;"></td>
                                  <td class="hidePWFWRMK" style="display:none;"></td>
                                  <td class="hidePWFWBAL" style="display:none;">`+ valuetoFixed(subtotalAmount) + `</td>
                                  <td class="hidePWFWVNO" style="display:none;"></td>
                                  </tr>`;
          }

          grandtotalGROSSAMT += totalGROSSAMT;
          grandtotalNETBILLAMT += totalNETBILLAMT;
          grandtotalGOODSRETURN += totalGOODSRETURN;
          grandtotalPAIDAMT += totalPAIDAMT;
          grandtotalAmount += totalAmount;
          if (DtArrayLength > 1) {
            row += `<tr class="tfootcard">
                                <td class="pdfBtnHide"></td>
                                <td > TOTAL</td>
                                <td class="hidePWFWFIRM"></td>
                                <td class="hidePWFWBILLDATE"></td>
                                <td class="hidePWFWGROSSAMT">` + valuetoFixed(totalGROSSAMT) + `</td>
                                <td class="hidePWFWNETBILLAMT">` + valuetoFixed(totalNETBILLAMT) + `</td>
                                <td class="hidePWFWGOODSRET.">` + valuetoFixed(totalGOODSRETURN) + `</td>
                                <td class="hidePWFWPAIDAMT">` + valuetoFixed(totalPAIDAMT) + `</td>
                                <td class="hidePWFWPENDAMT">` + valuetoFixed(totalAmount) + `</td>
                                <td class="hidePWFWDAYS" ></td>
                                <td class="hidePWFWAGHASTE" ></td>
                                <td class="GRD"></td>
                                <td class="hidePWFWTDSTCS" style="display:none;"></td>
                                <td class="hidePWFWTRASNPORT" style="display:none;"></td>
                                <td class="hidePWFWLR" style="display:none;"></td>
                                <td class="hidePWFWL1R" style="display:none;"></td>
                                <td class="hidePWFWL1P" style="display:none;"></td>
                                <td class="hidePWFWL2R" style="display:none;"></td>
                                <td class="hidePWFWL2P" style="display:none;"></td>
                                <td class="hidePWFWL3R" style="display:none;"></td>
                                <td class="hidePWFWL3P" style="display:none;"></td>
                                <td class="hidePWFWRMK" style="display:none;"></td>
                                <td class="hidePWFWBAL" style="display:none;">`+ valuetoFixed(totalAmount) + `</td>
                                  <td class="hidePWFWVNO" style="display:none;"></td>
                                  </tr>`;
          }


        }
        if (totalAmount == 0) {
          row = "";
        }
        tr += row;

      }


      tr += `<tr class="tfootcard"style="">
    <td class="pdfBtnHide"></td>
    <td >GRAND TOTAL</td>
    <td class="hidePWFWFIRM"></td>
    <td class="hidePWFWBILLDATE"></td>
    <td class="hidePWFWGROSSAMT">` + valuetoFixed(grandtotalGROSSAMT) + `</td>
    <td class="hidePWFWNETBILLAMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</td>
    <td class="hidePWFWGOODSRET.">` + valuetoFixed(grandtotalGOODSRETURN) + `</td>
    <td class="hidePWFWPAIDAMT">` + valuetoFixed(grandtotalPAIDAMT) + `</td>
    <td class="hidePWFWPENDAMT">` + valuetoFixed(grandtotalAmount) + `</td>
    <td class="hidePWFWDAYS" ></td>
    <td class="hidePWFWAGHASTE" ></td>
    <td class="GRD"></td>
    <td class="hidePWFWTDSTCS" style="display:none;"></td>
    <td class="hidePWFWTRASNPORT" style="display:none;"></td>
    <td class="hidePWFWLR" style="display:none;"></td>
    <td class="hidePWFWL1R" style="display:none;"></td>
    <td class="hidePWFWL1P" style="display:none;"></td>
    <td class="hidePWFWL2R" style="display:none;"></td>
    <td class="hidePWFWL2P" style="display:none;"></td>
    <td class="hidePWFWL3R" style="display:none;"></td>
    <td class="hidePWFWL3P" style="display:none;"></td>
    <td class="hidePWFWRMK" style="display:none;"></td>
    <td class="hidePWFWBAL" style="display:none;">`+ valuetoFixed(grandtotalAmount) + `</td>
    <td class="hidePWFWVNO" style="display:none;"></td>
    </tr>`;

      $('#result').html(tr);
      $("#loader").removeClass('has-loader');
      if (GRD == '' || GRD == null) {
        $('.GRD').css("display", "none");
      }
      var hideAbleTr = getUrlParams(url, "hideAbleTr");
      if (hideAbleTr == "true") {
        $('.hideAbleTr').css("display", "none");
      }

      var PDFStore = getUrlParams(url, "PDFStore");
      if (PDFStore == "true") {
        alert("PDFStore=true");
      }

      var PDFStorePermission = getUrlParams(url, "PDFStorePermission");
      if (PDFStorePermission == "true") {
        UrlSendToAndroid(Data);
      }


      BuildAccountdetaisl(CNOArray);
      hideList();
    } else {
      $('#result').html('<h1>No Data Found</h1>');
      $("#loader").removeClass('has-loader');

    }


  } catch (e) {
    $('#result').html(tr);
    $('#result').prepend(e);
    $("#loader").removeClass('has-loader');
  }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

