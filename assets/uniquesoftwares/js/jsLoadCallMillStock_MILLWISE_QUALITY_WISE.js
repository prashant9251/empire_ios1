
var url = window.location.href;
var PartyNameList = [];
var PartyQualList = [];
var MainArray = [];
function getMillQualityData_MWQW(code, Qual) {
  return MainArray.filter(function (d) {
    return d.code == code && d.QUAL == Qual;
  })
}
function getMillQualityName_MWQW(code) {
  return PartyQualList.filter(function (d) {
    return d.code == code;
  })
}

function jsLoadCallMillStock_MILLWISE_QUALITY_WISE(data) {
  var tr = '';

  Data = data;

  Data = Data.filter(function (data) {
    return data.billDetails.some((billDetails) => billDetails['BALPCS'] > 0 &&
      billDetails['BALMTS'] > 0);
  }).map(function (subdata) {
    return {
      code: subdata.code,
      billDetails: subdata.billDetails.filter(function (billDetails) {
        return (billDetails['BALPCS'] > 0 &&
          billDetails['BALMTS'] > 0);
      })
    }
  })

  var flagParty = [];
  var flagBroker = [];

  for (var i = 0; i < Data.length; i++) {
    for (var j = 0; j < Data[i].billDetails.length; j++) {
      var obj = {};
      obj.code = Data[i].code;
      obj.CNO = Data[i].billDetails[j].CNO;
      obj.TYPE = Data[i].billDetails[j].TYPE;
      obj.pay = Data[i].billDetails[j].pay;
      obj.part = Data[i].billDetails[j].part;
      obj.VNO = Data[i].billDetails[j].VNO;
      obj.CRD = Data[i].billDetails[j].CRD;
      obj.DSPNO = Data[i].billDetails[j].DSPNO;
      obj.DATE = Data[i].billDetails[j].DATE;
      obj.FRM = Data[i].billDetails[j].FRM;
      obj.QUAL = Data[i].billDetails[j].QUAL;
      obj.MAMT = Data[i].billDetails[j].MAMT;
      obj.BCOD = Data[i].billDetails[j].BCOD;
      obj.WVR = Data[i].billDetails[j].WVR;
      obj.PRET = Data[i].billDetails[j].PRET;
      obj.WMTS = Data[i].billDetails[j].WMTS;
      obj.WPCS = Data[i].billDetails[j].WPCS;
      obj.LOT = Data[i].billDetails[j].LOT;
      obj.ACTRPCS = Data[i].billDetails[j].ACTRPCS;
      obj.ACTRMTS = Data[i].billDetails[j].ACTRMTS;
      obj.SORTEG = Data[i].billDetails[j].SORTEG;
      obj.SORTMT = Data[i].billDetails[j].SORTMT;
      obj.BALPCS = Data[i].billDetails[j].BALPCS;
      obj.BALMTS = Data[i].billDetails[j].BALMTS;
      obj.WAMT = Data[i].billDetails[j].WAMT;
      obj.VAM = Data[i].billDetails[j].VAM;
      obj.AVAM = Data[i].billDetails[j].AVAM;
      obj.STG = Data[i].billDetails[j].STG;
      obj.DSG = Data[i].billDetails[j].DSG;
      obj.MRT = Data[i].billDetails[j].MRT;
      obj.R = Data[i].billDetails[j].R;
      obj.DR = Data[i].billDetails[j].DR;
      MainArray.push(obj);
      if (!flagParty[Data[i].code]) {
        PartyNameList.push(Data[i].code);
        flagParty[Data[i].code] = true;
      }
      if (!flagParty[Data[i].code + Data[i].billDetails[j].QUAL]) {
        var obj = {};
        obj.code = Data[i].code;
        obj.QUAL = Data[i].billDetails[j].QUAL;
        PartyQualList.push(obj);
        flagParty[Data[i].code + Data[i].billDetails[j].QUAL] = true;
      }
    }
  }
  console.log(PartyNameList, MainArray, PartyQualList);


  MainArray = MainArray.sort(function (a, b) {
    return new Date(a.DATE) - new Date(b.DATE) || parseInt(getValueNotDefine(a.DSPNO)) - parseInt(getValueNotDefine(b.DSPNO));
  });






  console.log(Data);
  var ccode;
  var pcode;
  var city;
  var broker;
  var label;
  var grandTotalWpcs = 0;
  var grandTotalWmts = 0;
  var grandTotalRmts = 0;
  var grandTotalBalpcs = 0;
  var grandTotalBalmts = 0;
  var grandTotalBalAmt = 0;
  var totalWpcs = 0;
  var totalWmts = 0;
  var totalRmts = 0;
  var totalBalpcs = 0;
  var totalBalmts = 0;
  var totalBalAmt = 0;
  var BLL;
  if (PartyNameList.length > 0) {

    for (let i = 0; i < PartyNameList.length; i++) {
      tr += `<tr class="trPartyHead" >
      <th colspan="25" class="trPartyHead" >` + PartyNameList[i] + `</th>                                    
      </tr>`;
      var MillQualityName = getMillQualityName_MWQW(PartyNameList[i]);
      MillQualityName = MillQualityName.sort(function (a, b) {
        return a.QUAL < b.QUAL ? -1 : 1;
      })
      for (let j = 0; j < MillQualityName.length; j++) {
        if (j == 0) {
          tr += `
            <tr class=""style=""align="center">   
            <th class="selectBoxReport" style="display:none;">
            SELECT<input type="checkbox" onchange="checkAllEntry(this);"/>
            </th>     
            <th class="unHAbleTr">QUALITY</th>                  
            <th class=" HAbleTr">DESP&nbsp;DATE</th>
            <th class="hideMWQWCHALNO HAbleTr">CHAL NO.</th>
            <th class="hideMWQWLOTNO HAbleTr"> LOT NO</th>
            <th class="hideMWQWWEAVER HAbleTr">WEAVER</th>
            <th class="hideMWQWWPCS alignRight">W.PCS</th>
            <th class="hideMWQWWMTS alignRight">W.MTS</th>
            <th class="hideMWQWRMTS alignRight">R.MTS</th>
            <th class="hideMWQWBALPCS alignRight">BAL  PCS</th>
            <th class="hideMWQWBALMTS alignRight">BAL MTS</th>
            <th class="hideMWQWBALAMT alignRight" style="display:none;">BAL AMT</th>
            <th class="hideMWQWDAYS HAbleTr">DAYS</th>
            <th class="hideMWQWRATE HAbleTr">RATE</th>
            <th class="hideMWQWLR HAbleTr">L/R</th>
            <th class="hideMWQWMILLRATE HAbleTr">MILL RATE</th>
            <th class="hideMWQWSHOR HAbleTr">SHOR.</th>
            <th class="hideMWQWWRMK" style="display:none;">WRMK</th>
            <th class="hideMWQWDRMK" style="display:none;">DRMK</th>
            </tr>`;
        }
        tr += `<tr class="HAbleTr" style="font-weight:bolder;font-size:20px;background-color:#f3f3f3;color:#6c757d;"align="left">
  <td colspan="25">` + MillQualityName[j].QUAL + `</td>                                    
  </tr>`;
        var MillQualityData = getMillQualityData_MWQW(PartyNameList[i], MillQualityName[j].QUAL);
        for (let k = 0; k < MillQualityData.length; k++) {

          totalWpcs += parseFloat(MillQualityData[k].WPCS);
          totalWmts += parseFloat(MillQualityData[k].WMTS);
          totalRmts += parseFloat(getValueNotDefineNo(MillQualityData[k].ACTRMTS));
          totalBalpcs += parseFloat(MillQualityData[k].BALPCS);
          totalBalmts += parseFloat(MillQualityData[k].BALMTS);
          if (MillQualityData[k].CRD != null && MillQualityData[k].CRD != undefined && MillQualityData[k].CRD != '') {
            var CRDdatalink = getFullDataLinkByMillCardNo(MillQualityData[k].CRD, MillQualityData[k].CNO, MillQualityData[k].TYPE);
            var CRDdatalinkRec = CRDdatalink.replace("FDispatchChallan", "FDispatchChallanRec");
          }
          var ID = stringHashCode(MillQualityData[k].CNO + MillQualityData[k].TYPE + MillQualityData[k].VNO);
          var balAmt = parseFloat(MillQualityData[k].BALMTS) * parseFloat(MillQualityData[k].PRET);
          totalBalAmt += balAmt;
          tr += ` <tr class="HAbleTr" style="text-align:center">
                          <td class="selectBoxReport" style="display:none;"> <input type="checkbox" id="`+ ID + `"millName="` + (Data[i].code) + `" CRD="` + MillQualityData[k].CRD + `" CNO="` + MillQualityData[k].CNO + `"DTYPE="` + MillQualityData[k].TYPE + `"VNO="` + MillQualityData[k].VNO + `"/></td>
                          <td class="unHAbleTr"></td>
                          <td  class="">` + formatDate(getValueNotDefine(MillQualityData[k].DATE)) + `</td>
                          <td  class="hideMWQWCHALNO"><a target="_blank"href="`+ CRDdatalink + `"><button class="PrintBtnHide">` + getValueNotDefine(MillQualityData[k].DSPNO) + `</button></a></td>
                          <td  class="hideMWQWLOTNO"onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(MillQualityData[k].LOT) + `</td>
                          <td  class="hideMWQWWEAVER"onclick="openSubR('`+ Data[i].code + `')">` + MillQualityData[k].WVR + `</td>
                          <td  class="hideMWQWWPCS alignRight"onclick="openSubR('`+ Data[i].code + `')">` + MillQualityData[k].WPCS + `</td>
                          <td  class="hideMWQWWMTS alignRight"onclick="openSubR('`+ Data[i].code + `')">` + MillQualityData[k].WMTS + `</td>
                          <td  class="hideMWQWRMTS alignRight"onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(MillQualityData[k].ACTRMTS) + `</td>
                          <td  class="hideMWQWBALPCS alignRight"onclick="openSubR('`+ Data[i].code + `')">` + MillQualityData[k].BALPCS + `</td>
                          <td  class="hideMWQWBALMTS alignRight"onclick="openSubR('`+ Data[i].code + `')">` + MillQualityData[k].BALMTS + `</td>
                          <td  class="hideMWQWBALAMT alignRight" style="display:none;"onclick="openSubR('`+ Data[i].code + `')">` + parseFloat(balAmt).toFixed(2) + `</td>
                          <td  class="hideMWQWDAYS"onclick="openSubR('`+ Data[i].code + `')" >` + getDaysDif(MillQualityData[k].DATE, nowDate) + `</td>
                          <td  class="hideMWQWRATE"onclick="openSubR('`+ Data[i].code + `')" >` + MillQualityData[k].PRET + `</td>
                          <td  class="hideMWQWLR"onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(MillQualityData[k].DSG) + `</td>
                          <td  class="hideMWQWMILLRATE"onclick="openSubR('`+ Data[i].code + `')" >` + getValueNotDefine(MillQualityData[k].MRT) + `</td>
                          <td  class="hideMWQWSHOR"onclick="openSubR('`+ Data[i].code + `')" >` + valuetoFixed(getValueNotDefineNo(MillQualityData[k].STG)) + `</td>
                          <td  class="hideMWQWWRMK"  style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + (getValueNotDefine(MillQualityData[k].R)) + `</td>
                          <td  class="hideMWQWDRMK"  style="display:none;" onclick="openSubR('`+ Data[i].code + `')" >` + (getValueNotDefine(MillQualityData[k].DR)) + `</td>
                          </tr>
                        `;

          if (takaDetails == "Y") {
            tr += challanTakaDetails(MillQualityData[k].CRD);
          }
        }

        grandTotalWpcs += totalWpcs;
        grandTotalWmts += totalWmts;
        grandTotalRmts += totalRmts;
        grandTotalBalpcs += totalBalpcs;
        grandTotalBalmts += totalBalmts;
        grandTotalBalAmt += totalBalAmt;

        tr += ` <tr class="tfootcard" style="background-color:#f3f3f3;color:#c107a2;">
                  <td class=" HAbleTr" >TOTAL</td>                  
                  <td class="unHAbleTr">` + MillQualityName[j].QUAL + `</td>
                  <td class="hideMWQWCHALNO HAbleTr" ></td>
                  <td class="hideMWQWLOTNO HAbleTr" ></td>
                  <td class="hideMWQWWEAVER HAbleTr" ></td>
                  <td class="hideMWQWWPCS alignRight">` + totalWpcs + `</td>
                  <td class="hideMWQWWMTS alignRight">` + parseFloat(totalWmts).toFixed(2) + `</td>
                  <td class="hideMWQWRMTS alignRight">` + parseFloat(totalRmts).toFixed(2) + `</td>
                  <td class="hideMWQWBALPCS alignRight">` + totalBalpcs + `</td>
                  <td class="hideMWQWBALMTS alignRight">` + parseFloat(totalBalmts).toFixed(2) + `</td>
                  <td class="hideMWQWBALAMT alignRight" style="display:none;">` + parseFloat(totalBalAmt).toFixed(2) + `</td>
                  <td class="hideMWQWDAYS HAbleTr" ></td>
                  <td class="hideMWQWRATE HAbleTr" ></td>
                  <td class="hideMWQWLR HAbleTr" ></td>
                  <td class="hideMWQWMILLRATE HAbleTr" ></td>
                  <td class="hideMWQWSHOR HAbleTr" ></td>
                  <th class="hideMWQWWRMK" style="display:none;"></th>
                  <th class="hideMWQWDRMK" style="display:none;"></th>
                  </tr>
                  `;

        totalWpcs = 0;
        totalWmts = 0;
        totalRmts = 0;
        totalBalpcs = 0;
        totalBalmts = 0;
        totalBalAmt = 0;
      }


    }


    tr += ` <tr class="tfootcard">
                              <td class="HAbleTr">GRAND TOTAL</td>
                              <td class="unHAbleTr">GRAND TOTAL</td>
                              <td class="hideMWQWCHALNO HAbleTr" ></td>
                              <td class="hideMWQWLOTNO HAbleTr" ></td>
                              <td class="hideMWQWWEAVER HAbleTr"></td>
                              <td class="hideMWQWWPCS alignRight">` + grandTotalWpcs + `</td>
                              <td class="hideMWQWWMTS alignRight">` + parseFloat(grandTotalWmts).toFixed(2) + `</td>
                              <td class="hideMWQWRMTS alignRight">` + parseFloat(grandTotalRmts).toFixed(2) + `</td>
                              <td class="hideMWQWBALPCS alignRight">` + grandTotalBalpcs + `</td>
                              <td class="hideMWQWBALMTS alignRight">` + parseFloat(grandTotalBalmts).toFixed(2) + `</td>
                              <td class="hideMWQWBALAMT alignRight" style="display:none;">` + parseFloat(grandTotalBalAmt).toFixed(2) + `</td>
                              <td class="hideMWQWDAYS HAbleTr"></td>
                              <td class="hideMWQWRATE HAbleTr"></td>
                              <td class="hideMWQWLR HAbleTr"></td>
                              <td class="hideMWQWMILLRATE HAbleTr"></td>
                              <td class="hideMWQWSHOR HAbleTr"></td>
                              <th class="hideMWQWWRMK" style="display:none;"></th>
                              <th class="hideMWQWDRMK" style="display:none;"></th>
                              </tr>
                            `;

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');

    //-------
    if (hideAbleTr == "true") {
      $('.HAbleTr').css("display", "none");
    } else {
      $('.unHAbleTr').css("display", "none");
    }
    //-------------
    $('td').css('width', '50px');

    hideList();
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }

}