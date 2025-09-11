function openSubR(partycode, ccode) {
  var urlLink = window.location.href;
  var ccdcode="";
  if (ccode != "" && ccode != null && ccode != undefined) {
    var ccdArr = getPartyDetailsBySendName(ccode);
    if(ccdArr.length){
      ccdcode =encodeURIComponent(ccdArr[0].value);
    }
  ccode = encodeURIComponent(ccode);
  } else {
    ccode = "";
  }  
  console.log(partycode,ccode)
  var partyArr = getPartyDetailsBySendCode(partycode);
  var partyname ="";
  if(partyArr.length){
    partyname =encodeURIComponent(partyArr[0].partyname);
  }
  partycode = encodeURIComponent(partycode);

  urlLink = SubPartylinkReplace(urlLink);
  var furl = urlLink + "&partyname=" + partyname + "&partycode=" + partycode + "&ccd=" + ccode + "&ccdcode=" + ccdcode;
  console.log(furl);
  window.open(furl, '_blank');
}

function SubPartylinkReplace(urlLink) {
  urlLink = urlLink.replaceAll("hideAbleTr", "")
  urlLink = urlLink.replaceAll("partyname", "")
  urlLink = urlLink.replaceAll("partycode", "")
  urlLink = urlLink.replaceAll("ccd", "")
  urlLink = urlLink.replaceAll("ccdcode", "")
  return urlLink;
}
function openSubRQ(code) {
  var code = encodeURIComponent(code);
  var urlLink = window.location.href;
  urlLink = urlLink.replace("qualname", "")
  urlLink = urlLink.replace("qualcode", "")
  window.open(urlLink + "&qualname=" + code + "&qualcode=" + code, '_blank');
}