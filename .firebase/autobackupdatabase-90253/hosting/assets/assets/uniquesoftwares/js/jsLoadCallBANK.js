
function loadCall(data) {

  var Data = data;
  var DOCNO;
  var BALANCE;
  var DEBIT;
  var CREDIT;
  var bankHeadTotal;
  var BLL;
  var DL = Data.length;
  if (DL > 0) {
    BALANCE = 0;
    DEBIT = 0;
    CREDIT = 0;
    bankHeadTotal = "";
    tr += ` <thead id="bankHeadTotal"> </thead> <thead><tr>
                        <th>DATE</th>
                        <th>FIRM</th>
                        <th>DOCNO</th>
                        <th>RFCODE</th>
                        <th class="CREDIT">CRAMT</th>
                        <th class="DEBIT">DRAMT</th>
                        <th class="hTotal">TOTAL</th>
                        <th>VNO</th>
                        <th>RMK</th>
                        </tr>
                        </thead>
                        `;
    for (var i = 0; i < DL; i++) {

      ccode = getPartyDetailsBySendCode(Data[i].RFCODE);
      if (ccode.length > 0) {
        var MO = getValueNotDefine(ccode[0].MO);
      }
      DEBIT += parseFloat(Data[i].DRAMT);
      CREDIT += parseFloat(Data[i].CRAMT);
      BALANCE += parseFloat(Data[i].DRAMT) - parseFloat(Data[i].CRAMT)
      DOCNO = getValueNotDefine(Data[i].DOCNO);
      var paymentSlipUrl = getUrlPaymentSlip(Data[i].CNO, Data[i].TYPE, Data[i].VNO, Data[i].IDE, MO);
      if (DOCNO == '' || DOCNO == null) {
        DOCNO = getValueNotDefine(Data[i].BILLNO);
        billbutton = `<a target="_blank" href="` + paymentSlipUrl + `"><button>OPEN</button></a>`;
      } else {
        billbutton = `<a target="_blank" href="` + paymentSlipUrl + `"><button>` + DOCNO + `</button></a>`;
      }
      tr += ` <tr>
                        <td>`+ formatDate(Data[i].DATE) + `</td>
                        <td>`+ Data[i].FRM + `</td>
                        <td>`+ billbutton + `</td>
                        <td>`+ Data[i].RFCODE + `</td>
                        <td class="CREDIT">`+ valuetoFixed(Data[i].DRAMT) + `</td>
                        <td class="DEBIT">`+ valuetoFixed(Data[i].CRAMT) + `</td>
                        <td class="hTotal">`+ (valuetoFixed(BALANCE)) + `</td>
                        <td>`+ Data[i].VNO + `</td>
                        <td> `+ getValueNotDefine(Data[i].RMK) + `</td>
                        </tr>
                        `;
                        if(adjustDet=="Y"){
                          tr+=getAdjustDetails(Data[i].IDE,Data[i].DATE);
                        }
    }
    bankHeadTotal += `     <tr class="tfootcard">
                        <td colspan="4">GRAND TOTAL</td>
                        <td class="CREDIT">`+ valuetoFixed(DEBIT) + `</td>
                        <td class="DEBIT">`+ valuetoFixed(CREDIT) + `</td>
                        <td  class="hTotal">`+ (valuetoFixed(BALANCE)) + `</td>
                        <td colspan="2"></td>
                        
                        </tr>
                        `;

    $('#result').html(tr);
    $('#bankHeadTotal').html(bankHeadTotal);
    $("#loader").removeClass('has-loader');
    if (order != "ASC") {
      $(`.hTotal`).css("display", "none");
    }
  } else {
    $('#result').html('<h1 align="center">No Data Found</h1>');
    $("#loader").removeClass('has-loader');
  }


}