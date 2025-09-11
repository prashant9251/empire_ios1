
var TransectionArray = [];
var transactionList = [];
var PartyNameList = [];
function getTypeTransactionPartyList(partyName, TYPE) {
  return TransectionArray.filter(function (d) {
    return d.code == partyName && d.TYPE == TYPE;
  });
}
function getTypeList(code) {
  return transactionList.filter(function (d) {
    return d.code == code;
  })
}


var ReportType = getUrlParams(url, "ReportType");
var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
// console.log(ReportType, ReportSeriesTypeCode, ReportATypeCode, ReportDOC_TYPECode);

var GRD;
function jsLoadCallBLS_TRANSACTION_WISE(data) {
  tr = '';
  TransectionArray = [];
  transactionList = [];
  PartyNameList = [];
  Data = data;
  var ccode;
  var pcode = "";
  var city;
  var broker = "";
  var label = "";
  var grandtotalNETBILLAMT = 0;
  var grandsubtotalGROSSAMT = 0;
  var grandtotalPAIDAMT = 0;
  var grandtotalAmount = 0;
  var totalNETBILLAMT;
  var subtotalGROSSAMT;
  var totalPAIDAMT;
  var totalAmount;
  var BLL;
  var FdataUrl
  var DL = Data.length;
  if (DL > 0) {
    
    // console.log(Data);
    var flagParty = [];
    var flagTYPE = [];

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
        obj.PRCL = Data[i].billDetails[j].PRCL;
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
        if (!flagParty[Data[i].code]) {
          PartyNameList.push(Data[i].code);
          flagParty[Data[i].code] = true;
        }
        if (!flagTYPE[Data[i].code + Data[i].billDetails[j].TYPE]) {
          var obj = {};
          obj.code = Data[i].code;
          obj.TYPE = Data[i].billDetails[j].TYPE;
          obj.SERIES = Data[i].billDetails[j].SERIES;
          transactionList.push(obj);
          flagTYPE[Data[i].code + Data[i].billDetails[j].TYPE] = true;
        }
      }
    }
    
    // console.log(PartyNameList);
    
    // console.log(transactionList);
    transactionList = transactionList.sort()

    var grandsubTotalGrossAmt = 0;
    var grandsubTotalfinalAmt = 0;
    var grandsubtotalMTS = 0;
    var grandTotalParcels = 0;
    var totalsr = 0;

    var tr = '';
   for (let i = 0; i < PartyNameList.length; i++) {
    var totalGrossAmt = 0;
    var totalFinalAmt = 0;
    var totalMTS = 0;
    var totalsr = 0;
    var totalParcel=0;
    const element = PartyNameList[i];
    ccode = getPartyDetailsBySendCode(Data[i].code);
  
    // console.log(Data[i].code+"-",ccode);
    if(ccode.length>0){
    pcode = getValueNotDefine(ccode[0].partyname);
    city = getValueNotDefine(ccode[0].city);
    broker = getValueNotDefine(ccode[0].broker);
    label = getValueNotDefine(ccode[0].label);
    MO = getValueNotDefine(ccode[0].MO);
  }
    tr += `<tr class="trPartyHead">
          <th  colspan="16" class="trPartyHead"><b >` + label + `</th>
      </tr>`;
    var PartyTransactionList=getTypeList(PartyNameList[i]);
    
    // console.log(PartyTransactionList);
      for (let j = 0; j < PartyTransactionList.length; j++) {
        const element = PartyTransactionList[j];
        tr += `<tr class="pinkHeading">
            <th  colspan="16" style="text-align:left;"><b >` + element.SERIES  + `</th>
         </tr>`;
         var TypeTransactionList=getTypeTransactionPartyList(PartyNameList[i],element.TYPE);
        
        //  console.log(TypeTransactionList);
        if(TypeTransactionList.length>0){
          tr += `<tr style="font-weight:500;"align="center">
                    
          <th class="pdfBtnHide">PDF</th>
          <td class="selectBoxReport" style="display:none;">
           SELECT<input type="checkbox" checked onchange="checkAllEntry(this);"/>
           </td>
          <th>BILL</th>
          <th class="hideBWPWDATE">BILL&nbsp;DATE</th>
          <th class="hideBWPWFIRM">FIRM</th>
          <th class="hideBWPWGROSSAMT">GROSS.AMT</th>
          <th class="hideBWPWGST">GST</th>
          <th class="hideBWPWTYPE">TYPE</th>
          <th class="hideBWPWQUAL" style="display:none;">QUAL</th>
          <th class="hideBWPWRATE" style="display:none;">RATE</th>
          <th class="hideBWPWMTS" style="display:none;">MTS</th>
          <th class="hideBWPWPARCEL"style="display:none;">PARCEL</th>
          <th class="hideBWPWFINALAMT">BILL AMT</th>
          <th class="hideBWPWPAID">PAID</th>
          <th class="hideBWPWAGHASTE">AG./HASTE</th>
          <th class="hideBWPWTRANSPORT">TRANSPORT</th>
          <th class="hideBWPWLRNO">LR NO</th>
          <th class="hideBWPWGRADE" style="display:none;">GRADE</th>
          <th class="hideBWPWRMK" style="display:none;">RMK</th>
          <th class="hideBWPWEWB" style="display:none;">EWB</th>
          <th class="hideDAYS" style="display:none;">DAYS</th>
          </tr>`;
          
        subtotalGrossAmt = 0;
        subtotalFinalAmt = 0;
        subtotalMTS = 0;
        subtotalParcel=0;
        sr = 0;
        for (let k = 0; k < TypeTransactionList.length; k++) {
          const ele = TypeTransactionList[k];
          
          sr += 1;
          var grsAmt = 0;
          var fnlAmt = 0;
          if (ele.DT != null && ele.DT != "") {
            if (ele.DT.toUpperCase().indexOf('CN')) {
              grsAmt = +Math.abs(ele.grsamt);
              fnlAmt = +Math.abs(ele.BAMT);
            } else if (ele.DT.toUpperCase().indexOf('DN')) {
              grsAmt = -Math.abs(ele.grsamt);
              fnlAmt = -Math.abs(ele.BAMT);
            } else if (ele.DT.toUpperCase().indexOf('OS')) {
              grsAmt = -Math.abs(ele.grsamt);
              fnlAmt = -Math.abs(ele.BAMT);
            } else {
              grsAmt = -Math.abs(ele.grsamt);
              fnlAmt = -Math.abs(ele.BAMT);
            }
          } else {
            grsAmt = -Math.abs(ele.grsamt);
            fnlAmt = -Math.abs(ele.BAMT);
          }
          TMTS = ele.TMTS == null ? 0 : parseFloat(ele.TMTS);
          subtotalGrossAmt += parseFloat(grsAmt);
          subtotalFinalAmt += parseFloat(fnlAmt);
          subtotalMTS += TMTS;
          GST = parseFloat(ele.VTAMT) + parseFloat(ele.ADVTAMT);
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(ele.CNO, ele.TYPE, ele.VNO, getFirmDetailsBySendCode(ele.CNO)[0].FIRM, ele.IDE, ccode[0].MO, ccode[0].EML);

          var BrokerHaste = '';
          var HST = ele.haste;
          if (HST != '' && HST != null && HST != undefined) {
            BrokerHaste = HST;
          } else {
            BrokerHaste = ele.BCODE;
          }
          var ID = ele.CNO + ele.TYPE + ele.VNO;
          const PARCEL = ele.PRCL;
          subtotalParcel += parseInt(PARCEL);
          tr += `<tr align="center"class="hideAbleTr">
                        <th class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                        <td class="selectBoxReport" style="display:none;">      <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + ele.CNO + `"DTYPE="` + ele.TYPE + `"VNO="` + ele.VNO + `"/></td>
                        <td><a href="`+ FdataUrl + `" target="_blank"><button>` + ele.BILL + `</button><a></td>
                        <td class="hideBWPWDATE" onclick="openSubR('`+ ele.code + `')">` + formatDate(ele.DATE) + `</td>
                        <td class="hideBWPWFIRM" onclick="openSubR('`+ ele.code + `')">` + ele.FRM + `</td>
                        <td class="hideBWPWGROSSAMT" onclick="openSubR('`+ ele.code + `')">` + valuetoFixed(grsAmt) + `</td>
                        <td class="hideBWPWGST" onclick="openSubR('`+ ele.code + `')">` + valuetoFixed(GST) + `</td>
                        <td class="hideBWPWTYPE" onclick="openSubR('`+ ele.code + `')">` + ele.SERIES + `</td>
                        <td class="hideBWPWQUAL" style="display:none;" onclick="openSubR('`+ ele.code + `')">` + getValueNotDefine(ele.QUAL) + `</td>
                        <td class="hideBWPWRATE" style="display:none;" onclick="openSubR('`+ ele.code + `')">` + getValueNotDefine(ele.GRT) + `</td>
                        <td class="hideBWPWMTS" style="display:none;" onclick="openSubR('`+ ele.code + `')">` + TMTS + `</td>
                        <td class="hideBWPWPARCEL" style="display:none;" onclick="openSubR('`+ ele.code + `')">` + PARCEL + `</td>
                        <td class="hideBWPWFINALAMT" onclick="openSubR('`+ ele.code + `')">` + valuetoFixed(fnlAmt) + `</td>
                        <td class="hideBWPWPAID" onclick="openSubR('`+ ele.code + `')">` + ele.paid + `</td>
                        <td class="hideBWPWAGHASTE" onclick="openSubR('`+ ele.code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                        <td class="hideBWPWTRANSPORT" onclick="openSubR('`+ ele.code + `')">` + getValueNotDefine(ele.TRNSP) + `</td>
                        <td class="hideBWPWLRNO" onclick="openSubR('`+ ele.code + `')">` + getValueNotDefine(ele.RRNO) + `</td>
                        <td class="hideBWPWGRADE" style="display:none;" onclick="openSubR('`+ ele.code + `')">` + getValueNotDefine(ele.GRD) + ` </td>
                        <td class="hideBWPWRMK" style="display:none;" onclick="openSubR('`+ ele.code + `')">` + getValueNotDefine(ele.RMK) + ` </td>
                <th class="hideBWPWEWB" style="display:none;"onclick="openSubR('`+ ele.code + `')">` + getValueNotDefine(ele.EWB) + `</th>
                <th class="hideDAYS" style="display:none;"onclick="openSubR('`+ ele.code + `')">` +  getDaysDif(ele.DATE, nowDate) + `</th>
                </tr>`;
                        
                        if (productDet == 'Y') {
                        
                          // console.log(Data[i].billDetails[j].IDE);
                          tr += jsgetArrayProductdetailsbyIDE(ele.IDE);
                         
                        }
          }

          tr += `<tr class="tfootcard">
                       <th class="pdfBtnHide"></th>
                       <th class="selectBoxReport" style="display:none;"></th>
                       <th></th>
                        <th class="hideBWPWDATE" >SUBTOTAL</th>
                        <th class="hideBWPWFIRM" >(`+ sr + `)</th>
                        <th class="hideBWPWGROSSAMT" >`+ valuetoFixed(subtotalGrossAmt) + `</th>
                        <th class="hideBWPWGST"></th>
                        <th class="hideBWPWTYPE"></th>
                        <th class="hideBWPWQUAL" style="display:none;" ></th>                        
                        <th class="hideBWPWRATE" style="display:none;" ></th>                        
                        <th class="hideBWPWMTS" style="display:none;" >`+ valuetoFixed(subtotalMTS) + `</th>
                        <th class="hideBWPWPARCEL" style="display:none;" >`+ subtotalParcel + `</th>
                        <th class="hideBWPWFINALAMT" >`+ valuetoFixed(subtotalFinalAmt) + `</th>
                        <th class="hideBWPWPAID" ></th>
                        <th class="hideBWPWAGHASTE" ></th>
                        <th class="hideBWPWTRANSPORT" ></th>
                        <th class="hideBWPWLRNO" ></th>
                        <th class="hideBWPWGRADE" style="display:none;"></th>
                        <th class="hideBWPWRMK" style="display:none;"></th>
          <th class="hideBWPWEWB" style="display:none;"></th>
          <th class="hideDAYS" style="display:none;"></th>
          </tr>`;
                        totalGrossAmt +=subtotalGrossAmt;
                        totalMTS +=subtotalMTS;
                        totalFinalAmt +=subtotalFinalAmt;
                        totalsr +=sr;
                        totalParcel +=subtotalParcel;
        }
       
      }
      if(PartyTransactionList.length>1){
        tr += `<tr class="tfootcard">
        <th class="pdfBtnHide"></th>
        <th class="selectBoxReport" style="display:none;"></th>
        <th></th>
        <th class="hideBWPWDATE" >TOTAL</th>
        <th class="hideBWPWFIRM" >(`+ totalsr + `)</th>
        <th class="hideBWPWGROSSAMT" >`+ valuetoFixed(totalGrossAmt) + `</th>
        <th class="hideBWPWGST"></th>
        <th class="hideBWPWTYPE"></th>
        <th class="hideBWPWQUAL" style="display:none;" ></th>                        
        <th class="hideBWPWRATE" style="display:none;" ></th>                        
        <th class="hideBWPWMTS" style="display:none;" >`+ valuetoFixed(totalMTS) + `</th>
        <th class="hideBWPWPARCEL" style="display:none;" >`+ totalParcel + `</th>
        <th class="hideBWPWFINALAMT" >`+ valuetoFixed(totalFinalAmt) + `</th>
        <th class="hideBWPWPAID" ></th>
        <th class="hideBWPWAGHASTE" ></th>
        <th class="hideBWPWTRANSPORT" ></th>
        <th class="hideBWPWLRNO" ></th>
        <th class="hideBWPWGRADE" style="display:none;"></th>
        <th class="hideBWPWRMK" style="display:none;"></th>
          <th class="hideBWPWEWB" style="display:none;"></th>
          <th class="hideDAYS" style="display:none;"></th>
          </tr>`;
      }
       grandsubTotalGrossAmt +=totalGrossAmt;
       grandsubTotalfinalAmt +=totalFinalAmt
       grandsubtotalMTS +=totalMTS;
       grandTotalParcels +=totalParcel;
       totalGrossAmt=0;
       totalFinalAmt=0;
       totalMTS=0;
       totalParcel=0;
   }
   if(PartyNameList.length>1){
    tr += `<tr class="tfootcard">
      <th class="pdfBtnHide"></th>
      <th class="selectBoxReport" style="display:none;"></th>
      <th></th>
      <th class="hideBWPWDATE" >GRAND TOTAL</th>
      <th class="hideBWPWFIRM" >(`+ totalsr + `)</th>
      <th class="hideBWPWGROSSAMT" >`+ valuetoFixed(grandsubTotalGrossAmt) + `</th>
      <th class="hideBWPWGST"></th>
      <th class="hideBWPWTYPE"></th>
      <th class="hideBWPWQUAL" style="display:none;" ></th>                        
      <th class="hideBWPWRATE" style="display:none;" ></th>                        
      <th class="hideBWPWMTS" style="display:none;" >`+ valuetoFixed(grandsubtotalMTS) + `</th>
      <th class="hideBWPWPARCEL" style="display:none;" >`+ grandTotalParcels + `</th>
      <th class="hideBWPWFINALAMT" >`+ valuetoFixed(grandsubTotalfinalAmt) + `</th>
      <th class="hideBWPWPAID" ></th>
      <th class="hideBWPWAGHASTE" ></th>
      <th class="hideBWPWTRANSPORT" ></th>
      <th class="hideBWPWLRNO" ></th>
      <th class="hideBWPWGRADE" style="display:none;"></th>
      <th class="hideBWPWRMK" style="display:none;"></th>
      <th class="hideBWPWEWB" style="display:none;"></th>
          <th class="hideDAYS" style="display:none;"></th>
          </tr>`;
  }
  
  // console.log(TransectionArray, transactionList, PartyNameList);
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

