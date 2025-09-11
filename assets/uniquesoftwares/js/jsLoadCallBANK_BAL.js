
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
function filterBy(oncode, CNO) {
  return BLLDATA.filter(function (d) {
    return d[oncode] == CNO;
  });
}
function filterByCNO_code(CNO, code) {
  return BLLDATA.filter(function (d) {
    return d["CNO"] == CNO && d["code"] == code;
  });
}
function getBankName(ATYPE) {
  return masterData.filter(function (d) {
    return d.ATYPE == ATYPE;
  })
}

function loadCall(data) {
try {    
  var Data = data;
  // if (cno != '' && cno != null) {
  //   Data = Data.filter(function (data) {
  //     return data.CNO == cno;
  //   })
  // }
  // if (partycode != '' && partycode != null) {
  //   Data = Data.filter(function (data) {
  //     return data.code == partycode;
  //   })
  console.log(Data);
  // }
  // if (todate != '' && todate != null) {
  //   Data = Data.filter(function (data) {
  //     return new Date(data.DATE).setHours(24, 0, 0, 0) <= new Date(todate).setHours(24, 0, 0, 0);
  //   })
  // }
  // if (CrDrEntryType == "CREDIT") {
  //   Data = Data.filter(function (data) {
  //     return data.DRAMT != 0;
  //   })
  // }
  // if (CrDrEntryType == "DEBIT") {
  //   Data = Data.filter(function (data) {
  //     return data.CRAMT != 0;
  //   })
  // }
  Data = Data.filter(function (d) {
    return d.code.toUpperCase().indexOf("BANK") > -1;
  })
  BLLDATA = Data;
  Data = Data.sort((a, b) => new Date(DateRpl(a.CNO)) - new Date(DateRpl(b.CNO)));

  var DtArray = [];
  var flagCNO = [];

  for (j = 0; j < Data.length; j++) {
    if (!flagCNO[Data[j].CNO]) {
      DtArray.push(Data[j].CNO);
      flagCNO[Data[j].CNO] = true;
    }
  }
  tr += `<tbody>`;

  var DtArrayLength = DtArray.length;

  if (DtArrayLength > 0) {
    var BALANCE = 0;
    var DEBIT = 0;
    var CREDIT = 0;
    tr += `
    <tr class="trPartyHead">
                        <th>BANK NAME</td>
                        <td style="text-align:center;">BALANCE</td>
                        <td style="text-align:center;">OD/CC AMT</td>
                        <td style="text-align:center;">FINAL BAL.</td>
                        </tr>
                        `;
    for (var l = 0; l < DtArrayLength; l++) {
      // console.log(lastTIMEUpdated);
      var FirmDet=getFirmDetailsBySendCode(DtArray[l]);
      var FIRM="";
      if(FirmDet.length>0){
        FIRM= FirmDet[0].FIRM;
      }
      tr += ` <tr style="font-weight:500;"align="center">                        
         <td  align="left" colspan="3"><b style="color:#c107a2;font-size: 18px;">`+ FIRM + `</b></td>
       `;

      filterByCNO = filterBy("CNO", DtArray[l]);
      var getBankNameList = getBankName(5);
      // console.log(getBankNameList)
      if (getBankNameList.length > 0) {
        for (j = 0; j < getBankNameList.length; j++) {
          tr += ` <tr style="font-weight:500;"align="center">                        
          <td  align="left"><b style="color:blue;font-size: 18px;" onclick="directOpenLedger('` + getBankNameList[j].partyname + `','`+FIRM+`');">`+ getBankNameList[j].partyname + `</b>
          </td>
            `;
          var filterByCNO_CODE = filterByCNO_code(DtArray[l], getBankNameList[j].partyname);
          // console.log(filterByCNO_CODE);

          for (var i = 0; i < filterByCNO_CODE.length; i++) {
            var DRAMT = filterByCNO_CODE[i].DRAMT;
            var CRAMT = filterByCNO_CODE[i].CRAMT;
            DRAMT = DRAMT == null || DRAMT == "" || DRAMT == undefined ? 0 : DRAMT;
            CRAMT = CRAMT == null || CRAMT == "" || CRAMT == undefined ? 0 : CRAMT;
            DEBIT += parseFloat(DRAMT);
            CREDIT += parseFloat(CRAMT);
            BALANCE += parseFloat(DRAMT) - parseFloat(CRAMT);
          }
          var XidPartyName = getBankNameList[j].partyname;
          XidPartyName = XidPartyName.replaceAll(".", "_");
          XidPartyName = XidPartyName.replaceAll(/[^ 0-9a-zA-Z ]/g, "_");
          var Xid = (DtArray[l] + "_" + XidPartyName);
          Xid = Xid.replaceAll(/[^ 0-9a-zA-Z ]/g, "_");
          Xid = Xid.replaceAll(" ", "");
          var ODCC = getValueNotDefineNo(localStorage.getItem("SL_ODCC_AMT_" + Xid));
          var finalBal = "0000";
          if (ODCC != "" && ODCC != null) {
            finalBal = ODCC - (-BALANCE);
          }
          tr += `     
            <td class="BALANCE" id="BAL_AMT_`+ Xid + `"style="color:#c107a2;font-size: 18px;" >` + CrDrTagforValue(valuetoFixed(BALANCE)) + `</td>
            <td class="BALANCE"><b style="color:#c107a2;font-size: 18px;">
            <input type="text" class="form-control"value="`+ ODCC + `"
            id="ODCC_AMT_`+ Xid + `"
            onchange="localSave('ODCC_AMT_`+ Xid + `');Calculate('` + BALANCE + `','` + Xid + `');"/></b></td>
            <td class="BALANCE"><b style="color:#c107a2;font-size: 18px;" id="final_Amt`+ Xid + `">
            `+ valuetoFixed(finalBal) + `</b></td>
            </tr>
            `;
          DEBIT = 0;
          CREDIT = 0;
          BALANCE = 0;
        }
      }
    }
    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    document.title = "BANK BALANCE";
    if (CrDrEntryType != "") {
      $(`.` + CrDrEntryType).css("display", "none");
    }
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');
  }

} catch (error) {
  noteError(error);
}

}
function CrDrTagforValue(value) {
  var BalanceValue = value;
  if (value < 0) {
    BalanceValue = "" + (value);
  } else if (value > 0) {
    BalanceValue = "" + (value);
  }
  return BalanceValue
}


var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

function Calculate(Bal, Xid) {
  var odcc = $('#ODCC_AMT_' + Xid).val();

  var finalbal = odcc - (-Bal);
  $('#final_Amt' + Xid).html(parseInt(finalbal));
}