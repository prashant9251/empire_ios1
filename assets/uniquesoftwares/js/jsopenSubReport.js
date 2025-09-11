function openSubRByPartyAndFirm(partycode,FIRM) {
  var PartyArray = getPartyDetailsBySendCode(partycode);
  var MO = PartyArray[0].MO == null ? '' : PartyArray[0].MO;
  var partycode = encodeURIComponent(partycode);
  var urlLink = window.location.href;
  urlLink = urlLink.replace("FIRM", "");

  urlLink = SubPartylinkReplace(urlLink);

  window.open(urlLink + "&partyname=" + partycode + "&partycode=" + partycode + "&mobileNo=" + MO +"&FIRM="+FIRM, '_blank');
}

function openSubR(partycode) {
  var PartyArray = getPartyDetailsBySendCode(partycode);
  var MO = PartyArray[0].MO == null ? '' : PartyArray[0].MO;
  var partycode = encodeURIComponent(partycode);
  var urlLink = window.location.href;
  urlLink = SubPartylinkReplace(urlLink);
  window.open(urlLink + "&partyname=" + partycode + "&partycode=" + partycode + "&mobileNo=" + MO, '_blank');
}
function SubPartylinkReplace(urlLink) {
  urlLink = urlLink.replace("hideAbleTr", "");
  urlLink = urlLink.replace("partyname", "");
  urlLink = urlLink.replace("partycode", "");
  urlLink = urlLink.replace("mobileNo", "");
  return urlLink;
}
function SubBrokerlinkReplace(urlLink) {
  urlLink = urlLink.replace("broker", "")
  urlLink = urlLink.replace("mobileNo", "")
  return urlLink;
}
function openSubRQ(code) {
  var code = encodeURIComponent(code);
  var urlLink = window.location.href;
  urlLink = urlLink.replace("qualname", "")
  urlLink = urlLink.replace("qualcode", "")
  window.open(urlLink + "&qualname=" + code + "&qualcode=" + code, '_blank');
}

function openSubTransportR(partycode) {
  var partycode = encodeURIComponent(partycode);
  var urlLink = window.location.href;
  urlLink = urlLink.replace("partyname", "")
  urlLink = urlLink.replace("partycode", "")
  window.open(urlLink + "&partyname=" + partycode + "&partycode=" + partycode, '_blank');
}
function openSubReportByUrl(partycode, URL, RedirectToUrl, ReportType, ReportATypeCode, ReportSeriesTypeCode, FIRM, PDFStore) {
  var PartyArray = getPartyDetailsBySendCode(partycode);
  var MO = PartyArray[0].MO == null ? '' : PartyArray[0].MO;
  if (FIRM == undefined || FIRM == null || FIRM == "undefined") {
    FIRM = "";
  }
  let url = window.location.href;
  url = url.replace(URL, RedirectToUrl);
  var partycode = encodeURIComponent(partycode);
  var urlLink = url + "&FIRM=" + encodeURIComponent(FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&search_ToDate=" + todate + "&PDFStore=" + PDFStore + "&chqFilterOnDate=true";
  urlLink = SubPartylinkReplace(urlLink);
  window.open(urlLink + "&partyname=" + partycode + "&partycode=" + partycode + "&mobileNo=" + MO, '_blank');
}

function openBrokerSupR(broker, Mo) {
  var urlLink = window.location.href;
  urlLink = SubBrokerlinkReplace(urlLink);
  window.open(urlLink + "&broker=" + encodeURIComponent(broker) + "&mobileNo=" + Mo, '_blank');
}

function openSubRType(Type, code) {
  var urlLink = window.location.href;
  ReportSeriesTypeCode;
  urlLink = SubPartylinkReplace(urlLink);
  urlLink = urlLink.replace("ReportSeriesTypeCode", "")
  window.open(urlLink + "&partyname=" + code + "&partycode=" + code + "&ReportSeriesTypeCode=" + Type, '_blank');
}