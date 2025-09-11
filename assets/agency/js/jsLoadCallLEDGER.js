
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}

function loadCall(data) {
  var Data = data;

  if (cno != '' && cno != null) {
    Data = Data.filter(function (data) {
      return data.CNO == cno;
    })
  }
  if (partycode != '' && partycode != null) {
    Data = Data.filter(function (data) {
      return data.COD == partycode;
    })
  }

  console.log(Data);
  if (ccdcode != '' && ccdcode != null) {
    Data = Data.filter(function (data) {
      return data.RFCD == ccdcode;
    })
  }

  if (todate != '' && todate != null) {
    Data = Data.filter(function (data) {
      return new Date(DateRpl(data.DT)).setHours(24, 0, 0, 0) <= new Date(DateRpl(todate)).setHours(24, 0, 0, 0);
    })
  }
  if (CrDrEntryType == "CREDIT") {
    Data = Data.filter(function (data) {
      return data.DRA != 0;
    })
  }
  if (CrDrEntryType == "DEBIT") {
    Data = Data.filter(function (data) {
      return data.CRA != 0;
    })
  }

  Data = Data.sort(function(a, b) {
    if (new Date(a.DT) < new Date(b.DT)) {
      return -1;
    }
    if (new Date(a.DT) > new Date(b.DT)) {
      return 1;
    }
    return a.VNO - b.VNO;
  });


console.log(Data);

  if (Data.length > 0) {
    var BALANCE = 0;
    var DEBIT = 0;
    var CREDIT = 0;
    var pcode="";
    var city="";
    var broker="";
    var label="";
    var MO="";
    var ATYPE="";
    var lbl="";
    ccode = getPartyDetailsBySendCode(Data[0].COD);
    if (ccode.length > 0) {
      pcode = getValueNotDefine(ccode[0].partyname);
      city = getValueNotDefine(ccode[0].city);
      broker = getValueNotDefine(ccode[0].broker);
      label = getValueNotDefine(ccode[0].label);
      MO = getValueNotDefine(ccode[0].MO);
      ATYPE = getValueNotDefine(ccode[0].ATYPE);
      lbl = parseInt(ATYPE) == 1 ? "CUST : " : parseInt(ATYPE) == 2 ? "SUPP : " : "";

    }
    tr += `<tr class="trPartyHead" style="height:40px" onclick="trOnClick('` + Data[0].COD + `','','','` + ATYPE + `','` + lbl + `');">  
                        <th colspan="9" class="trPartyHead">` + lbl + label + `</th> 
                        </tr>
                    
                        <tr>
                        <th>DATE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                        <th>BILL/CHQ</th>
                        <th>REFERENCE A/C</th>
                        <th class="DEBIT">DEBIT</th>
                        <th class="CREDIT">CREDIT</th>
                        <th class="BALANCE">BALANCE</th>
                        <th>VNO</th>
                        <th>RMK</th>
                        </tr>                        
                                `;
    for (var i = 0; i < Data.length; i++) {
      BALANCE += parseFloat(Data[i].DRA) - parseFloat(Data[i].CRA)
      var DCNO = getValueNotDefine(Data[i].DCNO);
      if (DCNO == '' || DCNO == null) {
        DCNO = getValueNotDefine(Data[i].BLNO);
        if (DCNO == '' || DCNO == null) {
          DCNO = "OPEN";
        }
      }
      FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].CNO, Data[i].TYPE, Data[i].VNO, getFirmDetailsBySendCode(Data[i].CNO)[0].FIRM, Data[i].IDE)??"";
      if ((Data[i].TYPE).toUpperCase().indexOf('B') > -1 || (Data[i].TYPE).toUpperCase().indexOf('C') > -1 || (Data[i].TYPE).toUpperCase().indexOf('00') > -1) {
        if ((Data[i].TYPE).toUpperCase().indexOf('00') > -1) {
          billbutton = '';
        } else {
          var paymentSlipPdf=FdataUrl.replace("Billpdf","paymentSlip");
          billbutton = `<a target="_blank" href="` + paymentSlipPdf + `"><button class="PrintBtnHide">` + DCNO + `</button></a>`;
          // billbutton = `<a target="_blank" href="` + paymentSlipUrl + `"><button>` + DCNO + `</button></a>`;
        }

      } else {
        billbutton = `<a target="_blank" href="` + FdataUrl + `"><button class="PrintBtnHide">` + DCNO + `</button></a>`;
      }
      RFCD = Data[i].RFCD;
      var RFCDArr = getPartyDetailsBySendCode(RFCD);
      if (RFCDArr.length > 0) {
        RFCD = RFCDArr[0].partyname;
      }

      if (new Date(DateRpl(fromdate)).setHours(0, 0, 0, 0) <= new Date(DateRpl(Data[i].DT)).setHours(0, 0, 0, 0)) {
        DEBIT += parseFloat(Data[i].DRA);
        CREDIT += parseFloat(Data[i].CRA);
        tr += ` <tr>
        <td>`+ formatDate(Data[i].DT) + `</td>
        <td>`+ billbutton + `</td>
        <td onclick="openSubR('`+ Data[i].COD + `','` + RFCD + `')">` + RFCD + `</td>
        <td class="DEBIT">`+ valuetoFixed(Data[i].DRA) + `</td>
        <td class="CREDIT">`+ valuetoFixed(Data[i].CRA) + `</td>
        <td class="BALANCE">`+ CrDrTagforValue(valuetoFixed(BALANCE)) + `</td>
        <td>`+ Data[i].VNO + `</td>
        <td> `+ getValueNotDefine(Data[i].RMK) + `</td>
        </tr>
        `;
      }

    }
    tr += `     <tr class="tfootcard">
    <th colspan="3">GRAND TOTAL</th>
    <th class="DEBIT">`+ valuetoFixed(DEBIT) + `</th>
    <th class="CREDIT">`+ valuetoFixed(CREDIT) + `</th>
    <th class="BALANCE">`+ CrDrTagforValue(valuetoFixed(BALANCE)) + `</th>
    <th colspan="2"></th>
    
    </tr>
    `;

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    if (CrDrEntryType != "") {
      $(`.` + CrDrEntryType).css("display", "none");
    }

    AddHeaderTbl();
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');
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
