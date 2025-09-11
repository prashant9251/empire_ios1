
var MData;
var MDataLength = 10;
function loadCall(partycode, searchVal) {
  MData = Data;
  console.log(Data);
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


  if (MData.length > 0) {
    var tr = '';

    for (var i = 0; i < MDataLength; i++) {
      var partyname = getValueNotDefine(MData[i].partyname);
      var city = getValueNotDefine(MData[i].city);
      var broker = getValueNotDefine(MData[i].broker);
      var AD1 = getValueNotDefine(MData[i].AD1);
      var AD2 = getValueNotDefine(MData[i].AD2);
      var AD3 = getValueNotDefine(MData[i].AD3);
      var AD4 = getValueNotDefine(MData[i].AD4);
      var PIN = getValueNotDefine(MData[i].PNO);
      var GST = getValueNotDefine(MData[i].GST);
      var MO = getValueNotDefine(MData[i].MO);
      var PH1 = getValueNotDefine(MData[i].PH1);
      var PH2 = getValueNotDefine(MData[i].PH2);
      var TRSPT = getValueNotDefine(MData[i].TRSPT);

      var shareText = "CLIENT:-" + partyname + "\n";
      shareText += "ADDRESS:-" + partyname + "\n";
      shareText += AD1 + "\n";
      shareText += AD2 + "," + PIN + "\n";
      shareText += "GST:-" + GST + "\n";
      shareText += "CONTECT:-" + MO + "," + PH1 + "," + PH2 + "\n";
      shareText += "EMAIL:-" + MData[i].EML + "\n";

      var gstText = "PARTY :" + partyname + "\n";
      gstText += "GSTIN: " + GST + "\n";
      gstText += "TRANSPORT: " + TRSPT;

      tr += `    <thead > <tr style="background-color: #588c7e;!important;">
        <th>`+ (partyname) + `</th>
        <th>`+ (city) + `</th>
        <th>`+ (broker) + `</th>
        </tr>
        </thead>
        `;

      tr += `   <tr>
        <th colspan="3">`+ getValueNotDefine(MData[i].AD1) + `,` + getValueNotDefine(MData[i].AD2) + `,` + getValueNotDefine(MData[i].PNO) + `</th>
        </tr>
        <tr>
        <th colspan="2"><a target="_blank"href="https://wa.me?text=`+ encodeURIComponent(gstText) + `">` + getValueNotDefine(MData[i].GST) + `</a></th>                        
        <th style="text-align:center;"><a target="_blank"href="https://wa.me?text=`+ encodeURIComponent(shareText) + `"><button>SHARE</button></a></th>
        </tr>
        `;

      if (MData[i].MO != null || MData[i].MO != null || MData[i].MO != null) {
        tr += `
          <tr>
          <th colspan="3">CONTACT:-<a href="tel:`+ getValueNotDefine(MData[i].MO) + `">` + getValueNotDefine(MData[i].MO) + `</a>,<a href="tel:` + getValueNotDefine(MData[i].PH1) + `">` + getValueNotDefine(MData[i].PH1) + `</a>,<a href="tel:` + getValueNotDefine(MData[i].PH2) + `">` + getValueNotDefine(MData[i].PH3) + `</a></th>
          </tr>
           `;
      }

      tr += `<tr>
          <th colspan="2"> DHARA : `+ getValueNotDefine(MData[i].DR) + `</th>                        
          <th style="text-align:center;">COMMISSION  :  `+ getValueNotDefine(MData[i].C) + `</th>
          </tr>`;
      tr += `            
          <tr>
          <th colspan="3">RMK: `+ getValueNotDefine(MData[i].R) + `</th>                 
          </tr>
          `;
      tr += `            
          <tr>
          <th colspan="2">CLOTH TYPE: `+ getValueNotDefine(MData[i].CT) + `</th>                 
          <th colspan="1">CR DAYS: `+ getValueNotDefine(MData[i].CR) + `</th>                 
          </tr>
          `;
      tr += `            
          <tr>
          <th colspan="2">BILL_CNO: `+ getValueNotDefine(MData[i].BC) + `</th>                 
          <th colspan="1">QD: `+ getValueNotDefine(MData[i].QD) + `</th>                 
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