var url = window.location.href;
var modelDiv = `<div id="myModal" class="modal">
<div class="modal-content">
  <div class="modal-header">
      <h3 id="mdlPartyName">PARTY NAME</h3>
    <span class="close">&times;</span>
  </div>
  <div class="modal-body" id="CallWaButton">
  </div>
  <div class="modal-footer">
    <div style="width:50%;float:left;" id="MO"></div>
    <div style="width:50%;float:right;"align="right"><h5 onclick="document.getElementById('myModal').style.display = 'none'">Close</h5><div>
  </div>
</div>
</div>`;
$('body').append(modelDiv);
var modal = document.getElementById("myModal");

function sendingOptionClick(partycode, mobileNo, msg) {
  var ReportType = getUrlParams(url, "ReportType");
  var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
  var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
  var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
  if (msg == undefined || msg == null || msg == "undefined") {
    msg = '';
  }
  buttonToAdd = "";
  var ccode = getPartyDetailsBySendCode(partycode);
  var MO = ccode[0].MO;
  var PH1 = ccode[0].PH1;
  var PH2 = ccode[0].PH2;
  var ATYPE = ccode[0].ATYPE;
  $("#MO").html('');
  if (MO != null && MO != '') {
    buttonToAdd = ` <div style="width:100%;display:flex;">
    <div style="width:50%;float:left;">
    <a id="hrefCall" class="btn btn-secondary btn-lg btn-block" style="color:white;"onclick="dialNo('`+ MO + `');" >Call : ` + MO + `</a><br>    
    </div>
    </div>`;
  }
  if (PH1 != null && PH1 != '') {
    buttonToAdd += `<br> <div style="width:100%;display:flex;">
    <div style="width:50%;float:left;">
    <a id="hrefCall" class="btn btn-secondary btn-lg btn-block" style="color:white;" onclick="dialNo('`+ PH1 + `');" >Call : ` + PH1 + `</a><br>    
    </div></div>`
  }
  if (PH2 != null && PH2 != '') {
    buttonToAdd = `<br> <div style="width:100%;display:flex;">
    <div style="width:50%;float:left;">
    <a id="hrefCall" class="btn btn-secondary btn-lg btn-block" style="color:white;"onclick="dialNo('`+ PH2 + `');" >Call : ` + PH2 + `</a><br>    
    </div></div>`
  }
  $("#CallWaButton").html(buttonToAdd);
  $("#mdlPartyName").html(partycode);
  modal.style.display = "block";
  var hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(partycode) + "&partyname=" + encodeURIComponent(partycode) + "&FIRM=" + encodeURIComponent(FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&";

  ReportType = " SALES ";
  ReportATypeCode = "1";
  ReportSeriesTypeCode = "S";

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
