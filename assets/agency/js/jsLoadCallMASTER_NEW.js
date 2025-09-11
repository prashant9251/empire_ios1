
var MData;
var MDataLength = 50;
function loadCall(partycode, searchVal) {
  MData = Data;
  MData = Data.sort(function (a, b) {
    return a['value'] > b['value'] ? -1 : 1;
  });
  if (partycode != '' && partycode != null) {
    MData = Data.filter(function (d) {
      return (d.value) == partycode;
    });
    console.log(MData);
    MDataLength = MData.length;
  }
  if (searchVal != '' && searchVal != null) {
    MData = Data.filter(function (d) {
      return (d.label).toUpperCase().indexOf(searchVal.toUpperCase()) > -1;
    });
    MDataLength = MData.length;
  }

  // try {

  if (atypeSelect != null && atypeSelect != "") {
    MData = MData.filter(function (d) {
      return (d.ATYPE).trim() == atypeSelect.trim();
    });
  }
  MData = MData.sort(function (a, b) {
    return a.partyname - b.partyname;
  })
  if (MData.length > 0) {
    var tr = '';
    tr += `    <thead > <tr style="background-color: #588c7e;!important;color:black;">
    <th style="border:1px solid black;">NAME</th>
    <th style="border:1px solid black;">CITY</th>
    <th style="border:1px solid black;">BROKER</th>
    <th style="border:1px solid black;">TRANSPORT</th>
    <th style="border:1px solid black;">STATION</th>
    <th style="border:1px solid black;">GSTIN</th>
    <th style="border:1px solid black;">ADDRESS</th>
    <th style="border:1px solid black;">CONTACT</th>
    </tr>
    </thead>
    `;
    for (var i = 0; i < MDataLength; i++) {
      var partyname = getValueNotDefine(MData[i].partyname);
      var city = getValueNotDefine(MData[i].city);
      var broker = getValueNotDefine(MData[i].broker);
      var AD1 = getValueNotDefine(MData[i].AD1);
      var AD2 = getValueNotDefine(MData[i].AD2);
      var ST = getValueNotDefine(MData[i].ST);
      var AD3 = getValueNotDefine(MData[i].AD3);
      var AD4 = getValueNotDefine(MData[i].AD4);
      var PIN = getValueNotDefine(MData[i].PNO);
      var GST = getValueNotDefine(MData[i].GST);
      var MO = getValueNotDefine(MData[i].MO);
      var PH1 = getValueNotDefine(MData[i].PH1);
      var PH2 = getValueNotDefine(MData[i].PH2);
      var CTNM = getValueNotDefine(MData[i].CTNM);
      var TRSPT = getValueNotDefine(MData[i].TRSPT);

      var shareText = "" + partyname + "\n";
      // shareText += "EMAIL:-" + MData[i].EML + "\n";
      shareText += "ADDRESS:-" + partyname + "\n";
      shareText += AD1 + "\n";
      shareText += AD2 + "," + city + "," + PIN + "\n";
      shareText += "TRANSPORT: " + TRSPT + "\n";
      shareText += "STATION : " + ST + "\n";
      shareText += "GST:-" + GST + "\n";
      shareText += MO + "," + PH1 + "," + PH2;
      var FIRM = $('#FIRM').val();
      var gstText = "PARTY :" + partyname + "\n";
      gstText += "GSTIN: " + GST + "\n";
      gstText += "TRANSPORT: " + TRSPT + "\n";
      gstText += "STATION : " + ST + "\n";
      gstText += FIRM != "" ? "BROKER: " + FIRM : "";

      tr += ` <tr>
      <th>`+ partyname + `</th>
      <th>`+ city + `</th>
      <th>`+ broker + `</th>
      <th>`+ TRSPT + `</th>
      <th>`+ ST + `</th>
      <th style="color:darkblue;text-decoration-line: underline;" onclick="shareTextToFlutterApp('`+ encodeURIComponent(gstText) + `')">` + GST + `</th>
      <th style="color:darkblue;text-decoration-line: underline;" onclick="shareTextToFlutterApp('`+ encodeURIComponent(shareText) + `')">` + getValueNotDefine(MData[i].AD1) + `,` + getValueNotDefine(MData[i].AD2) + `,` + getValueNotDefine(MData[i].city) + `,` + getValueNotDefine(MData[i].PNO) + `</th>
      <th style="color:darkblue;text-decoration-line: underline;">`+ (CTNM) + `<br><a onclick="dialNo('` + getValueNotDefine(MData[i].MO) + `')">` + getValueNotDefine(MData[i].MO) + `</a><br><a onclick="dialNo('` + getValueNotDefine(MData[i].PH1) + `')">` + getValueNotDefine(MData[i].PH1) + `</a><br><a onclick="dialNo('` + getValueNotDefine(MData[i].PH2) + `')">` + getValueNotDefine(MData[i].PH3) + `</a><br></th>
      </tr>
      `;

    }

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
  } else {
    $('#result').html('<h1>No Data Found</h1>');

  }
  // } catch (error) {
  //     // alert(error);
  // }


}