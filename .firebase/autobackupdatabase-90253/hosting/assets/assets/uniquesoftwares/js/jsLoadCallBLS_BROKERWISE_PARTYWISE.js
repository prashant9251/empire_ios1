
var TransectionArray = [];
var BrokerNameList = [];
var PartyNameList = [];
function filterByBrokerOrParty(partyName, bcode) {
  return TransectionArray.filter(function (d) {
    return d.code == partyName && d.BCODE == bcode;
  });
}
function getBrokerPartyList(code) {
  return PartyNameList.filter(function (d) {
    return d.BCODE == code;
  })
}
// console.log(ReportType, ReportSeriesTypeCode, ReportATypeCode, ReportDOC_TYPECode);

var GRD;
function loadCallBROKERWISE_PARTYWISE(data) {
  tr = '';
  TransectionArray = [];
  BrokerNameList = [];
  PartyNameList = [];
  Data = data;
  var ccode;
  var pcode = "";
  var city;
  var broker = "";
  var label = "";
  var grandtotalNETBILLAMT = 0;
  var grandtotalGROSSAMT = 0;
  var grandtotalGOODSRETURN = 0;
  var grandtotalPAIDAMT = 0;
  var grandtotalAmount = 0;
  var totalNETBILLAMT;
  var totalGROSSAMT;
  var totalGOODSRETURN;
  var totalPAIDAMT;
  var totalAmount;
  var BLL;
  var FdataUrl
  var DL = Data.length;
  if (DL > 0) {
// console.log(Data);
    var flagParty = [];
    var flagBroker = [];

    for (var i = 0; i < Data.length; i++) {
      for (var j = 0; j < Data[i].billDetails.length; j++) {
        var obj = {};
        obj.code = Data[i].code;
        obj.IDE = Data[i].billDetails[j].IDE;
        obj.sft = Data[i].billDetails[j].sft;
        obj.year = Data[i].billDetails[j].year;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.CITY = Data[i].billDetails[j].CITY;
        obj.SERIES = Data[i].billDetails[j].SERIES;
        obj.ACCODE = Data[i].billDetails[j].ACCODE;
        obj.ATYP = Data[i].billDetails[j].ATYP;
        obj.CNO = Data[i].billDetails[j].CNO;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.VNO = Data[i].billDetails[j].VNO;
        obj.ADAT = Data[i].billDetails[j].ADAT;
        obj.BILL = Data[i].billDetails[j].BILL;
        obj.DATE = Data[i].billDetails[j].DATE;
        obj.CHLN = Data[i].billDetails[j].CHLN;
        obj.RRNO = Data[i].billDetails[j].RRNO;
        obj.RRDET = Data[i].billDetails[j].RRDET;
        obj.WGT = Data[i].billDetails[j].WGT;
        obj.FRT = Data[i].billDetails[j].FRT;
        obj.CSNO = Data[i].billDetails[j].CSNO;
        obj.PLC = Data[i].billDetails[j].PLC;
        obj.TRNSP = Data[i].billDetails[j].TRNSP;
        obj.BAMT = Data[i].billDetails[j].BAMT;
        obj.TMTS = Data[i].billDetails[j].TMTS;
        obj.TPCS = Data[i].billDetails[j].TPCS;
        obj.RC_AMT = Data[i].billDetails[j].RC_AMT;
        obj.DISC = Data[i].billDetails[j].DISC;
        obj.OTH_LS = Data[i].billDetails[j].OTH_LS;
        obj.RD_AMT = Data[i].billDetails[j].RD_AMT;
        obj.clms = Data[i].billDetails[j].clms;
        obj.SWTS_AMT = Data[i].billDetails[j].SWTS_AMT;
        obj.DDCOM = Data[i].billDetails[j].DDCOM;
        obj.AD_AMT = Data[i].billDetails[j].AD_AMT;
        obj.PART = Data[i].billDetails[j].PART;
        obj.WT_LS = Data[i].billDetails[j].WT_LS;
        obj.WT_LSRATE = Data[i].billDetails[j].WT_LSRATE;
        obj.WT_LSAMT = Data[i].billDetails[j].WT_LSAMT;
        obj.fnlamt = Data[i].billDetails[j].fnlamt;
        obj.paid = Data[i].billDetails[j].paid;
        obj.RMK = Data[i].billDetails[j].RMK;
        obj.PRCL = Data[i].billDetails[j].PRCL;
        obj.grsamt = Data[i].billDetails[j].grsamt;
        obj.billdis = Data[i].billDetails[j].billdis;
        obj.BCODE = Data[i].billDetails[j].BCODE;
        obj.PRCL = Data[i].billDetails[j].PRCL;
        obj.PAYCHQ = Data[i].billDetails[j].PAYCHQ;
        obj.PAYDET = Data[i].billDetails[j].PAYDET;
        obj.CNVTAMT = Data[i].billDetails[j].CNVTAMT;
        obj.ad_oth2 = Data[i].billDetails[j].ad_oth2;
        obj.haste = Data[i].billDetails[j].haste;
        obj.WT_LSBASE = Data[i].billDetails[j].WT_LSBASE;
        obj.TDSRATE = Data[i].billDetails[j].TDSRATE;
        obj.TDSAMT = Data[i].billDetails[j].TDSAMT;
        obj.QUAL = Data[i].billDetails[j].QUAL;
        obj.GRT = Data[i].billDetails[j].GRT;
        obj.discamt = Data[i].billDetails[j].discamt;
        obj.LA1qty = Data[i].billDetails[j].LA1qty;
        obj.LA2qty = Data[i].billDetails[j].LA2qty;
        obj.LA3qty = Data[i].billDetails[j].LA3qty;
        obj.LA1RMK = Data[i].billDetails[j].LA1RMK;
        obj.LA2RMK = Data[i].billDetails[j].LA2RMK;
        obj.LA3RMK = Data[i].billDetails[j].LA3RMK;
        obj.LA1RATE = Data[i].billDetails[j].LA1RATE;
        obj.LA2RATE = Data[i].billDetails[j].LA2RATE;
        obj.LA3RATE = Data[i].billDetails[j].LA3RATE;
        obj.LA1AMT = Data[i].billDetails[j].LA1AMT;
        obj.LA2AMT = Data[i].billDetails[j].LA2AMT;
        obj.LA3AMT = Data[i].billDetails[j].LA3AMT;
        obj.OTHRTYPE = Data[i].billDetails[j].OTHRTYPE;
        obj.GRYCT = Data[i].billDetails[j].GRYCT;
        obj.LDRRMK = Data[i].billDetails[j].LDRRMK;
        obj.VTRET = Data[i].billDetails[j].VTRET;
        obj.VTAMT = Data[i].billDetails[j].VTAMT;
        obj.ADVTRET = Data[i].billDetails[j].ADVTRET;
        obj.ADVTAMT = Data[i].billDetails[j].ADVTAMT;
        obj.EWB = Data[i].billDetails[j].EWB;
        obj.STC = Data[i].billDetails[j].STC;
        obj.DT = Data[i].billDetails[j].DT;
        obj.GRD = Data[i].billDetails[j].GRD;

        TransectionArray.push(obj);
        if (!flagBroker[Data[i].billDetails[j].BCODE]) {
          BrokerNameList.push(Data[i].billDetails[j].BCODE);
          flagBroker[Data[i].billDetails[j].BCODE] = true;
        }
        if (!flagParty[Data[i].code + Data[i].billDetails[j].BCODE]) {
          var obj = {};
          obj.code = Data[i].code;
          obj.BCODE = Data[i].billDetails[j].BCODE;
          PartyNameList.push(obj);
          flagParty[Data[i].code + Data[i].billDetails[j].BCODE] = true;
        }
      }
    }
// console.log(PartyNameList);
// console.log(BrokerNameList);
    BrokerNameList = BrokerNameList.sort()

    var grandTotalGrossAmt = 0;
    var grandTotalfinalAmt = 0;
    var grandtotalMTS = 0;
    var grandTotalParcel = 0;
    var totalsr = 0;



    var subTotalGrossAmt = 0;
    var subTotalfinalAmt = 0;
    var subtotalMTS = 0;
    var subtotalsr = 0;
    var subtotalParcel = 0;

    var tr = '';
    for (var i = 0; i < BrokerNameList.length; i++) {

      var totalNETBILLAMT = 0;
      var totalGROSSAMT = 0;
      var totalGOODSRETURN = 0;
      var totalPAIDAMT = 0;
      var totalAmount = 0;
      var totalParcel = 0;
      var BrokerArr = getPartyDetailsBySendCode(BrokerNameList[i]);
      var BContact = "";
      var BMO = "";
      if (BrokerArr.length > 0) {
        BMO = getValueNotDefine(BrokerArr[0].MO);
        BContact = `,<a onclick="dialNo(` + getValueNotDefine(BrokerArr[0].MO) + `)">` + getValueNotDefine(BrokerArr[0].MO) + `</a>`;
        BContact += `,<a onclick="dialNo(` + getValueNotDefine(BrokerArr[0].PH1) + `)">` + getValueNotDefine(BrokerArr[0].PH1) + `</a>`;
        BContact += `,<a onclick="dialNo(` + getValueNotDefine(BrokerArr[0].PH1) + `)">` + getValueNotDefine(BrokerArr[0].PH1) + `</a>`;
       }
      tr += `<tr class="pinkHeading">
            <th  colspan="16"><b  onclick="openBrokerSupR('`+ BrokerNameList[i] + `','` + BMO + `')">` + BrokerNameList[i] + "</b>" + BContact + `</th>
        </tr>`;

      var uniqBrokerPartyList = getBrokerPartyList(BrokerNameList[i])
      uniqBrokerPartyList = uniqBrokerPartyList.sort((a, b) => {
        if (a.code > b.code)
          return 1;
        if (a.code < b.code)
          return -1;
        return 0;
      });
      for (var j = 0; j < uniqBrokerPartyList.length; j++) {
        ccode = getPartyDetailsBySendCode(uniqBrokerPartyList[j].code);
        var pcode = "";
        var city = "";
        var broker = "";
        if (ccode.length > 0) {
          label = getValueNotDefine(ccode[0].label);
          pcode = getValueNotDefine(ccode[0].value);
          city = getValueNotDefine(ccode[0].city);
          broker = getValueNotDefine(ccode[0].broker);
        }
        tr += `<tr class="trPartyHead"  onclick="trOnClick('` + pcode + `','` + city + `','` + broker + `');">
            <th class="trPartyHead" colspan="23">`+ label + `</th>
        </tr>`;
        tr += `<tr style="font-weight:500;"align="center">
                    
        <td class="pdfBtnHide">PDF</td>
        <td class="selectBoxReport" style="display:none;">SELECT</td>
        <td>BILL</td>
        <td class="hideDATE">BILL&nbsp;DATE</td>
        <td class="hideFIRM">FIRM</td>
        <td class="hideGROSSAMT">GROSS.AMT</td>
        <td class="hideGST">GST</td>
        <td class="hideTYPE">TYPE</td>
        <td class="hideQUAL hqual">QUAL</td>
        <td class="hideMTS hmts">MTS</td>
        <td class="hidePARCEL" style="display:none;">PARCEL</td>
        <td class="hideFINALAMT">BILL AMT</td>
        <td class="hidePAID">PAID</td>
        <td class="hideAGHASTE">AG./HASTE</td>
        <td class="hideTRANSPORT">TRANSPORT</td>
        <td class="hideLRNO">LR NO</td>
        <td class="hideGRADE">GRADE</td>
        <td class="hideEWB">EWB</td>
        <td class="hideDAYS">DAYS</td>
        </tr>`;
        var Data = filterByBrokerOrParty(uniqBrokerPartyList[j].code, BrokerNameList[i]);
        if (Data.length > 0) {
          totalGrossAmt = 0;
          totalFinalAmt = 0;
          totalMTS = 0;
          var sr = 0;
          for (var k = 0; k < Data.length; k++) {
            sr += 1;
            var grsAmt = 0;
            var fnlAmt = 0;
            if (Data[k].DT != null && Data[k].DT != "") {
              if (Data[k].DT.toUpperCase().indexOf('CN')) {
                grsAmt = +Math.abs(Data[k].grsamt);
                fnlAmt = +Math.abs(Data[k].BAMT);
              } else if (Data[k].DT.toUpperCase().indexOf('DN')) {
                grsAmt = -Math.abs(Data[k].grsamt);
                fnlAmt = -Math.abs(Data[k].BAMT);
              } else if (Data[k].DT.toUpperCase().indexOf('OS')) {
                grsAmt = -Math.abs(Data[k].grsamt);
                fnlAmt = -Math.abs(Data[k].BAMT);
              } else {
                grsAmt = -Math.abs(Data[k].grsamt);
                fnlAmt = -Math.abs(Data[k].BAMT);
              }
            } else {
              grsAmt = -Math.abs(Data[k].grsamt);
              fnlAmt = -Math.abs(Data[k].BAMT);
            }
            TMTS = Data[k].TMTS == null ? 0 : parseFloat(Data[k].TMTS);
            totalGrossAmt += parseFloat(grsAmt);
            totalFinalAmt += parseFloat(fnlAmt);
            totalMTS += TMTS;
            GST = parseFloat(Data[k].VTAMT) + parseFloat(Data[k].ADVTAMT);
            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[k].CNO, Data[k].TYPE, Data[k].VNO, getFirmDetailsBySendCode(Data[k].CNO)[0].FIRM, Data[k].IDE, ccode[0].MO, ccode[0].EML);

            var BrokerHaste = '';
            var HST = Data[k].haste;
            if (HST != '' && HST != null && HST != undefined) {
              BrokerHaste = HST;
            } else {
              BrokerHaste = Data[k].BCODE;
            }
            var ID = Data[k].CNO + Data[k].TYPE + Data[k].VNO;

            const PARCEL = Data[k].PRCL;
            totalParcel += parseInt(PARCEL);
            tr += `<tr align="center"class="hideAbleTr">
                          <th class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                          <td class="selectBoxReport" style="display:none;">      <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + Data[k].CNO + `"DTYPE="` + Data[k].TYPE + `"VNO="` + Data[k].VNO + `"/></td>
                          <td><a href="`+ FdataUrl + `" target="_blank"><button>` + Data[k].BILL + `</button><a></td>
                          <td class="hideDATE" onclick="openSubR('`+ Data[k].code + `')">` + formatDate(Data[k].DATE) + `</td>
                          <td class="hideFIRM" onclick="openSubR('`+ Data[k].code + `')">` + Data[k].FRM + `</td>
                          <td class="hideGROSSAMT" onclick="openSubR('`+ Data[k].code + `')">` + valuetoFixed(grsAmt) + `</td>
                          <td class="hideGST" onclick="openSubR('`+ Data[k].code + `')">` + valuetoFixed(GST) + `</td>
                          <td class="hideTYPE" onclick="openSubR('`+ Data[k].code + `')">` + Data[k].SERIES + `</td>
                          <td class="hideQUAL hqual" onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(Data[k].QUAL) + `</td>
                          <td class="hideMTS hmts" onclick="openSubR('`+ Data[k].code + `')">` + TMTS + `</td>
                          <td class="hidePARCEL" style="display:none;" onclick="openSubR('`+ Data[k].code + `')">` + PARCEL + `</td>
                          <td class="hideFINALAMT" onclick="openSubR('`+ Data[k].code + `')">` + valuetoFixed(fnlAmt) + `</td>
                          <td class="hidePAID" onclick="openSubR('`+ Data[k].code + `')">` + Data[k].paid + `</td>
                          <td class="hideAGHASTE" onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                          <td class="hideTRANSPORT" onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(Data[k].TRNSP) + `</td>
                          <td class="hideLRNO" onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(Data[k].RRNO) + `</td>
                          <td class="hideGRADE" onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(Data[k].GRD) + ` </td>
        <td class="hideEWB"onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(Data[k].EWB) + ` </td>
        <td class="hideDAYS"onclick="openSubR('`+ Data[k].code + `')">` + getDaysDif(Data[k].DATE, nowDate) + ` </td>
        </tr>`;


          }

        }
        subTotalGrossAmt += totalGrossAmt;
        subTotalfinalAmt += totalFinalAmt;
        subtotalMTS += totalMTS;
        subtotalParcel += totalParcel;
        tr += `<tr class="tfootcard">
        <td class="pdfBtnHide"></td>
        <td class="selectBoxReport" style="display:none;"></td>
                          <td class="hideDATE" >TOTAL</td>
                          <td class="hideFIRM" ></td>
                          <td class="hideGROSSAMT" >(`+ sr + `)<td>
                          <td class="hideGST" >`+ valuetoFixed(totalGrossAmt) + `</td>
                          <td class="hideTYPE" ></td>
                          <td class="hideQUAL hqual" ></td>                        
                          <td class="hideMTS hmts" >`+ valuetoFixed(totalMTS) + `</td>
                          <td class="hidePARCEL" style="display:none;" >`+ totalParcel + `</td>
                          <td class="hideFINALAMT" >`+ valuetoFixed(totalFinalAmt) + `</td>
                          <td class="hidePAID" ></td>
                          <td class="hideAGHASTE" ></td>
                          <td class="hideTRANSPORT" ></td>
                          <td class="hideLRNO" ></td>
                          <td class="hideGRADE"></td>
        <td class="hideEWB"></td>
        <td class="hideDAYS"></td>
        </tr>`;

        subtotalsr += sr;
      }
      tr += `<tr class="tfootcard">
      <td class="pdfBtnHide"></td>
      <td class="selectBoxReport" style="display:none;"></td>
                        <td class="hideDATE" >TOTAL</td>
                        <td class="hideFIRM" ></td>
                        <td class="hideGROSSAMT" >(`+ sr + `)<td>
                        <td class="hideGST" >`+ valuetoFixed(subtotalGrossAmt) + `</td>
                        <td class="hideTYPE" ></td>
                        <td class="hideQUAL hqual" ></td>                        
                        <td class="hideMTS hmts" >`+ valuetoFixed(subtotalMTS) + `</td>
                        <td class="hidePARCEL" style="display:none;" >`+ subtotalParcel + `</td>
                        <td class="hideFINALAMT" >`+ valuetoFixed(subtotalFinalAmt) + `</td>
                        <td class="hidePAID" ></td>
                        <td class="hideAGHASTE" ></td>
                        <td class="hideTRANSPORT" ></td>
                        <td class="hideLRNO" ></td>
                        <td class="hideGRADE"></td>
        <td class="hideEWB"></td>
        <td class="hideDAYS"></td>
        </tr>`;
    }

    totalsr += subtotalsr;
    grandTotalGrossAmt += subTotalGrossAmt;
    grandTotalfinalAmt += subTotalfinalAmt;
    grandtotalMTS += subtotalMTS;
    grandTotalParcel += subtotalParcel
    tr += `
    <tr class="tfootcard">
        <td class="pdfBtnHide"></td>
        <td class="selectBoxReport" style="display:none;"></td>
    <td class="hideDATE">GRAND TOTAL</td>
    <td class="hideFIRM"></td>
    <td class="hideGROSSAMT">(`+ totalsr + `)<td>
    <td class="hideGST">`+ valuetoFixed(grandTotalGrossAmt) + `</td>
    <td class="hideTYPE"></td>
    <td class="hideQUAL hqual"></td>
    <td class="hideMTS hmts">`+ valuetoFixed(grandtotalMTS) + `</td>
    <td class="hidePARCEL" style="display:none;">`+ grandTotalParcel + `</td>
    <td class="hideFINALAMT">`+ valuetoFixed(grandTotalfinalAmt) + `</td>
    <td class="hidePAID"></td>
    <td class="hideAGHASTE"></td>
    <td class="hideTRANSPORT"></td>
    <td class="hideLRNO"></td>
    <td class="hideGRADE"></td>
        <td class="hideEWB"></td>
        <td class="hideDAYS"></td>
        </tr></tbody>`;


    // console.log(TransectionArray, BrokerNameList, PartyNameList);
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

    // BuildAccountdetaisl(CNOArray);
    hideList();
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

