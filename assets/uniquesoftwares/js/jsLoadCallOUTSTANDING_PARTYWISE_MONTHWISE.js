
var hideAbleTr = getUrlParams(url, "hideAbleTr");

function getMonthListOfParty(COD) {
  return MonthList.filter(function (d) {
    return d.code == COD;
  })
}

function getmonthWiseDetails(COD, monthName, selectYear) {
  return TransectionArray.filter(function (d) {
    return d.code == COD && d.monthName == monthName && d.selectYear == selectYear;
  })
}
const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];
function jsLoadCallOUTSTANDING_PARTYWISE_MONTHWISE(data) {

  var CNOArray = [];
  var flgCno = [];
  tr = '';
  TransectionArray = [];
  MonthList = [];
  PartynameList = [];
  var MonthListFlg = [];
  var PartynameListFlg = [];
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
  var grandtotalGST = 0;
  var totalGST = 0;
  var totalNETBILLAMT = 0;
  var totalGROSSAMT = 0;
  var totalGOODSRETURN = 0;
  var totalPAIDAMT = 0;
  var totalAmount = 0;
  var totalGST = 0;
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
        var monthName = "";
        try {
          var d = new Date(Data[i].billDetails[j].DATE);
          var selectYear = d.getFullYear();
          var monthName = monthNames[d.getMonth()];
        } catch (error) {

        }
        if (!MonthListFlg[Data[i].code + monthName + selectYear]) {
          var Nobj = {}
          Nobj.code = Data[i].code;
          Nobj.monthName = monthName;
          Nobj.selectYear = selectYear;
          MonthList.push(Nobj);
          MonthListFlg[Data[i].code + monthName + selectYear] = true;
        }
        if (!PartynameListFlg[Data[i].code]) {
          PartynameList.push(Data[i].code);
          PartynameListFlg[Data[i].code] = true;
        }
        obj.monthName = monthName;
        obj.selectYear = selectYear;
        TransectionArray.push(obj);

      }
    }

  }
  var ccode;
  var pcode;
  var city;
  var broker;
  var label;

  var subtotalNETBILLAMT = 0;
  var subtotalGROSSAMT = 0;
  var subtotalGOODSRETURN = 0;
  var subtotalPAIDAMT = 0;
  var subtotalAmount = 0;
  var subtotalGST = 0;
  var BLL;
  var FdataUrl
  if (PartynameList.length > 0) {
    for (let i = 0; i < PartynameList.length; i++) {
      const partyName = PartynameList[i];
      grandtotalGROSSAMT = 0;
      grandtotalNETBILLAMT = 0;
      grandtotalGOODSRETURN = 0;
      grandtotalPAIDAMT = 0;
      grandtotalAmount = 0;
      grandtotalAmount = 0;
      grandtotalGST = 0;
      ccode = getPartyDetailsBySendCode(partyName);
      var EML = '';
      if (ccode.length > 0) {
        pcode = getValueNotDefine(ccode[0].partyname);
        city = getValueNotDefine(ccode[0].city);
        broker = getValueNotDefine(ccode[0].broker);
        label = getValueNotDefine(ccode[0].label);
        MO = getValueNotDefine(ccode[0].MO);
        EML = getValueNotDefine(ccode[0].EML);
      }
      tr += `<tr class="trPartyHead"onclick="trOnClick('` + partyName + `','` + city + `','` + broker + `');">
                          <th colspan="20" class="trPartyHead">` + label + `<a href="tel:` + MO + `"><button>MO:` + getValueNotDefine(MO) + `</button></a></th>
                        </tr>
                        `;

      var MonthListOfParty = getMonthListOfParty(partyName);
      for (let j = 0; j < MonthListOfParty.length; j++) {
        const month = MonthListOfParty[j];
        tr += `<tr style="font-weight:bolder;font-size:20px;background-color:#f3f3f3;color:#c107a2;">
          <th colspan="16" style="font-weight:bolder;font-size:20px;background-color:#f3f3f3;">`+ month.monthName + ` ` + month.selectYear + `</th>
            </tr>
            <tr style="font-weight:500;"align="center">                        
            <th class="pdfBtnHide">BILL</th>
            <td class="selectBoxReport" style="display:none;">
                SELECT<input type="checkbox" checked onchange="checkAllEntry(this);"/>
                </td>  
            <th class="hidePWMWBILLNO">BILL NO.</th>
            <th class="hidePWMWFIRM">FIRM</th>
            <th class="hidePWMWDATE">BILL&nbsp;DATE</th>
            <th class="hidePWMWGROSSAMT">GROSS AMT</th>
            <th class="hidePWMWGST">GST</th>
            <th class="hidePWMWNETBILLAMT">NET AMT</th>
            <th class="hidePWMWGOODSRET">GOODS RET.</th>
            <th class="hidePWMWPAIDAMT">PAID AMT.</th>
            <th class="hidePWMWPENDAMT">PEND AMT.</th>
            <th class="hidePWMWDAYS"> DAYS</th>
            <th class="hidePWMWAGHASTE">AG./HASTE</th>
           <th class="GRD">GRADE</th>
           <th class="hidePWMWTDSTCS" style="display:none;">TCS/TDS</th>
           <th class="hidePWMWTRASNPORT" style="display:none;">TRASNPORT</th>
           <th class="hidePWMWLRNO" style="display:none;">L.R</th>
           <th class="hidePWMWL1R" style="display:none;">RMK1</th>
           <th class="hidePWMWL1P" style="display:none;">DIS1</th>
           <th class="hidePWMWL2R" style="display:none;">RMK2</th>
           <th class="hidePWMWL2P" style="display:none;">DIS2</th>
           <th class="hidePWMWL3R" style="display:none;">RMK3</th>
           <th class="hidePWMWL3P" style="display:none;">DIS3</th>
           <th class="hidePWMWRMK" style="display:none;">RMK</th>
           <th class="hidePWMWBAL" style="display:none;">BAL</th>
           <th class="hidePWMWVNO" style="display:none;">VNO</th>
             </tr>
            `;

        var monthWiseDetails = getmonthWiseDetails(partyName, month.monthName, month.selectYear);
        subtotalNETBILLAMT = 0;
        subtotalGROSSAMT = 0;
        subtotalGOODSRETURN = 0;
        subtotalPAIDAMT = 0;
        subtotalAmount = 0;
        subtotalGST = 0;
        for (let k = 0; k < monthWiseDetails.length; k++) {
          const element = monthWiseDetails[k];
          var GRSAMT = element.GRSAMT == null || element.GRSAMT == "" ? 0 : element.GRSAMT;
          var GST = element.GST == null || element.GST == "" ? 0 : element.GST;
          // try {
          //   if (element.DT.trim() != "os") {
          //     GRSAMT = 0;
          //     GST = 0;
          //   }
          // } catch (error) {

          // }

          var FAMT = element.FAMT == null || element.FAMT == "" ? 0 : element.FAMT;
          var CLAIMS = element.CLAIMS == null || element.CLAIMS == "" ? 0 : element.CLAIMS;
          var RECAMT = element.RECAMT == null || element.RECAMT == "" ? 0 : element.RECAMT;
          var PAMT = element.PAMT == null || element.RECAMT == "" ? 0 : element.PAMT;
          subtotalGROSSAMT += parseFloat(getValueNotDefineNo(GRSAMT));
          subtotalGST += parseFloat(getValueNotDefineNo(GST));
          subtotalNETBILLAMT += parseFloat(getValueNotDefineNo(FAMT));
          subtotalGOODSRETURN += parseFloat(getValueNotDefineNo(CLAIMS));
          subtotalPAIDAMT += parseFloat(getValueNotDefineNo(RECAMT));
          subtotalAmount += parseFloat(getValueNotDefineNo(PAMT));
          var UrlPaymentSlip = getUrlPaymentSlip(element.CNO, (element.TYPE).replace("ZS", ""), element.VNO, (element.IDE).replace("ZS", ""));
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(element.CNO, element.TYPE, element.VNO, getFirmDetailsBySendCode(element.CNO)[0].FIRM, element.IDE, MO, EML);
          var urlopen = '';
          var TYPEforLink = (element.TYPE).toUpperCase();
          if (TYPEforLink.indexOf('B') > -1) {

            urlopen = UrlPaymentSlip;
          } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
            urlopen = FdataUrl;
          }
          var BrokerHaste = '';
          var HST = element.HST;
          BrokerHaste = element.BCODE;
          var ID = element.CNO + element.TYPE + element.VNO;
          var Days = parseInt(getDaysDif(element.DATE, nowDate));
          var color = daysWiseColoring == "Y" ? colorByDaysFormate(Days) : "";

          if (!flgCno[element.CNO]) {
            CNOArray.push(element.CNO);
            flgCno[element.CNO] = true;
          }
          tr += ` 
                            
                              <tr class="hideAbleTr"align="center"style="`+ color + `">
                              <th class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                              <td class="selectBoxReport" style="display:none;">
                              <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + element.CNO + `"DTYPE="` + element.TYPE + `"VNO="` + element.VNO + `"/></td>
                              <td class="hidePWMWBILLNO"><a target="_blank" href="` + FdataUrl + `"><button class="PrintBtnHide">` + getValueNotDefine(element.BILL) + `</button></a></td>
                              <td class="hidePWMWFIRM" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(element.FRM) + `</td>
                              <td class="hidePWMWDATE" onclick="openSubR('`+ Data[i].code + `')">` + formatDate(element.DATE) + `</td>
                              <td class="hidePWMWGROSSAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(GRSAMT) + `</td>
                              <td class="hidePWMWGST" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(GST) + `</td>
                              <td class="hidePWMWNETBILLAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(FAMT) + `</td>
                              <td class="hidePWMWGOODSRET" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(CLAIMS) + `</td>
                              <td class="hidePWMWPAIDAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(RECAMT) + `</td>
                              <td class="hidePWMWPENDAMT" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(PAMT) + `</td>
                              <td class="hidePWMWDAYS" onclick="openSubR('`+ Data[i].code + `')">` + Days + ` </td>
                              <td class="hidePWMWAGHASTE" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                              <td onclick="openSubR('`+ Data[i].code + `')"class="GRD">` + getValueNotDefine(element.GRD) + ` </td>                                  
                              <td class="hidePWMWTDSTCS" style="display:none;">` + getValueNotDefine(element.T) + `</td>
                              <td class="hidePWMWTRASNPORT" style="display:none;">` + getValueNotDefine(element.TR) + `</td>
                              <td class="hidePWMWLRNO" style="display:none;">` + getValueNotDefine(element.RR) + `</td>
                              <td class="hidePWMWL1R" style="display:none;">` + getValueNotDefine(element.L1R) + `</td>
                              <td class="hidePWMWL1P" style="display:none;">` + getValueNotDefine(element.L1P) + `%</td>
                              <td class="hidePWMWL2R" style="display:none;">` + getValueNotDefine(element.L2R) + `</td>
                              <td class="hidePWMWL2P" style="display:none;">` + getValueNotDefine(element.L2P) + `%</td>
                              <td class="hidePWMWL3R" style="display:none;">` + getValueNotDefine(element.L3R) + `</td>
                              <td class="hidePWMWL3P" style="display:none;">` + getValueNotDefine(element.L3P) + `%</td>
                              <td class="hidePWMWRMK" style="display:none;">` + getValueNotDefine(element.R1) + `</td>
                              <td class="hidePWMWBAL" style="display:none;">`+ valuetoFixed(totalAmount) + `</td>
                              <td class="hidePWMWVNO" style="display:none;">` + getValueNotDefine(element.VNO) + `</td>
                              </tr>`;



        }
        totalNETBILLAMT += subtotalNETBILLAMT;
        totalGROSSAMT += subtotalGROSSAMT;
        totalGOODSRETURN += subtotalGOODSRETURN;
        totalPAIDAMT += subtotalPAIDAMT;
        totalAmount += subtotalAmount;
        totalGST += subtotalGST;

        tr += `<tr class="tfootcard" >
                              <td class="pdfBtnHide"></td>
                              <td class="selectBoxReport" style="display:none;"></td>
                              <td class="hidePWMWBILLNO">SUB TOTAL</td>
                              <td class="hidePWMWFIRM"></td>
                              <td class="hidePWMWDATE"></td>
                              <td class="hidePWMWGROSSAMT">` + valuetoFixed(subtotalGROSSAMT) + `</td>
                              <td class="hidePWMWGST">`+ valuetoFixed(subtotalGST) + `</td>
                              <td class="hidePWMWNETBILLAMT">` + valuetoFixed(subtotalNETBILLAMT) + `</td>
                              <td class="hidePWMWGOODSRET">` + valuetoFixed(subtotalGOODSRETURN) + `</td>
                              <td class="hidePWMWPAIDAMT">` + valuetoFixed(subtotalPAIDAMT) + `</td>
                              <td class="hidePWMWPENDAMT">` + valuetoFixed(subtotalAmount) + `</td>
                              <td  class="hidePWMWDAYS"></td>
                              <td  class="hidePWMWAGHASTE"></td>
                              <td class="GRD"></td>
                              <td class="hidePWMWTDSTCS" style="display:none;"></td>
                              <td class="hidePWMWTRASNPORT" style="display:none;"></td>
                              <td class="hidePWMWLRNO" style="display:none;"></td>
                              <td class="hidePWMWL1R" style="display:none;"></td>
                              <td class="hidePWMWL1P" style="display:none;"></td>
                              <td class="hidePWMWL2R" style="display:none;"></td>
                              <td class="hidePWMWL2P" style="display:none;"></td>
                              <td class="hidePWMWL3R" style="display:none;"></td>
                              <td class="hidePWMWL3P" style="display:none;"></td>
                              <td class="hidePWMWRMK" style="display:none;"></td>
                              <td class="hidePWMWBAL" style="display:none;">`+ valuetoFixed(subtotalAmount) + `</td>
                              <td class="hidePWMWVNO" style="display:none;"></td>
                              </tr>`;
        subtotalNETBILLAMT = 0;
        subtotalGROSSAMT = 0;
        subtotalGOODSRETURN = 0;
        subtotalPAIDAMT = 0;
        subtotalAmount = 0;
        subtotalGST = 0;
      }

      grandtotalGROSSAMT += totalGROSSAMT;
      grandtotalNETBILLAMT += totalNETBILLAMT;
      grandtotalGOODSRETURN += totalGOODSRETURN;
      grandtotalPAIDAMT += totalPAIDAMT;
      grandtotalAmount += totalAmount;
      grandtotalGST += totalGST;
      tr += `<tr class="tfootcard">
                              <td class="pdfBtnHide"></td>
                              <td class="selectBoxReport" style="display:none;"></td>
                              <td class="hidePWMWBILLNO">TOTAL</td>
                              <td class="hidePWMWFIRM"></td>
                              <td class="hidePWMWDATE"></td>
                              <td class="hidePWMWGROSSAMT">` + valuetoFixed(totalGROSSAMT) + `</td>
                              <td class="hidePWMWGST">`+ valuetoFixed(totalGST) + `</td>
                              <td class="hidePWMWNETBILLAMT">` + valuetoFixed(totalNETBILLAMT) + `</td>
                              <td class="hidePWMWGOODSRET">` + valuetoFixed(totalGOODSRETURN) + `</td>
                              <td class="hidePWMWPAIDAMT">` + valuetoFixed(totalPAIDAMT) + `</td>
                              <td class="hidePWMWPENDAMT">` + valuetoFixed(totalAmount) + `</td>
                              <td  class="hidePWMWDAYS"></td>
                              <td  class="hidePWMWAGHASTE"></td>
                              <td class="GRD"></td>
                              <td class="hidePWMWTDSTCS" style="display:none;"></td>
                              <td class="hidePWMWTRASNPORT" style="display:none;"></td>
                              <td class="hidePWMWLRNO" style="display:none;"></td>
                              <td class="hidePWMWL1R" style="display:none;"></td>
                              <td class="hidePWMWL1P" style="display:none;"></td>
                              <td class="hidePWMWL2R" style="display:none;"></td>
                              <td class="hidePWMWL2P" style="display:none;"></td>
                              <td class="hidePWMWL3R" style="display:none;"></td>
                              <td class="hidePWMWL3P" style="display:none;"></td>
                              <td class="hidePWMWRMK" style="display:none;"></td>
                              <td class="hidePWMWBAL" style="display:none;">`+ valuetoFixed(totalAmount) + `</td>
                              <td class="hidePWMWVNO" style="display:none;"></td>
                              </tr>`;
      totalGROSSAMT = 0;
      totalGST = 0;
      totalNETBILLAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;
    }

    tr += `<tr class="tfootcard">
    <td class="pdfBtnHide"></td>
    <td class="selectBoxReport" style="display:none;"></td>
    <td class="hidePWMWBILLNO">GRAND TOTAL</td>
    <td class="hidePWMWFIRM"></td>
    <td class="hidePWMWDATE"></td>
    <td class="hidePWMWGROSSAMT">` + valuetoFixed(grandtotalGROSSAMT) + `</td>
    <td class="hidePWMWGST">`+ valuetoFixed(grandtotalGST) + `</td>
    <td class="hidePWMWNETBILLAMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</td>
    <td class="hidePWMWGOODSRET">` + valuetoFixed(grandtotalGOODSRETURN) + `</td>
    <td class="hidePWMWPAIDAMT">` + valuetoFixed(grandtotalPAIDAMT) + `</td>
    <td class="hidePWMWPENDAMT">` + valuetoFixed(grandtotalAmount) + `</td>
    <td class="hidePWMWDAYS"></td>
    <td class="hidePWMWAGHASTE"></td>
    <td class="GRD"></td>
    <td class="hidePWMWTDSTCS" style="display:none;"></td>
    <td class="hidePWMWTRASNPORT" style="display:none;"></td>
    <td class="hidePWMWLRNO" style="display:none;"></td>
    <td class="hidePWMWL1P" style="display:none;"></td>
    <td class="hidePWMWL2R" style="display:none;"></td>
    <td class="hidePWMWL2P" style="display:none;"></td>
    <td class="hidePWMWL3R" style="display:none;"></td>
    <td class="hidePWMWL3P" style="display:none;"></td>
    <td class="hidePWMWRMK" style="display:none;"></td>
    <td class="hidePWMWBAL" style="display:none;">`+ valuetoFixed(grandtotalAmount) + `</td>
    <td class="hidePWMWVNO" style="display:none;"></td>
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



    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    if (GRD == '' || GRD == null) {
      $('.GRD').css("display", "none");
    }


    var PDFStore = getUrlParams(url, "PDFStore");
    if (PDFStore == "true") {
      alert("PDFStore=true");
    }

    var PDFStorePermission = getUrlParams(url, "PDFStorePermission");
    if (PDFStorePermission == "true") {
      UrlSendToAndroid(Data);
    }

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

