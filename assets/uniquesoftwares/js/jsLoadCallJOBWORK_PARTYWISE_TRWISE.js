
var ReportType = getUrlParams(url, "ReportType");
var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
var ReportFilter = getUrlParams(url, "ReportFilter");
var checkPcs = getUrlParams(url, "checkPcs");

function getSERIES(code) {
  // console.log(SERIES);
  return SERIES.filter(function (d) {
    return d.SERIESCODE == code;
  })
}
function getPartyWithType(party) {
  return TransactionType.filter(function (d) {
    return d.code == party;
  })
}
function getTransactionData(party, type) {
  return TransectionArray.filter(function (d) {
    return d.TYPE == type && d.code == party;
  })
}
var GRD;
var TransectionArray = [];
function jsLoadCallJOBWORK_PARTYWISE_TRWISE(data) {
  var isOrder = false;
  if (url.indexOf("PCORDER") > -1) {
    isOrder = true;
  }
  Data = data;
  console.log(Data)
  TransectionArray = [];
  flgTransactionType = [];
  TransactionType = [];
  flgPartyList = [];
  PartyList = [];
  for (var i = 0; i < Data.length; i++) {
    for (var j = 0; j < Data[i].billDetails.length; j++) {
      var obj = {};
      obj.code = Data[i].code;
      obj.GP = Data[i].GP;
      obj.IDE = Data[i].billDetails[j].IDE;
      obj.FRM = Data[i].billDetails[j].FRM;
      obj.BLL = Data[i].billDetails[j].BLL;
      obj.ql = Data[i].billDetails[j].ql;
      obj.SPS = Data[i].billDetails[j].SPS;
      obj.RPS = Data[i].billDetails[j].RPS;
      obj.CNO = Data[i].billDetails[j].CNO;
      obj.TYPE = Data[i].billDetails[j].TYPE;
      obj.VNO = Data[i].billDetails[j].VNO;
      obj.SRN = Data[i].billDetails[j].SRN;
      obj.DT = Data[i].billDetails[j].DT;
      obj.BAMT = Data[i].billDetails[j].BAMT;
      obj.PLC = Data[i].billDetails[j].PLC;
      obj.TRNP = Data[i].billDetails[j].TRNP;
      obj.RT = Data[i].billDetails[j].RT;
      obj.BCD = Data[i].billDetails[j].BCD;
      obj.S1 = Data[i].billDetails[j].S1;
      obj.S2 = Data[i].billDetails[j].S2;
      obj.SM = Data[i].billDetails[j].SM;
      obj.RM = Data[i].billDetails[j].RM;
      obj.BM = Data[i].billDetails[j].BM;
      obj.LPS = Data[i].billDetails[j].LPS;
      obj.CPS = Data[i].billDetails[j].CPS;
      obj.D = Data[i].billDetails[j].D;
      obj.C = Data[i].billDetails[j].C;
      TransectionArray.push(obj);
      if (!flgPartyList[Data[i].code]) {
        PartyList.push(Data[i].code);
        flgPartyList[Data[i].code] = true;
      }
      if (!flgTransactionType[Data[i].code + Data[i].billDetails[j].TYPE]) {
        var obj = {};
        obj.code = Data[i].code;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        TransactionType.push(obj);
        flgTransactionType[Data[i].code + Data[i].billDetails[j].TYPE] = true;
      }
    }
  }
  Data = data;
  console.log(TransectionArray, PartyList, TransactionType);

  var subtotalPEND = 0;
  var subtotalSPS = 0;
  var subtotalRPS = 0;
  var totalSPS = 0;
  var totalRPS = 0;
  var totalPEND = 0;
  var grandtotalSPS = 0;
  var grandtotalRPS = 0;
  var grandtotalPEND = 0;


  var subtotalMTSPEND = 0;
  var subtotalMTSSPS = 0;
  var subtotalMTSRPS = 0;
  var totalMTSSPS = 0;
  var totalMTSRPS = 0;
  var totalMTSPEND = 0;
  var grandtotalMTSSPS = 0;
  var grandtotalMTSRPS = 0;
  var grandtotalMTSPEND = 0;
  if (PartyList.length > 0) {
    for (let k = 0; k < PartyList.length; k++) {
      const PARTY = PartyList[k];
      var PartyArr = getPartyDetailsBySendCode(PARTY);
      console.log(PartyArr);
      var PARTY_NAME = ""
      var Mo = "";
      var label = "";
      if (PartyArr.length > 0) {
        PARTY_NAME = PartyArr[0].partyname;
        Mo = PartyArr[0].MO;
        label = PartyArr[0].label;
      }
      tr += `<tr class="trPartyHead">
   <th colspan="14" class="trPartyHead">` + label + `<a href="tel:` + Mo + `"><button> MO:` + getValueNotDefine(Mo) + `</button></a>` + `</th>
    </tr>
    `;
      var PartyWithType = getPartyWithType(PARTY);
      for (let l = 0; l < PartyWithType.length; l++) {
        const PartyWithTypeData = PartyWithType[l];
        var SERIES_NAME = "";
        var SERIES_ARR = getSERIES(PartyWithTypeData.TYPE);
        if (SERIES_ARR.length > 0) {
          SERIES_NAME = SERIES_ARR[0].SERIES;
        }
        var sendPCSType = isOrder ? "ORD.PCS" : "SEND";
        var recPCSType = isOrder ? "DISP.PCS" : "REC.";

        var sendMTSType = isOrder ? "ORD.MTS" : "SEND.MTS";
        var recMTSType = isOrder ? "DISP.MTS" : "REC.MTS";
        tr += `<tr style="background-color:#f3f3f3;color:#c107a2;" >
      <th colspan="18" class="" onclick="openSubRType('`+ PartyWithTypeData.TYPE + `','` + PARTY + `')">` + SERIES_NAME + `</th>
        </tr>

        <tr style="font-weight:500;"align="center">                        
          <th class="hideBILL">BILL </th>
          <th class="hideFIRM">FIRM</th>
          <th class="hideDATE">DATE</th>
          <th class="hideSEND">`+ sendPCSType + `</th>
          <th class="hideREC">`+ recPCSType + ` </th>
          <th class="hidePEND">PEND.</th>
          <th class="hideSENDMTS"style="display:none;">`+ sendMTSType + `</th>
          <th class="hideRECMTS"style="display:none;">`+ recMTSType + ` </th>
          <th class="hidePENDMTS"style="display:none;">PEND.MTS</th>
          <th class="hideRATE"">RATE</th>
          <th class="hideQUAL">QUAL</th>
          <th class="hideDAYS"> DAYS</th>
          <th class="hideAGHASTE">AG./HASTE</th>
          <th class="hideCOMPONENT">COMPONENT</th>
          <th class="hideRMK">RMK</th>
          <th class="hideGRP" style="display:none;">GROUP</th>
          <th class="hideTYPE" style="display:none;">TYPE</th>
          <th class="hideCHECKPCS">CHECK PCS</th>
          <th class="hideJOBTYPE">JOB TYPE</th>
          </tr>
        `;
        var TRANSACTION = getTransactionData(PARTY, PartyWithTypeData.TYPE);
        console.log(TRANSACTION);
        for (let m = 0; m < TRANSACTION.length; m++) {
          const element = TRANSACTION[m];

          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(element.CNO, element.TYPE, element.VNO, getFirmDetailsBySendCode(element.CNO)[0].FIRM, element.IDE);
          var urlopen = '';
          var PEND = 0;
          var SPS = parseInt(element.SPS == null ? 0 : element.SPS);
          var RPS = parseInt(element.RPS == null ? 0 : element.RPS);
          var PEND_MTS = 0;
          var SM = parseInt(element.SM == null ? 0 : element.SM);
          var RM = parseInt(element.RM == null ? 0 : element.RM);

          PEND = SPS - RPS;
          PEND_MTS = SM - RM;
          subtotalPEND += parseInt(PEND);
          subtotalSPS += parseInt(SPS);
          subtotalRPS += parseInt(RPS);


          subtotalMTSPEND += parseInt(PEND_MTS);
          subtotalMTSSPS += parseInt(SM);
          subtotalMTSRPS += parseInt(RM);

          var BrokerHaste = '';
          var HST = element.HST;
          if (HST != '' && HST != null && HST != undefined) {
            BrokerHaste = HST;
          } else {
            BrokerHaste = element.BCD;
          }

          console.log(element.CPS);
          tr += ` 
                            
                              <tr class="hideAbleTr"align="center"style="">
                              <td  class="hideBILL">` + getValueNotDefine(element.BLL) + `</td>
                                  <td  class="hideFIRM" onclick="openSubR('`+ element.code + `')">` + getValueNotDefine(element.FRM) + `</td>
                                  <td  class="hideDATE" onclick="openSubR('`+ element.code + `')">` + formatDate(element.DT) + `</td>
                                  <td  class="hideSEND alignRight" onclick="openSubR('`+ element.code + `')" >` + getValueNotDefineNo(SPS) + `</td>
                                  <td  class="hideREC alignRight" onclick="openSubR('`+ element.code + `')" >` + getValueNotDefineNo(RPS) + `</td>
                                  <td  class="hidePEND alignRight" onclick="openSubR('`+ element.code + `')" >` + getValueNotDefineNo(PEND) + `</td>
                                  <td  class="hideSENDMTS alignRight" onclick="openSubR('`+ element.code + `')"style="display:none;" >` + getValueNotDefineNo(SM) + `</td>
                                  <td  class="hideRECMTS alignRight" onclick="openSubR('`+ element.code + `')" style="display:none;">` + getValueNotDefineNo(RM) + `</td>
                                  <td  class="hidePENDMTS alignRight" onclick="openSubR('`+ element.code + `')" style="display:none;">` + getValueNotDefineNo(PEND_MTS) + `</td>
                                  <td  class="hideRATE alignRight" onclick="openSubR('`+ element.code + `')">` + getValueNotDefine(element.RT) + `</td>
                                  <td  class="hideQUAL" onclick="openSubR('`+ element.code + `')">` + getValueNotDefine(element.ql) + `</td>
                                  <td  class="hideDAYS" onclick="openSubR('`+ element.code + `')">` + getDaysDif(element.DT, nowDate) + ` </td>
                                  <td  class="hideAGHASTE" onclick="openBrokerSupR('`+ BrokerHaste + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                                  <td  class="hideCOMPONENT" onclick="openSubR('`+ element.code + `')">` + getValueNotDefine(element.WT) + `</td>
                                  <td  class="hideRMK" onclick="openSubR('`+ element.code + `')">` + getValueNotDefine(element.D) + `</td>
                                  <td  class="hideGRP" style="display:none;" onclick="openSubR('`+ element.code + `')">` + getValueNotDefine(element.GP) + `</td>
                                  <td  class="hideTYPE" style="display:none;" onclick="openSubR('`+ element.code + `')">` + getValueNotDefine(element.TYPE) + `</td>
                                  <td  class="hideCHECKPCS" onclick="openSubR('`+ element.code + `')">` + getValueNotDefine(element.CPS) + `</td>
                                  <td class="hideJOBTYPE" onclick="openSubR('`+ element.code + `')">` + getValueNotDefine(element.C) + `</td>
                              </tr>`;
        }

        totalSPS += subtotalSPS;
        totalRPS += subtotalRPS;
        totalPEND += subtotalPEND;



        totalMTSSPS += subtotalMTSSPS;
        totalMTSRPS += subtotalMTSRPS;
        totalMTSPEND += subtotalMTSPEND;

        if (PartyWithType.length > 1) {
          tr += `<tr class="tfootcard">
                              <td  class="hideBILL">SUBTOTAL</td>
                              <td  class="hideFIRM" ></td>
                              <td  class="hideDATE" ></td>
                              <td  class="hideSEND alignRight"  >` + valuetoFixedNo(subtotalSPS) + `</td>                              
                              <td  class="hideREC alignRight"  >` + valuetoFixedNo(subtotalRPS) + `</td>
                              <td  class="hidePEND alignRight"  >` + valuetoFixedNo(subtotalPEND) + `</td>
                              <td  class="hideSENDMTS alignRight"style="display:none;"  >` + valuetoFixedNo(subtotalMTSSPS) + `</td>                              
                              <td  class="hideRECMTS alignRight" style="display:none;" >` + valuetoFixedNo(subtotalMTSRPS) + `</td>
                              <td  class="hidePENDMTS alignRight" style="display:none;" >` + valuetoFixedNo(subtotalMTSPEND) + `</td>
                              <td  class="hideRATE alignRight"></td>
                              <td  class="hideQUAL" ></td>
                              <td  class="hideDAYS" ></td>
                              <td  class="hideAGHASTE" ></td>
                              <td  class="hideCOMPONENT" ></td>
                              <td  class="hideRMK" ></td>
                              <td  class="hideGRP" style="display:none;" ></td>
                              <td  class="hideTYPE" style="display:none;" ></td>
                              <td  class="hideCHECKPCS" ></td>
                              <td class="hideJOBTYPE"></td>
                              </tr>`;
        }

        subtotalSPS = 0;
        subtotalRPS = 0;
        subtotalPEND = 0;


        subtotalMTSSPS = 0;
        subtotalMTSRPS = 0;
        subtotalMTSPEND = 0;
      }
      grandtotalSPS += totalSPS;
      grandtotalRPS += totalRPS;
      grandtotalPEND += totalPEND;


      grandtotalMTSSPS += totalMTSSPS;
      grandtotalMTSRPS += totalMTSRPS;
      grandtotalMTSPEND += totalMTSPEND;
      tr += `<tr class="tfootcard">
    <td  class="hideBILL">TOTAL</td>
    <td  class="hideFIRM" ></td>
    <td  class="hideDATE" ></td>
    <td  class="hideSEND alignRight"  >` + valuetoFixedNo(totalSPS) + `</td>                              
    <td  class="hideREC alignRight"  >` + valuetoFixedNo(totalRPS) + `</td>
    <td  class="hidePEND alignRight"  >` + valuetoFixedNo(totalPEND) + `</td>
    <td  class="hideSENDMTS alignRight" style="display:none;" >` + valuetoFixedNo(totalMTSSPS) + `</td>                              
    <td  class="hideRECMTS alignRight"  style="display:none;">` + valuetoFixedNo(totalMTSRPS) + `</td>
    <td  class="hidePENDMTS alignRight" style="display:none;" >` + valuetoFixedNo(totalMTSPEND) + `</td>
    <td  class="hideRATE alignRight"></td>
    <td  class="hideQUAL" ></td>
    <td  class="hideDAYS" ></td>
    <td  class="hideAGHASTE" ></td>
    <td  class="hideCOMPONENT" ></td>
    <td  class="hideRMK" ></td>
    <td  class="hideGRP" style="display:none;"></td>
    <td  class="hideTYPE" style="display:none;"></td>
    <td  class="hideCHECKPCS" ></td>
    <td class="hideJOBTYPE"></td>
    </tr>`;
      totalSPS = 0;
      totalRPS = 0;
      totalPEND = 0;
    }

    if (PartyList.length > 1) {
      tr += `<tr class="tfootcard">
  <td  class="hideBILL">GRANDTOTAL</td>
  <td  class="hideFIRM" ></td>
  <td  class="hideDATE" ></td>
  <td  class="hideSEND alignRight">` + valuetoFixedNo(grandtotalSPS) + `</td>                              
  <td  class="hideREC alignRight">` + valuetoFixedNo(grandtotalRPS) + `</td>
  <td  class="hidePEND alignRight">` + valuetoFixedNo(grandtotalPEND) + `</td>
  <td  class="hideSENDMTS alignRight" style="display:none;">` + valuetoFixedNo(grandtotalMTSSPS) + `</td>                              
  <td  class="hideRECMTS alignRight" style="display:none;">` + valuetoFixedNo(grandtotalMTSRPS) + `</td>
  <td  class="hidePENDMTS alignRight" style="display:none;">` + valuetoFixedNo(grandtotalMTSPEND) + `</td>
  <td  class="hideRATE alignRight"></td>
  <td  class="hideQUAL" ></td>
  <td  class="hideDAYS" ></td>
  <td  class="hideAGHASTE" ></td>
  <td  class="hideCOMPONENT" ></td>
  <td  class="hideRMK" ></td>
  <td  class="hideGRP" style="display:none;" ></td>
  <td  class="hideTYPE" style="display:none;" ></td>
  <td  class="hideCHECKPCS"></td>
  <td class="hideJOBTYPE"></td>
  </tr>`;
    }

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    hideList();
  } else {

    $('#result').html('<h1 align="center">No Data Found</h1>');
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

