var MainArr = [];
function getListBySubName(searchValue) {
  return MainArr.filter(function (d) {
    return d.DATE == searchValue;
  })
}

var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);
function jsLoadCallPENDINGLR_DATEWISE(Data) {

  ///console.log("BLS", Data);

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
        obj.PLC = Data[i].billDetails[j].PLC;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.BAMT = Data[i].billDetails[j].BAMT;
        obj.RRDET = Data[i].billDetails[j].RRDET;        
        obj.fnlamt = Data[i].billDetails[j].fnlamt;
        MainArr.push(obj);
        if (DtArray.indexOf(Data[i].billDetails[j].DATE) < 0) {
          DtArray.push(Data[i].billDetails[j].DATE);
        }
      }
    }

  }

  // console.log("DtArray", DtArray);

  Data = DtArray;
  Data = Data.sort(function (a, b) {
    return new Date(b) - new Date(a);
  });
  if (Data.length > 0) {

    var grandparcelcount = 0;
    var grandtotalBAMT = 0;
    for (i = Data.length - 1; i >= 0; i--) {
      tr += `<tr class="trPartyHead">
                          <th colspan="11" class="trPartyHead" >` + formatDate(Data[i]) + `</th>                                    
                    </tr>`;
      var Subarray = getListBySubName(Data[i]);

      if (Subarray.length > 0) {
        tr += `<tr>
            <th>BILL</th>
            <th>PARTY NAME</th>
            <th>TRANSPORT</th>
            <th>STATION</th>
            <th>L/R NO</th>
            <th>PDF</th>
            <th>DATE</th>
            <th>FIRM</th>
            <th>BILL AMT</th>
            <th>LR REC<BR>DATE</th>
            </tr>`;
        var parcelcount = 0;
        totalBAMT = 0;
        for (j = 0; j < Subarray.length; j++) {
          parcelcount += 1;
          var BAMT = parseFloat(Subarray[j].BAMT);
          totalBAMT += BAMT;
          var FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Subarray[j].CNO, Subarray[j].TYPE, Subarray[j].VNO, getFirmDetailsBySendCode(Subarray[j].CNO)[0].FIRM, Subarray[j].IDE);
          tr += `<tr class="hideAbleTr">
              <th><a target="_blank"href="`+ FdataUrl + `"><button>` + Subarray[j].BILL + `</button></a></th>
              <th>`+ (Subarray[j].code) + `</th>
              <th>`+ getValueNotDefine(Subarray[j].TRNSP) + `</th>
              <th>`+ getValueNotDefine(Subarray[j].PLC) + `</th>
              <th>`+ getValueNotDefine(Subarray[j].RRNO) + `</th>
              <th><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button></a></th>
              <th>`+ formatDate(Subarray[j].DATE) + `</th>
              <th>`+ Subarray[j].FRM + `</th>
              <th>`+ valuetoFixed(Subarray[j].BAMT) + `</th>
              <th>`+ formatDate(Subarray[j].RRDET) + `</th>
              </tr>`;

              if (productDet == "Y") {  tr += jsgetArrayProductdetailsbyIDE( Subarray[j].IDE);}
        }
        tr += `<tr class="tfootcard">
        <th colspan="6">TOTAL PARCEL :-</th>
        <th colspan="2"> `+ parcelcount + `</th>
        <th>`+ valuetoFixed(totalBAMT) + `</th>
        <th colspan="1"></th>
        </tr>`;
        grandparcelcount += parcelcount;
        grandtotalBAMT += totalBAMT;
      }
    }
    tr += `<tr class="tfootcard">
    <th colspan="6">GRAND TOTAL PARCEL :-</th>
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

