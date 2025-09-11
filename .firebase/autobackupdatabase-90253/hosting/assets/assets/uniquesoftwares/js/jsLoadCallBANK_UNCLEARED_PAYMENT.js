
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

function filterBy_CNO_DR_CR_AMT(CNO, bankcode) {
  return BLLDATA.filter(function (d) {
    return d["CNO"] == CNO && d["TYPE"].toUpperCase().indexOf(bankcode) > -1 && d["SRNO"] == 1 && (d["RCD"] == "" ||d["RCD"] ==null)
  }).sort(function (a, b) {
    return new Date(DateRpl(a.DATE)) - new Date(DateRpl(b.DATE));
  }).sort(function (a, b) {
    return a.VNO - b.VNO;
  });


}
function loadCall(data) {
  try {

  var Data = data;
  Data = Data.filter(function (d) {
    return (d.RCD == "" || d.RCD == null) && d.TYPE.toUpperCase().indexOf("B") > -1;
  })
  console.log(Data);
  BLLDATA = Data;
  Data = Data.sort((a, b) => (a.CNO) - (b.CNO));

  var DtArray = [];
  for (j = 0; j < Data.length; j++) {
    if (DtArray.indexOf(Data[j].CNO) < 0) {
      DtArray.push(Data[j].CNO);
    }
  }
  tr += `<tbody>`;

  var DtArrayLength = DtArray.length;
  if (DtArrayLength > 0) {
    var BALANCE = 0;
    var DEBIT = 0;
    var CREDIT = 0;
    // tr += `
    // <tr class="trPartyHead">
    //                     <th colspan="10">UNCLEARED PAYMENT LIST</td>
    //                     </tr>
    //                     `;
    for (var l = 0; l < DtArrayLength; l++) {
      // console.log(lastTIMEUpdated);
      tr += ` <tr class="trPartyHead" style="font-weight:500; font-size:20px;"align="center">                        
     <th class="trPartyHead" align="left" colspan="10">`+ getFirmDetailsBySendCode(DtArray[l])[0].FIRM + `</th>
     </tr>
       `;

      filterByCNO_DR_ARRAY = filterBy_CNO_DR_CR_AMT(DtArray[l], "B1");

      console.log(filterByCNO_DR_ARRAY);
      if (filterByCNO_DR_ARRAY.length > 0) {
        tr += `        
        <tr>
        <td colspan="10">
        <b style="color:#c107a2;font-size: 18px;">Cheque received but not cleared</b>
        </td>
        </tr>
          <tr>
          <th>PARTY NAME</th>
          <th>DATE</th>
          <th>CHQ</th>
          <th>RECEIPT</th>
          <th>PAYMENT</th>
          <th>REF.PARTY</th>
          <th>RMK</th>
          </tr>`;
        for (var i = 0; i < filterByCNO_DR_ARRAY.length; i++) {
          DEBIT += parseFloat(filterByCNO_DR_ARRAY[i].DRAMT);
          CREDIT += parseFloat(filterByCNO_DR_ARRAY[i].CRAMT);
          BALANCE += parseFloat(filterByCNO_DR_ARRAY[i].DRAMT) - parseFloat(filterByCNO_DR_ARRAY[i].CRAMT);
          tr += `
          <tr>
          <td>`+ filterByCNO_DR_ARRAY[i].code + `</td>
          <td>`+ formatDate(filterByCNO_DR_ARRAY[i].DATE) + `</td>
          <td>`+ filterByCNO_DR_ARRAY[i].DOCNO + `</td>
          <td>`+ filterByCNO_DR_ARRAY[i].DRAMT + `</td>
          <td>`+ filterByCNO_DR_ARRAY[i].CRAMT + `</td>
          <td>`+ filterByCNO_DR_ARRAY[i].RFCODE + `</td>
          <td>`+ filterByCNO_DR_ARRAY[i].RMK + `</td>
          </tr>`;
        }
        tr += `
        <tr>
        <th colspan="3">TOTAL</th>
        <th>`+ DEBIT + `</th>
        <th>`+ CREDIT + `</th>
        <th></th>
        <th></th>
        </tr>`;

      }


      filterByCNO_CR_ARRAY = filterBy_CNO_DR_CR_AMT(DtArray[l], "B2");

      console.log(filterByCNO_CR_ARRAY);
      if (filterByCNO_CR_ARRAY.length > 0) {
        tr += `        
        <tr>
        <td colspan="10" style="color: red;font-size:20px;">
        Cheque issued but not cleared
        </td>
        </tr>
          <tr>
          <th>PARTY NAME</th>
          <th>DATE</th>
          <th>CHQ</th>
          <th>RECEIPT</th>
          <th>PAYMENT</th>
          <th>REF.PARTY</th>
          <th>RMK</th>
          </tr>`;
        for (var i = 0; i < filterByCNO_CR_ARRAY.length; i++) {
          DEBIT += parseFloat(filterByCNO_CR_ARRAY[i].DRAMT);
          CREDIT += parseFloat(filterByCNO_CR_ARRAY[i].CRAMT);
          BALANCE += parseFloat(filterByCNO_CR_ARRAY[i].DRAMT) - parseFloat(filterByCNO_CR_ARRAY[i].CRAMT);
          tr += `
          <tr>
          <td>`+ filterByCNO_CR_ARRAY[i].code + `</td>
          <td>`+ formatDate(filterByCNO_CR_ARRAY[i].DATE) + `</td>
          <td>`+ filterByCNO_CR_ARRAY[i].DOCNO + `</td>
          <td>`+ filterByCNO_CR_ARRAY[i].DRAMT + `</td>
          <td>`+ filterByCNO_CR_ARRAY[i].CRAMT + `</td>
          <td>`+ filterByCNO_CR_ARRAY[i].RFCODE + `</td>
          <td>`+ filterByCNO_CR_ARRAY[i].RMK + `</td>
          </tr>`;



        }
        tr += `
        <tr>
        <th colspan="3">TOTAL</th>
        <th>`+ DEBIT + `</th>
        <th>`+ CREDIT + `</th>
        <th></th>
        <th></th>
        </tr>`;
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