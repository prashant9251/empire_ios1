

//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}

var GRD;
function loadCall(data) {
  Data = data;



  var ccode;
  var pcode;
  var city;
  var broker;
  var label;
  var grandtotalNETBILLAMT = 0;
  var grandtotalGROSSAMT = 0;
  var grandtotalGOODSRETURN = 0;
  var grandtotalPAIDAMT = 0;
  var grandtotalAmount = 0;
  var totalNETBILLAMT = 0;
  var totalGROSSAMT = 0;
  var totalGOODSRETURN = 0;
  var totalPAIDAMT = 0;
  var totalAmount = 0;
  var subtotalNETBILLAMT = 0;
  var subtotalGROSSAMT = 0;
  var subtotalGOODSRETURN = 0;
  var subtotalPAIDAMT = 0;
  var subtotalAmount = 0;
  var BLL;
  var FdataUrl
  var DL = Data.length;
  if (DL > 0) {
    grandtotalNETBILLAMT = 0;
    grandtotalGROSSAMT = 0;
    grandtotalGOODSRETURN = 0;
    grandtotalPAIDAMT = 0;
    grandtotalAmount = 0;
    tr = "<tbody>";

    for (var i = 0; i < DL; i++) {
      ccode = getPartyDetailsBySendCode(Data[i].COD);
      if (ccode.length > 0) {
        pcode = getValueNotDefine(ccode[0].partyname);
        city = getValueNotDefine(ccode[0].city);
        broker = getValueNotDefine(ccode[0].broker);
        label = getValueNotDefine(ccode[0].label);
        MO = getValueNotDefine(ccode[0].MO);
      }
      tr += `<tr class="trPartyHead"onclick="trOnClick('` + Data[i].COD + `','` + city + `','` + broker + `');">
                          <th colspan="15" class="trPartyHead">` + label + `<a href="tel:` + MO + `"><button>MO:` + getValueNotDefine(MO) + `</button></a></th>
                        </tr>
                        `;
      Data[i].billDetails=Data[i].billDetails.sort(function(a, b) {
        if (new Date(a.DTE) < new Date(b.DTE)) {
          return -1;
        }
        if (new Date(a.DTE) > new Date(b.DTE)) {
          return 1;
        }
        return a.VNO - b.VNO;
      });
      BLL = Data[i].billDetails.length;
      if (BLL > 0) {
        tr += ` <tr style="font-weight:bold;"align="center">                    
        <th >BILL</th>
        <th >DATE</th>
        <th class="hideCUST">CUSTOMER</th>
        <th class="hideFRM">FIRM</th>
        <th class="hideVNO">VNO</th>
        <th class="hideGROSSAMT">GROSS <br>AMT</th>
        <th class="hideTYPE">TYPE</th>
        <th class="hideNETBILLAMT">NET BILL<br>AMT</th>
        <th class="hideGOODSRET">GOODS<br>RET.</th>
        <th class="hidePAID">PAID <BR> AMT</th>
        <th class="hidePEND">PEND<br>AMT.</th>
        <th class="hideGROUP">GROUP</th>
        <th class="hideDAYS">DAYS</th>
        <th class="hideTRANSPORT">TRANSPORT</th>
        <th class="hideLR">LR NO</th>
        </tr>  `;

        totalNETBILLAMT = 0;
        totalGROSSAMT = 0;
        totalGOODSRETURN = 0;
        totalPAIDAMT = 0;
        totalAmount = 0;
        var codex = null;
        var CodePrev = null;
        for (j = 0; j < BLL; j++) {
          var sr = 0
          codex = Data[i].billDetails[j].ccd;
          if (j == 0 ) {
          
            CodePrev = codex;
          }

          var transport = (Data[i].billDetails[j].TR);

          var UrlPaymentSlip = getUrlPaymentSlip(Data[i].billDetails[j].CNO, (Data[i].billDetails[j].TYPE).replace("ZS", ""), Data[i].billDetails[j].VNO, (Data[i].billDetails[j].IDE).replace("ZS", ""));
          FdataUrl = getPurchaseFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE);
          var urlopen = '';
          var TYPEforLink = (Data[i].billDetails[j].TYPE).toUpperCase();
          if (TYPEforLink.indexOf('B') > -1) {

            urlopen = UrlPaymentSlip;
          } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
            urlopen = FdataUrl;
          }
          var BAMT = 0;
          var FAMT = 0;
          var CLM = 0;
          var RAMT = 0;
          var PAMT = 0;
          BAMT = parseInt((Data[i].billDetails[j].BAMT == null) ? 0 : Data[i].billDetails[j].BAMT);
          FAMT = parseInt((Data[i].billDetails[j].FAMT == null) ? 0 : Data[i].billDetails[j].FAMT);
          CLM = parseInt((Data[i].billDetails[j].CLM == null) ? 0 : Data[i].billDetails[j].CLM);
          RAMT = parseInt((Data[i].billDetails[j].RAMT == null) ? 0 : Data[i].billDetails[j].RAMT);
          PAMT = parseInt((Data[i].billDetails[j].PAMT == null) ? 0 : Data[i].billDetails[j].PAMT);
          totalGROSSAMT += (BAMT);
          totalNETBILLAMT += (FAMT);
          totalGOODSRETURN += (CLM);
          totalPAIDAMT += (RAMT);
          totalAmount += (PAMT);

          tr += ` 
                 <tr class="hideAbleTr"align="center"style="">
                 <td><a href="`+ FdataUrl + `" target="_blank"><button class="PrintBtnHide">` + Data[i].billDetails[j].BLL + `</button></a></td>
                 <td onclick="openSubR('`+ Data[i].COD + `')">` + formatDate(Data[i].billDetails[j].DTE) + `</td>
                 <td  class="hideCUST"onclick="openSubR('`+ Data[i].COD + `','` + Data[i].billDetails[j].ccd + `')">` + (Data[i].billDetails[j].ccd) + `</td>
                                <td class="hideFRM" onclick="openSubR('`+ Data[i].COD + `')">` + (Data[i].billDetails[j].FRM) + `</td>
                                <td class="hideVNO" onclick="openSubR('`+ Data[i].COD + `')">` + (Data[i].billDetails[j].VNO) + `</td>
                                    <td class="hideGROSSAMT" onclick="openSubR('`+ Data[i].COD + `')">` + (BAMT) + `</td>
                                    <td class="hideTYPE" onclick="openSubR('`+ Data[i].COD + `')">` + (Data[i].billDetails[j].TYPE) + `</td>
                                    <td class="hideNETBILLAMT" onclick="openSubR('`+ Data[i].COD + `')">` + (FAMT) + `</td>
                                    <td class="hideGOODSRET" onclick="openSubR('`+ Data[i].COD + `')">` + (CLM) + `</td>
                                    <td class="hidePAID" onclick="openSubR('`+ Data[i].COD + `')">` + (RAMT) + `</td>
                                    <td class="hidePEND"onclick="openSubR('`+ Data[i].COD + `')">` + (PAMT) + `</td>
                                    <td class="hideGROUP"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(Data[i].billDetails[j].SG) + ` </td>
                                    <td class="hideDAYS"onclick="openSubR('`+ Data[i].COD + `')">` + getDaysDif(Data[i].billDetails[j].DTE, nowDate) + ` </td>
                                    <td class="hideTRANSPORT" onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(transport) + ` </td>
                                    <td class="hideLR"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(Data[i].billDetails[j].LR) + ` </td>
                                    
                                </tr>`;
           
          
        }

        grandtotalGROSSAMT += totalGROSSAMT;
        grandtotalNETBILLAMT += totalNETBILLAMT;
        grandtotalGOODSRETURN += totalGOODSRETURN;
        grandtotalPAIDAMT += totalPAIDAMT;
        grandtotalAmount += totalAmount;
        tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
        <tr class="tfootcard"style="background-color:#3e3b3b26;text-align: center;">
            <td class="" style="text-align:left;"colspan="2">TOTAL</td>
            <td  class="hideCUST"></td>   
            <td class="hideFRM" ></td>
            <td class="hideVNO" ></td>
            <td class="hideGROSSAMT">` + valuetoFixed(totalGROSSAMT) + `</td>
            <td class="hideTYPE" ></td>
            <td class="hideNETBILLAMT">` + valuetoFixed(totalNETBILLAMT) + `</td>
            <td class="hideGOODSRET" >` + valuetoFixed(totalGOODSRETURN) + `</td>
            <td class="hidePAID" >` + valuetoFixed(totalPAIDAMT) + `</td>
            <td class="hidePEND" >` + valuetoFixed(totalAmount) + `</td>
            <td class="hideGROUP" ></td>
            <td class="hideDAYS"></td>
            <td class="hideTRANSPORT"></td>
            <td class="hideLR"></td>
        </tr>`;
        totalGROSSAMT = 0;
        totalNETBILLAMT = 0;
        totalGOODSRETURN = 0;
        totalPAIDAMT = 0;
        totalAmount = 0;
      }
    }
    tr += `<tr class="tfootcard grandTotel"style="background-color:#3e3b3b26;color:#080844;">
    <td colspan="2" >GRAND TOTAL</td>
    <td class="hideCUST"></td>   
    <td class="hideFRM" ></td>
    <td class="hideVNO" ></td>
    <td class="hideGROSSAMT">` + valuetoFixed(grandtotalGROSSAMT) + `</td>
    <td class="hideTYPE" ></td>
    <td class="hideNETBILLAMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</td>
    <td class="hideGOODSRET" >` + valuetoFixed(grandtotalGOODSRETURN) + `</td>
    <td class="hidePAID" >` + valuetoFixed(grandtotalPAIDAMT) + `</td>
    <td class="hidePEND" >` + valuetoFixed(grandtotalAmount) + `</td>
    <td class="hideGROUP" ></td>
    <td class="hideDAYS"></td>
    <td class="hideTRANSPORT"></td>
    <td class="hideLR"></td>
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

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
  }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

