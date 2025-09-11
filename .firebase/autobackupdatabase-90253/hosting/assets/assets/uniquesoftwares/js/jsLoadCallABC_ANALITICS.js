
var Data;
function getLedgerMeargeTransaction(IDE) {
  return LEDGER_MEARGE.filter(function (d) {
    return d.IDE == IDE;
  })
}
function getPartyTransaction(code) {
  return TransactionArray.filter(function (d) {
    return d.RFCODE == code;
  })
}
var hideAbleTr = getUrlParams(url, "hideAbleTr");
var smArray = [];
var flagParty = [];
var PartyNameList = [];
var TransactionArray = [];
var tr = "<tbody>";
function loadCall(data) {
   smArray = [];

  TransactionArray = [];
  flagParty = [];
  PartyNameList = [];
  try {

    Data = data;
    for (let i = 0; i < Data.length; i++) {
      for (let j = 0; j < Data[i].billDetails.length; j++) {
        var LEDGER_TRANSACTION = getLedgerMeargeTransaction(Data[i].IDE);
        Data[i].billDetails[j].LEDGER_TRANSACTION = LEDGER_TRANSACTION;
        Data[i].billDetails[j].code = (LEDGER_TRANSACTION[0].code);
        Data[i].billDetails[j].RFCODE = (LEDGER_TRANSACTION[0].RFCODE);
        var ccode = getPartyDetailsBySendCode(Data[i].billDetails[j].RFCODE);
        // console.log(Data[i].code+"-",ccode);
        city = "";
        broker = "";
        label = "";
        if (ccode.length > 0) {
          city = getValueNotDefine(ccode[0].city);
          broker = getValueNotDefine(ccode[0].broker);
          ATP = getValueNotDefine(ccode[0].ATYPE);
        }
        Data[i].billDetails[j].city = city;
        Data[i].billDetails[j].broker = broker;
        Data[i].billDetails[j].ATP = ATP;
        TransactionArray.push(Data[i].billDetails[j]);
        if (!flagParty[Data[i].billDetails[j].RFCODE]) {
          var obj = {};
          obj.RFCODE = Data[i].billDetails[j].RFCODE;
          obj.city = Data[i].billDetails[j].city;
          obj.broker = Data[i].billDetails[j].broker;
          obj.ATP = Data[i].billDetails[j].ATP;
          PartyNameList.push(obj);
          flagParty[Data[i].billDetails[j].RFCODE] = true;
        }

      }
    }
    PartyNameList=PartyNameList.filter(function(d){
      return d.ATP==1;
    })
    PartyNameList = PartyNameList.sort(function (a, b) {
      if (a.RFCODE > b.RFCODE)
        return 1;
      if (a.RFCODE < b.RFCODE)
        return -1;
      return 0;
    });
    if(partycode!=null){
      PartyNameList=PartyNameList.filter(function(d){
        return d.RFCODE==partycode;
      })
    }
    if (PartyNameList.length > 0) {

      for (let k = 0; k < PartyNameList.length; k++) {
        tr +=`
          <tr>
          <th>DATE</th>
          <th>BILL NO</th>
          <th>TYPE</th>
          <th>BILL AMT</th>
          <th>RET.GOODS</th>
          <th>ADJ.AMT</th>
          <th>REC IN DAYS</th>
          </tr>

        <tr>
        <th>`+PartyNameList[k].RFCODE+`</th>
        </tr>
        `;
        var PartyTransaction = getPartyTransaction(PartyNameList[k].RFCODE);
        PartyTransaction =PartyTransaction.filter(function(d){
          return d.DOC.toString().toUpperCase().trim()=="OS"
        })
        var totalBamtTotal = 0;
        var totalReturnsGoods = 0;
        var totalPaidAmt = 0;
        var totalDays=0;
        var totalsr=0;
        for (let l = 0; l < PartyTransaction.length; l++) {
          totalBamtTotal += parseFloat(PartyTransaction[l].BA);
          totalReturnsGoods += parseFloat(PartyTransaction[l].RGA);
          totalPaidAmt += parseFloat(PartyTransaction[l].AMT);
          var days =getDaysDif(PartyTransaction[l].DT, PartyTransaction[l].LEDGER_TRANSACTION[0].DATE);
          totalDays+=days;
          totalsr++;
          tr +=`
          <tr>
          <td>`+PartyTransaction[l].DT+`</td>
          <td>`+PartyTransaction[l].BL+`</td>
          <td>`+PartyTransaction[l].TYPE+`</td>
          <td>`+PartyTransaction[l].BA+`</td>
          <td>`+PartyTransaction[l].RGA+`</td>
          <td>`+PartyTransaction[l].AMT+`</td>
          <td>`+days +`</td>
          </tr>
          `;
        }
        var avgDays=parseInt(totalDays/totalsr);
        var returnPerformance = totalReturnsGoods/totalBamtTotal*100;
        var obj = {};
        obj.RFCODE = PartyNameList[k].RFCODE;
        obj.totalBamtTotal = totalBamtTotal;
        obj.totalReturnsGoods = totalReturnsGoods;
        obj.returnPerformance = returnPerformance;
        obj.totalPaidAmt=totalPaidAmt;
        obj.avgDays=avgDays;
        smArray.push(obj);
        tr +=`
        <tr class="tfootcard">
        <td>TOTAL</td>
        <td></td>
        <td></td>
        <td>`+totalBamtTotal+`</td>
        <td>`+totalReturnsGoods+`</td>
        <td>`+totalPaidAmt+`</td>
        <td>`+avgDays+`</td>
        </tr>
        `;

      }
      if (hideAbleTr == "true") {
        createABCummeryReport();
      }else{
        $('#result').html(tr);
        $("#loader").removeClass('has-loader');
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

function createABCummeryReport() {
  var smtr = `<thead>›
  <tr class="trPartyHead">
  <th class="trPartyHead">PARTY&nbsp;NAME <br><select id="partyNameOrder" onchange="getLEDGERSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
  <th class="hidePWSMDEBIT trPartyHead"    >TOTAL BILLAMT <br><select id="totalBamtTotal" onchange="getLEDGERSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
  <th class="hidePWSMreturnPerformance trPartyHead" >ADJ AMT <select id="returnPerformanceOrder" onchange="getLEDGERSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
  <th class="hidePWSMavgDays trPartyHead" >REC.IN.AVG.DAYS  <select id="avgDays" onchange="getLEDGERSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
   </tr>
  </thead>
  <tbody id="summery"></tbody>`;
  $('#result').html(smtr);
  $('#avgDays').val("ASC");
  tr = getLEDGERSummery();
}
function getLEDGERSummery() {
  try {
    
  $("#loader").addClass('has-loader');
  var partyNameOrder = $('#partyNameOrder').val();
  var totalBamtTotal = $('#totalBamtTotal').val();
  var CREDITOrder = $('#CREDITOrder').val();
  var returnPerformanceOrder = $('#returnPerformanceOrder').val();
  var avgDays = $('#avgDays').val();

  var ARR = smArray;
  if (partyNameOrder != null && partyNameOrder != "") {
    if (partyNameOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        if (a.code > b.code)
          return 1;
        if (a.code < b.code)
          return -1;
        return 0;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        if (a.code < b.code)
          return 1;
        if (a.code > b.code)
          return -1;
        return 0;
      });
    }
  }
  if (totalBamtTotal != null && totalBamtTotal != "") {
    if (totalBamtTotal == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.totalBamtTotal - b.totalBamtTotal;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.totalBamtTotal - a.totalBamtTotal;
      });
    }
  }
  if (CREDITOrder != null && CREDITOrder != "") {
    if (CREDITOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.totalCREDIT - b.totalCREDIT;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.totalCREDIT - a.totalCREDIT;
      });
    }
  }
  if (returnPerformanceOrder != null && returnPerformanceOrder != "") {
    if (returnPerformanceOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.returnPerformance - b.returnPerformance;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.returnPerformance - a.returnPerformance;
      });
    }
  } if (avgDays != null && avgDays != "") {
    if (avgDays == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.avgDays - b.avgDays;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.avgDays - a.avgDays;
      });
    }
  }
  var smTr = '';
  if (ARR.length > 0) {
    smTr += `
    `;
    var grandtotalBamtTotal = 0;
    var grandtotalCREDIT = 0;
    var grandtotalBALANCE = 0;
    for (let i = 0; i < ARR.length; i++) {
      const element = ARR[i];
      var idCode = stringHashCode(element.RFCODE);
      smTr += `
      <tr>
      <td style="text-align:left;" onclick="openSubR('` + element.RFCODE + `');">  ` + element.RFCODE + `</td>
      <td class="hidePWSMDEBIT" >`+ parseFloat(element.totalBamtTotal).toFixed(2) + `</td>
      <td class="hidePWSMCREDIT" >`+ parseFloat(element.totalPaidAmt).toFixed(2) + `</td>
      <td class="hidePWSMBALANCE" >`+(element.avgDays) + `</td>
      </tr>`;

      grandtotalBamtTotal += parseFloat(element.totalBamtTotal);
      grandtotalCREDIT += parseFloat(element.totalCREDIT);
      grandtotalBALANCE += parseFloat(element.totalBALANCE);
    }
    smTr += `
    <tr class="tfootcard">
    <th></th>
    <th style="text-align:left;">TOTAL</th>
    <th class="hidePWSMDEBIT" >`+ parseFloat(grandtotalBamtTotal).toFixed(2) + `</th>
    <th class="hidePWSMCREDIT" >`+ parseFloat(grandtotalCREDIT).toFixed(2) + `</th>
    <th class="hidePWSMBALANCE" >`+ parseFloat(grandtotalBALANCE).toFixed(2) + `</th>
    </tr>`;
  }
  $('#summery').html(smTr);
  $("#loader").removeClass('has-loader');
  $('#footerSummery').html(` <div style="width: 100%;display:inline;float: left;">
    <button class="btn btn-lg btn-block" style="background-color: #f08827;color: white;"
      onclick="sendToWhatsappOUTSTANDINGSummery();">CREATE PDF  & SHARE</button>
    </div>`);

  } catch (error) {
    noteError(error);
  }
  return smTr;
}
hideAbleTr


var newPartyListForPdf = [];
function sendToWhatsappOUTSTANDINGSummery() {
  newPartyListForPdf = [];
  $('input[type=checkbox]').each(function () {
    var id = $(this).attr('id');
    var obj = {};
    if (id && id.indexOf("selectFieldCode_") > -1) {
      if ($(this).is(':checked')) {
        var code = $(this).attr('code');
        obj.id = id;
        obj.code = code;
        var urlLink = window.location.href;
        // urlLink = SubPartylinkReplace(urlLink)
        // var partycode = encodeURIComponent(code);
        urlLink = urlLink + "&partyname=" + partycode + "&partycode=" + partycode + "&PDFStore=true";
        obj.urlLink = urlLink;
        newPartyListForPdf.push(obj);
      } else {
        newPartyListForPdf = newPartyListForPdf.filter(function (d) {
          return !(d.code == code);
        })
      }
    }
  });
  if (newPartyListForPdf.length == 0) {
    alert("Please select at least 1 party");
  } else {
    bulkPdfStartCreateShare(newPartyListForPdf);
  }
}

function checkAllEntryCode(ele) {
  var checkboxes = document.getElementsByTagName('input');
  if (ele.checked) {
    for (var i = 0; i < checkboxes.length; i++) {
      if (checkboxes[i].type == 'checkbox' && checkboxes[i].id.indexOf("selectFieldCode_") > -1) {
        checkboxes[i].checked = true;
      }
    }

    document.getElementById('footerSummery').style.display = "";
  } else {
    for (var i = 0; i < checkboxes.length; i++) {
      //  console.log(i)
      if (checkboxes[i].type == 'checkbox' && checkboxes[i].id.indexOf("selectFieldCode_") > -1) {
        checkboxes[i].checked = false;
      }
    }
  }
}
