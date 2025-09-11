
function ExtraDataOpt() {
  var BLS_DATA = BLS_OPT();
  storedatatoIndexdb(DSN, "BLS", JSON.stringify(BLS_DATA)).then(function (data) {
    // frame(width);
  })
  var OUTSTANDING_DATA = OUTSTANDING_OPT();
  storedatatoIndexdb(DSN, "OUTSTANDING", JSON.stringify(OUTSTANDING_DATA)).then(function (data) {
    // frame(width);
  })
}
function BLS_OPT() {
  for (let i = 0; i < SYNCBLS.length; i++) {
    var groupName = "";
    var groupArray = getGroupDetailsBySendCode(SYNCBLS[i].code);
    if (groupArray.length > 0) {
      groupName = groupArray[0].GP;
    }
    groupName = groupName == null || groupName == undefined ? "" : groupName;
    SYNCBLS[i].GP = groupName;
  }
  // console.log(SYNCBLS);
  return SYNCBLS;
}
function OUTSTANDING_OPT() {
  for (let i = 0; i < SYNCOUTSTANDING.length; i++) {
    var groupName = "";
    var MARKET = "";
    var groupArray = getGroupDetailsBySendCode(SYNCOUTSTANDING[i].code);
    if (groupArray.length > 0) {
      groupName = groupArray[0].GP;
    }
    var PartyDetails = getPartyDetailsBySendCode(SYNCOUTSTANDING[i].code);
    if (PartyDetails.length > 0) {
      MARKET = PartyDetails[0].M;
    }
    groupName = groupName == null || groupName == undefined ? "" : groupName;
    SYNCOUTSTANDING[i].GP = groupName;
    SYNCOUTSTANDING[i].MARKET = MARKET;
  }
  // console.log(SYNCOUTSTANDING);
  return SYNCOUTSTANDING;
}
function getGroupDetailsBySendCode(ccode) {
  return SYNCACGROUP.filter(function (data) {
    return data.value == ccode;
  })
}

function getGroupDetailsBySendCode(ccode) {
  return SYNCACGROUP.filter(function (data) {
    return data.value == ccode;
  })
}
function getPartyDetailsBySendCode(ccode) {
  try {
    
  return SYNCMST.filter(function (data) {
    return data.value == ccode;
  })
} catch (error) {
  return [];
}
}
function mstOpt(ARR) {
  ARR = ARR.filter(function (d) {
    return d != null;
  })
  // console.log(ARR);
  return JSON.stringify(ARR);
}