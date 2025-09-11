

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
        obj.SG = Data[i].billDetails[j].SG;
        obj.DR = Data[i].billDetails[j].DR;
        obj.DA = Data[i].billDetails[j].DA;
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
  console.log(MainArr);
  MainArr = MainArr.sort(function (a, b) {
    if (parseInt(a.VNO) < 100000) {
     return new Date(a.DTE) - new Date(b.DTE) || parseInt(getValueNotDefine(a.VNO)) - parseInt(getValueNotDefine(b.VNO));
    } else {
      return new Date(a.DTE) - new Date(b.DTE)
    }
  })

  MainArr = MainArr.sort(function (a, b) {
    if (parseInt(a.VNO) > 100000) {
     return new Date(a.DTE) - new Date(b.DTE) || parseInt(getValueNotDefine(a.VNO)) - parseInt(getValueNotDefine(b.VNO));
    } else {
      return new Date(a.DTE) - new Date(b.DTE)
    }
  })
  
  if (DL > 0) {
    tr += ` <tr style="font-weight:500;font-weight:bold;background-color:#588c7e;color:white;"align="center">                    
    <th>BILL</th>
    <th class="hideCUST">CUSTOMER</th>
    <th class="date">DATE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
    <th class="hideVNO" style="display:none;">VNO</th>
    <th class="hideSUPP">SUPPLIER</th>
    <th class="hideFRM">FIRM</th>
    <th  class="hideGROSSAMT">GROSS <br>AMT</th>
    <th  class="hideTYPE" style="display:none;">TYPE</th>
    <th  class="hideNETBILLAMT">NET BILL<br>AMT</th>
    <th  class="hideGOODSRET">GOODS<br>RET.</th>
    <th  class="hidePAID">PAID <BR> AMT</th>
    <th  class="hidePEND">PEND<br>AMT.</th>
    <th class="hideDIS" style="display:none;">DIS%</th>
    <th class="hideDISAMT" style="display:none;">DISAMT</th>
    <th  class="hideDAYS">DAYS</th>
    <th  class="hideTRANSPORT">TRANSPORT</th>
    <th  class="hideLR">LR</th>
    <th class="hideGROUP" >GROUP</th>
    <th class="hideBROKER"style="display:none;">BROKER</th>
    </tr>`;
    for (o = Data.length - 1; o >= 0; o--) {

      totalNETBILLAMT = 0;
      totalGROSSAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;

      // tr += `<tr class="hideHeaddate">
      //                       <th colspan="17" class="trPartyHead" >` + formatDate(Data[o]) + `</th>                                    
      //                 </tr>
      //      `;

      var Subarray = filterBy("DTE", Data[o]);
      // console.log(Subarray);
      // Subarray=Subarray.sort(function(a,b){

      // })
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
          var BCD = "";
          var BrokerArr = getPartyDetailsBySendCode(Subarray[j].BCD);
          if (BrokerArr.length > 0) {
            BCD = getValueNotDefine(BrokerArr[0].partyname);
          }
          tr += ` 
                <tr class="hideAbleTr"align="center"style="">
                               <th ><a href="`+ FdataUrl + `" target="_blank"><button  class="PrintBtnHide">` + Subarray[j].BLL + `</button></a></th>
                               <th  class="hideCUST" style="border: 1px solid #588c7e"onclick="openSubR('`+ Subarray[j].COD + `')">` + (pcode) + `</th>
                               <th class="date">` + formatDate(Subarray[j].DTE) + `</th>                               
                              <th class="hideVNO" style="display:none;">` + (Subarray[j].VNO) + `</th>
                              <th class="hideSUPP" style="border: 1px solid #588c7e;" onclick="openSubR('`+ Subarray[j].COD + `','` + Subarray[j].ccd + `')">` + (Subarray[j].ccd) + `</th>
                              <th class="hideFRM">` + (Subarray[j].FRM) + `</th>
                              <th class="hideGROSSAMT">` + (BAMT) + `</th>
                              <th class="hideTYPE" style="display:none;">` + (Subarray[j].TYPE) + `</th>
                              <th class="hideNETBILLAMT">` + (FAMT) + `</th>
                              <th class="hideGOODSRET">` + (CLM) + `</th>
                              <th class="hidePAID">` + (RAMT) + `</th>
                              <th class="hidePEND">` + (PAMT) + `</th>
                              <tH class="hideDIS" style="display:none;">` + getValueNotDefine(Subarray[j].DR) + ` </tH> 
                              <tH class="hideDISAMT" style="display:none;">` + getValueNotDefine(Subarray[j].DA) + ` </tH> 
                              <th class="hideDAYS">` + getDaysDif(Subarray[j].DTE, nowDate) + ` </th>
                              <th class="hideTRANSPORT">` + getValueNotDefine(transport) + ` </th>
                              <th class="hideLR">` + getValueNotDefine(Subarray[j].LR) + ` </th>
                              <th class="hideGROUP">` + getValueNotDefine(Subarray[j].SG) + ` </th>                                    
                              <th class="hideBROKER"style="display:none;">` + getValueNotDefine(BCD) + ` </th>
                              
                                   
                               </tr>`;

          totalGROSSAMT += BAMT;
          totalNETBILLAMT += FAMT;
          totalGOODSRETURN += CLM;
          totalPAIDAMT += RAMT;
          totalAmount += PAMT;
        }
      }
      // tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
      // <th  colspan="5">TOTAL </th>
      // <th>` + valuetoFixed(totalGROSSAMT) + `</th>
      // <th></th>
      // <th>` + valuetoFixed(totalNETBILLAMT) + `</th>
      // <th>` + valuetoFixed(totalGOODSRETURN) + `</th>
      // <th>` + valuetoFixed(totalPAIDAMT) + `</th>
      // <th>` + valuetoFixed(totalAmount) + `</th>
      // <th colspan="3"></th>
      // </tr>`;

      grandtotalGROSSAMT += totalGROSSAMT;
      grandtotalNETBILLAMT += totalNETBILLAMT;
      grandtotalGOODSRETURN += totalGOODSRETURN;
      grandtotalPAIDAMT += totalPAIDAMT;
      grandtotalAmount += totalAmount;
    }
    tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
    <th>GRAND TOTAL </th>
    <th class="hideCUST"></th>
    <th></th>
    <th class="hideVNO"></th>
    <th class="hideSUPP"></th>
    <th class="hideFRM"></th>
    <th class="hideGROSSAMT">` + valuetoFixed(grandtotalGROSSAMT) + `</th>
    <th class="hideTYPE" style="display:none;"></th>
    <th class="hideNETBILLAMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</th>
    <th class="hideGOODSRET">` + valuetoFixed(grandtotalGOODSRETURN) + `</th>
    <th class="hidePAID">` + valuetoFixed(grandtotalPAIDAMT) + `</th>
    <th class="hidePEND">` + valuetoFixed(grandtotalAmount) + `</th>
    <tH class="hideDIS" style="display:none;" ></tH>
    <tH class="hideDISAMT" style="display:none;" ></tH>
    <th class="hideDAYS"></th>
    <th class="hideTRANSPORT"></th>
    <th class="hideLR"></th>
    <th class="hideGROUP" ></th>
    <th class="hideBROKER"style="display:none;"></th>
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

