var MainArr = [];
function getListByTransportName(TRNSP) {
  return MainArr.filter(function (d) {
    return d.TRNSP == TRNSP;
  })
}

var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

function jsLoadCallPENDINGLR_TRANSPORTWISE(Data) {


  console.log("BLS", Data);

  var DtArray = [];
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
        obj.PLC = Data[i].billDetails[j].PLC;
        obj.BAMT = Data[i].billDetails[j].BAMT;
        obj.RRDET = Data[i].billDetails[j].RRDET;
        obj.fnlamt = Data[i].billDetails[j].fnlamt;
        MainArr.push(obj);
        if (DtArray.indexOf(Data[i].billDetails[j].TRNSP) < 0) {
          DtArray.push(Data[i].billDetails[j].TRNSP);
        }
      }
    }

  }

  console.log("DtArray", DtArray);

  Data = DtArray;
  Data = Data.sort(function (a, b) {
    return a < b ? -1 : 1;
  });
  if (Data.length > 0) {

    var grandparcelcount = 0;
    var grandtotalBAMT = 0;
    for (i = 0; i < Data.length; i++) {
      tr += `<tr class="trPartyHead">
                          <th colspan="11" class="trPartyHead" >` + Data[i] + `</th>                                    
                    </tr>`;
      var TRNSParray = getListByTransportName(Data[i]);
      if (TRNSParray.length > 0) {
        tr += `<tr>
        <th>BILL</th>
        <th>PARTY NAME</th>
        <th>STATION</th>
        <th>L/R NO</th>
        <th>PDF</th>
            <th>DATE</th>
            <th>FIRM</th>
            <th>BILL AMT</th>
            <th>LR REC<BR>DATE</th>
            </tr>`;
        console.log()
        var parcelcount = 0;
        totalBAMT = 0;
        for (j = 0; j < TRNSParray.length; j++) {
          parcelcount += 1;
          var BAMT = parseFloat(TRNSParray[j].BAMT);
          totalBAMT += BAMT;
          var FdataUrl = getFullDataLinkByCnoTypeVnoFirm(TRNSParray[j].CNO, TRNSParray[j].TYPE, TRNSParray[j].VNO, getFirmDetailsBySendCode(TRNSParray[j].CNO)[0].FIRM, TRNSParray[j].IDE);
          tr += `<tr class="hideAbleTr">
          <th><a target="_blank"href="`+ FdataUrl + `"><button>` + TRNSParray[j].BILL + `</button></a></th>
          <th>`+ (TRNSParray[j].code) + `</th>
          <th>`+ getValueNotDefine(TRNSParray[j].PLC) + `</th>
          <th>`+ getValueNotDefine(TRNSParray[j].RRNO) + `</th>
          <th><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button></a></th>
              <th>`+ formatDate(TRNSParray[j].DATE) + `</th>
              <th>`+ TRNSParray[j].FRM + `</th>
              <th>`+ valuetoFixed(TRNSParray[j].BAMT) + `</th>
              <th>`+ formatDate(TRNSParray[j].RRDET) + `</th>
              </tr>`;
              
              if (productDet == "Y") {  tr += jsgetArrayProductdetailsbyIDE(TRNSParray[j].IDE);}
        }
        tr += `<tr class="tfootcard">
        <th colspan="5">TOTAL PARCEL :-</th>
        <th colspan="2"> `+ parcelcount + `</th>
        <th>`+ valuetoFixed(totalBAMT) + `</th>
        <th colspan="1"></th>
        </tr>`;
        grandparcelcount += parcelcount;
        grandtotalBAMT += totalBAMT;
      }
    }
    tr += `<tr class="tfootcard">
    <th colspan="5">GRAND TOTAL PARCEL :-</th>
    <th colspan="2"> `+ grandparcelcount + `</th>
    <th>`+ valuetoFixed(grandtotalBAMT) + `</th>
        <th colspan="1"></th>
        </tr>`;
    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    var hideAbleTr = getUrlParams(url, "hideAbleTr");
    if (hideAbleTr == "true") {
      $('.hideAbleTr').css("display", "none");
    }
    hideList();
    try {
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
