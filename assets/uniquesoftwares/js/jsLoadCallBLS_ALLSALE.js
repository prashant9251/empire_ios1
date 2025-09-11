
var MainArr = [];
var ReportType = getUrlParams(url, "ReportType");
var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
var order = getUrlParams(url, "order");

  
function jsLoadCallBLS_ALLSALE(Data) {
  MainArr = [];
// console.log(Data);
  for (i = 0; i < Data.length; i++) {
    if (Data[i].billDetails.length > 0) {
      for (j = 0; j < Data[i].billDetails.length; j++) {
        var obj = {};
        obj.code = Data[i].code;
        obj.CNO = Data[i].billDetails[j].CNO;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.VNO = Data[i].billDetails[j].VNO;
        obj.IDE = Data[i].billDetails[j].IDE;
        obj.TRNSP = Data[i].billDetails[j].TRNSP;
        obj.RRNO = Data[i].billDetails[j].RRNO;
        obj.BILL = Data[i].billDetails[j].BILL;
        obj.DATE = Data[i].billDetails[j].DATE;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.BAMT = Data[i].billDetails[j].BAMT;
        obj.fnlamt = Data[i].billDetails[j].fnlamt;
        obj.TMTS = Data[i].billDetails[j].TMTS
        obj.SERIES = Data[i].billDetails[j].SERIES
        obj.PRCL = Data[i].billDetails[j].PRCL
        obj.paid = Data[i].billDetails[j].paid
        obj.EWB = Data[i].billDetails[j].EWB
        MainArr.push(obj);
      }
    }
  }


  // console.log(MainArr);
  if (order == 'ASC') {
    Data = MainArr.sort(function (a, b) { return a.DATE - b.DATE });
    Data = Data.sort(function (a, b) { return a.VNO - b.VNO });
  } else {
    Data = MainArr.sort(function (a, b) { return b.DATE - a.DATE });
    Data = Data.sort(function (a, b) { return b.VNO - a.VNO });
  }

  if (this.fromdate !== '' && this.fromdate !== null) {
    Data = Data.filter(function (data) {
      return new Date(data.DATE).setHours(0, 0, 0, 0) >= new Date(this.fromdate).setHours(0, 0, 0, 0);
    })
  }
  if (todate !== '' && todate !== null) {
    Data = Data.filter(function (data) {
      return new Date(data.DATE).setHours(24, 0, 0, 0) <= new Date(this.todate).setHours(24, 0, 0, 0);
    })
  }
  // console.log(Data)

  var totalGrossAmt;
  var totalFinalAmt;
  var totalmts;
  var totalParcel;
  var GST;
  var FdataUrl;
  var ccode;
  var pcode;
  var city;
  var broker;
  var label;
  var grandTotalGrossAmt;
  var grandTotalfinalAmt;
  var grandTotalMts;
  var DL = Data.length;
  var BLL;
  if (DL > 0) {
    grandTotalGrossAmt = 0;
    grandTotalfinalAmt = 0;
    grandTotalMts = 0;
    var MO = '';
    if (partycode != '' && partycode != null) {
      ccode = getPartyDetailsBySendCode(partycode);
      pcode = getValueNotDefine(ccode[0].partyname);
      city = getValueNotDefine(ccode[0].city);
      broker = getValueNotDefine(ccode[0].broker);
      label = getValueNotDefine(ccode[0].label);
      MO = getValueNotDefine(ccode[0].MO);
      tr += `<tr  class="trPartyHead" style="font-weight:bolder;height:50px;"align="left">
                      <th colspan="22"class="trPartyHead">` + label + `</th>  
                       </tr>
                     `;
    }
    if (this.broker != '' && this.broker != null) {
      tr += `<tr  class="trPartyHead" style="font-weight:bolder;height:50px;"align="left">
                       colspan="22"class="trPartyHead">BROKER - ` + getPartyDetailsBySendCode(this.broker)[0].partyname + `</th>  
                       </tr>
                     `;
    }
    if (haste != '' && haste != null) {
      tr += `<tr  class="trPartyHead" style="font-weight:bolder;height:50px;"align="left">
                      <th colspan="22"class="trPartyHead">HASTE - ` + haste + `</th>  
                       </tr>
                     `;
    }
    if (CITY != '' && CITY != null) {
      tr += `<tr  class="trPartyHead" style="font-weight:bolder;height:50px;"align="left">
                      <th colspan="22"class="trPartyHead">CITY - ` + CITY + `</th>  
                       </tr>
                     `;
    }
    tr += `<tr  style="background-color:grey;color:white" >
    <th class="hidePDF">PDF</th>
    <th class="hideBILL">BILL</th>
    <th class="hideDATE">BILLDATE</th>
    <th class="hidePARTYNAME">PARTY NAME</th>
    <th class="hideFIRM">FIRM</th>
    <th class="hideMTS">MTS</th>
    <th class="hideTYPE">TYPE</th>
    <th class="hidePARCEL" style="display:none;">PARCEL</th>
    <th class="hideBILLAMT">BILL AMT</th>
    <th class="hidePAID">PAID</th>
    <th class="hideEWB" style="display:none;">EWB</th>
    <th class="hideDAYS" style="display:none;">DAYS</th>
    <th class="hideTRANSPORT" style="display:none;">TRANSPORT</th>
    <th class="hideLR" style="display:none;">LR</th>
    </tr>`;

    totalGrossAmt = 0;
    totalFinalAmt = 0;
    totalmts = 0;
    totalParcel = 0;
    var sr = 0;
    for (k = 0; k < DL; k++) {
      sr += 1;
      TMTS = Data[k].TMTS == null ? 0 : parseFloat(Data[k].TMTS);
      totalGrossAmt += parseFloat(Data[k].grsamt);
      totalFinalAmt += parseFloat(Data[k].BAMT);
      totalmts += TMTS;
      GST = parseFloat(Data[k].VTAMT) + parseFloat(Data[k].ADVTAMT);
      var pccode = getPartyDetailsBySendCode(Data[k].code);
      if(pccode.length>0){
        MO=getValueNotDefine(pccode[0].MO);
      }
      FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[k].CNO, Data[k].TYPE, Data[k].VNO, getFirmDetailsBySendCode(Data[k].CNO)[0].FIRM, Data[k].IDE, MO);

      const PARCEL = Data[k].PRCL;
      totalParcel += parseInt(PARCEL);
      tr += `<tr>
                <td  class="hidePDF"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></td>
                <td  class="hideBILL"><a href="`+ FdataUrl + `" target="_blank"><button>` + Data[k].BILL + `</button><a></td>
                <td  class="hideDATE">`+ formatDate(Data[k].DATE) + `</td>
                <td  class="hidePARTYNAME"  onclick="openSubR('`+ Data[k].code + `')">`+ (Data[k].code) + `</td>
                <td  class="hideFIRM">`+ Data[k].FRM + `</td>
                <td  class="hideMTS"  >`+ TMTS + `</td>
                <td  class="hideTYPE">`+ Data[k].SERIES + `</td>
                <td  class="hidePARCEL" style="display:none;">`+ PARCEL + `</td>
                <td  class="hideBILLAMT">`+ valuetoFixed(Data[k].BAMT) + `</td>
                <td  class="hidePAID">`+ Data[k].paid + `</td>
                <td  class="hideEWB" style="display:none;">`+ Data[k].EWB + `</td>
                <td  class="hideDAYS" style="display:none;">`+getDaysDif(Data[k].DATE, nowDate) + `</td>
                <td  class="hideTRANSPORT" style="display:none;">`+ Data[k].TRNSP + `</td>
                <td  class="hideLR" style="display:none;">`+ Data[k].RRNO + `</td>
                </tr>`;

      if (productDet == 'Y') {
        // console.log(Data[i].billDetails[j].IDE);
        tr += jsgetArrayProductdetailsbyIDE(Data[k].IDE);
        
      }
    }

    grandTotalGrossAmt += totalGrossAmt;
    grandTotalfinalAmt += totalFinalAmt;
    grandTotalMts += totalmts;

    tr += `<tr class="tfootcard">
                    <th class="hidePDF">TOTAL </th>
                    <th class="hideBILL"></th>
                    <th class="hideDATE"></th>
                    <th class="hidePARTYNAME">(`+ valuetoFixedNo(sr) + `)</th>
                    <th class="hideFIRM"></th>
                    <th class="hideMTS">`+ valuetoFixed(totalmts) + `</th>
                    <th class="hideTYPE"></th>
                    <th class="hidePARCEL" style="display:none;">`+ totalParcel + `</th>
                    <th class="hideBILLAMT">`+ valuetoFixed(totalFinalAmt) + `</th>
                    <th class="hidePAID"></th>
                    <th class="hideEWB" style="display:none;"></th>
                    <th class="hideDAYS" style="display:none;"></th>
                    <th class="hideTRANSPORT" style="display:none;"></th>
                    <th class="hideLR" style="display:none;"></th>
                    </tr>`;
                    
    $('#result').append(tr);
    $("#loader").removeClass('has-loader');
    hideList();
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }

}