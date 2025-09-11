
//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
//-----------function-------
var GRD;
function loadCall(data) {
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
    for (var i = 0; i < DL; i++) {
      totalNETBILLAMT = 0;
      totalGROSSAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;
      pcode = "";
      city = "";
      broker = "";
      label = Data[i].code;
      var MO = "";
      ccode = getPartyDetailsBySendCode(Data[i].code);
      // console.log(Data[i].code+"-",ccode)
      if (ccode.length > 0) {
        pcode = ccode[0].partyname;
        city = ccode[0].city;
        broker = ccode[0].broker;
        label = ccode[0].label;
        MO = ccode[0].MO;
      }
      tr += `<tr class="trPartyHead"onclick="trOnClick('` + Data[i].code + `','` + city + `','` + broker + `');">
                          <th colspan="14" class="trPartyHead">` + label + `<a href="tel:` + MO + `"><button>MO:` + getValueNotDefine(MO) + `</button></a></th>
                        </tr>
                        <tr style="font-weight:500;"align="center">
                        
                        <td>BILL</td>
                        <td>BILL NO.</td>
                        <td>FIRM</td>
                          <td>BILL&nbsp;DATE</td>
                          <td>GROSS AMT</td>
                          <td>NET BILL AMT</td>
                          <td>GOODS RET.</td>
                          <td>PAID AMT.</td>
                          <td>PEND AMT.</td>
                          <td> DAYS</td>
                          <td>AG./HASTE</td>
                          <td class="GRD">GRADE</td>
                          </tr>
                        `;

      BLL = Data[i].billDetails.length;
      if (BLL > 0) {
        for (j = 0; j < BLL; j++) {

          totalGROSSAMT += parseFloat(Data[i].billDetails[j].GRSAMT);
          totalNETBILLAMT += parseFloat(Data[i].billDetails[j].FAMT);
          totalGOODSRETURN += parseFloat(Data[i].billDetails[j].CLAIMS);
          totalPAIDAMT += parseFloat(Data[i].billDetails[j].RECAMT);
          totalAmount += parseFloat(Data[i].billDetails[j].PAMT);
          var UrlPaymentSlip = getUrlPaymentSlip(Data[i].billDetails[j].CNO, (Data[i].billDetails[j].TYPE).replace("ZS", ""), Data[i].billDetails[j].VNO, (Data[i].billDetails[j].IDE).replace("ZS", ""));
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE, MO);
          var urlopen = '';
          var TYPEforLink = (Data[i].billDetails[j].TYPE).toUpperCase();
          if (TYPEforLink.indexOf('B') > -1) {

            urlopen = UrlPaymentSlip;
          } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
            urlopen = FdataUrl;
          }
          var BrokerHaste = '';
          var HST = Data[i].billDetails[j].HST;
          if (HST != '' && HST != null && HST != undefined) {
            BrokerHaste = HST;
          } else {
            BrokerHaste = Data[i].billDetails[j].BCODE;
          }
          tr += ` 
                              
                                <tr class="hideAbleTr"align="center"style="">
                                <th><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                                <td><a target="_blank" href="` + FdataUrl + `"><button>` + getValueNotDefine(Data[i].billDetails[j].BILL) + `</button></a></td>
                                    <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].FRM) + `</td>
                                    <td onclick="openSubR('`+ Data[i].code + `')">` + formatDate(Data[i].billDetails[j].DATE) + `</td>
                                    <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].GRSAMT) + `</td>
                                    <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].FAMT) + `</td>
                                    <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].CLAIMS) + `</td>
                                    <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].RECAMT) + `</td>
                                    <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].PAMT) + `</td>
                                    <td onclick="openSubR('`+ Data[i].code + `')">` + getDaysDif(Data[i].billDetails[j].DATE, nowDate) + ` </td>
                                    <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                                    <td onclick="openSubR('`+ Data[i].code + `')"class="GRD">` + getValueNotDefine(Data[i].billDetails[j].GRD) + ` </td>
                                    
                                </tr>`;


        }
        grandtotalNETBILLAMT += totalGROSSAMT;
        grandtotalGROSSAMT += totalNETBILLAMT;
        grandtotalGOODSRETURN += totalGOODSRETURN;
        grandtotalPAIDAMT += totalPAIDAMT;
        grandtotalAmount += totalAmount;

        tr += `<tr class="tfootcard">
                                <td  colspan="4">Total Amount</td>
                                <td>` + valuetoFixed(totalGROSSAMT) + `</td>
                                <td>` + valuetoFixed(totalNETBILLAMT) + `</td>
                                <td>` + valuetoFixed(totalGOODSRETURN) + `</td>
                                <td>` + valuetoFixed(totalPAIDAMT) + `</td>
                                <td>` + valuetoFixed(totalAmount) + `</td>
                                <td colspan="3"></td>
                                <td class="GRD"colspan="1"></td>
                                </tr>`;
      }

    }
    tr += `<tr class="tfootcard">
    <td  colspan="4">GRAND TOTAL</td>
    <td>` + valuetoFixed(grandtotalGROSSAMT) + `</td>
    <td>` + valuetoFixed(grandtotalNETBILLAMT) + `</td>
    <td>` + valuetoFixed(grandtotalGOODSRETURN) + `</td>
    <td>` + valuetoFixed(grandtotalPAIDAMT) + `</td>
    <td>` + valuetoFixed(grandtotalAmount) + `</td>
    <td colspan="3"></td>
    <td class="GRD"colspan="1"></td>
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

  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }
  } catch (e) {
    noteError(e);
    $("#loader").removeClass('has-loader');
  }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

