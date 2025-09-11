
function filterByBrokerOrParty(bcode) {
  return TransectionArray.filter(function (d) {
    return d.BCODE == bcode;
  });
}
function getBrokerPartyList(code) {
  return PartyNameList.filter(function (d) {
    return d.BCODE == code;
  })
}

var GRD;
function jsLoadCallOUTSTANDING_BROKERWISE(data) {

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
        obj.T = Data[i].billDetails[j].T;
        obj.HST = Data[i].billDetails[j].HST;
        obj.DT = Data[i].billDetails[j].DT;
        obj.L1R = Data[i].billDetails[j].L1R;
        obj.L1P = Data[i].billDetails[j].L1P;
        obj.L2R = Data[i].billDetails[j].L2R;
        obj.L2P = Data[i].billDetails[j].L2P;
        obj.L3R = Data[i].billDetails[j].L3R;
        obj.L3P = Data[i].billDetails[j].L3P;
        obj.R1 = Data[i].billDetails[j].R1;

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
        BContact = `,<a href="tel:` + getValueNotDefine(BrokerArr[0].MO) + `">` + getValueNotDefine(BrokerArr[0].MO) + `</a>`;
        BContact += `,<a href="tel:` + getValueNotDefine(BrokerArr[0].PH1) + `">` + getValueNotDefine(BrokerArr[0].PH1) + `</a>`;
        BContact += `,<a href="tel:` + getValueNotDefine(BrokerArr[0].PH1) + `">` + getValueNotDefine(BrokerArr[0].PH1) + `</a>`;
      }
      tr += `<tr class="pinkHeading">
            <th  colspan="18"><b  onclick="openBrokerSupR('`+ BrokerNameList[i] + `','` + BMO + `')">` + BrokerNameList[i] + "</b>" + BContact + `</th>
        </tr>`;
      tr += ` 
        <tr style="background-color: #588c7e; color: #ffffff; text-align: right; font-weight: bold;">   
        <td class="selectBoxReport" style="display:none;">
                         SELECT<input type="checkbox" checked onchange="checkAllEntry(this);"/>
                         </td>                     
          <th  class="pdfBtnHide">BILL</th>
          <th >BILL NO.</th>
          <th class="hideBWPARTY">PARTY</th>
          <th class="hideBWFIRM">FIRM</th>
          <th class="hideBWBILLDATE">BILL&nbsp;DATE</th>
          <th class="hideBWGROSSAMT">GROSS AMT</th>
          <th class="hideBWNETBILL AMT">NET BILL AMT</th>
          <th class="hideBWGOODSRET">GOODS RET.</th>
          <th class="hideBWPAIDAMT">PAID AMT.</th>
          <th class="hideBWPENDAMT">PEND AMT.</th>
          <th class="hideBWDAYS"> DAYS</th>
          <th class="GRD">GRADE</th>        
          <th class="hidePWMWTDSTCS" style="display:none;">TCS/TDS</th>
          <th class="hideBWL1R" style="display:none;">RMK1</th>
          <th class="hideBWL1P" style="display:none;">DIS1</th>
          <th class="hideBWL2R" style="display:none;">RMK2</th>
          <th class="hideBWL2P" style="display:none;">DIS2</th>
          <th class="hideBWL3R" style="display:none;">RMK3</th>
          <th class="hideBWL3P" style="display:none;">DIS3</th>
          <th class="hideBWRMK" style="display:none;">RMK</th>
          <th class="hideBWBAL" style="display:none;">BAL</th>
          <th class="hideBWVNO" style="display:none;">VNO</th>
            </tr>`;
      var uniqBrokerPartyList = getBrokerPartyList(BrokerNameList[i])
      uniqBrokerPartyList = uniqBrokerPartyList.sort((a, b) => {
        if (a.code > b.code)
          return 1;
        if (a.code < b.code)
          return -1;
        return 0;
      });
      var Data = filterByBrokerOrParty(BrokerNameList[i]);
      Data = Data.sort(function (a, b) {
        return new Date(a.DATE) - new Date(b.DATE) || parseInt(getValueNotDefine(a.VNO)) - parseInt(getValueNotDefine(b.VNO));
      });
      var subtotalNETBILLAMT = 0;
      var subtotalGROSSAMT = 0;
      var subtotalGOODSRETURN = 0;
      var subtotalPAIDAMT = 0;
      var subtotalAmount = 0;
      if (Data.length > 0) {
        for (var k = 0; k < Data.length; k++) {
          ccode = getPartyDetailsBySendCode(Data[k].code);
          var pcode = "";
          var pName = "";
          var city = "";
          var broker = "";
          var MO = "";
          if (ccode.length > 0) {
            label = getValueNotDefine(ccode[0].label);
            pcode = getValueNotDefine(ccode[0].value);
            pName = getValueNotDefine(ccode[0].partyname);
            city = getValueNotDefine(ccode[0].city);
            broker = getValueNotDefine(ccode[0].broker);
            MO = getValueNotDefine(ccode[0].MO);
          }
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


          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[k].CNO, Data[k].TYPE, Data[k].VNO, getFirmDetailsBySendCode(Data[k].CNO)[0].FIRM, Data[k].IDE, MO);
          var urlopen = '';
          var TYPEforLink = (Data[k].TYPE).toUpperCase();
          if (TYPEforLink.indexOf('B') > -1) {

            // urlopen = UrlPaymentSlip;
          } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
            urlopen = FdataUrl;
          }

          var ID = Data[k].CNO + Data[k].TYPE + Data[k].VNO;

          var Days = parseInt(getDaysDif(Data[k].DATE, nowDate));
          var color = daysWiseColoring == "Y" ? colorByDaysFormate(Days) : "";

          if(!flgCno[ Data[k].CNO]){
            CNOArray.push( Data[k].CNO);
            flgCno[ Data[k].CNO]=true;
          }

          tr += `
            <tr style="`+color+`">
            <td  class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button >PDF</button><a></td>
            <td class="selectBoxReport" style="display:none;text-align:center;">
            <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + Data[k].CNO + `"DTYPE="` + Data[k].TYPE + `"VNO="` + Data[k].VNO + `"/></td>
           
            <td><a target="_blank" href="` + FdataUrl + `"><button >` + getValueNotDefine(Data[k].BILL) + `</button></a></td>             
            <td class="hideBWPARTY"onclick="openSubR('`+ Data[k].code + `')">` + getValueNotDefine(pName) + `</td>
            <td class="hideBWFIRM"onclick="openSubR('`+ Data[k].code + `')">` + Data[k].FRM + `</td>
            <td class="hideBWBILLDATE date"onclick="openSubR('`+ Data[k].code + `')">` + formatDate(Data[k].DATE) + `</td>
            <td class="hideBWGROSSAMT"onclick="openSubR('`+ Data[k].code + `')" style="text-align:right;">` + valuetoFixed(getValueNotDefineNo(GRSAMT)) + `</td>
            <td class="hideBWNETBILL AMT"onclick="openSubR('`+ Data[k].code + `')" style="text-align:right;">` + valuetoFixed(getValueNotDefineNo(FAMT)) + `</td>
            <td class="hideBWGOODSRET"onclick="openSubR('`+ Data[k].code + `')" style="text-align:right;">` + valuetoFixed(getValueNotDefineNo(CLAIMS)) + `</td>
            <td class="hideBWPAIDAMT"onclick="openSubR('`+ Data[k].code + `')" style="text-align:right;">` + valuetoFixed(getValueNotDefineNo(RECAMT)) + `</td>
            <td class="hideBWPENDAMT"onclick="openSubR('`+ Data[k].code + `')" style="text-align:right;">` + valuetoFixed(getValueNotDefineNo(PAMT)) + `</td>
            <td class="hideBWDAYS"onclick="openSubR('`+ Data[k].code + `')">` + Days + ` </td>
            <td onclick="openSubR('`+ Data[k].code + `')"class="GRD">` + getValueNotDefine(Data[k].GRD) + ` </td>
            <td class="hidePWMWTDSTCS" style="display:none;">` + getValueNotDefine(Data[k].T) + `</td>
            <td class="hideBWL1R" style="display:none;">` + getValueNotDefine(Data[k].L1R) + `</td>
            <td class="hideBWL1P" style="display:none;">` + getValueNotDefine(Data[k].L1P) + `%</td>
            <td class="hideBWL2R" style="display:none;">` + getValueNotDefine(Data[k].L2R) + `</td>
            <td class="hideBWL2P" style="display:none;">` + getValueNotDefine(Data[k].L2P) + `%</td>
            <td class="hideBWL3R" style="display:none;">` + getValueNotDefine(Data[k].L3R) + `</td>
            <td class="hideBWL3P" style="display:none;">` + getValueNotDefine(Data[k].L3P) + `%</td>
            <td class="hideBWRMK" style="display:none;">` + getValueNotDefine(Data[k].R1) + `</td>
            <td class="hideBWBAL" style="display:none;">`+ valuetoFixed(totalAmount) + `</td>
            <td class="hideBWVNO" style="display:none;">` + getValueNotDefine(Data[k].VNO) + `</td>
            </tr>
            `;


          totalGROSSAMT += parseFloat(GRSAMT);
          totalNETBILLAMT += parseFloat(FAMT);
          totalGOODSRETURN += parseFloat(CLAIMS);
          totalPAIDAMT += parseFloat(RECAMT);
          totalAmount += parseFloat(PAMT);
          if (productDet == 'Y') {
            DETAILSDET = jsgetArrayProductdetailsbyIDE(Data[k].IDE);
            if (DETAILSDET.length > 0) {
              // var row='';
              tr += `
                                    
                                                          <tr>
                                                              <td><strong></strong></td>
                                                              <td class="text-center">ITEM</td>
                                                              <td class="text-center"><strong>PCS</strong></td>
                                                              <td class="text-center"><strong>PACK</strong></td>
                                                              <td class="text-center"><strong>UNIT</strong></td>
                                                              <td class="text-center"><strong>CUT</strong></td>
                                                              <td class="text-center"><strong>RATE</strong></td>
                                                              <td class="text-center"><strong>MTS</strong></td>
                                                              <td class="text-right"><strong>AMT</strong></td>
                                                          </tr>
                                                          `;
              for (m = 0; m < DETAILSDET[0].length; m++) {
                tr += `<tr class="hideAbleTr">
                                                                <td class="text-center"></td>
                                                                <td class="text-center">`+ DETAILSDET[0][m]['qual'] + `</td>
                                                                <td class="text-center">`+ Number(DETAILSDET[0][m]['PCS']) + `</td>
                                                              <td class="text-center">`+ DETAILSDET[0][m]['PCK'] + `</td>
                                                              <td class="text-center">`+ DETAILSDET[0][m]['UNIT'] + `</td>
                                                              <td class="text-center">`+ DETAILSDET[0][m]['CUT'] + `</td>
                                                              <td class="text-center">`+ valuetoFixed(DETAILSDET[0][m]['RATE']) + `</td>
                                                              <td class="text-center">`+ valuetoFixed(DETAILSDET[0][m]['MTS']) + `</td>
                                                              <td class="text-center">`+ valuetoFixed(DETAILSDET[0][m]['AMT']) + `</td>
                                                              </tr>`;

                if (DETAILSDET[0][m].DET != undefined && DETAILSDET[0][m].DET != null && DETAILSDET[0][m].DET != "") {
                  tr += `<tr class="hideAbleTr">
                                                            <td class="text-center" colspan="9">REMARK : `+ DETAILSDET[0][m]['DET'] + `</td>
                                                            </tr>`;
                }
              }
            }
          }
        }

        grandtotalGROSSAMT += totalGROSSAMT;
        grandtotalNETBILLAMT += totalNETBILLAMT;
        grandtotalGOODSRETURN += totalGOODSRETURN;
        grandtotalPAIDAMT += totalPAIDAMT;
        grandtotalAmount += totalAmount;

        tr += `<tr class="tfootcard"  style="">
                                <td class="pdfBtnHide"></td>
                                <td> TOTAL</td>
                                <td class="hideBWPARTY"></td>
                                <td class="hideBWFIRM"></td>
                                <td class="hideBWBILLDATE"></td>
                                <td class="hideBWGROSSAMT alignRight">` + valuetoFixed(totalGROSSAMT) + `</td>
                                <td class="hideBWNETBILL AMT alignRight">` + valuetoFixed(totalNETBILLAMT) + `</td>
                                <td class="hideBWGOODSRET alignRight">` + valuetoFixed(totalGOODSRETURN) + `</td>
                                <td class="hideBWPAIDAMT alignRight">` + valuetoFixed(totalPAIDAMT) + `</td>
                                <td class="hideBWPENDAMT alignRight">` + valuetoFixed(totalAmount) + `</td>
                                <td class="hideBWDAYS"></td>
                                <td class="GRD"></td>
                                <td class="hidePWMWTDSTCS" style="display:none;"></td>
                                <td class="hideBWL1R" style="display:none;"></td>
                                <td class="hideBWL1P" style="display:none;"></td>
                                <td class="hideBWL2R" style="display:none;"></td>
                                <td class="hideBWL2P" style="display:none;"></td>
                                <td class="hideBWL3R" style="display:none;"></td>
                                <td class="hideBWL3P" style="display:none;"></td>
                                <td class="hideBWRMK" style="display:none;"></td>
                                <td class="hideBWBAL" style="display:none;">`+ valuetoFixed(totalAmount) + `</td>
                                <td class="hideBWVNO" style="display:none;"></td>
                                </tr>`;

        totalGROSSAMT = 0;
        totalNETBILLAMT = 0;
        totalGOODSRETURN = 0;
        totalPAIDAMT = 0;
        totalAmount = 0;
      }

    }


    tr += `<tr class="tfootcard"style="">
    <td class="pdfBtnHide"></td>
    <td>GRAND TOTAL</td>
    <td class="hideBWPARTY"></td>
    <td class="hideBWFIRM"></td>
    <td class="hideBWBILLDATE"></td>
    <td class="hideBWGROSSAMT alignRight">` + valuetoFixed(grandtotalGROSSAMT) + `</td>
    <td class="hideBWNETBILL AMT alignRight">` + valuetoFixed(grandtotalNETBILLAMT) + `</td>
    <td class="hideBWGOODSRET alignRight">` + valuetoFixed(grandtotalGOODSRETURN) + `</td>
    <td class="hideBWPAIDAMT alignRight">` + valuetoFixed(grandtotalPAIDAMT) + `</td>
    <td class="hideBWPENDAMT alignRight">` + valuetoFixed(grandtotalAmount) + `</td>
    <td class="hideBWDAYS"></td>
    <td class="GRD"></td>
    <td class="hidePWMWTDSTCS" style="display:none;"></td>
    <td class="hideBWL1R" style="display:none;"></td>
    <td class="hideBWL1P" style="display:none;"></td>
    <td class="hideBWL2R" style="display:none;"></td>
    <td class="hideBWL2P" style="display:none;"></td>
    <td class="hideBWL3R" style="display:none;"></td>
    <td class="hideBWL3P" style="display:none;"></td>
    <td class="hideBWRMK" style="display:none;"></td>
    <td class="hideBWBAL" style="display:none;">`+ valuetoFixed(grandtotalAmount) + `</td>
    <td class="hideBWVNO" style="display:none;"></td>
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

