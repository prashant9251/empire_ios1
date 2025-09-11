
var url = window.location.href;
var QualityNameList = [];
var PartyQualList = [];
var MainArray = [];
function getMillQualityData(code, Qual) {
  return MainArray.filter(function (d) {
    return d.code == code && d.QUAL == Qual;
  })
}
function getMillQualityName(QUAL) {
  return PartyQualList.filter(function (d) {
    return d.QUAL == QUAL;
  })
}

function jsLoadCallMillStockQualWise(data) {
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
  try {

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
        if (!flagParty[Data[i].billDetails[j].QUAL]) {
          QualityNameList.push(Data[i].billDetails[j].QUAL);
          flagParty[Data[i].billDetails[j].QUAL] = true;
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
    console.log(QualityNameList, MainArray, PartyQualList);

    MainArray = MainArray.sort(function (a, b) {
      return new Date(a.DATE) - new Date(b.DATE)|| parseInt(getValueNotDefine(a.DSPNO)) - parseInt(getValueNotDefine(b.DSPNO));
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
    var totalWpcs = 0;
    var totalWmts = 0;
    var totalRmts = 0;
    var totalBalpcs = 0;
    var totalBalmts = 0;
    var BLL;
    QualityNameList=QualityNameList.sort(function(a,b){
      return a<b?-1:1;
    })
    if (QualityNameList.length > 0) {

      for (let i = 0; i < QualityNameList.length; i++) {
        tr += `<tr class="trPartyHead" >
      <th colspan="25" class="trPartyHead" >` + QualityNameList[i] + `</th>                                    
      </tr>`;
        var MillQualityName = getMillQualityName(QualityNameList[i]);
        MillQualityName=MillQualityName.sort(function(a,b){
          return a.code < b.code ?-1:1;
        })
        for (let j = 0; j < MillQualityName.length; j++) {
          if (j == 0) {
            tr += `
      <tr class=""style=""align="center">      
      <th class="selectBoxReport" style="display:none;">
      SELECT<input type="checkbox" onchange="checkAllEntry(this);"/>
      </th>  
      <th class="unHAbleTr">MILL NAME</th>                  
      <th class=" HAbleTr">DESP&nbsp;DATE</th>
      <th class="hideQWMWCHALNO HAbleTr">CHAL NO.</th>
      <th class="hideQWMWLOTNO HAbleTr"> LOT NO</th>
      <th class="hideQWMWWEAVER HAbleTr">WEAVER</th>
      <th class="hideQWMWWPCS alignRight">W.PCS</th>
      <th class="hideQWMWWMTS alignRight">W.MTS</th>
      <th class="hideQWMWRMTS alignRight">R.MTS</th>
      <th class="hideQWMWBALPCS alignRight">BAL  PCS</th>
      <th class="hideQWMWBALMTS alignRight">BAL MTS</th>
      <th class="hideQWMWDAYS HAbleTr">DAYS</th>
      <th class="hideQWMWRATE HAbleTr">RATE</th>
      <th class="hideQWMWLR HAbleTr">L/R</th>
      <th class="hideQWMWMILLRATE HAbleTr">MILL RATE</th>
      <th class="hideQWMWSHOR HAbleTr">SHOR.</th>
      <th class="hideQWMWWRMK" style="display:none;">WRMK</th>
      <th class="hideQWMWDRMK" style="display:none;">DRMK</th>
      </tr>
        `;
      }
          tr += `<tr class="HAbleTr" style="font-weight:bolder;font-size:20px;background-color:#f3f3f3;color:#6c757d;marg"align="left">
  <td colspan="25">` + MillQualityName[j].code + `</td>                                    
  </tr>`;
          var MillQualityData = getMillQualityData(MillQualityName[j].code, QualityNameList[i]);
          
          console.log(MillQualityData)
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

            tr += ` <tr class="HAbleTr" style="text-align:center">
            <td class="selectBoxReport" style="display:none;"> <input type="checkbox" id="`+ ID + `"millName="`+ (MillQualityName[j].code) + `" CRD="` + MillQualityData[k].CRD + `" CNO="` + MillQualityData[k].CNO + `"DTYPE="` + MillQualityData[k].TYPE + `"VNO="` + MillQualityData[k].VNO + `"/></td>
                      
                          <td class="unHAbleTr"></td>
                          <td  class="">` + formatDate(getValueNotDefine(MillQualityData[k].DATE)) + `</td>
                          <td  class="hideQWMWCHALNO"><a target="_blank"href="`+ CRDdatalink + `"><button class="PrintBtnHide">` + getValueNotDefine(MillQualityData[k].DSPNO) + `</button></a></td>
                          <td  class="hideQWMWLOTNO"onclick="openSubR('`+ MillQualityData[k].code + `')" >` + getValueNotDefine(MillQualityData[k].LOT) + `</td>
                          <td  class="hideQWMWWEAVER"onclick="openSubR('`+ MillQualityData[k].code + `')">` + MillQualityData[k].WVR + `</td>
                          <td  class="hideQWMWWPCS alignRight"onclick="openSubR('`+ MillQualityData[k].code + `')">` + MillQualityData[k].WPCS + `</td>
                          <td  class="hideQWMWWMTS alignRight"onclick="openSubR('`+ MillQualityData[k].code + `')">` + MillQualityData[k].WMTS + `</td>
                          <td  class="hideQWMWRMTS alignRight"onclick="openSubR('`+ MillQualityData[k].code + `')">` + getValueNotDefine(MillQualityData[k].ACTRMTS) + `</td>
                          <td  class="hideQWMWBALPCS alignRight"onclick="openSubR('`+ MillQualityData[k].code + `')">` + MillQualityData[k].BALPCS + `</td>
                          <td  class="hideQWMWBALMTS alignRight"onclick="openSubR('`+ MillQualityData[k].code + `')">` + MillQualityData[k].BALMTS + `</td>
                          <td  class="hideQWMWDAYS"onclick="openSubR('`+ MillQualityData[k].code + `')" >` + getDaysDif(MillQualityData[k].DATE, nowDate) + `</td>
                          <td  class="hideQWMWRATE"onclick="openSubR('`+ MillQualityData[k].code + `')" >` + MillQualityData[k].PRET + `</td>
                          <td  class="hideQWMWLR"onclick="openSubR('`+ MillQualityData[k].code + `')" >` + getValueNotDefine(MillQualityData[k].DSG) + `</td>
                          <td  class="hideQWMWMILLRATE"onclick="openSubR('`+ MillQualityData[k].code + `')" >` + getValueNotDefine(MillQualityData[k].MRT) + `</td>
                          <td  class="hideQWMWSHOR"onclick="openSubR('`+ MillQualityData[k].code + `')" >` + parseFloat(getValueNotDefineNo(MillQualityData[k].STG)).toFixed(2) + `</td>
                          <td  class="hideQWMWWRMK"  style="display:none;" onclick="openSubR('`+ MillQualityData[k].code + `')" >` + (getValueNotDefine(MillQualityData[k].R)) + `</td>
                          <td  class="hideQWMWDRMK"  style="display:none;" onclick="openSubR('`+ MillQualityData[k].code + `')" >` + (getValueNotDefine(MillQualityData[k].DR)) + `</td>
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
          tr += ` <tr class="tfootcard" style="background-color:#f3f3f3;color:#c107a2;">
                  <td class="HAbleTr" >TOTAL</td>                  
                  <td class="unHAbleTr">` + MillQualityName[j].code + `</td>
                  <td class="hideQWMWCHALNO HAbleTr" ></td>
                  <td class="hideQWMWLOTNO HAbleTr" ></td>
                  <td class="hideQWMWWEAVER HAbleTr" ></td>
                  <td class="hideQWMWWPCS alignRight">` + totalWpcs + `</td>
                  <td class="hideQWMWWMTS alignRight">` + parseFloat(totalWmts).toFixed(2) + `</td>
                  <td class="hideQWMWRMTS alignRight">` + parseFloat(totalRmts).toFixed(2) + `</td>
                  <td class="hideQWMWBALPCS alignRight">` + totalBalpcs + `</td>
                  <td class="hideQWMWBALMTS alignRight">` + parseFloat(totalBalmts).toFixed(2) + `</td>
                  <td class="hideQWMWDAYS HAbleTr" ></td>
                  <td class="hideQWMWRATE HAbleTr" ></td>
                  <td class="hideQWMWLR HAbleTr" ></td>
                  <td class="hideQWMWMILLRATE HAbleTr" ></td>
                  <td class="hideQWMWSHOR HAbleTr" ></td>
                  <th class="hideQWMWWRMK" style="display:none;"></th>
                  <th class="hideQWMWDRMK" style="display:none;"></th>
                  </tr>
                  `;

          totalWpcs = 0;
          totalWmts = 0;
          totalRmts = 0;
          totalBalpcs = 0;
          totalBalmts = 0;
        }


      }


      tr += ` <tr class="tfootcard">
                              <td class="HAbleTr">GRAND TOTAL</td>
                              <td class="unHAbleTr">GRAND TOTAL </td>
                              <td class="hideQWMWCHALNO HAbleTr" ></td>
                              <td class="hideQWMWLOTNO HAbleTr" ></td>
                              <td class="hideQWMWWEAVER HAbleTr"></td>
                              <td class="hideQWMWWPCS alignRight">` + grandTotalWpcs + `</td>
                              <td class="hideQWMWWMTS alignRight">` + parseFloat(grandTotalWmts).toFixed(2) + `</td>
                              <td class="hideQWMWRMTS alignRight">` + parseFloat(grandTotalRmts).toFixed(2) + `</td>
                              <td class="hideQWMWBALPCS alignRight">` + grandTotalBalpcs + `</td>
                              <td class="hideQWMWBALMTS alignRight">` + parseFloat(grandTotalBalmts).toFixed(2) + `</td>
                              <td class="hideQWMWDAYS HAbleTr"></td>
                              <td class="hideQWMWRATE HAbleTr"></td>
                              <td class="hideQWMWLR HAbleTr"></td>
                              <td class="hideQWMWMILLRATE HAbleTr"></td>
                              <td class="hideQWMWSHOR HAbleTr"></td>
                              <th class="hideQWMWWRMK" style="display:none;"></th>
                              <th class="hideQWMWDRMK" style="display:none;"></th>
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

  } catch (error) {
    noteError(error);
  }
}