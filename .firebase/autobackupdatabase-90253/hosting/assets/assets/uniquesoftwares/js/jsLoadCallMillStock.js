
var url = window.location.href;

function loadCall(data) {
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
  var totalWpcs;
  var totalWmts;
  var totalRmts;
  var totalBalpcs;
  var totalBalmts;
  var BLL;
  var DL = Data.length;
  if (DL > 0) {
    for (var i = 0; i < DL; i++) {
      totalWpcs = 0;
      totalWmts = 0;
      totalRmts = 0;
      totalBalpcs = 0;
      totalBalmts = 0;
      ccode = getPartyDetailsBySendCode(Data[i].code);
      pcode = ccode[0].partyname;
      city = ccode[0].city;
      broker = ccode[0].broker;
      label = ccode[0].label;
      tr += `<tr class="trPartyHead"  style="font-weight:bolder;height:50px;"align="left">
                          <th colspan="20" class="trPartyHead" >` + label + `</th>                                    
                        </tr>
                        <tr style="font-weight:500;"align="center">      
                        <th class="selectBoxReport" style="display:none;">
                        SELECT<input type="checkbox" onchange="checkAllEntry(this);"/>
                        </th>                  
                        <th>DESP&nbsp;DATE</th>
                        <th class="hideMWCHALNO">CHAL NO.</th>
                        <th class="hideMWLOTNO">LOT NO</th>
                        <th class="hideMWQUALITY">QUALITY</th>
                        <th class="hideMWWEAVER">WEAVER</th>
                        <th class="hideMWWPCS">W.PCS</th>
                        <th class="hideMWWMTS">W.MTS</th>
                        <th class="hideMWRMTS">R.MTS</th>
                        <th class="hideMWBALPCS">BAL  PCS</th>
                        <th class="hideMWBALMTS">BAL MTS</th>
                        <th class="hideMWDAYS">DAYS</th>
                        <th class="hideMWRATE">RATE</th>
                        <th class="hideMWLR">L/R</th>
                        <th class="hideMWMILLRATE">MILL RATE</th>
                        <th class="hideMWSHOR">SHOR.</th>
                        <th class="hideMWWRMK" style="display:none;">WRMK</th>
                        <th class="hideMWDRMK" style="display:none;">DRMK</th>
                          </tr>
                        `;

      if (Data[i].billDetails.length > 0) {
        var BillDetails = Data[i].billDetails.sort(function (a, b) {
          return new Date(a.DATE) - new Date(b.DATE) || parseInt(getValueNotDefine(a.DSPNO)) - parseInt(getValueNotDefine(b.DSPNO));
        });
        for (j = 0; j < BillDetails.length; j++) {
          totalWpcs += parseFloat(BillDetails[j].WPCS);
          totalWmts += parseFloat(BillDetails[j].WMTS);
          totalRmts += parseFloat(getValueNotDefineNo(BillDetails[j].ACTRMTS));
          totalBalpcs += parseFloat(BillDetails[j].BALPCS);
          totalBalmts += parseFloat(BillDetails[j].BALMTS);
          if (BillDetails[j].CRD != null && BillDetails[j].CRD != undefined && BillDetails[j].CRD != '') {
            var CRDdatalink = getFullDataLinkByMillCardNo(BillDetails[j].CRD, BillDetails[j].CNO, BillDetails[j].TYPE);
            var CRDdatalinkRec = CRDdatalink.replace("FDispatchChallan", "FDispatchChallanRec");
          }
          var ID = stringHashCode(BillDetails[j].CNO + BillDetails[j].TYPE + BillDetails[j].VNO);

          tr += ` <tr class="hideAbleTr" style="text-align:center">
          <td class="selectBoxReport" style="display:none;"> <input type="checkbox" id="`+ ID + `"millName="` + (Data[i].code) + `" CRD="` + BillDetails[j].CRD + `" CNO="` + BillDetails[j].CNO + `"DTYPE="` + BillDetails[j].TYPE + `"VNO="` + BillDetails[j].VNO + `"/></td>
                          <td  >` + formatDate(getValueNotDefine(BillDetails[j].DATE)) + `</td>
                          <td   class="hideMWCHALNO" ><a target="_blank"href="`+ CRDdatalink + `"><button class="PrintBtnHide">` + getValueNotDefine(BillDetails[j].DSPNO) + `</button></a></td>
                          <td   class="hideMWLOTNO" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BillDetails[j].LOT) + `</td>
                          <td   class="hideMWQUALITY" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].QUAL + `</td>
                          <td   class="hideMWWEAVER" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].WVR + `</td>
                          <td   class="hideMWWPCS" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].WPCS + `</td>
                          <td   class="hideMWWMTS" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].WMTS + `</td>
                          <td   class="hideMWRMTS" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BillDetails[j].ACTRMTS) + `</td>
                          <td   class="hideMWBALPCS" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].BALPCS + `</td>
                          <td   class="hideMWBALMTS" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].BALMTS + `</td>
                          <td   class="hideMWDAYS" onclick="openSubR('`+ Data[i].code + `')">` + getDaysDif(BillDetails[j].DATE, nowDate) + `</td>
                          <td   class="hideMWRATE" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].PRET + `</td>
                          <td   class="hideMWLR" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BillDetails[j].DSG) + `</td>
                          <td   class="hideMWMILLRATE" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BillDetails[j].MRT) + `</td>
                          <td   class="hideMWSHOR" onclick="openSubR('`+ Data[i].code + `')">` + (parseFloat(BillDetails[j].STG).toFixed(2)) + `</td>
                          <td   class="hideMWWRMK" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + (getValueNotDefine(BillDetails[j].R)) + `</td>
                          <td   class="hideMWDRMK" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + (getValueNotDefine(BillDetails[j].DR)) + `</td>
                          </tr>
                        `;

          if (takaDetails == "Y") {
            tr += challanTakaDetails(BillDetails[j].CRD);
          }
        }
      }
      grandTotalWpcs += totalWpcs;
      grandTotalWmts += totalWmts;
      grandTotalRmts += totalRmts;
      grandTotalBalpcs += totalBalpcs;
      grandTotalBalmts += totalBalmts;
      tr += ` <tr class="tfootcard">
                          <td>TOTAL</td>
                          <td  class="hideMWCHALNO"></td>
                          <td  class="hideMWLOTNO"></td>
                          <td  class="hideMWQUALITY"></td>
                          <td  class="hideMWWEAVER"></td>
                          <td  class="hideMWWPCS">` + totalWpcs + `</td>
                          <td  class="hideMWWMTS">` + parseFloat(totalWmts).toFixed(2) + `</td>
                          <td  class="hideMWRMTS">` + parseFloat(totalRmts).toFixed(2) + `</td>
                          <td  class="hideMWBALPCS">` + totalBalpcs + `</td>
                          <td  class="hideMWBALMTS">` + parseFloat(totalBalmts).toFixed(2) + `</td>
                          <td  class="hideMWDAYS"></td>
                          <td  class="hideMWRATE"></td>
                          <td  class="hideMWLR"></td>
                          <td  class="hideMWMILLRATE"></td>
                          <td  class="hideMWSHOR"></td>
                          <td  class="hideMWWRMK" style="display:none;"></td>
                          <td  class="hideMWDRMK" style="display:none;"></td>
                          </tr>
                          `;


    }
    tr += ` <tr class="tfootcard">
                              <td>GRAND TOTAL</td>
                              <td  class="hideMWCHALNO"></td>
                              <td  class="hideMWLOTNO"></td>
                              <td  class="hideMWQUALITY"></td>
                              <td  class="hideMWWEAVER"></td>
                              <td  class="hideMWWPCS">` + grandTotalWpcs + `</td>
                              <td  class="hideMWWMTS">` + parseFloat(grandTotalWmts).toFixed(2) + `</td>
                              <td  class="hideMWRMTS">` + parseFloat(grandTotalRmts).toFixed(2) + `</td>
                              <td  class="hideMWBALPCS">` + grandTotalBalpcs + `</td>
                              <td  class="hideMWBALMTS">` + parseFloat(grandTotalBalmts).toFixed(2) + `</td>
                              <td  class="hideMWDAYS"></td>
                              <td  class="hideMWRATE"></td>
                              <td  class="hideMWLR"></td>
                              <td  class="hideMWMILLRATE"></td>
                              <td  class="hideMWSHOR"></td>
                              <td  class="hideMWWRMK" style="display:none;"></td>
                              <td  class="hideMWDRMK" style="display:none;"></td>
                              </tr>
                            `;

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');

    //-------

    if (hideAbleTr == "true") {
      $('.hideAbleTr').css("display", "none");
    }
    $('td').css('width', '50px');

    hideList();
    //-------------
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }

}
