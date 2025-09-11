function openSubR(partycode, ccode) {
  var urlLink = window.location.href;
  var ccdcode="";
  if (ccode != "" && ccode != null && ccode != undefined) {
  urlLink = urlLink.replace("hideAbleTr", "")
  ccdcode =getPartyDetailsBySendName(ccode)[0].value;
  ccode = encodeURIComponent(ccode);
  } else {
    ccode = "";
  }  
  console.log(partycode,ccode)
  partyname =getPartyDetailsBySendName(partycode)[0].partyname;
  partycode = encodeURIComponent(partycode);

  urlLink = urlLink.replace("partyname", "")
  console.log(urlLink)
  urlLink = urlLink.replace("partycode", "")
  urlLink = urlLink.replace("ccd", "")
  urlLink = urlLink.replace("ccdcode", "")
  window.open(urlLink + "&ccd=" + partyname + "&ccdcode=" + partycode + "&partyname=" + ccode + "&partycode=" + ccdcode, '_blank');
}
function openSubRQ(code) {
  var code = encodeURIComponent(code);
  var urlLink = window.location.href;
  urlLink = urlLink.replace("qualname", "")
  urlLink = urlLink.replace("qualcode", "")
  console.log(urlLink)
  window.open(urlLink + "&qualname=" + code + "&qualcode=" + code, '_blank');
}