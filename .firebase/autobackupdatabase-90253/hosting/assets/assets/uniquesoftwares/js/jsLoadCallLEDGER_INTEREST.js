
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}

function loadCall() {
  $("#loader").addClass('has-loader');
  interestParamsHide();
  console.log(Data)
  Data = Data.filter(function (d) {
    return !(d.TYPE.indexOf("B") > -1 || d.TYPE.indexOf("C") > -1 || d.TYPE.indexOf('00') > -1);
  })
  if (cno != '' && cno != null) {
    Data = Data.filter(function (data) {
      return data.CNO == cno;
    })
  }
  if (partycode != '' && partycode != null) {
    Data = Data.filter(function (data) {
      return data.code == partycode;
    })
    console.log(Data);
  }
  if (todate != '' && todate != null) {
    Data = Data.filter(function (data) {
      return new Date(DateRpl(data.DATE)).setHours(24, 0, 0, 0) <= new Date(DateRpl(todate)).setHours(24, 0, 0, 0);
    })
  }
  if (CrDrEntryType == "CREDIT") {
    Data = Data.filter(function (data) {
      return data.DRAMT != 0;
    })
  }
  if (CrDrEntryType == "DEBIT") {
    Data = Data.filter(function (data) {
      return data.CRAMT != 0;
    })
  }
  Data = Data.sort((a, b) => new Date(DateRpl(a.DATE)) - new Date(DateRpl(b.DATE)));
  if (Data.length > 0) {
    var BALANCE = 0;
    var DEBIT = 0;
    var CREDIT = 0;
    if (Data[0].code != null) {
      ccode = getPartyDetailsBySendCode(Data[0].code);
      pcode = getValueNotDefine(ccode[0].partyname);
      city = getValueNotDefine(ccode[0].city);
      broker = getValueNotDefine(ccode[0].broker);
      label = getValueNotDefine(ccode[0].label);
      MO = getValueNotDefine(ccode[0].MO);
    }
    tr += `<tr class="trPartyHead" style="height:40px" onclick="trOnClick('` + Data[0].code + `','','');">  
                        <th colspan="9" class="trPartyHead">` + label + `</th> 
                        </tr>
                    
                        <tr>
                        <th>DATE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                        <th>BILL/CHQ</th>
                        <th>GRACE</th>
                        <th>PAYMENT&nbsp;DATE</th>
                        <th  class="alignCenter">AMT</th>
                        <th>INTREST%</th>
                        <th>DAYS</th>
                        <th>PAY</th>
                        <th>INT. AMT</th>
                        </tr>                        
                                `;

    var interestAmt = 0;
    var totalInterestAmt = 0;
    for (var i = 0; i < Data.length; i++) {
      
      if (new Date(DateRpl(fromdate)).setHours(0, 0, 0, 0) <= new Date(DateRpl(Data[i].DATE)).setHours(0, 0, 0, 0)) {
      var BILL_DETAILS = getBLS(Data[i].CNO, Data[i].TYPE, Data[i].VNO);
      var nowDate = new Date($('#PaymentDate').val());
      var PAY="";
      var DOCTYPE="";
      if (BILL_DETAILS.length > 0) {

        var newNowdate=(BILL_DETAILS[0].billDetails[0].PAYDET);
        nowDate=newNowdate=="" || newNowdate==null || newNowdate ==undefined?nowDate: new Date(newNowdate);
        PAY=getValueNotDefine(BILL_DETAILS[0].billDetails[0].paid);
        DOCTYPE=getValueNotDefine(BILL_DETAILS[0].billDetails[0].DT);
      }

      // console.log(Data[i])
      DEBIT += parseFloat(Data[i].DRAMT);
      CREDIT += parseFloat(Data[i].CRAMT);
      BALANCE += parseFloat(Data[i].DRAMT) - parseFloat(Data[i].CRAMT)
      var DOCNO = getValueNotDefine(Data[i].DOCNO);
      if (DOCNO == '' || DOCNO == null) {
        DOCNO = getValueNotDefine(Data[i].BILLNO);
        if (DOCNO == '' || DOCNO == null) {
          DOCNO = "OPEN";
        }
      }

      GraceDaysVal = $('#GraceDays').val();
      // console.log(GraceDaysVal);
      GRACE_DATE = formatDate(nowDate);
      var nowDays = getDaysDif(Data[i].DATE, nowDate) + 1;
      interestDays = nowDays - GraceDaysVal;

      netAmt = parseFloat(Data[i].DRAMT) + parseFloat(Data[i].CRAMT)
      BALANCE += netAmt;
      interestrate = $('#interestRate').val();
      DaysInYear = $('#DaysInYear').val();
      interestAmt = netAmt * parseInt(interestDays) / DaysInYear * interestrate / 100;




        tr += ` <tr>
                        <th>`+ formatDate(Data[i].DATE) + `</th>
                        <td>`+ DOCNO + `</td>
                        <td>`+ GraceDaysVal + `</td>
                        <th>`+ GRACE_DATE + `</th>
                        <td class="alignRight">`+ valuetoFixed(netAmt) + `</td>
                        <td class="alignCenter">`+ interestrate + `%</td>
                        <td  class="alignCenter">`+ interestDays + `</td>
                        <td>`+ PAY + `</td>
                        <td class="alignRight"style="padding-right:10px;"> `+ parseFloat(interestAmt).toFixed(2) + `</td>
                        </tr>
                        `;
        totalInterestAmt += interestAmt;
      }
    }
    tr += `     <tr class="tfootcard">
                        <td>GRAND TOTAL</td>
                        <td ></td>
                        <td ></td>
                        <td ></td>
                        <td class="alignRight">`+ CrDrTagforValue(valuetoFixed(BALANCE)) + `</td>
                        <td ></td>
                        <td ></td>
                        <td ></td>
                        <td >`+ valuetoFixed(totalInterestAmt) + `</td>
                        
                        </tr>
                        `;

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    if (CrDrEntryType != "") {
      $(`.` + CrDrEntryType).css("display", "none");
    }
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
