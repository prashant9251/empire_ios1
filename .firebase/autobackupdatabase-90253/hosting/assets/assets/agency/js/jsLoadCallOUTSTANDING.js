
var hideAbleTr = getUrlParams(url, "hideAbleTr");

//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
var MainBilldetails = [];
function getMainBilldetails(ccd) {
  return MainBilldetails.filter(function (d) {
    return d.ccd == ccd;
  })
}
var GRD;
function loadCall(data) {
  Data = data;
  console.log(Data);
  Data=Data.sort(function(a,b){
    return a['partyName'] < b['partyName'] ? -1 : 1;
  })
  var ccode = "";
  var pcode = "";
  var city = "";
  var broker = "";
  var label = "";
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

  grandtotalNETBILLAMT = 0;
  grandtotalGROSSAMT = 0;
  grandtotalGOODSRETURN = 0;
  grandtotalPAIDAMT = 0;
  grandtotalAmount = 0;
  var BLL;
  var FdataUrl
  var DL = Data.length;
  if (DL > 0) {
    tr = "<tbody>";

    for (var i = 0; i < DL; i++) {
      ccode = Data[i].ccode;
      if (ccode.length > 0) {
        pcode = getValueNotDefine(ccode[0].partyname);
        city = getValueNotDefine(ccode[0].city);
        broker = getValueNotDefine(ccode[0].broker);
        label = getValueNotDefine(ccode[0].label);
        MO = getValueNotDefine(ccode[0].MO);
      }
      var trRow = `<tr class="trPartyHead"onclick="trOnClick('` + Data[i].COD + `','` + city + `','` + broker + `');">
                          <th colspan="16" class="trPartyHead">` + label + `<a onclick="dialNo('` + MO + `')"><button>MO:` + getValueNotDefine(MO) + `</button></a></th>
                        </tr>
                        `;

      MainBilldetails = Data[i].billDetails;
      var ccdList = [];
      var ccdFlg = [];
      Data[i].billDetails = Data[i].billDetails.sort(function (a, b) {
        return a['ccd'] > b['ccd'] ? -1 : 1;
      })
      Data[i].billDetails = Data[i].billDetails.filter(function (a) {
        if (!ccdFlg[a['ccd']]) {
          ccdList.push(a['ccd']);
          ccdFlg[a['ccd']] = true;
        }
        return true;
      })
      // console.log(ccdList);
      ccdList = ccdList.sort(function (a, b) {
        return a < b ? -1 : 1;
      })
      for (let m = 0; m < ccdList.length; m++) {
        trRow += `<tr class="trPartyHead2" style="height:40px">  
        <th colspan="17" class="trPartyHead2" onclick="openSubR('`+ Data[i].COD + `','` + ccdList[m] + `')">` + ccdList[m] + `</th> 
        </tr>
        
        <tr style="font-weight:bold;"align="center">                    
            <th class="unhideAbleTr">SELECT </th>
            <th >BILL</th>
            <th >DATE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
            <th class="hideFRM"style="display:none;">FIRM</th>
            <th class="hideVNO">VNO</th>
            <th class="hideGROSSAMT"style="display:none;">GROSS <br>AMT</th>
            <th class="hideTYPE"style="display:none;">TYPE</th>
            <th class="hideNETBILLAMT">NET BILL<br>AMT</th>
            <th class="hideGOODSRET">GOODS<br>RET.</th>
            <th class="hidePAID">PAID <BR> AMT</th>
            <th class="hidePEND">PEND<br>AMT.</th>
            <th class="hideDIS" style="display:none;">DIS%</th>
            <th class="hideDISAMT" style="display:none;">DISAMT</th>
            <th class="hideGROUP">GROUP</th>
            <th class="hideBROKER"style="display:none;">BROKER</th>
            <th class="hideDAYS">DAYS</th>
            <th class="hideTRANSPORT">TRANSPORT</th>
            <th class="hideLR">LR NO</th>
            </tr> `;
        var supBillDetails = getMainBilldetails(ccdList[m]);

        // console.log(supBillDetails);
        for (var n = 0; n < supBillDetails.length; n++) {
          var transport = (supBillDetails[n].TR);

          var UrlPaymentSlip = getUrlPaymentSlip(supBillDetails[n].CNO, (supBillDetails[n].TYPE).replace("ZS", ""), supBillDetails[n].VNO, (supBillDetails[n].IDE).replace("ZS", ""));
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(supBillDetails[n].CNO, supBillDetails[n].TYPE, supBillDetails[n].VNO, getFirmDetailsBySendCode(supBillDetails[n].CNO)[0].FIRM, supBillDetails[n].IDE);
          var urlopen = '';
          var TYPEforLink = (supBillDetails[n].TYPE).toUpperCase();
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
          BAMT = parseInt((supBillDetails[n].BAMT == null) ? 0 : supBillDetails[n].BAMT);
          FAMT = parseInt((supBillDetails[n].FAMT == null) ? 0 : supBillDetails[n].FAMT);
          CLM = parseInt((supBillDetails[n].CLM == null) ? 0 : supBillDetails[n].CLM);
          RAMT = parseInt((supBillDetails[n].RAMT == null) ? 0 : supBillDetails[n].RAMT);
          PAMT = parseInt((supBillDetails[n].PAMT == null) ? 0 : supBillDetails[n].PAMT);
          subtotalGROSSAMT += (BAMT);
          subtotalNETBILLAMT += (FAMT);
          subtotalGOODSRETURN += (CLM);
          subtotalPAIDAMT += (RAMT);
          subtotalAmount += (PAMT);
          var BCD = "";
          var BrokerArr = getPartyDetailsBySendCode(supBillDetails[n].BCD);
          if (BrokerArr.length > 0) {
            BCD = getValueNotDefine(BrokerArr[0].partyname);
          }
          trRow += ` 
                 <tr class="hideAbleTr"align="center"style="">
                <td><a href="`+ FdataUrl + `" target="_blank"><button class="PrintBtnHide">` + supBillDetails[n].BLL + `</button></a></td>
                <td onclick="openSubR('`+ Data[i].COD + `')">` + formatDate(supBillDetails[n].DTE) + `</td>
                <td class="hideFRM"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">` + (supBillDetails[n].FRM) + `</td>
                <td class="hideVNO" onclick="openSubR('`+ Data[i].COD + `')">` + (supBillDetails[n].VNO) + `</td>
                <td class="hideGROSSAMT"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">` + (BAMT) + `</td>
                <td class="hideTYPE"style="display:none;" onclick="openSubR('`+ Data[i].COD + `')">` + (supBillDetails[n].TYPE) + `</td>
                <td class="hideNETBILLAMT" onclick="openSubR('`+ Data[i].COD + `')">` + (FAMT) + `</td>
                <td class="hideGOODSRET" onclick="openSubR('`+ Data[i].COD + `')">` + (CLM) + `</td>
                <td class="hidePAID" onclick="openSubR('`+ Data[i].COD + `')">` + (RAMT) + `</td>
                <td class="hidePEND"onclick="openSubR('`+ Data[i].COD + `')">` + (PAMT) + `</td>
                <td class="hideDIS" style="display:none;"onclick="openSubR('','` +  Data[i].COD + `')">` + getValueNotDefine(supBillDetails[n].DR) + ` </td> 
                <td class="hideDISAMT" style="display:none;"onclick="openSubR('','` +  Data[i].COD + `')">` + getValueNotDefine(supBillDetails[n].DA) + ` </td> 
                <td class="hideGROUP"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(supBillDetails[n].SG) + ` </td>                                    
                <td class="hideBROKER"style="display:none;"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(BCD) + ` </td>
                <td class="hideDAYS"onclick="openSubR('`+ Data[i].COD + `')">` + getDaysDif(supBillDetails[n].DTE, nowDate) + ` </td>
                <td class="hideTRANSPORT" onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(transport) + ` </td>
                <td class="hideLR"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(supBillDetails[n].LR) + ` </td>                                    
                                </tr>`;

        }
        if (ccdList.length > 1) {
          trRow += `
        <tr class="tfootcard"style="font-weight:bold;"align="center">                    
        <th >SUBTOTAL</th>
        <th ></th>
        <th class="hideFRM"style="display:none;"></th>
        <th class="hideVNO"></th>
        <tH class="hideGROSSAMT"style="display:none;">` + valuetoFixed(subtotalGROSSAMT) + `</tH>        
        <th class="hideTYPE"style="display:none;"></th>
        <tH class="hideNETBILLAMT">` + valuetoFixed(subtotalNETBILLAMT) + `</tH>
        <tH class="hideGOODSRET" >` + valuetoFixed(subtotalGOODSRETURN) + `</tH>
        <tH class="hidePAID" >` + valuetoFixed(subtotalPAIDAMT) + `</tH>
        <tH class="hidePEND" >` + valuetoFixed(subtotalAmount) + `</tH>
        <tH class="hideDIS" style="display:none;" ></tH>
        <tH class="hideDISAMT" style="display:none;" ></tH>
        <th class="hideGROUP"></th>
        <th class="hideBROKER"style="display:none;"></th>
        <th class="hideDAYS"></th>
        <th class="hideTRANSPORT"></th>
        <th class="hideLR"></th>
        </tr> `;

        }
        totalNETBILLAMT += subtotalNETBILLAMT;
        totalGROSSAMT += subtotalGROSSAMT;
        totalGOODSRETURN += subtotalGOODSRETURN;
        totalPAIDAMT += subtotalPAIDAMT;
        totalAmount += subtotalAmount;
        subtotalNETBILLAMT = 0;
        subtotalGROSSAMT = 0;
        subtotalGOODSRETURN = 0;
        subtotalPAIDAMT = 0;
        subtotalAmount = 0;


      }

      trRow += `
        <tr class="tfootcard"style="font-weight:bold;"align="center">                    
        <th >TOTAL</th>
        <th ></th>
        <th class="hideFRM"style="display:none;"></th>
        <th class="hideVNO"></th>
        <tH class="hideGROSSAMT"style="display:none;">` + valuetoFixed(totalGROSSAMT) + `</tH>        
        <th class="hideTYPE"style="display:none;"></th>
        <tH class="hideNETBILLAMT">` + valuetoFixed(totalNETBILLAMT) + `</tH>
        <tH class="hideGOODSRET" >` + valuetoFixed(totalGOODSRETURN) + `</tH>
        <tH class="hidePAID" >` + valuetoFixed(totalPAIDAMT) + `</tH>
        <tH class="hidePEND" >` + valuetoFixed(totalAmount) + `</tH>
        <tH class="hideDIS" style="display:none;" ></tH>
        <tH class="hideDISAMT" style="display:none;" ></tH>
        <th class="hideGROUP"></th>
        <th class="hideBROKER"style="display:none;"></th>
        <th class="hideDAYS"></th>
        <th class="hideTRANSPORT"></th>
        <th class="hideLR"></th>
        </tr> `;
      if(totalAmount!=0){
        tr +=trRow;
      }
      grandtotalNETBILLAMT += totalNETBILLAMT;
      grandtotalGROSSAMT += totalGROSSAMT;
      grandtotalGOODSRETURN += totalGOODSRETURN;
      grandtotalPAIDAMT += totalPAIDAMT;
      grandtotalAmount += totalAmount;

      totalNETBILLAMT = 0;
      totalGROSSAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;
    }
    if (Data.length > 1) {

      tr += `
    <tr class="tfootcard"style="font-weight:bold;"align="center">                    
    <th >GRAND TOTAL</th>
    <th ></th>
    <th class="hideFRM"style="display:none;"></th>
    <th class="hideVNO"></th>
    <tH class="hideGROSSAMT"style="display:none;">` + valuetoFixed(grandtotalGROSSAMT) + `</tH>        
    <th class="hideTYPE"style="display:none;"></th>
    <tH class="hideNETBILLAMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</tH>
    <tH class="hideGOODSRET" >` + valuetoFixed(grandtotalGOODSRETURN) + `</tH>
    <tH class="hidePAID" >` + valuetoFixed(grandtotalPAIDAMT) + `</tH>
    <tH class="hidePEND" >` + valuetoFixed(grandtotalAmount) + `</tH>
    <tH class="hideDIS" style="display:none;" ></tH>
    <tH class="hideDISAMT" style="display:none;" ></tH>
    <th class="hideGROUP"></th>
    <th class="hideBROKER"style="display:none;"></th>
    <th class="hideDAYS"></th>
    <th class="hideTRANSPORT"></th>
    <th class="hideLR"></th>
    </tr> `;

    }
    $('#result').html(tr);
    $("#loader").removeClass('has-loader');

    if (hideAbleTr == "true") {
      $('.hideAbleTr').css("display", "none");
      $('.unhideAbleTr').css("display", "");
      // $('#footer').css("display", "");
    } else {
      $('.unhideAbleTr').css("display", "none");
      $('#footer').css("display", 'none');
    }

    AddHeaderTbl();

  } else {
    $('#result').html('<h1 style="text-align:center;">No Data Found</h1>');
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

