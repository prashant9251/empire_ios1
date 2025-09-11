var url = window.location.href;
var modelDiv = `<div id="myModal" class="modal">
<div class="modal-content">
  <div class="modal-header">
      <h3 id="mdlPartyName">PARTY NAME</h3>
    <span class="close">&times;</span>
  </div>
  <div class="modal-body">
    <a target="_blank"id="hrefSALE"  onclick="closePopUp();"class="btn btn-secondary btn-lg btn-block">SALE</a><br>
    <a target="_blank"id="hrefOUTSTANDING" onclick="closePopUp();" class="btn btn-secondary btn-lg btn-block">OUTSTANDING</a><br>
    <a target="_blank"id="hrefLEDGER" onclick="closePopUp();" class="btn btn-secondary btn-lg btn-block">LEDGER</a><br>
    <a target="_blank"id="hrefBANKBOOK" onclick="closePopUp();" class="btn btn-secondary btn-lg btn-block">BANK BOOK</a><br>
  </div> 
  <div class="modal-footer">
    <div style="width:50%;float:left;" id="MO"></div>
    <div style="width:50%;float:right;"align="right"><h5 onclick="document.getElementById('myModal').style.display = 'none'">Close</h5><div>
  </div>
</div>
</div>`;
$('body').append(modelDiv);
var modal = document.getElementById("myModal");

function trOnClick(partycode, city, bcode, ATYPE, lbl) {
  var ReportType = getUrlParams(url, "ReportType");
  var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
  var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
  ReportSeriesTypeCode = ReportSeriesTypeCode == null ? '' : ReportSeriesTypeCode;
  var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
  ReportDOC_TYPECode = ReportDOC_TYPECode == null ? '' : ReportDOC_TYPECode;
  var ccode = getPartyDetailsBySendCode(partycode);

  if (ccode.length > 0) {
    partyname = ccode[0].partyname;
    MO = ccode[0].MO;
    PH1 = ccode[0].PH1;
    PH2 = ccode[0].PH2;
    $("#MO").html('');
    if (MO != null && MO != '') {
      $("#MO").html(`<a href="tel:` + MO + `"><button>CALL:` + MO + `</button></a>`);
    }
    if (PH1 != null && PH1 != '') {
      $("#MO").append(`<br><a href="tel:` + PH1 + `"><button>CALL:` + PH1 + `</button></a>`);
    }
    if (PH2 != null && PH2 != '') {
      $("#MO").append(`<br><a href="tel:` + PH2 + `"><button>CALL:` + PH2 + `</button></a>`);
    }
  }

  $("#mdlPartyName").html(partyname);
  var BCD_ARR = getPartyDetailsBySendCode(bcode);
  if (BCD_ARR.length > 0) {
    Broker = BCD_ARR[0].partyname;
    $("#mdlPartyName").append("<br><h6>" + city + " " + Broker + "</h6>");
  }
  modal.style.display = "block";
  var hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(partycode) + "&partyname=" + encodeURIComponent(partyname) + "&FIRM=" + encodeURIComponent(FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&";
  if (url.indexOf('PURCHASE') > -1) {
    ReportType = " PURCHASE ";
    ReportSeriesTypeCode = "P1";
    hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(partycode) + "&partyname=" + encodeURIComponent(partyname) + "&FIRM=" + encodeURIComponent(FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&";
    // document.getElementById("hrefSALE").href = "PURCHASE_AJXREPORT.html" + hrefLink;
    // document.getElementById("hrefSALE").innerText = "PURCHASE";
    document.getElementById("hrefOUTSTANDING").href = "PURCHASEOUTSTANDING_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefOUTSTANDING").innerText = "PURCHASE OUTSTANDING";
    document.getElementById("hrefLEDGER").href = "LEDGER_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefBANKBOOK").href = "bankPassBook_AJXREPORT.html" + hrefLink;
    var myobj = document.getElementById("hrefITEMWISESALE");
    myobj.remove();
  } else {
    ReportType = " SALES ";
    ReportATypeCode = "1";
    ReportSeriesTypeCode = "S1";


    hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(partycode) + "&partyname=" + encodeURIComponent(partyname) + "&FIRM=" + encodeURIComponent(FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&";
    document.getElementById("hrefLEDGER").href = "LEDGER_AJXREPORT.html" + hrefLink;
    if (ATYPE == 2) {
      hrefLink = "?ntab=NTAB&ccdcode=" + encodeURIComponent(partycode) + "&ccd=" + encodeURIComponent(partyname) + "&FIRM=" + encodeURIComponent(FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&";
    }
    document.getElementById("hrefSALE").href = "ALLSALE_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefOUTSTANDING").href = "OUTSTANDING_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefBANKBOOK").href = "bankPassBook_AJXREPORT.html" + hrefLink;
  }
}
var span = document.getElementsByClassName("close")[0];
span.onclick = function () {
  modal.style.display = "none";
}
window.onclick = function (event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}
function closePopUp() {
  modal.style.display = "none";
}
$(document).keyup(function (e) {
  if (e.key === "Escape") { // escape key maps to keycode `27`
    modal.style.display = "none";
  }
});
