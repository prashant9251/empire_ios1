
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);
function loadCall(Data) {

  console.log("BLS", Data);

  if (Data.length > 0) {
    var grandparcelcount = 0;
    var grandTotalfinalAmt = 0;

    try {

      for (i = 0; i < Data.length; i++) {
        var ccode = getPartyDetailsBySendCode(Data[i].code);
        console.table(Data[i].code + "-", ccode);
        var pcode = getValueNotDefine(ccode[0].partyname);
        var city = getValueNotDefine(ccode[0].city);
        var broker = getValueNotDefine(ccode[0].broker);
        var label = getValueNotDefine(ccode[0].label);
        tr += `<tr class="trPartyHead" onclick="trOnClick('` + Data[i].code + `','` + city + `','` + broker + `');"
                >
                          <th colspan="11" class="trPartyHead" >` + label + `</th>                                    
                        </tr>`;

        if (Data[i].billDetails.length > 0) {
          tr += `<tr>
                        <th>PDF</th>
                        <th>TRANSPORT</th>
                        <th>STATION</th>
                        <th>L/R NO</th>
                        <th>BILL</th>
                        <th>DATE</th>
                        <th>FIRM</th>
                        <th>BILL AMT</th>
                        <th>LR REC<BR>DATE</th>
                        </tr>`;
          var parcelcount = 0;
          var totalFinalAmt = 0;
          for (j = 0; j < Data[i].billDetails.length; j++) {
            parcelcount += 1;
            totalFinalAmt += parseFloat(Data[i].billDetails[j].fnlamt);
            var GST = parseFloat(Data[i].billDetails[j].VTAMT) + parseFloat(Data[i].billDetails[j].ADVTAMT);
            var FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE);
            tr += `<tr class="hideAbleTr">
                        <td><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + (Data[i].billDetails[j].TRNSP) + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + (Data[i].billDetails[j].PLC) + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].RRNO) + `</td>
                        <td><a target="_blank"href="`+ FdataUrl + `"><button>` + Data[i].billDetails[j].BILL + `</button></a></td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + formatDate(Data[i].billDetails[j].DATE) + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].FRM + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(Data[i].billDetails[j].fnlamt) + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + formatDate(Data[i].billDetails[j].RRDET) + `</td>
                        </tr>`;
            if (productDet == "Y") { tr += jsgetArrayProductdetailsbyIDE(Data[i].billDetails[j].IDE); }

          }
        }
        grandparcelcount += parcelcount;
        grandTotalfinalAmt += totalFinalAmt;
        tr += `<tr class="tfootcard">
                        <th colspan="5"> PARCEL `+ parcelcount + `</th>
                        <th colspan="2"></th>
                        <th>`+ valuetoFixed(totalFinalAmt) + `</th>
                        <th colspan="1"></th>
                        </tr>`;
      }
      tr += `
            <tr class="tfootcard">
                    <th colspan="5">TOTAL PARCEL `+ grandparcelcount + `</th>
                    <th colspan="2"></th>
                    <th>`+ valuetoFixed(grandTotalfinalAmt) + `</th>
                    <th colspan="1"></th>
                    </tr>`;

      $('#result').html(tr);
      $("#loader").removeClass('has-loader');
      var hideAbleTr = getUrlParams(url, "hideAbleTr");
      if (hideAbleTr == "true") {
        $('.hideAbleTr').css("display", "none");
      }
      hideList();
    } catch (e) {
      alert(e);
      $('#result').html(tr);
      $("#loader").removeClass('has-loader');
    }
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }

}
