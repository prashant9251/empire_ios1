var GRD;
var url = window.location.href;
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

var hideAbleTr = getUrlParams(url, "hideAbleTr");

function loadCall(Data) {
  //---------------
  console.log(Data);
  var GST;
  var FdataUrl;
  var DETAILSDET;
  var ccode;
  var pcode;
  var city;
  var broker;
  var label;
  var grandTotalGrossAmt = 0;
  var grandTotalfinalAmt = 0;
  var subtotalGrossAmt = 0;
  var subtotalFinalAmt = 0;
  var totalGrossAmt = 0;
  var totalFinalAmt = 0;
  var DL = Data.length;
  var BLL;
  if (DL > 0) {
    grandTotalGrossAmt = 0;
    grandTotalfinalAmt = 0;
    tr = "<tbody>";

    for (i = 0; i < DL; i++) {
      ccode = getPartyDetailsBySendCode(Data[i].COD);
      var CST_GRP = "";
      if (ccode.length > 0) {
        pcode = getValueNotDefine(ccode[0].partyname);
        city = getValueNotDefine(ccode[0].city);
        broker = getValueNotDefine(ccode[0].broker);
        label = getValueNotDefine(ccode[0].label);
        CST_GRP = getValueNotDefine(ccode[0].GP);
      }
      tr += `
                <tr class="trPartyHead"  onclick="trOnClick('` + Data[i].COD + `','` + city + `','` + broker + `');">
                          <th  class="trPartyHead" colspan="13">` + label + `</th>                                    
                        </tr>`;

      BLL = Data[i].billDetails.length;
      if (BLL > 0) {

        subtotalGrossAmt = 0;
        subtotalfinalAmt = 0;
        var codex = null;
        var CodePrev = null;
        for (j = 0; j < BLL; j++) {
          var sr = 0
          codex = Data[i].billDetails[j].ccd;
          if (j == 0 && codex != CodePrev) {
            tr += ` <tr style="font-weight:500;font-weight:bold;"align="center">                    
            <th class="unhideAbleTr">SELECT </th>
            <th class="hidePWSPBILL">BILL</th>
            <th class="hidePWSPBILLDATE">BILL&nbsp;DATE</th>
            <th class="hidePWSPPARTYNAME">PARTY NAME</th>
            <th class="hidePWSPGROSSAMT" style="display:none;">GROSS AMT</th>
            <th class="hidePWSPFINALAMT">FINAL AMT</th>
            <th class="hidePWSPGR" style="display:none;">GR</th>
            <th class="hidePWSPFIRM">FIRM</th>
            <th class="hidePWSPTYPE">TYPE</th>
            <th class="hidePWSPPAID">PAID</th>
            <th class="hidePWSPRECDATE">REC&nbsp;DATE</th>
            <th class="hidePWSPDIS" style="display:none;">DIS%</th>
            <th class="hidePWSPDISCAMT" style="display:none;">DISCAMT</th>
            <th class="hidePWSPTRANSPORT">TRANSPORT</th>
            <th class="hidePWSPLR NO">LR NO</th>
            <th class="hidePWSPGROUP">GROUP</th>
            <th class="hidePWSPVNO">VNO</th>
            </tr>  `;
            CodePrev = codex;
          }
          var ID = codex;

          if (j != 0 && codex != CodePrev) {
            tr += `  
            <tr class="tfootcard"style="background-color:#3e3b3b26;color:#c107a2;text-align: center;">
            <th class="unhideAbleTr">
            <input type="checkbox" checked id="selectField_`+ ID + `"partycode="`+ Data[i].COD+`" ccd="` +  Data[i].billDetails[j].ccd + `"/> </th>            
            <th class="hideAbleTr"colspan="3">SUBTOTAL</th>
            <th class="unhideAbleTr" colspan="3"onclick="openSubR('`+ Data[i].COD + `','` + Data[i].billDetails[j - 1].ccd + `')">` + Data[i].billDetails[j - 1].ccd + `</th>
            <th class="hidePWSPGROSSAMT" style="display:none;">` + valuetoFixed(subtotalGrossAmt) + `</th>            
            <th>` + valuetoFixed(subtotalFinalAmt) + `</th>
            <th colspan="10"></th>
            </tr>  `;
            CodePrev = codex;
            totalGrossAmt += subtotalGrossAmt;
            totalFinalAmt += subtotalFinalAmt;
            subtotalGrossAmt = 0;
            subtotalFinalAmt = 0;
          }

          var grsAmt = 0;
          var fnlAmt = 0;
          if (Data[i].billDetails[j].DT != null && Data[i].billDetails[j].DT != "") {
            if (Data[i].billDetails[j].DT.toUpperCase().indexOf('CN')) {
              grsAmt = +Math.abs(Data[i].billDetails[j].GAMT);
              fnlAmt = +Math.abs(Data[i].billDetails[j].BAMT);
            } else if (Data[i].billDetails[j].DT.toUpperCase().indexOf('DN')) {
              grsAmt = -Math.abs(Data[i].billDetails[j].GAMT);
              fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
            } else if (Data[i].billDetails[j].DT.toUpperCase().indexOf('OS')) {
              grsAmt = -Math.abs(Data[i].billDetails[j].GAMT);
              fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
            } else {
              grsAmt = -Math.abs(Data[i].billDetails[j].GAMT);
              fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
            }
          } else {
            grsAmt = -Math.abs(Data[i].billDetails[j].GAMT);
            fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
          }
          subtotalGrossAmt += parseInt(grsAmt);
          subtotalFinalAmt += parseInt(fnlAmt);
          GST = parseFloat(Data[i].billDetails[j].VTAMT) + parseFloat(Data[i].billDetails[j].ADVTAMT);
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE);

          var supGrpName = Data[i].billDetails[j].SG;
          tr += `<tr align="center"class="hideAbleTr">
                        <th  class="hidePWSPBILL"><a href="`+ FdataUrl + `" target="_blank"><button class="PrintBtnHide">` + Data[i].billDetails[j].BLL + `</button></a></th>
                        <th  class="hidePWSPBILLDATE" onclick="openSubR('`+ Data[i].COD + `')">` + formatDate(Data[i].billDetails[j].DTE) + `</th>
                        <th  class="hidePWSPPARTYNAME" onclick="openSubR('`+ Data[i].COD + `','` + Data[i].billDetails[j].ccd + `')">` + getValueNotDefine(Data[i].billDetails[j].ccd) + `</th>
                        <th class="hidePWSPGROSSAMT" style="display:none;"onclick="openSubR('`+ Data[i].COD + `')">` + valuetoFixed(grsAmt) + `</th>
                        <th  class="hidePWSPFINALAMT" onclick="openSubR('`+ Data[i].COD + `')">` + valuetoFixed(fnlAmt) + `</th>
                        <th class="hidePWSPGR" style="display:none;"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(Data[i].billDetails[j].CLM) + `</th>
                        <th  class="hidePWSPFIRM" onclick="openSubR('`+ Data[i].COD + `')">` + Data[i].billDetails[j].FRM + `</th>
                        <th  class="hidePWSPTYPE" onclick="openSubR('`+ Data[i].COD + `')">` + Data[i].billDetails[j].SRS + `</th>
                        <th  class="hidePWSPPAID" onclick="openSubR('`+ Data[i].COD + `')">` + Data[i].billDetails[j].PD + `</th>
                        <th  class="hidePWSPRECDATE" onclick="openSubR('`+ Data[i].COD + `')">` + formatDate(Data[i].billDetails[j].RD) + `</th>
                        <th  class="hidePWSPDIS" style="display:none;"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(Data[i].billDetails[j].LA1RT) + `</th>
                        <th  class="hidePWSPDISCAMT" style="display:none;"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(Data[i].billDetails[j].DCAMT) + `</th>
                        <th  class="hidePWSPTRANSPORT"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(Data[i].billDetails[j].TRN) + `</th>
                        <th  class="hidePWSPLR NO"onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(Data[i].billDetails[j].RNO) + `</th>
                        <th  class="hidePWSPGROUP" onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(supGrpName) + `</th>
                        <th  class="hidePWSPVNO" onclick="openSubR('`+ Data[i].COD + `')">` + getValueNotDefine(Data[i].billDetails[j].VNO) + `</th>
                        </tr>`;

          if (j == BLL - 1) {
            tr += `  
            <tr class="tfootcard"style="background-color:white;color:#c107a2;text-align: center;">
            <th class="unhideAbleTr">
            <input type="checkbox" checked id="selectField_`+ ID + `"partycode="`+ Data[i].COD+`" ccd="` +  Data[i].billDetails[j].ccd + `"/> </th>            
            <th class="hideAbleTr"colspan="3">SUBTOTAL</th>
            <th class="unhideAbleTr" colspan="3"onclick="openSubR('`+ Data[i].COD + `','` + Data[i].billDetails[j].ccd + `')">` + Data[i].billDetails[j].ccd + `</th>
            <th class="hidePWSPGROSSAMT" style="display:none;">` + valuetoFixed(subtotalGrossAmt) + `</th>            
            <th>` + valuetoFixed(subtotalFinalAmt) + `</th>            
            <th colspan="7"></th>
            <th colspan="4"></th>
            </tr>  `;
            totalGrossAmt += subtotalGrossAmt;
            totalFinalAmt += subtotalFinalAmt;
            subtotalGrossAmt = 0;
            subtotalFinalAmt = 0;

          }
        }
      }
      grandTotalGrossAmt += totalGrossAmt;
      grandTotalfinalAmt += totalFinalAmt;
      tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
    <th class="unhideAbleTr"> </th>
    <th colspan="3">TOTAL</th>
      <th class="hidePWSPGROSSAMT" style="display:none;">`+ valuetoFixed(totalGrossAmt) + `</th>
      <th >`+ valuetoFixed(totalFinalAmt) + `</th>
      <th colspan="7"></th>
      <thcolspan="4"></th>
      </tr>`;
      totalGrossAmt = 0;
      totalFinalAmt = 0;
    }
    tr += `
                    <tr class="tfootcard"style="background-color:#3e3b3b26;color:#080844;">
                  <th class="unhideAbleTr"> </th>
                  <th >GRAND TOTAL</th>
                  <th  class="hidePWSPBILL"></th>
                  <th  class="hidePWSPBILLDATE"></th>
                  <th  class="hidePWSPGROSSAMT" style="display:none;">`+ valuetoFixed(grandTotalGrossAmt) + `</th>
                  <th  class="hidePWSPPARTYNAME">`+ valuetoFixed(grandTotalfinalAmt) + `</th>
                  <th  class="hidePWSPFINALAMT"></th>
                  <th  class="hidePWSPFIRM"></th>
                  <th  class="hidePWSPTYPE"></th>
                  <th  class="hidePWSPPAID"></th>
                  <th class="hidePWSPRECDATE"></th>
                  <th class="hidePWSPDIS" style="display:none;"></th>
                  <th class="hidePWSPDISCAMT" style="display:none;"></th>
                  <th  class="hidePWSPTRANSPORT"></th>
                  <th  class="hidePWSPLR NO"></th>
                  <th  class="hidePWSPGROUP"></th>
                  <th  class="hidePWSPVNO"></th>

                    </tr></tbody>`;

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    if ((url).indexOf('ALLSALE_AJXREPORT') < 0) {
      $(".TRNSPT").css("display", "none");
    }
    if (hideAbleTr == "true") {
      $('.hideAbleTr').css("display", "none");
      $('.unhideAbleTr').css("display", "");
      $('#footer').css("display", "");    
    } else {
      $('.unhideAbleTr').css("display", "none");
    }
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }
  // try { } catch (error) {
  //   alert(error)
  // $('#result').html(tr);
  // $("#loader").removeClass('has-loader');

  // }
}
