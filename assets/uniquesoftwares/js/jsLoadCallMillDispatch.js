
var url = window.location.href;
function jsLoadCallMillDispatch(data) {
  var tr = '';

  Data = data;
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
  var totalWpcs;
  var totalWmts;
  var totalRmts;
  var totalBalpcs;
  var totalBalmts;
  var totalBalAmt;
  var BLL;
  var DL = Data.length;
  if (DL > 0) {
    for (var i = 0; i < DL; i++) {
      totalWpcs = 0;
      totalWmts = 0;
      totalRmts = 0;
      totalBalpcs = 0;
      totalBalmts = 0;
      totalBalAmt = 0;
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
                        <th >DESP&nbsp;DATE</th>
                        <th class="hideMWDCHALNO">CHAL NO.</th>
                        <th class="hideMWDLOTNO">LOT NO</th>
                        <th class="hideMWDQUALITY">QUALITY</th>
                        <th class="hideMWDWEAVER">WEAVER</th>
                        <th class="hideMWDWPCS">W.PCS</th>
                        <th class="hideMWDWMTS">W.MTS</th>
                        <th class="hideMWDRECMTS">REC.MTS</th>
                        <th class="hideMWDBALPCS">BAL.PCS</th>
                        <th class="hideMWDBALMTS">BAL.MTS</th>
                        <th class="hideMWDBALAMT" style="display:none;">BAL.AMT</th>
                        <th class="hideMWDPURRATE">PUR.RATE</th>
                        <th class="hideMWDLR">L/R</th>
                        <th class="hideMWDMILLRATE">MILLRATE</th>
                        <th class="hideMWDSHOR">SHOR.</th>
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
          }
          var ID = stringHashCode(BillDetails[j].CNO + BillDetails[j].TYPE + BillDetails[j].VNO + BillDetails[j].CRD);
          var balAmt = parseFloat(BillDetails[j].BALMTS) * parseFloat(BillDetails[j].PRET);
          totalBalAmt += balAmt;
          tr += ` <tr  class="hideAbleTr">                        
                          <td class="selectBoxReport" style="display:none;"> <input type="checkbox" id="`+ ID + `"millName="` + (Data[i].code) + `" CRD="` + BillDetails[j].CRD + `" CNO="` + BillDetails[j].CNO + `"DTYPE="` + BillDetails[j].TYPE + `"VNO="` + BillDetails[j].VNO + `"/></td>
                          <td  onclick="openSubR('`+ Data[i].code + `')">` + formatDate(getValueNotDefine(BillDetails[j].DATE)) + `</td>
                          <td  class="hideMWDCHALNO"><a target="_blank"href="`+ CRDdatalink + `"><button>` + getValueNotDefine(BillDetails[j].DSPNO) + `</button></a></td>
                          <td  class="hideMWDLOTNO" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BillDetails[j].LOT) + `</td>
                          <td  class="hideMWDQUALITY" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].QUAL + `</td>
                          <td  class="hideMWDWEAVER" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].WVR + `</td>
                          <td  class="hideMWDWPCS" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].WPCS + `</td>
                          <td  class="hideMWDWMTS" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].WMTS + `</td>
                          <td  class="hideMWDRECMTS" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BillDetails[j].ACTRMTS) + `</td>
                          <td  class="hideMWDBALPCS" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].BALPCS + `</td>
                          <td  class="hideMWDBALMTS" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].BALMTS + `</td>
                          <td  class="hideMWDBALAMT" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + parseFloat(balAmt).toFixed(2) + `</td>
                          <td  class="hideMWDPURRATE" onclick="openSubR('`+ Data[i].code + `')">` + BillDetails[j].PRET + `</td>
                          <td  class="hideMWDLR" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BillDetails[j].DSG) + `</td>
                          <td  class="hideMWDMILLRATE" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BillDetails[j].MRT) + `</td>
                          <td  class="hideMWDSHOR" onclick="openSubR('`+ Data[i].code + `')">` + (parseFloat(BillDetails[j].STG).toFixed(2)) + `</td>
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
      grandTotalBalAmt += totalBalAmt;
      tr += ` <tr class="tfootcard">
                          <td>TOTAL</td>
                          <td  class="hideMWDCHALNO"></td>
                          <td  class="hideMWDLOTNO"></td>
                          <td  class="hideMWDQUALITY"></td>
                          <td  class="hideMWDWEAVER"></td>
                          <td  class="hideMWDWPCS">` + totalWpcs + `</td>
                          <td  class="hideMWDWMTS">` + parseFloat(totalWmts).toFixed(2) + `</td>
                          <td  class="hideMWDRECMTS">` + parseFloat(totalRmts).toFixed(2) + `</td>
                          <td  class="hideMWDBALPCS">` + totalBalpcs + `</td>
                          <td  class="hideMWDBALMTS">` + parseFloat(totalBalmts).toFixed(2) + `</td>
                          <td  class="hideMWDBALAMT" style="display:none;">` + parseFloat(totalBalAmt).toFixed(2) + `</td>
                          <td  class="hideMWDPURRATE"></td>
                          <td  class="hideMWDLR"></td>
                          <td  class="hideMWDMILLRATE"></td>
                          <td  class="hideMWDSHOR"></td>
                          <td  class="hideMWWRMK" style="display:none;"></td>
                          <td  class="hideMWDRMK" style="display:none;"></td>
                          </tr>
                          `;


    }
    tr += ` <tr class="tfootcard">
                              <td>GRAND TOTAL</td>
                              <td  class="hideMWDCHALNO"></td>
                              <td  class="hideMWDLOTNO"></td>
                              <td  class="hideMWDQUALITY"></td>
                              <td  class="hideMWDWEAVER"></td>
                              <td  class="hideMWDWPCS">` + grandTotalWpcs + `</td>
                              <td  class="hideMWDWMTS">` + parseFloat(grandTotalWmts).toFixed(2) + `</td>
                              <td  class="hideMWDRECMTS">` + parseFloat(grandTotalRmts).toFixed(2) + `</td>
                              <td  class="hideMWDBALPCS">` + grandTotalBalpcs + `</td>
                              <td  class="hideMWDBALMTS">` + parseFloat(grandTotalBalmts).toFixed(2) + `</td>
                              <td  class="hideMWDBALAMT" style="display:none;">` + parseFloat(grandTotalBalAmt).toFixed(2) + `</td>
                              <td  class="hideMWDPURRATE"></td>
                              <td  class="hideMWDLR"></td>
                              <td  class="hideMWDMILLRATE"></td>
                              <td  class="hideMWDSHOR"></td>
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