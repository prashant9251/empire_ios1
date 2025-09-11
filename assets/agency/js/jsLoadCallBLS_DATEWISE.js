

//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
var MainArr = [];
function filterBy(oncode, value) {
  return MainArr.filter(function (d) {
    return d[oncode] === value;
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
  var totalNETBILLAMT = 0;
  var subtotalNETBILLAMT = 0;
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
        obj.BLL = Data[i].billDetails[j].BLL;
        obj.DTE = Data[i].billDetails[j].DTE;
        obj.TRN = Data[i].billDetails[j].TRN;
        obj.RNO = Data[i].billDetails[j].RNO;
        obj.LA1RT = Data[i].billDetails[j].LA1RT;
        obj.DCAMT = Data[i].billDetails[j].DCAMT;
        obj.DT = Data[i].billDetails[j].DT;
        obj.PD = Data[i].billDetails[j].PD;
        obj.SG = Data[i].billDetails[j].SG;
        obj.FAMT = Data[i].billDetails[j].FAMT;
        obj.BAMT = Data[i].billDetails[j].BAMT;
        obj.SRS = Data[i].billDetails[j].SRS;
        obj.RD = Data[i].billDetails[j].RD;

        MainArr.push(obj);
        if (DtArray.indexOf(Data[i].billDetails[j].DTE) < 0) {
          DtArray.push(Data[i].billDetails[j].DTE);
        }
      }
    }
  }

  // console.log(DtArray);
  Data = DtArray;
  Data = Data.sort(function (a, b) {
    return new Date(b) - new Date(a);
  });
  // console.log(MainArr);
  if (DL > 0) {
    grandtotalNETBILLAMT = 0;
    for (o = Data.length - 1; o >= 0; o--) {
      tr += `<tr class="trPartyHead">
                            <th colspan="15" class="trPartyHead" >` + formatDate(Data[o]) + `</th>                                    
                      </tr>
                      <tr style="font-weight:500;font-weight:bold;"align="center">                    
                      <th>BILL</th>
                      <th>PARTY NAME</th>
                      <th>BILL&nbsp;DATE</th>
                      <th class="hideDTWSUPPLIER">SUPPLIER</th>
                      <th class="hideDTWFINALAMT">FINAL AMT</th>
                      <th class="hideDTWFIRM">FIRM</th>
                      <th class="hideDTWTYPE" style="display:none;">TYPE</th>
                      <th class="hideDTWPAID">PAID</th>
                      <th class="hideDTWRECDATE">REC&nbsp;DATE</th>
                      <th class="hideDTWDIS" style="display:none;">DIS%</th>
                      <th class="hideDTWDISCAMT" style="display:none;">DISCAMT</th>
                      <th class="hideDTWTRANSPORT">TRANSPORT</th>
                      <th class="hideDTWLRNO">LR NO</th>
                      <th class="hideDTWGROUP">GROUP</th>
                      <th class="hideDTWVNO">VNO</th>
                      <th class="hideDTWRMK" style="display:none;">RMK</th>
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

          var FAMT = 0;
          if (Subarray[j].DT != null && Subarray[j].DT != "") {
            if (Subarray[j].DT.toUpperCase().indexOf('CN')) {
              FAMT = +Math.abs(Subarray[j].BAMT);
            } else if (Subarray[j].DT.toUpperCase().indexOf('DN')) {
              FAMT = -Math.abs(Subarray[j].BAMT);
            } else if (Subarray[j].DT.toUpperCase().indexOf('OS')) {
              FAMT = -Math.abs(Subarray[j].BAMT);
            } else {
              FAMT = -Math.abs(Subarray[j].BAMT);
            }
          } else {
            FAMT = -Math.abs(Subarray[j].BAMT);
          }
          var supGrpName = Subarray[j].SG;
          tr += ` 
          <tr align="center"class="hideAbleTr">
          <th><a href="`+ FdataUrl + `" target="_blank"><button  class="PrintBtnHide">` + Subarray[j].BLL + `</button></a></th>
          <th onclick="openSubR('`+ Subarray[j].COD + `')">` + pcode + `</th>
          <th onclick="openSubR('`+ Subarray[j].COD + `')">` + formatDate(Subarray[j].DTE) + `</th>
          <th class="hideDTWSUPPLIER" onclick="openSubR('`+ Subarray[j].COD + `','` + Subarray[j].ccd + `')">` + getValueNotDefine(Subarray[j].ccd) + `</th>
          <th class="hideDTWFINALAMT" onclick="openSubR('`+ Subarray[j].COD + `')">` + valuetoFixed(FAMT) + `</th>
          <th class="hideDTWFIRM" onclick="openSubR('`+ Subarray[j].COD + `')">` + Subarray[j].FRM + `</th>
          <th class="hideDTWTYPE" style="display:none;" onclick="openSubR('`+ Subarray[j].COD + `')">` + Subarray[j].SRS + `</th>
          <th class="hideDTWPAID" onclick="openSubR('`+ Subarray[j].COD + `')">` + Subarray[j].PD + `</th>
          <th onclick="openSubR('`+ Subarray[j].COD + `')" class="hideDTWRECDATE">` + formatDate(Subarray[j].RD) + `</th>
          <th class="hideDTWDIS" style="display:none;" onclick="openSubR('`+ Subarray[j].COD + `')">` + getValueNotDefine(Subarray[j].LA1RT) + `</th>
          <th class="hideDTWDISCAMT" style="display:none;" onclick="openSubR('`+ Subarray[j].COD + `')">` + getValueNotDefine(Subarray[j].DCAMT) + `</th>
          <th class="hideDTWTRANSPORT" onclick="openSubR('`+ Subarray[j].COD + `')">` + getValueNotDefine(Subarray[j].TRN) + `</th>
          <th class="hideDTWLRNO" onclick="openSubR('`+ Subarray[j].COD + `')">` + getValueNotDefine(Subarray[j].RNO) + `</th>
          <th class="hideDTWGROUP" onclick="openSubR('`+ Subarray[j].COD + `')">` + getValueNotDefine(supGrpName) + `</th>
          <th class="hideDTWVNO" onclick="openSubR('`+ Subarray[j].COD + `')">` + getValueNotDefine(Subarray[j].VNO) + `</th>
          <th class="hideDTWRMK" style="display:none;" onclick="openSubR('`+ Subarray[j].COD + `')">` + getValueNotDefine(Subarray[j].R) + `</th>
          </tr>`;

          totalNETBILLAMT += FAMT;
        }
      }
      tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
      <th >TOTAL </th>
      <th></th>
      <th></th>
      <th class="hideDTWSUPPLIER"></th>
      <th class="hideDTWFINALAMT">` + valuetoFixed(totalNETBILLAMT) + `</th>
      <th class="hideDTWFIRM"></th>
      <th class="hideDTWTYPE" style="display:none;"></th>
      <th class="hideDTWPAID"></th>
      <th class="hideDTWRECDATE"></th>
      <th class="hideDTWDIS" style="display:none;"></th>
      <th class="hideDTWDISCAMT" style="display:none;"></th>
      <th class="hideDTWTRANSPORT"></th>
      <th class="hideDTWLRNO"></th>
      <th class="hideDTWGROUP"></th>
      <th class="hideDTWVNO"></th>
      <th class="hideDTWRMK" style="display:none;"></th>

      </tr>`;
      grandtotalNETBILLAMT += totalNETBILLAMT;
      totalNETBILLAMT = 0;
    }
    tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
    <th>GRAND TOTAL </th>
    <th></th>
    <th></th>
    <th class="hideDTWSUPPLIER"></th>
    <th class="hideDTWFINALAMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</th>
    <th class="hideDTWFIRM"></th>
    <th class="hideDTWTYPE" style="display:none;"></th>
    <th class="hideDTWPAID"></th>
    <th class="hideDTWRECDATE"></th>
    <th class="hideDTWDIS" style="display:none;"></th>
    <th class="hideDTWDISCAMT" style="display:none;"></th>
    <th class="hideDTWTRANSPORT"></th>
    <th class="hideDTWLRNO"></th>
    <th class="hideDTWGROUP"></th>
    <th class="hideDTWVNO"></th>
    <th class="hideDTWRMK" style="display:none;"></th>
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

    // AddHeaderTbl();
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

