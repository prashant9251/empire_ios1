

//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
var MainArr = [];
function filterBy(oncode, value) {
  return MainArr.filter(function (d) {
    return d[oncode] == value;
  });
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
  tr = "<tbody>";

  var DtArray = [];
  for (i = 0; i < Data.length; i++) {
    if (Data[i].billDetails.length > 0) {
      for (j = 0; j < Data[i].billDetails.length; j++) {
        var obj = {};
        obj.COD = Data[i].COD;
        obj.ATP = Data[i].ATP;
        obj.CT = Data[i].CT;
        obj.CNO = Data[i].billDetails[j].CNO;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.VNO = Data[i].billDetails[j].VNO;
        obj.IDE = Data[i].billDetails[j].IDE;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.ccd = Data[i].billDetails[j].ccd;
        obj.BCD = Data[i].billDetails[j].BCD;
        obj.BAMT = Data[i].billDetails[j].BAMT;
        obj.FAMT = Data[i].billDetails[j].FAMT;
        obj.CLM = Data[i].billDetails[j].CLM;
        obj.RAMT = Data[i].billDetails[j].RAMT;
        obj.PAMT = Data[i].billDetails[j].PAMT;
        obj.BLL = Data[i].billDetails[j].BLL;
        obj.DTE = Data[i].billDetails[j].DTE;
        obj.TR = Data[i].billDetails[j].TR;
        obj.LR = Data[i].billDetails[j].LR;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.DTE = Data[i].billDetails[j].DTE;
        MainArr.push(obj);
        if (DtArray.indexOf(Data[i].billDetails[j].DTE) < 0) {
          DtArray.push(Data[i].billDetails[j].DTE);
        }
      }
    }
  }
  Data = DtArray;
  Data = Data.sort(function (a, b) {
    return new Date(b) - new Date(a);
  });
  // console.log(MainArr);
  if (DL > 0) {
      tr +=` <tr  class="trPartyHead"  style="font-weight:500;font-weight:bold;"align="center">                    
      <th>BILL</th>
      <th class="hideSUPP">SUPPLIER</th>
      <th>DATE</th>
      <th class="hideVNO" style="display:none;">VNO</th>
      <th class="hideCUST">CUSTOMER</th>
      <th class="hideFRM">FIRM</th>
      <th  class="hideGROSSAMT">GROSS <br>AMT</th>
      <th  class="hideTYPE">TYPE</th>
      <th  class="hideNETBILLAMT">NET BILL<br>AMT</th>
      <th  class="hideGOODSRET">GOODS<br>RET.</th>
      <th  class="hidePAID">PAID <BR> AMT</th>
      <th  class="hidePEND">PEND<br>AMT.</th>
      <th  class="hideDAYS">DAYS</th>
      <th  class="hideTRANSPORT">TRANSPORT</th>
      <th  class="hideLR">LR</th>
      </tr>`;
    for (o = Data.length - 1; o >= 0; o--) {

      totalNETBILLAMT = 0;
      totalGROSSAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;

      tr += `<tr class="hideHeaddate">
                            <th colspan="15" class="trPartyHead" >` + formatDate(Data[o]) + `</th>                                    
                      </tr>
           `;

      var Subarray = filterBy("DTE", Data[o]);
      SubarrayBLL = Subarray.length;
      if (SubarrayBLL > 0) {
        for (j = 0; j < SubarrayBLL; j++) {
          ccode = getPartyDetailsBySendCode(Subarray[j].COD);
          if (ccode.length > 0) {
            pcode = getValueNotDefine(ccode[0].partyname);
            city = getValueNotDefine(ccode[0].city);
            broker = getValueNotDefine(ccode[0].broker);
            label = getValueNotDefine(ccode[0].label);
            MO = getValueNotDefine(ccode[0].MO);

          }
          var transport = (Subarray[j].TR);
          var UrlPaymentSlip = getUrlPaymentSlip(Subarray[j].CNO, (Subarray[j].TYPE).replace("ZS", ""), Subarray[j].VNO, (Subarray[j].IDE).replace("ZS", ""));
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Subarray[j].CNO, Subarray[j].TYPE, Subarray[j].VNO, getFirmDetailsBySendCode(Subarray[j].CNO)[0].FIRM, Subarray[j].IDE);

          var BAMT = 0;
          var FAMT = 0;
          var CLM = 0;
          var RAMT = 0;
          var PAMT = 0;
          BAMT = parseInt((Subarray[j].BAMT == null) ? 0 : Subarray[j].BAMT);
          FAMT = parseInt((Subarray[j].FAMT == null) ? 0 : Subarray[j].FAMT);
          CLM = parseInt((Subarray[j].CLM == null) ? 0 : Subarray[j].CLM);
          RAMT = parseInt((Subarray[j].RAMT == null) ? 0 : Subarray[j].RAMT);
          PAMT = parseInt((Subarray[j].PAMT == null) ? 0 : Subarray[j].PAMT);
          tr += ` 
                <tr class="hideAbleTr"align="center"style="">
                               <td ><a href="`+ FdataUrl + `" target="_blank"><button  class="PrintBtnHide">` + Subarray[j].BLL + `</button></a></td>
                               <td  class="hideSUPP" style="border: 1px solid #588c7e"onclick="openSubR('`+ Subarray[j].COD + `')">` + (pcode) + `</td>
                               <td >` + formatDate(Subarray[j].DTE) + `</td>                               
                              <td class="hideVNO" style="display:none;">` + (Subarray[j].VNO) + `</td>
                              <td class="hideCUST" style="border: 1px solid #588c7e;" onclick="openSubR('`+ Subarray[j].COD + `','` + Subarray[j].ccd + `')">` + (Subarray[j].ccd) + `</td>
                              <td class="hideFRM">` + (Subarray[j].FRM) + `</td>
                              <td class="hideGROSSAMT">` + (BAMT) + `</td>
                              <td class="hideTYPE">` + (Subarray[j].TYPE) + `</td>
                              <td class="hideNETBILLAMT">` + (FAMT) + `</td>
                              <td class="hideGOODSRET">` + (CLM) + `</td>
                              <td class="hidePAID">` + (RAMT) + `</td>
                              <td class="hidePEND">` + (PAMT) + `</td>
                              <td class="hideDAYS">` + getDaysDif(Subarray[j].DTE, nowDate) + ` </td>
                              <td class="hideTRANSPORT">` + getValueNotDefine(transport) + ` </td>
                              <td class="hideLR">` + getValueNotDefine(Subarray[j].LR) + ` </td>
                                   
                               </tr>`;

          totalGROSSAMT += BAMT;
          totalNETBILLAMT += FAMT;
          totalGOODSRETURN += CLM;
          totalPAIDAMT += RAMT;
          totalAmount += PAMT;
        }
      }
      // tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
      // <td  colspan="5">TOTAL </td>
      // <td>` + valuetoFixed(totalGROSSAMT) + `</td>
      // <td></td>
      // <td>` + valuetoFixed(totalNETBILLAMT) + `</td>
      // <td>` + valuetoFixed(totalGOODSRETURN) + `</td>
      // <td>` + valuetoFixed(totalPAIDAMT) + `</td>
      // <td>` + valuetoFixed(totalAmount) + `</td>
      // <td colspan="3"></td>
      // </tr>`;

      grandtotalGROSSAMT += totalGROSSAMT;
      grandtotalNETBILLAMT += totalNETBILLAMT;
      grandtotalGOODSRETURN += totalGOODSRETURN;
      grandtotalPAIDAMT += totalPAIDAMT;
      grandtotalAmount += totalAmount;
    }
    tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
    <td>GRAND TOTAL </td>
    <td  class="hideSUPP"></td>
    <td></td>
    <td class="hideVNO"></td>
    <td class="hideCUST"></td>
    <td class="hideFRM"></td>
    <td class="hideGROSSAMT">` + valuetoFixed(grandtotalGROSSAMT) + `</td>
    <td class="hideTYPE"></td>
    <td class="hideNETBILLAMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</td>
    <td class="hideGOODSRET">` + valuetoFixed(grandtotalGOODSRETURN) + `</td>
    <td class="hidePAID">` + valuetoFixed(grandtotalPAIDAMT) + `</td>
    <td class="hidePEND">` + valuetoFixed(grandtotalAmount) + `</td>
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

