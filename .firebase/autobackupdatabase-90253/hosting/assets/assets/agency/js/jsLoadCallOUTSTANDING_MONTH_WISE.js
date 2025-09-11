

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
const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];
var GRD;


function getMonthListOfParty(COD) {
  return MonthList.filter(function (d) {
    return d.COD == COD;
  })
}

function getmonthWiseDetails(COD, monthName, selectYear) {
  return MainArr.filter(function (d) {
    return d.COD == COD && d.monthName == monthName && d.selectYear == selectYear;
  })
}
var MonthList = [];
var PartynameList = [];
function loadCall(data) {
  var MonthListFlg = [];
  var PartynameListFlg = [];
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
        var monthName = "";
        try {
          var d = new Date(Data[i].billDetails[j].DTE);
          var selectYear = d.getFullYear();
          var monthName = monthNames[d.getMonth()];
          var monthNo = d.getMonth();
          // console.log(selectYear);
        } catch (error) {

        }
        if (!MonthListFlg[Data[i].COD + monthName + selectYear]) {
          var Nobj = {}
          Nobj.COD = Data[i].COD;
          Nobj.monthName = monthName;
          Nobj.selectYear = selectYear;
          Nobj.monthNo = monthNo;
          
          MonthList.push(Nobj);
          MonthListFlg[Data[i].COD + monthName + selectYear] = true;
        }
        if (!PartynameListFlg[Data[i].COD]) {
          PartynameList.push(Data[i].COD);
          PartynameListFlg[Data[i].COD] = true;
        }
        obj.monthName = monthName;
        obj.selectYear = selectYear;
        MainArr.push(obj);
     


      }
    }
  }
  MonthList=MonthList.sort(function(a,b){
    return   a.monthNo-b.monthNo;
  })
  // console.log(MainArr);
  if (PartynameList.length > 0) {
    for (let i = 0; i < PartynameList.length; i++) {
      const partyName = PartynameList[i];


      ccode = getPartyDetailsBySendCode(partyName);
      // console.log(ccode, partyName);
      if (ccode.length > 0) {
        pcode = getValueNotDefine(ccode[0].partyname);
        city = getValueNotDefine(ccode[0].city);
        broker = getValueNotDefine(ccode[0].broker);
        label = getValueNotDefine(ccode[0].label);
        MO = getValueNotDefine(ccode[0].MO);
      }
      tr += `<tr class="trPartyHead"onclick="trOnClick('` + partyName + `','` + city + `','` + broker + `');">
                        <th colspan="16" class="trPartyHead">` + label + `<a href="tel:` + MO + `"><button>MO:` + getValueNotDefine(MO) + `</button></a></th>
                      </tr>
                      `;

      var MonthListOfParty = getMonthListOfParty(partyName);
      for (let j = 0; j < MonthListOfParty.length; j++) {
        const month = MonthListOfParty[j];
        tr += `<tr >
        <th colspan="16" style="font-weight:bolder;font-size:20px;background-color:#f3f3f3;color:#c107a2;text-align:left;">`+ month.monthName + ` ` + month.selectYear + `</th>
          </tr>
          <tr style="font-weight:bold;"align="center">                    
          <th >BILL</th>
          <th >DATE</th>
          <th class="hidePWMWSUPP">SUPPLIER</th>
          <th class="hidePWMWFRM">FIRM</th>
          <th class="hidePWMWVNO">VNO</th>
          <th class="hidePWMWGROSSAMT">GROSS <br>AMT</th>
          <th class="hidePWMWTYPE" style="display:none;">TYPE</th>
          <th class="hidePWMWNETBILLAMT">NET AMT</th>
          <th class="hidePWMWGOODSRET">GOODS<br>RET.</th>
          <th class="hidePWMWPAID">PAID <BR> AMT</th>
          <th class="hidePWMWPEND">PEND<br>AMT.</th>
          <th class="hidePWMWDIS" style="display:none;">DIS%</th>
          <th class="hidePWMWDISAMT" style="display:none;">DISAMT</th>
          <th class="hidePWMWGROUP">GROUP</th>
          <th class="hidePWMWBROKER"style="display:none;">BROKER</th>
          <th class="hidePWMWDAYS">DAYS</th>
          <th class="hidePWMWTRANSPORT">TRANSPORT</th>
          <th class="hidePWMWLR">LR NO</th>
          </tr> 
          `;

        var monthWiseDetails = getmonthWiseDetails(partyName, month.monthName, month.selectYear);
        // console.log(partyName, month.monthName, month.selectYear, monthWiseDetails);
        for (let k = 0; k < monthWiseDetails.length; k++) {
          const element = monthWiseDetails[k];
          var transport = (element.TR);

          var UrlPaymentSlip = getUrlPaymentSlip(element.CNO, (element.TYPE).replace("ZS", ""), element.VNO, (element.IDE).replace("ZS", ""));
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(element.CNO, element.TYPE, element.VNO, getFirmDetailsBySendCode(element.CNO)[0].FIRM, element.IDE);
          var urlopen = '';
          var TYPEforLink = (element.TYPE).toUpperCase();
          if (TYPEforLink.indexOf('B') > -1) {

            urlopen = UrlPaymentSlip;
          } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
            urlopen = FdataUrl;
          }
          var BAMT = 0;
          var FAMT = 0;
          var CLM = 0;
          var RAMT = 0;
          var PAMT = 0;
          BAMT = parseInt((element.BAMT == null) ? 0 : element.BAMT);
          FAMT = parseInt((element.FAMT == null) ? 0 : element.FAMT);
          CLM = parseInt((element.CLM == null) ? 0 : element.CLM);
          RAMT = parseInt((element.RAMT == null) ? 0 : element.RAMT);
          PAMT = parseInt((element.PAMT == null) ? 0 : element.PAMT);
          subtotalGROSSAMT += (BAMT);
          subtotalNETBILLAMT += (FAMT);
          subtotalGOODSRETURN += (CLM);
          subtotalPAIDAMT += (RAMT);
          subtotalAmount += (PAMT);
          var BCD = "";
          var BrokerArr = getPartyDetailsBySendCode(element.BCD);
          if (BrokerArr.length > 0) {
            BCD = getValueNotDefine(BrokerArr[0].partyname);
          }
          tr += ` 
                 <tr align="center"style="">
                 <th><a href="`+ FdataUrl + `" target="_blank"><button class="PrintBtnHide">` + element.BLL + `</button></a></th>
                 <th onclick="openSubR('`+ element.COD + `')">` + formatDate(element.DTE) + `</th>
                 <th  class="hidePWMWSUPP"onclick="openSubR('`+ element.COD + `','` + element.ccd + `')">` + (element.ccd) + `</th>
                                <th class="hidePWMWFRM" onclick="openSubR('`+ element.COD + `')">` + (element.FRM) + `</th>
                                <th class="hidePWMWVNO" onclick="openSubR('`+ element.COD + `')">` + (element.VNO) + `</th>
                                    <th class="hidePWMWGROSSAMT" onclick="openSubR('`+ element.COD + `')">` + (BAMT) + `</th>
                                    <th class="hidePWMWTYPE" style="display:none;" onclick="openSubR('`+ element.COD + `')">` + (element.TYPE) + `</th>
                                    <th class="hidePWMWNETBILLAMT" onclick="openSubR('`+ element.COD + `')">` + (FAMT) + `</th>
                                    <th class="hidePWMWGOODSRET" onclick="openSubR('`+ element.COD + `')">` + (CLM) + `</th>
                                    <th class="hidePWMWPAID" onclick="openSubR('`+ element.COD + `')">` + (RAMT) + `</th>
                                    <th class="hidePWMWPEND"onclick="openSubR('`+ element.COD + `')">` + (PAMT) + `</th>
                                    <tH class="hidePWMWDIS" style="display:none;"onclick="openSubR('','` + element.ccd + `')">` + getValueNotDefine(element.DR) + ` </tH> 
                                    <tH class="hidePWMWDISAMT" style="display:none;"onclick="openSubR('','` + element.ccd + `')">` + getValueNotDefine(element.DA) + ` </tH> 
                                    <th class="hidePWMWGROUP"onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.SG) + ` </th>                                    
                                    <th class="hidePWMWBROKER"style="display:none;"onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(BCD) + ` </th>
                                    <th class="hidePWMWDAYS"onclick="openSubR('`+ element.COD + `')">` + getDaysDif(element.DTE, nowDate) + ` </th>
                                    <th class="hidePWMWTRANSPORT" onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(transport) + ` </th>
                                    <th class="hidePWMWLR"onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.LR) + ` </th>
                                    
                                </tr>`;


        }
        tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
        <tr class="tfootcard"style="background-color:#3e3b3b26;text-align: center;">
            <th class="" style="text-align:left;"colspan="2">SUB TOTAL</th>
            <th  class="hidePWMWSUPP"></th>   
            <th class="hidePWMWFRM" ></th>
            <th class="hidePWMWVNO" ></th>
            <th class="hidePWMWGROSSAMT">` + valuetoFixed(subtotalGROSSAMT) + `</th>
            <th class="hidePWMWTYPE" style="display:none;" ></th>
            <th class="hidePWMWNETBILLAMT">` + valuetoFixed(subtotalNETBILLAMT) + `</th>
            <th class="hidePWMWGOODSRET" >` + valuetoFixed(subtotalGOODSRETURN) + `</th>
            <th class="hidePWMWPAID" >` + valuetoFixed(subtotalPAIDAMT) + `</th>
            <th class="hidePWMWPEND" >` + valuetoFixed(subtotalAmount) + `</th>
            <tH class="hidePWMWDIS" style="display:none;" ></tH>
            <tH class="hidePWMWDISAMT" style="display:none;" ></tH>
            <th class="hidePWMWGROUP" ></th>
            <th class="hidePWMWBROKER"style="display:none;"></th>
            <th class="hidePWMWDAYS"></th>
            <th class="hidePWMWTRANSPORT"></th>
            <th class="hidePWMWLR"></th>
        </tr>`;
        totalNETBILLAMT += subtotalNETBILLAMT;
        totalGROSSAMT += subtotalGROSSAMT;
        totalGOODSRETURN += subtotalGOODSRETURN;
        totalPAIDAMT += subtotalPAIDAMT;
        totalAmount += subtotalAmount;
        subtotalNETBILLAMT = 0;
        subtotalGROSSAMT = 0;
        subtotalGOODSRETURN = 0;
        subtotalPAIDAMT = 0;
        subtotalAmount = 0;
      }
      tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
      <tr class="tfootcard"style="background-color:#3e3b3b26;text-align: center;">
          <th class="" style="text-align:left;"colspan="2">TOTAL</th>
          <th  class="hidePWMWSUPP"></th>   
          <th class="hidePWMWFRM" ></th>
          <th class="hidePWMWVNO" ></th>
          <th class="hidePWMWGROSSAMT">` + valuetoFixed(totalGROSSAMT) + `</th>
          <th class="hidePWMWTYPE" style="display:none;" ></th>
          <th class="hidePWMWNETBILLAMT">` + valuetoFixed(totalNETBILLAMT) + `</th>
          <th class="hidePWMWGOODSRET" >` + valuetoFixed(totalGOODSRETURN) + `</th>
          <th class="hidePWMWPAID" >` + valuetoFixed(totalPAIDAMT) + `</th>
          <th class="hidePWMWPEND" >` + valuetoFixed(totalAmount) + `</th>
          <tH class="hidePWMWDIS" style="display:none;" ></tH>
          <tH class="hidePWMWDISAMT" style="display:none;" ></tH>
          <th class="hidePWMWGROUP" ></th>
          <th class="hidePWMWBROKER"style="display:none;"></th>
          <th class="hidePWMWDAYS"></th>
          <th class="hidePWMWTRANSPORT"></th>
          <th class="hidePWMWLR"></th>
      </tr>`;
      grandtotalGROSSAMT += totalGROSSAMT;
      grandtotalNETBILLAMT += totalNETBILLAMT;
      grandtotalGOODSRETURN += totalGOODSRETURN;
      grandtotalPAIDAMT += totalPAIDAMT;
      grandtotalAmount += totalAmount;
      totalGROSSAMT = 0;
      totalNETBILLAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;
    }

    tr += `<tr class="tfootcard grandTotel"style="background-color:#3e3b3b26;color:#080844;">
    <th colspan="2" >GRAND TOTAL</th>
    <th class="hidePWMWSUPP"></th>   
    <th class="hidePWMWFRM" ></th>
    <th class="hidePWMWVNO" ></th>
    <th class="hidePWMWGROSSAMT">` + valuetoFixed(grandtotalGROSSAMT) + `</th>
    <th class="hidePWMWTYPE" style="display:none;" ></th>
    <th class="hidePWMWNETBILLAMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</th>
    <th class="hidePWMWGOODSRET" >` + valuetoFixed(grandtotalGOODSRETURN) + `</th>
    <th class="hidePWMWPAID" >` + valuetoFixed(grandtotalPAIDAMT) + `</th>
    <th class="hidePWMWPEND" >` + valuetoFixed(grandtotalAmount) + `</th>
    <tH class="hidePWMWDIS" style="display:none;" ></tH>
    <tH class="hidePWMWDISAMT" style="display:none;" ></tH>
    <th class="hidePWMWGROUP" ></th>
    <th class="hidePWMWBROKER"style="display:none;"></th>
    <th class="hidePWMWDAYS"></th>
    <th class="hidePWMWTRANSPORT"></th>
    <th class="hidePWMWLR"></th>
    </tr>`;
    $('#result').html(tr);
    $("#loader").removeClass('has-loader');

    var hideAbleTr = getUrlParams(url, "hidePWMWAbleTr");
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

