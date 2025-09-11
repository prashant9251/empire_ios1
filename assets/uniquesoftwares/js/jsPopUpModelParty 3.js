var url = window.location.href;
var modelDiv = `<div id="myModal" class="modal" style="overflow: auto;">
<div class="modal-content">
  <div class="modal-header">
      <h3 id="mdlPartyName">PARTY NAME</h3>
    <span class="close">&times;</span>
  </div>
  <div class="modal-body">
    <a target="_blank"id="hrefSALE"  onclick="closePopUp();"class="btn btn-secondary btn-lg btn-block">SALE</a><br>
    <a target="_blank"id="hrefOUTSTANDING" onclick="closePopUp();" class="btn btn-secondary btn-lg btn-block">OUTSTANDING</a><br>
    <a target="_blank"id="hrefLEDGER" onclick="closePopUp();" class="btn btn-secondary btn-lg btn-block">LEDGER</a><br>
    <a target="_blank"id="hrefITEMWISESALE" onclick="closePopUp();" class="btn btn-secondary btn-lg btn-block">ITEM WISE SALE</a><br>
    <a target="_blank"id="hrefBANKBOOK" onclick="closePopUp();" class="btn btn-secondary btn-lg btn-block">BANK BOOK</a><br>
  </div>
  <div class="modal-footer">
    <div style="width:50%;float:left;" id="MO"> 
        
    </div>
    <div style="width:50%;float:right;"align="right"><h5 onclick="document.getElementById('myModal').style.display = 'none'">Close</h5><div>
  </div>
</div>
</div>`;
$('body').append(modelDiv);
var modal = document.getElementById("myModal");

function trOnClick(partycode, city, bcode) {
  var ReportType = getUrlParams(url, "ReportType");
  var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
  var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
  var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
  var FIRM = getUrlParams(url, "FIRM");

  console.log(FIRM);
  var ccode = getPartyDetailsBySendCode(partycode);
  var MO = ccode[0].MO == null ? '' : ccode[0].MO;
  var partyEmail = ccode[0].EML == null ? '' : ccode[0].EML;
  var PH1 = ccode[0].PH1;
  var PH2 = ccode[0].PH2;
  var ATYPE = ccode[0].ATYPE;
  $("#MO").html('');
  if (MO != null && MO != '') {
    $("#MO").html(`<button onclick="dialNo('`+MO +`')">CALL:` + MO + `</button>`);
  }
  if (PH1 != null && PH1 != '') {
    $("#MO").append(`<br><button onclick="dialNo('`+PH1+`')">CALL:` + PH1 + `</button>`);
  }
  if (PH2 != null && PH2 != '') {
    $("#MO").append(`<br><button onclick="dialNo('`+PH2+`')">CALL:` + PH2 + `</button>`);
  }
  $("#mdlPartyName").html(partycode);
  city = city == 'null' || city == null ? "" : city;
  bcode = bcode == 'null' || bcode == null ? "" : bcode;
  $("#mdlPartyName").append("<br><h6>" + (city) + " " + (bcode) + "</h6>");
  ReportATypeCode = ReportATypeCode == "" || ReportATypeCode == null ? ATYPE : ReportATypeCode;
  FIRM = FIRM == "" || FIRM == null ? "" : FIRM;
  modal.style.display = "block";
  var hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(partycode) + "&partyname=" + encodeURIComponent(partycode) + "&FIRM=" + encodeURIComponent(FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&mobileNo=" + MO + "&partyEmail=" + encodeURIComponent(partyEmail);
  if (url.indexOf('PURCHASE') > -1 || ATYPE != 1) {
    ReportType = " PURCHASE (ALL) ";
    ReportSeriesTypeCode = "P";
    hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(partycode) + "&partyname=" + encodeURIComponent(partycode) + "&FIRM=" + encodeURIComponent(FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&mobileNo=" + MO + "&partyEmail=" + encodeURIComponent(partyEmail);
    document.getElementById("hrefSALE").href = "PURCHASE_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefSALE").innerText = "PURCHASE";
    document.getElementById("hrefOUTSTANDING").href = "PURCHASEOUTSTANDING_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefOUTSTANDING").innerText = "PURCHASE OUTSTANDING";
    document.getElementById("hrefLEDGER").href = "LEDGER_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefBANKBOOK").href = "bankPassBook_AJXREPORT.html" + hrefLink;
    var myobj = document.getElementById("hrefITEMWISESALE");
    myobj.style.display = "none";
  } else {
    ReportType = " SALES ";
    ReportATypeCode = "1";
    ReportSeriesTypeCode = "S";
    hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(partycode) + "&partyname=" + encodeURIComponent(partycode) + "&FIRM=" + encodeURIComponent(FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&mobileNo=" + MO + "&partyEmail=" + encodeURIComponent(partyEmail);
    console.log(hrefLink);
    document.getElementById("hrefSALE").href = "ALLSALE_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefOUTSTANDING").href = "OUTSTANDING_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefLEDGER").href = "LEDGER_AJXREPORT.html" + hrefLink;
    document.getElementById("hrefITEMWISESALE").href = "ITEMWISESALE_AJXREPORT.html" + hrefLink;
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
