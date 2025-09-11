var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsLoadCallLEDGER_SUMMERY.js');
document.head.appendChild(my_awesome_script);


var Data;
var TransactionArray = [];
function getPartyTransaction(code) {
  return TransactionArray.filter(function (d) {
    return d.code == code;
  })
}
var smArray = [];
function loadCall(data) {
  smArray = [];

  var grandBALANCE = 0;
  var grandDEBIT = 0;
  var grandCREDIT = 0;
  try {

    TransactionArray = data;
    tr = '';
    Data = data;
    data =[];

    for (var i = 0; i < Data.length; i++) {
      if (!flagParty[Data[i].code]) {
        PartyNameList.push(Data[i].code);
        flagParty[Data[i].code] = true;
      }
    }
    Data = [];
    if (PartyNameList.length > 0) {
      var BALANCE = 0;
      var DEBIT = 0;
      var CREDIT = 0;
      tr += `  <tbody>   <tr class="tfootcard">
    <td class="selectBoxReport" style="display:none;"></td>
    <td class="hideDATE">GRAND TOTAL</td>
    <td class="hideFIRM"></td>
    <td class="hideTYPE"></td>
    <td class="hideBILLCHQ"></td>
    <td class="hideREFERENCEAC"></td>
    <td class="hideDEBIT DEBIT"id="totalDebitTop"></td>
    <td class="hideCREDIT CREDIT" id="totalCreditTop"></td>
    <td class="hideBALANCE BALANCE" id="totalBalTop"></td>
    <td class="hideVNO"></td>
    <td class="hideRMK"></td>
    </tr>
    `;
      PartyNameList = PartyNameList.sort(function (a, b) {
        if (a < b) {
          return -1;
        }
        if (a > b) {
          return 1;
        }
        return 0;
      })
      for (let i = 0; i < PartyNameList.length; i++) {
        const party = PartyNameList[i];
        ccode = getPartyDetailsBySendCode(party);
        var pcode = party;
        var city = "";
        var broker = "";
        var label = party;
        var MO = "";
        if (ccode.length > 0) {
          pcode = getValueNotDefine(ccode[0].partyname);
          city = getValueNotDefine(ccode[0].city);
          broker = getValueNotDefine(ccode[0].broker);
          label = getValueNotDefine(ccode[0].label);
          MO = getValueNotDefine(ccode[0].MO);
        }

        var trRow = `
    
                       <tr class="trPartyHead" style="height:40px" onclick="trOnClick('` + party + `','','');">  
                         <th colspan="12 " class="trPartyHead">` + label + `</th> 
                        </tr>
                    
                        <tr>
                        <td class="selectBoxReport" style="display:none;">SELECT</td>
                        <td class="hideDATE">DATE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td class="hideFIRM">FIRM</td>
                        <td class="hideTYPE">TYPE</td>
                        <td class="hideBILLCHQ">BILL/CHQ</td>
                        <td class="hideREFERENCEAC">REFERENCE A/C</td>
                        <td class="hideDEBIT DEBIT alignRight">DEBIT</td>
                        <td class="hideCREDIT CREDIT alignRight">CREDIT</td>
                        <td class="hideBALANCE BALANCE alignRight">BALANCE</td>
                        <td class="hideVNO">VNO</td>
                        <td class="hideRMK" style="max-width:290px;"> RMK</td>
                        </tr>                        
                                `;

        var PartyTransaction = getPartyTransaction(party);
        PartyTransaction = PartyTransaction.sort(function (a, b) {
          if (new Date(a.DATE) < new Date(b.DATE)) {
            return -1;
          }
          if (new Date(a.DATE) > new Date(b.DATE)) {
            return 1;
          }
          return a.VNO - b.VNO;
        });

        for (let j = 0; j < PartyTransaction.length; j++) {
          const element = PartyTransaction[j];
          BALANCE += parseFloat(element.DRAMT) - parseFloat(element.CRAMT)
          var DOCNO = getValueNotDefine(element.DOCNO);
          if (DOCNO == '' || DOCNO == null) {
            DOCNO = getValueNotDefine(element.BILLNO);
            if (DOCNO == '' || DOCNO == null) {
              DOCNO = "OPEN";
            }
          }
          var paymentSlipUrl = getUrlPaymentSlip(element.CNO, element.TYPE, element.VNO, element.IDE, MO);
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(element.CNO, element.TYPE, element.VNO, getFirmDetailsBySendCode(element.CNO)[0].FIRM, element.IDE, MO);
          if ((element.TYPE).toUpperCase().indexOf('B') > -1 || (element.TYPE).toUpperCase().indexOf('C') > -1 || (element.TYPE).toUpperCase().indexOf('00') > -1) {
            if ((element.TYPE).toUpperCase().indexOf('00') > -1) {
              billbutton = '';
            } else {
              billbutton = `<a target="_blank" href="` + paymentSlipUrl + `"><button>` + DOCNO + `</button></a>`;
            }

          } else {
            billbutton = `<a target="_blank" href="` + FdataUrl + `"><button>` + DOCNO + `</button></a>`;
          }
          var ID = element.CNO + element.TYPE + element.VNO;

          if (new Date(DateRpl(fromdate)).setHours(0, 0, 0, 0) <= new Date(DateRpl(element.DATE)).setHours(0, 0, 0, 0)) {

            DEBIT += parseFloat(element.DRAMT);
            CREDIT += parseFloat(element.CRAMT);
            trRow += ` <tr> 
           <th class="selectBoxReport" style="display:none; text-align:center;">
              <input type="checkbox" checked id="selectField_`+ ID + `" CNO="` + element.CNO + `"DTYPE="` + element.TYPE + `"VNO="` + element.VNO + `"/></th>        
                          <th  onclick="openSubR('`+ party + `')" class="hideDATE">` + formatDate(element.DATE) + `</th>
                          <td  onclick="openSubR('`+ party + `')" class="hideFIRM">` + element.FRM + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideTYPE">` + element.TYPE + `</td>
                          <td  class="hideBILLCHQ">`+ billbutton + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideREFERENCEAC">` + element.RFCODE + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideDEBIT DEBIT alignRight">` + valuetoFixed(element.DRAMT) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideCREDIT CREDIT alignRight">` + valuetoFixed(element.CRAMT) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideBALANCE BALANCE alignRight">` + CrDrTagforValue(valuetoFixed(BALANCE)) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideVNO">` + element.VNO + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideRMK"  style="max-width:290px;"> ` + getValueNotDefine(element.RMK) + `</td>
                          </tr>
                    `;
          }

        }
        obj = {};
        obj.label = label;
        obj.code = party;
        obj.totalDEBIT = DEBIT;
        obj.totalCREDIT = CREDIT;
        obj.totalBALANCE = BALANCE;
        smArray.push(obj);
        trRow += `     <tr class="tfootcard">
                        <td class="selectBoxReport" style="display:none;"></td>
                        <td class="hideDATE">TOTAL</td>
                        <td class="hideFIRM"></td>
                        <td class="hideTYPE"></td>
                        <td class="hideBILLCHQ"></td>
                        <td class="hideREFERENCEAC"></td>
                        <td class="hideDEBIT DEBIT alignRight">`+ valuetoFixed(DEBIT) + `</td>
                        <td class="hideCREDIT CREDIT alignRight">`+ valuetoFixed(CREDIT) + `</td>
                        <td class="hideBALANCE BALANCE alignRight">`+ CrDrTagforValue(valuetoFixed(BALANCE)) + `</td>
                        <td class="hideVNO"></td>
                        <td class="hideRMK"  style="max-width:290px;"></td>
                        </tr>
                        `;
       
        tr += trRow;
        trRow=null;
        grandBALANCE += BALANCE;
        grandDEBIT += DEBIT;
        grandCREDIT += CREDIT;
        BALANCE = 0;
        DEBIT = 0;
        CREDIT = 0;
      }

      var hideAbleTr = getUrlParams(url, "hideAbleTr");
      if (hideAbleTr == "true") {
        createLEDGERSummeryReport();
      } else {
        $('#result').html(tr);
        tr =null;
        $("#loader").removeClass('has-loader');
        $("#totalDebitTop").html(valuetoFixed(grandDEBIT));
        $("#totalCreditTop").html(valuetoFixed(grandCREDIT));
        $("#totalBalTop").html(CrDrTagforValue(valuetoFixed(grandBALANCE)));
      }
      if (CrDrEntryType != "") {
        $(`.` + CrDrEntryType).css("display", "none");
      }

      hideList();

      var PDFStore = getUrlParams(url, "PDFStore");
      if (PDFStore == "true") {
        directPdfCreateOnLoad();
      }
    } else {
      $('#result').html('<h1>No Data Found</h1>');
      $("#loader").removeClass('has-loader');
    }

  } catch (error) {
    alert(error);
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