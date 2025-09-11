

function filterByBrokerOrPartyList(partyName, bcode) {
  return TransectionArray.filter(function (d) {
    return d.code == partyName && d.BCODE == bcode;
  });
}
function getBrokerPartyList(code) {
  return PartyNameList.filter(function (d) {
    return d.BCODE == code;
  })
}

var GRD;
function jsLoadCallOUTSTANDING_BROKERWISE_PARTYWISE(data) {

  var CNOArray = [];
  var flgCno = [];

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
    var flagParty = [];
    var flagBroker = [];

    for (var i = 0; i < Data.length; i++) {
      for (var j = 0; j < Data[i].billDetails.length; j++) {
        var obj = {};
        obj.code = Data[i].code;
        obj.CNO = Data[i].billDetails[j].CNO;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.VNO = Data[i].billDetails[j].VNO;
        obj.IDE = Data[i].billDetails[j].IDE;
        obj.BILL = Data[i].billDetails[j].BILL;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.DATE = Data[i].billDetails[j].DATE;
        obj.GRSAMT = Data[i].billDetails[j].GRSAMT;
        obj.GST = Data[i].billDetails[j].GST;
        obj.FAMT = Data[i].billDetails[j].FAMT;
        obj.CLAIMS = Data[i].billDetails[j].CLAIMS;
        obj.RECAMT = Data[i].billDetails[j].RECAMT;
        obj.PAMT = Data[i].billDetails[j].PAMT;
        obj.BCODE = Data[i].billDetails[j].BCODE;
        obj.GRD = Data[i].billDetails[j].GRD;
        obj.HST = Data[i].billDetails[j].HST;
        obj.DT = Data[i].billDetails[j].DT;
        obj.L1R = Data[i].billDetails[j].L1R;
        obj.L1P = Data[i].billDetails[j].L1P;
        obj.L2R = Data[i].billDetails[j].L2R;
        obj.L2P = Data[i].billDetails[j].L2P;
        obj.L3R = Data[i].billDetails[j].L3R;
        obj.L3P = Data[i].billDetails[j].L3P;
        obj.T = Data[i].billDetails[j].T;
        obj.R1 = Data[i].billDetails[j].R1;
        obj.TR = Data[i].billDetails[j].TR;
        obj.RR = Data[i].billDetails[j].RR;

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
    BrokerNameList = BrokerNameList.sort()
    for (var i = 0; i < BrokerNameList.length; i++) {

      var totalNETBILLAMT = 0;
      var totalGROSSAMT = 0;
      var totalGOODSRETURN = 0;
      var totalPAIDAMT = 0;
      var totalAmount = 0;
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
            <th  colspan="20"><b  onclick="openBrokerSupR('`+ BrokerNameList[i] + `','` + BMO + `')">` + BrokerNameList[i] + "</b>" + BContact + `</th>
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

        tr += ` 
      <tr style="font-weight:700;"align="center">   
      <td class="selectBoxReport" style="display:none;">
                         SELECT<input type="checkbox" checked onchange="checkAllEntry(this);"/>
                         </td>                     
        <td  class="pdfBtnHide">BILL</td>
        <td >BILL NO.</td>
        <td class="hideBWPWFIRM">FIRM</td>
        <td class="hideBWPWBILLDATE">BILL DATE</td>
        <td class="hideBWPWGROSSAMT">GROSS AMT</td>
        <td class="hideBWPWNETBILL AMT">NET BILL AMT</td>
        <td class="hideBWPWGOODSRET">GOODS RET.</td>
        <td class="hideBWPWPAIDAMT">PAID AMT.</td>
        <td class="hideBWPWPENDAMT">PEND AMT.</td>
        <td class="hideBWPWDAYS"> DAYS</td>
        <td class="GRD">GRADE</td>        
        <td class="hidePWMWTDSTCS" style="display:none;">TCS/TDS</td>
        <td class="hideBWPWTRASNPORT" style="display:none;">TRASNPORT</td>
        <td class="hideBWPWLR" style="display:none;">LR</td>
        <td class="hideBWPWL1R" style="display:none;">RMK1</td>
        <td class="hideBWPWL1P" style="display:none;">DIS1</td>
        <td class="hideBWPWL2R" style="display:none;">RMK2</td>
        <td class="hideBWPWL2P" style="display:none;">DIS2</td>
        <td class="hideBWPWL3R" style="display:none;">RMK3</td>
        <td class="hideBWPWL3P" style="display:none;">DIS3</td>
        <td class="hideBWPWRMK" style="display:none;">RMK</td>
        <td class="hideBWPWBAL" style="display:none;">BAL</td>
        <td class="hideBWPWVNO" style="display:none;">VNO</td>
          </tr>`;
        var Data = filterByBrokerOrPartyList(uniqBrokerPartyList[j].code, BrokerNameList[i]);

        var subtotalNETBILLAMT = 0;
        var subtotalGROSSAMT = 0;
        var subtotalGOODSRETURN = 0;
        var subtotalPAIDAMT = 0;
        var subtotalAmount = 0;
        if (Data.length > 0) {
          for (var k = 0; k < Data.length; k++) {

            var GRSAMT = Data[k].GRSAMT == null ? 0 : Data[k].GRSAMT;
            var GST = Data[k].GST == null ? 0 : Data[k].GST;
            // try {
            //   if (Data[k].DT.trim() != "os") {
            //     GRSAMT = 0;
            //     GST = 0;
            //   }
            // } catch (error) { }


            var GST = Data[k].GST == null ? 0 : Data[k].GST;
            var FAMT = Data[k].FAMT == null ? 0 : Data[k].FAMT;
            var CLAIMS = Data[k].CLAIMS == null ? 0 : Data[k].CLAIMS;
            var RECAMT = Data[k].RECAMT == null ? 0 : Data[k].RECAMT;
            var PAMT = Data[k].PAMT == null ? 0 : Data[k].PAMT;

            subtotalGROSSAMT += parseFloat(GRSAMT);
            subtotalNETBILLAMT += parseFloat(FAMT);
            subtotalGOODSRETURN += parseFloat(CLAIMS);
            subtotalPAIDAMT += parseFloat(RECAMT);
            subtotalAmount += parseFloat(PAMT);
            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[k].CNO, Data[k].TYPE, Data[k].VNO, getFirmDetailsBySendCode(Data[k].CNO)[0].FIRM, Data[k].IDE, ccode[0].MO);
            var urlopen = '';
            var TYPEforLink = (Data[k].TYPE).toUpperCase();
            if (TYPEforLink.indexOf('B') > -1) {

              // urlopen = UrlPaymentSlip;
            } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
              urlopen = FdataUrl;
            }
            var Days = parseInt(getDaysDif(Data[k].DATE, nowDate));
            var color = daysWiseColoring == "Y" ? colorByDaysFormate(Days) : "";

            var ID = Data[k].CNO + Data[k].TYPE + Data[k].VNO;

            if (!flgCno[Data[k].CNO]) {
              CNOArray.push(Data[k].CNO);
              flgCno[Data[k].CNO] = true;
            }
            tr += `
            <tr style="`+ color + `">
            <td  class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button >PDF</button><a></td>
            <td class="selectBoxReport alignCenter" style="display:none;">
            <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + Data[k].CNO + `"DTYPE="` + Data[k].TYPE + `"VNO="` + Data[k].VNO + `"/></td>
           
            <td><a target="_blank" href="` + FdataUrl + `"><button >` + getValueNotDefine(Data[k].BILL) + `</button></a></td>             
            <td class="hideBWPWFIRM"onclick="openSubR('`+ Data[k].code + `')">` + Data[k].FRM + `</td>
            <td class="hideBWPWBILLDATE"onclick="openSubR('`+ Data[k].code + `')">` + formatDate(Data[k].DATE) + `</td>
            <td class="hideBWPWGROSSAMT"onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(GRSAMT) + `</td>
            <td class="hideBWPWNETBILL AMT"onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(FAMT) + `</td>
            <td class="hideBWPWGOODSRET"onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(CLAIMS) + `</td>
            <td class="hideBWPWPAIDAMT"onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(RECAMT) + `</td>
            <td class="hideBWPWPENDAMT"onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(PAMT) + `</td>
            <td class="hideBWPWDAYS"onclick="openSubR('`+ Data[k].code + `')">` + Days + ` </td>
            <td onclick="openSubR('`+ Data[k].code + `')"class="GRD">` + getValueNotDefine(Data[k].GRD) + ` </td>
            <td class="hidePWMWTDSTCS" style="display:none;">` + getValueNotDefine(Data[k].T) + `</td>
            <td class="hideBWPWTRASNPORT" style="display:none;">` + getValueNotDefine(Data[k].TR) + `</td>
            <td class="hideBWPWLR" style="display:none;">` + getValueNotDefine(Data[k].RR) + `</td>
            <td class="hideBWPWL1R" style="display:none;">` + getValueNotDefine(Data[k].L1R) + `</td>
            <td class="hideBWPWL1P" style="display:none;">` + getValueNotDefine(Data[k].L1P) + `%</td>
            <td class="hideBWPWL2R" style="display:none;">` + getValueNotDefine(Data[k].L2R) + `</td>
            <td class="hideBWPWL2P" style="display:none;">` + getValueNotDefine(Data[k].L2P) + `%</td>
            <td class="hideBWPWL3R" style="display:none;">` + getValueNotDefine(Data[k].L3R) + `</td>
            <td class="hideBWPWL3P" style="display:none;">` + getValueNotDefine(Data[k].L3P) + `%</td>
            <td class="hideBWPWRMK" style="display:none;">` + getValueNotDefine(Data[k].R1) + `</td>
            <td class="hideBWPWBAL" style="display:none;">`+ valuetoFixed(subtotalAmount) + `</td>
            <td class="hideBWPWVNO" style="display:none;">` + getValueNotDefine(Data[k].VNO) + `</td>
            </tr>
            `;

            if (productDet == 'Y') {
              tr += jsgetArrayProductdetailsbyIDE(Data[k].IDE);

            }
          }

          totalGROSSAMT += subtotalGROSSAMT;
          totalNETBILLAMT += subtotalNETBILLAMT;
          totalGOODSRETURN += subtotalGOODSRETURN;
          totalPAIDAMT += subtotalPAIDAMT;
          totalAmount += subtotalAmount;

          tr += `<tr class="tfootcard">
                                <td class="pdfBtnHide"></td>
                                <td>SUB TOTAL</td>
                                <td class="hideBWPWFIRM"></td>
                                <td class="hideBWPWBILLDATE"></td>
                                <td class="hideBWPWGROSSAMT">` + valuetoFixed(subtotalGROSSAMT) + `</td>
                                <td class="hideBWPWNETBILL AMT">` + valuetoFixed(subtotalNETBILLAMT) + `</td>
                                <td class="hideBWPWGOODSRET">` + valuetoFixed(subtotalGOODSRETURN) + `</td>
                                <td class="hideBWPWPAIDAMT">` + valuetoFixed(subtotalPAIDAMT) + `</td>
                                <td class="hideBWPWPENDAMT">` + valuetoFixed(subtotalAmount) + `</td>
                                <td class="hideBWPWDAYS"></td>
                                <td class="GRD"></td>
                                <td class="hidePWMWTDSTCS" style="display:none;"></td>
                                <td class="hideBWPWTRASNPORT" style="display:none;"></td>
                                <td class="hideBWPWLR" style="display:none;"></td>
                                <td class="hideBWPWL1R" style="display:none;"></td>
                                <td class="hideBWPWL1P" style="display:none;"></td>
                                <td class="hideBWPWL2R" style="display:none;"></td>
                                <td class="hideBWPWL2P" style="display:none;"></td>
                                <td class="hideBWPWL3R" style="display:none;"></td>
                                <td class="hideBWPWL3P" style="display:none;"></td>
                                <td class="hideBWPWRMK" style="display:none;"></td>
                                <td class="hideBWPWBAL" style="display:none;">`+ valuetoFixed(subtotalAmount) + `</td>
                                <td class="hideBWPWVNO" style="display:none;"></td>
                                </tr>`;

          subtotalGROSSAMT = 0;
          subtotalNETBILLAMT = 0;
          subtotalGOODSRETURN = 0;
          subtotalPAIDAMT = 0;
          subtotalAmount = 0;
        }
      }

      grandtotalGROSSAMT += totalGROSSAMT;
      grandtotalNETBILLAMT += totalNETBILLAMT;
      grandtotalGOODSRETURN += totalGOODSRETURN;
      grandtotalPAIDAMT += totalPAIDAMT;
      grandtotalAmount += totalAmount;
      if (uniqBrokerPartyList.length > 1) {
        tr += `<tr class="tfootcard">
                            <td class="pdfBtnHide"></td>
                            <td> TOTAL</td>
                            <td class="hideBWPWFIRM"></td>
                            <td class="hideBWPWBILLDATE"></td>
                            <td class="hideBWPWGROSSAMT">` + valuetoFixed(totalGROSSAMT) + `</td>
                            <td class="hideBWPWNETBILL AMT">` + valuetoFixed(totalNETBILLAMT) + `</td>
                            <td class="hideBWPWGOODSRET">` + valuetoFixed(totalGOODSRETURN) + `</td>
                            <td class="hideBWPWPAIDAMT">` + valuetoFixed(totalPAIDAMT) + `</td>
                            <td class="hideBWPWPENDAMT">` + valuetoFixed(totalAmount) + `</td>
                            <td class="hideBWPWDAYS"></td>
                            <td class="GRD"></td>
                            <td class="hidePWMWTDSTCS" style="display:none;"></td>
                            <td class="hideBWPWTRASNPORT" style="display:none;"></td>
                            <td class="hideBWPWLR" style="display:none;"></td>
                            <td class="hideBWPWL1R" style="display:none;"></td>
                            <td class="hideBWPWL1P" style="display:none;"></td>
                            <td class="hideBWPWL2R" style="display:none;"></td>
                            <td class="hideBWPWL2P" style="display:none;"></td>
                            <td class="hideBWPWL3R" style="display:none;"></td>
                            <td class="hideBWPWL3P" style="display:none;"></td>
                            <td class="hideBWPWRMK" style="display:none;"></td>
                            <td class="hideBWPWBAL" style="display:none;">`+ valuetoFixed(totalAmount) + `</td>
                            <td class="hideBWPWVNO" style="display:none;"></td>
                            </tr>`;
      }
      totalGROSSAMT = 0;
      totalNETBILLAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;
    }


    tr += `<tr class="tfootcard"style="">
    <td class="pdfBtnHide"></td>
    <td>GRAND TOTAL</td>
    <td class="hideBWPWFIRM"></td>
    <td class="hideBWPWBILLDATE"></td>
    <td class="hideBWPWGROSSAMT">` + valuetoFixed(grandtotalGROSSAMT) + `</td>
    <td class="hideBWPWNETBILL AMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</td>
    <td class="hideBWPWGOODSRET">` + valuetoFixed(grandtotalGOODSRETURN) + `</td>
    <td class="hideBWPWPAIDAMT">` + valuetoFixed(grandtotalPAIDAMT) + `</td>
    <td class="hideBWPWPENDAMT">` + valuetoFixed(grandtotalAmount) + `</td>
    <td class="hideBWPWDAYS"></td>
    <td class="GRD"></td>
    <td class="hidePWMWTDSTCS" style="display:none;"></td>
    <td class="hideBWPWTRASNPORT" style="display:none;"></td>
    <td class="hideBWPWLR" style="display:none;"></td>
    <td class="hideBWPWL1R" style="display:none;"></td>
    <td class="hideBWPWL1P" style="display:none;"></td>
    <td class="hideBWPWL2R" style="display:none;"></td>
    <td class="hideBWPWL2P" style="display:none;"></td>
    <td class="hideBWPWL3R" style="display:none;"></td>
    <td class="hideBWPWL3P" style="display:none;"></td>
    <td class="hideBWPWRMK" style="display:none;"></td>
    <td class="hideBWPWBAL" style="display:none;">`+ valuetoFixed(grandtotalAmount) + `</td>
    <td class="hideBWPWVNO" style="display:none;"></td>
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

