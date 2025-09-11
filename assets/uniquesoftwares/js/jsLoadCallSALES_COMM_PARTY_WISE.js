

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

  try {

    TransactionArray = data;
    tr = '<tbody>';
    Data = data;

    for (var i = 0; i < Data.length; i++) {
      if (!flagParty[Data[i].code]) {
        PartyNameList.push(Data[i].code);
        flagParty[Data[i].code] = true;
      }
    }

    console.log(Data);
    if (PartyNameList.length > 0) {
      var BALANCE = 0;
     
  
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

        tr += `
    
    <tr class="trPartyHead" style="height:40px" onclick="trOnClick('` + party + `','','');">  
                        <th colspan="12 " class="trPartyHead">` + label + `</th> 
                        </tr>
                    
                        <tr>
                        <td class="hideDATE">DATE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td class="hideVNO">VNO</td>
                        <td class="hideREFERENCEAC">PARTY NAME</td>
                        <td class="hideFIRM" style="display:none;">FIRM</td>
                        <td class="hideBILLCHQ" style="display:none;">BILL/CHQ</td>
                        <td class="hideREC_AMT alignRight">REC_AMT</td>
                        <td class="hideTAXABLEVALUE alignRight">TAXABLE\nVALUE</td>
                        <td class="hideCOMM_PERSENT alignRight">COMM%</td>
                        <td class="hideCOMM_AMT alignRight">COMM_AMT</td>
                        <td class="hideCOMM_BILL_VNO"> COMM_BILL_VNO</td>
                        <td class="hideRMK"> RMK</td>
                        <td class="hideBROKER"> BROKER</td>
                        <td class="hideTYPE"style="display:none;">TYPE</td>
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
        var DEBIT = 0;
        var TAX_ABLE_VALUE = 0;
        var COMM_AMT = 0;
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
            TAX_ABLE_VALUE += parseFloat(getValueNotDefineNo(element.OA));
            COMM_AMT += parseFloat(getValueNotDefineNo(element.CA));
            
            tr += ` <tr> 
           <th class="selectBoxReport" style="display:none; text-align:center;">
                          <th  onclick="openSubR('`+ party + `')" class="hideDATE">`+ formatDate(element.DATE) + `</th>
                          <td  onclick="openSubR('`+ party + `')" class="hideVNO">`+ element.VNO + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideREFERENCEAC">`+ element.RFCODE + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideFIRM" style="display:none;">`+ element.FRM + `</td>
                          <td  class="hideBILLCHQ" style="display:none;">`+ DOCNO + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideDEBIT DEBIT alignRight">`+ valuetoFixed(element.DRAMT) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideTAXABLEVALUE alignRight">`+ getValueNotDefine(element.OA) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideCOMM_PERSENT alignRight">`+ getValueNotDefine(element.C) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideCOMM_AMT alignRight">`+ getValueNotDefine(element.CA) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideCOMM_BILL_VNO"> `+ getValueNotDefine(element.BV) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideRMK"> `+ getValueNotDefine(element.RMK) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideBROKER"> `+ getValueNotDefine(element.G) + `</td>
                          <td  onclick="openSubR('`+ party + `')" class="hideTYPE"style="display:none;">`+ element.TYPE + `</td>
                          </tr>
                    `;
          }

        }
      
        tr += `     <tr class="tfootcard">
                        <td class="hideDATE">SUB TOTAL</td>
                        <td class="hideVNO"></td>
                        <td class="hideREFERENCEAC"></td>
                        <td class="hideFIRM" style="display:none;"></td>
                        <td class="hideBILLCHQ" style="display:none;"></td>
                        <td class="hideDEBIT DEBIT alignRight">`+ valuetoFixed(DEBIT) + `</td>
                        <td class="hideTAXABLEVALUE alignRight">`+ valuetoFixed(TAX_ABLE_VALUE) + `</td>
                        <td class="hideCOMM_PERSENT alignRight"></td>
                        <td class="hideCOMM_AMT alignRight">`+valuetoFixed(COMM_AMT)+`</td>
                        <td class="hideCOMM_BILL_VNO"></td>
                        <td class="hideRMK"></td>
                        <td class="hideBROKER"></td>
                        <td class="hideTYPE"style="display:none;"></td>
                        </tr>
                        `;
        DEBIT = 0;
        TAX_ABLE_VALUE = 0;
        COMM_AMT=0;


      }

      var hideAbleTr = getUrlParams(url, "hideAbleTr");
      if (hideAbleTr == "true") {
       // createLEDGERSummeryReport();
      } else {
        $('#result').html(tr);
        $("#loader").removeClass('has-loader');
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