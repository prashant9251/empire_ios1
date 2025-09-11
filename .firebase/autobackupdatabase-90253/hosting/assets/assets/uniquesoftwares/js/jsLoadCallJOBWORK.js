
var ReportType = getUrlParams(url, "ReportType");
var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
var ReportFilter = getUrlParams(url, "ReportFilter");
var checkPcs = getUrlParams(url, "checkPcs");


var GRD;
function loadCall(data) {
  
  Data = data;
  console.log(ReportType, ReportSeriesTypeCode, ReportATypeCode, ReportDOC_TYPECode);



  var ccode;
  var pcode;
  var city;
  var broker;
  var label;
  var grandtotalRPS;
  var grandtotalSPS;
  var grandtotalPEND;
  var grandtotalPAIDAMT;
  var grandtotalAmount;
  var totalRPS;
  var totalSPS;
  var totalPEND;
  var totalPAIDAMT;
  var totalAmount;
  var BLL;
  var FdataUrl
  var DL = Data.length;
  if (DL > 0) {

    grandtotalRPS = 0;
    grandtotalSPS = 0;
    grandtotalPEND = 0;
    grandtotalPAIDAMT = 0;
    grandtotalAmount = 0;
    for (var i = 0; i < DL; i++) {
      totalRPS = 0;
      totalSPS = 0;
      totalPEND = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;
      ccode = getPartyDetailsBySendCode(Data[i].code);
      // console.log(Data[i].code+"-",ccode) 
      pcode = ccode[0].partyname;
      city = ccode[0].city;
      broker = ccode[0].broker;
      label = ccode[0].label;

      tr += `<tr class="trPartyHead"onclick="trOnClick('` + Data[i].code + `','` + city + `','` + broker + `');">
                          <th colspan="14" class="trPartyHead">` + label + `<a href="tel:` + ccode[0].MO + `"><button> MO:` + getValueNotDefine(ccode[0].MO) + `</button></a>`+`</th>
                        </tr>
                        <tr style="font-weight:500;"align="center">                        
                        <th>BILL NO.</th>
                        <th class="hideFIRM">FIRM</th>
                        <th class="hideDATE">DATE</th>
                        <th class="hideSEND">SEND</th>
                        <th class="hideREC">REC.</th>
                        <th class="hidePEND">PEND.</th>
                        <th class="hidequal">qual</th>
                        <th class="hideDAYS"> DAYS</th>
                        <th class="hideAGHASTE">AG./HASTE</th>
                        <th class="hideRMK">RMK</th>
                        <th class="hideGRP" style="display:none;">GROUP</th>
                        <th class="hideTYPE" style="display:none;">TYPE</th>
                        <th class="hideCHECKPCS">CHECK PCS</th>
                          </tr>
                        `;

      BLL = Data[i].billDetails.length;
      if (BLL > 0) {
        for (j = 0; j < BLL; j++) {

          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE);
          var urlopen = '';
          var PEND = 0;
          var SPS = parseInt(Data[i].billDetails[j].SPS == null ? 0 : Data[i].billDetails[j].SPS);
          var RPS = parseInt(Data[i].billDetails[j].RPS == null ? 0 : Data[i].billDetails[j].RPS);
          PEND = SPS - RPS;
          totalPEND += parseInt(PEND);
          totalSPS += parseInt(SPS);
          totalRPS += parseInt(RPS);
          var BrokerHaste = '';
          var HST = Data[i].billDetails[j].HST;
          if (HST != '' && HST != null && HST != undefined) {
            BrokerHaste = HST;
          } else {
            BrokerHaste = Data[i].billDetails[j].BCD;
          }
          
          console.log(Data[i].billDetails[j].CPS);
          tr += ` 
                              
                                <tr class="hideAbleTr"align="center"style="">
                                <td>` + getValueNotDefine(Data[i].billDetails[j].BLL) + `</td>
                                    <td  class="hideFIRM" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].FRM) + `</td>
                                    <td  class="hideDATE" onclick="openSubR('`+ Data[i].code + `')">` + formatDate(Data[i].billDetails[j].DT) + `</td>
                                    <td  class="hideSEND" onclick="openSubR('`+ Data[i].code + `')" class="alignRight">` + getValueNotDefineNo(SPS) + `</td>
                                    <td  class="hideREC" onclick="openSubR('`+ Data[i].code + `')" class="alignRight">` + getValueNotDefineNo(RPS) + `</td>
                                    <td  class="hidePEND" onclick="openSubR('`+ Data[i].code + `')" class="alignRight">` + getValueNotDefineNo(PEND) + `</td>
                                    <td  class="hidequal" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].ql) + `</td>
                                    <td  class="hideDAYS" onclick="openSubR('`+ Data[i].code + `')">` + getDaysDif(Data[i].billDetails[j].DT, nowDate) + ` </td>
                                    <td  class="hideAGHASTE" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                                    <td  class="hideRMK" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].D) + `</td>
                                    <td  class="hideGRP" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].GP) + `</td>
                                    <td  class="hideTYPE" style="display:none;" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].TYPE) + `</td>
                                    <td  class="hideCHECKPCS" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].CPS) + `</td>                                    
                                </tr>`;


        }
        grandtotalSPS += totalSPS;
        grandtotalRPS += totalRPS;
        grandtotalPEND += totalPEND;
        tr += `<tr class="tfootcard">
                                <td >Total</td>
                                <td class="hideFIRM" ></td>
                                <td class="hideDATE" ></td>
                                <td class="hideSEND alignRight">` + valuetoFixedNo(totalSPS) + `</td>                              
                                <td class="hideREC alignRight">` + valuetoFixedNo(totalRPS) + `</td>
                                <td class="hidePEND alignRight">` + valuetoFixedNo(totalPEND) + `</td>
                                <td class="hidequal" ></td>
                                <td class="hideDAYS" ></td>
                                <td class="hideAGHASTE" ></td>
                                <td class="hideRMK" ></td>
                                <td class="hideGRP" style="display:none;" ></td>
                                <td class="hideTYPE" style="display:none;" ></td>
                                <td class="hideCHECKPCS" ></td>
                                </tr>`;
      }

    }
    tr += `<tr class="tfootcard">
    <td >GRAND TOTAL</td>
    <td class="hideFIRM" ></td>
    <td class="hideDATE" ></td>
    <td  class="alignRight">` + valuetoFixedNo(grandtotalSPS) + `</td>  
    <td  class="alignRight">` + valuetoFixedNo(grandtotalRPS) + `</td>
    <td  class="alignRight">` + valuetoFixedNo(grandtotalPEND) + `</td>
    <td class="hidequal" ></td>
    <td class="hideDAYS" ></td>
    <td class="hideAGHASTE" ></td>
    <td class="hideRMK" ></td>
    <td class="hideGRP" style="display:none;" ></td>
    <td class="hideTYPE" style="display:none;" ></td>
    <td class="hideCHECKPCS" ></td>
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

