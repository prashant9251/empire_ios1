
var Data;
function loadCall(data) {
  tr='';
   Data = data;
  var order = getUrlParams(url, "order");
  if(order=="DESC"){
    Data = Data.sort((a, b) => new Date(DateRpl(b.DATE)) - new Date(DateRpl(a.DATE)));
  }else{
    Data = Data.sort((a, b) => new Date(DateRpl(a.DATE)) - new Date(DateRpl(b.DATE)));
  }

  console.log(Data);
  if (Data.length > 0) {
    var BALANCE = 0;
    var DEBIT = 0;
    var CREDIT = 0;
if(Data[0].code!=null){
  ccode = getPartyDetailsBySendCode( Data[0].code);
  pcode = getValueNotDefine(ccode[0].partyname);
  city = getValueNotDefine(ccode[0].city);
  broker = getValueNotDefine(ccode[0].broker);
  label = getValueNotDefine(ccode[0].label);
  MO = getValueNotDefine(ccode[0].MO);
}
tr += `  <tbody>   <tr class="tfootcard">
<td class="selectBoxReport" style="display:none;"></td>
<td class="hideDATE">GRAND TOTAL</td>
<td class="hideFIRM"></td>
<td class="hideBILLCHQ"></td>
<td class="hideREFERENCEAC"></td>
<td class="hideDEBIT DEBIT"id="totalDebitTop"></td>
<td class="hideCREDIT CREDIT" id="totalCreditTop"></td>
<td class="hideBALANCE BALANCE" id="totalBalTop"></td>
<td class="hideVNO"></td>
<td class="hideRMK"></td>
</tr>
`;
    tr += `
    
    <tr class="trPartyHead" style="height:40px" onclick="trOnClick('` + Data[0].code + `','','');">  
                        <th colspan="12 " class="trPartyHead">` + label + `</th> 
                        </tr>
                    
                        <tr>
                        <td class="selectBoxReport" style="display:none;">SELECT</td>
                        <td class="hideDATE">DATE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td class="hideFIRM">FIRM</td>
                        <td class="hideBILLCHQ">BILL/CHQ</td>
                        <td class="hideREFERENCEAC">REFERENCE A/C</td>
                        <td class="hideDEBIT DEBIT">DEBIT</td>
                        <td class="hideCREDIT CREDIT">CREDIT</td>
                        <td class="hideBALANCE BALANCE">BALANCE</td>
                        <td class="hideVNO">VNO</td>
                        <td class="hideRMK"> RMK</td>
                        </tr>                        
                                `;
    for (var i = 0; i < Data.length; i++) {
     
      BALANCE += parseFloat(Data[i].DRAMT) - parseFloat(Data[i].CRAMT)
      var DOCNO = getValueNotDefine(Data[i].DOCNO);
      if (DOCNO == '' || DOCNO == null) {
        DOCNO = getValueNotDefine(Data[i].BILLNO);
        if (DOCNO == '' || DOCNO == null) {
          DOCNO = "OPEN";
        }
      }
      var paymentSlipUrl = getUrlPaymentSlip(Data[i].CNO, Data[i].TYPE, Data[i].VNO, Data[i].IDE,MO);
      FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].CNO, Data[i].TYPE, Data[i].VNO, getFirmDetailsBySendCode(Data[i].CNO)[0].FIRM, Data[i].IDE,MO);
      if ((Data[i].TYPE).toUpperCase().indexOf('B') > -1 || (Data[i].TYPE).toUpperCase().indexOf('C') > -1 || (Data[i].TYPE).toUpperCase().indexOf('00') > -1) {
        if ((Data[i].TYPE).toUpperCase().indexOf('00') > -1) {
          billbutton = '';
        } else {
          billbutton = `<a target="_blank" href="` + paymentSlipUrl + `"><button>` + DOCNO + `</button></a>`;
        }

      } else {
        billbutton = `<a target="_blank" href="` + FdataUrl + `"><button>` + DOCNO + `</button></a>`;
      }
      var ID =  Data[i].CNO +  Data[i].TYPE +  Data[i].VNO;

      if (new Date(DateRpl(fromdate)).setHours(0, 0, 0, 0) <= new Date(DateRpl(Data[i].DATE)).setHours(0, 0, 0, 0)) {
        DEBIT += parseFloat(Data[i].DRAMT);
        CREDIT += parseFloat(Data[i].CRAMT);
        tr += ` <tr> 
         <th class="selectBoxReport" style="display:none; text-align:center;">
        <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + Data[i].CNO + `"DTYPE="` + Data[i].TYPE + `"VNO="` + Data[i].VNO + `"/></th>        
                        <th class="hideDATE">`+ formatDate(Data[i].DATE) + `</th>
                        <td class="hideFIRM">`+ Data[i].FRM + `</td>
                        <td class="hideBILLCHQ">`+ billbutton + `</td>
                        <td class="hideREFERENCEAC">`+ Data[i].RFCODE + `</td>
                        <td class="hideDEBIT DEBIT">`+ valuetoFixed(Data[i].DRAMT) + `</td>
                        <td class="hideCREDIT CREDIT">`+ valuetoFixed(Data[i].CRAMT) + `</td>
                        <td class="hideBALANCE BALANCE">`+ CrDrTagforValue(valuetoFixed(BALANCE)) + `</td>
                        <td class="hideVNO">`+ Data[i].VNO + `</td>
                        <td class="hideRMK"> `+ getValueNotDefine(Data[i].RMK) + `</td>
                        </tr>
                        `;
      }
    }
    tr += `     <tr class="tfootcard">
                        <td class="selectBoxReport" style="display:none;"></td>
                        <td class="hideDATE">GRAND TOTAL</td>
                        <td class="hideFIRM"></td>
                        <td class="hideBILLCHQ"></td>
                        <td class="hideREFERENCEAC"></td>
                        <td class="hideDEBIT DEBIT">`+ valuetoFixed(DEBIT) + `</td>
                        <td class="hideCREDIT CREDIT">`+ valuetoFixed(CREDIT) + `</td>
                        <td class="hideBALANCE BALANCE">`+ CrDrTagforValue(valuetoFixed(BALANCE)) + `</td>
                        <td class="hideVNO"></td>
                        <td class="hideRMK"></td>
                        
                        </tr>
                        `;

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    $("#totalDebitTop").html(valuetoFixed(DEBIT));
    $("#totalCreditTop").html(valuetoFixed(CREDIT));
    $("#totalBalTop").html(CrDrTagforValue(valuetoFixed(BALANCE)));
    if (CrDrEntryType != "") {
      $(`.` + CrDrEntryType).css("display", "none");
    }
    
    hideList();
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
