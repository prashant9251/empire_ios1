
//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
//-----------function-------
var GRD;

var MainArr = [];
function filterByDateWise(oncode, value) {
  return MainArr.filter(function (d) {
    return d[oncode] == value;
  });
}

function jsLoadCallOUTSTANDINGPURCHASE_DATEWISE(data) {

  var CNOArray = [];
  var flgCno = [];
  Data = data;

  var DtArray = [];
  for (i = 0; i < Data.length; i++) {
    if (Data[i].billDetails.length > 0) {
      for (j = 0; j < Data[i].billDetails.length; j++) {
        var obj = {};
        obj.code = Data[i].code;
        obj.CNO = Data[i].billDetails[j].CNO;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.VNO = Data[i].billDetails[j].VNO;
        obj.IDE = Data[i].billDetails[j].IDE;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.HST = Data[i].billDetails[j].HST
        obj.BCODE = Data[i].billDetails[j].BCODE
        obj.BILL = Data[i].billDetails[j].BILL
        obj.FRM = Data[i].billDetails[j].FRM
        obj.DATE = Data[i].billDetails[j].DATE
        obj.GRSAMT = Data[i].billDetails[j].GRSAMT
        obj.FAMT = Data[i].billDetails[j].FAMT
        obj.CLAIMS = Data[i].billDetails[j].CLAIMS
        obj.RECAMT = Data[i].billDetails[j].RECAMT
        obj.PAMT = Data[i].billDetails[j].PAMT
        obj.GRD = Data[i].billDetails[j].GRD
        obj.T = Data[i].billDetails[j].T
        MainArr.push(obj);
        if (DtArray.indexOf(Data[i].billDetails[j].DATE) < 0) {
          DtArray.push(Data[i].billDetails[j].DATE);
        }
      }
    }

  }



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

  Data = DtArray;
  Data = Data.sort(function (a, b) {
    return new Date(b) - new Date(a);
  });
  var DL = Data.length;
  if (DL > 0) {

    grandtotalNETBILLAMT = 0;
    grandtotalGROSSAMT = 0;
    grandtotalGOODSRETURN = 0;
    grandtotalPAIDAMT = 0;
    grandtotalAmount = 0;

    for (o = Data.length - 1; o >= 0; o--) {
      tr += `<tr class="trPartyHead">
                            <th colspan="16" class="trPartyHead" >` + formatDate(Data[o]) + `</th>                                    
                      </tr>
                      <tr style="font-weight:700;"align="center">
                        
                      <td>BILL</td>
                      <td>BILL NO.</td>
                      <td>FIRM</td>
                        <td>PARTY NAME</td>
                        <td>BILL&nbsp;DATE</td>
                        <td>GROSS AMT</td>
                        <td>NET BILL AMT</td>
                        <td>GOODS RET.</td>
                        <td>PAID AMT.</td>
                        <td>PEND AMT.</td>
                        <td> DAYS</td>
                        <td>AG./HASTE</td>
                        <td class="GRD">GRADE</td>
                        <td class="hidePWFWTDSTCS" style="display:none;">TCS/TDS</td>
                        <td >VNO</td>
                        </tr>
                        `;
      var Subarray = filterByDateWise("DATE", Data[o]);

      totalNETBILLAMT = 0;
      totalGROSSAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;

      BLL = Subarray.length;
      if (BLL > 0) {
        for (j = 0; j < BLL; j++) {
          totalGROSSAMT += parseFloat(Subarray[j].GRSAMT);
          totalNETBILLAMT += parseFloat(Subarray[j].FAMT);
          totalGOODSRETURN += parseFloat(Subarray[j].CLAIMS);
          totalPAIDAMT += parseFloat(Subarray[j].RECAMT);
          totalAmount += parseFloat(Subarray[j].PAMT);
          var UrlPaymentSlip = getUrlPaymentSlip(Subarray[j].CNO, (Subarray[j].TYPE).replace("ZS", ""), Subarray[j].VNO, (Subarray[j].IDE).replace("ZS", ""));
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Subarray[j].CNO, Subarray[j].TYPE, Subarray[j].VNO, getFirmDetailsBySendCode(Subarray[j].CNO)[0].FIRM, Subarray[j].IDE);
          var urlopen = '';
          var TYPEforLink = (Subarray[j].TYPE).toUpperCase();
          if (TYPEforLink.indexOf('B') > -1) {

            urlopen = UrlPaymentSlip;
          } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
            urlopen = FdataUrl;
          }
          var BrokerHaste = '';
          var HST = Subarray[j].HST;
          if (HST != '' && HST != null && HST != undefined) {
            BrokerHaste = HST;
          } else {
            BrokerHaste = Subarray[j].BCODE;
          }

          var Days = parseInt(getDaysDif(Subarray[j].DATE, nowDate));
          var color = daysWiseColoring == "Y" ? colorByDaysFormate(Days) : "";

          if(!flgCno[Subarray[j].CNO]){
            CNOArray.push(Subarray[j].CNO);
            flgCno[Subarray[j].CNO]=true;
          }
          tr += ` 
                              
                                <tr class="hideAbleTr"align="center"style="`+color+`">
                                <th><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                                <td><a target="_blank" href="` + FdataUrl + `"><button>` + getValueNotDefine(Subarray[j].BILL) + `</button></a></td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + getValueNotDefine(Subarray[j].FRM) + `</td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + getValueNotDefine(Subarray[j].code) + `</td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + formatDate(Subarray[j].DATE) + `</td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + getValueNotDefine(Subarray[j].GRSAMT) + `</td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + getValueNotDefine(Subarray[j].FAMT) + `</td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + getValueNotDefine(Subarray[j].CLAIMS) + `</td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + getValueNotDefine(Subarray[j].RECAMT) + `</td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + getValueNotDefine(Subarray[j].PAMT) + `</td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + Days + ` </td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')"class="GRD">` + getValueNotDefine(Subarray[j].GRD) + ` </td>
                                    <td class="hidePWFWTDSTCS" style="display:none;">` + getValueNotDefine(Subarray[j].T) + `</td>
                                    <td onclick="openSubR('`+ Subarray[j].code + `')">` + getValueNotDefine(Subarray[j].VNO) + ` </td>
                                    
                                </tr>`;


        }
        grandtotalNETBILLAMT += totalGROSSAMT;
        grandtotalGROSSAMT += totalNETBILLAMT;
        grandtotalGOODSRETURN += totalGOODSRETURN;
        grandtotalPAIDAMT += totalPAIDAMT;
        grandtotalAmount += totalAmount;

        tr += `<tr class="tfootcard">
                                <td  colspan="5">Total Amount</td>
                                <td>` + valuetoFixed(totalGROSSAMT) + `</td>
                                <td>` + valuetoFixed(totalNETBILLAMT) + `</td>
                                <td>` + valuetoFixed(totalGOODSRETURN) + `</td>
                                <td>` + valuetoFixed(totalPAIDAMT) + `</td>
                                <td>` + valuetoFixed(totalAmount) + `</td>
                                <td colspan="3"></td>
                                <td class="GRD"colspan="1"></td>
                                <td class="hidePWFWTDSTCS" style="display:none;"></td>
                                <td class=""colspan="1"></td>
                                </tr>`;
      }

    }
    tr += `<tr class="tfootcard">
    <td  colspan="5">GRAND TOTAL</td>
    <td>` + valuetoFixed(grandtotalGROSSAMT) + `</td>
    <td>` + valuetoFixed(grandtotalNETBILLAMT) + `</td>
    <td>` + valuetoFixed(grandtotalGOODSRETURN) + `</td>
    <td>` + valuetoFixed(grandtotalPAIDAMT) + `</td>
    <td>` + valuetoFixed(grandtotalAmount) + `</td>
    <td colspan="3"></td>
    <td class="GRD"colspan="1"></td>
    <td class="hidePWFWTDSTCS" style="display:none;"></td>
    <td class=""colspan="1"></td>
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
    hideList();
    BuildAccountdetaisl(CNOArray);

  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }


  try {
  } catch (e) {
    $('#result').html(tr);
    $('#result').prepend(e);
    $("#loader").removeClass('has-loader');
  }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

