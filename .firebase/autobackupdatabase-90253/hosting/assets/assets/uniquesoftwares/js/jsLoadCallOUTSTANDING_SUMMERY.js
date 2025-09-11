

function createOUTSTANDINGSummeryReport() {
  var smtr = `<thead>›
  <tr class="trPartyHead">
  <th>SELECT&nbsp;ALL<input type="checkbox" style="margin:20px;" onchange="checkAllEntryCode(this);"/></th>
  <th class="hidePWSMATYPE_NAME">ACCOUNT&nbsp;TYPE</th>
  <th class="trPartyHead">PARTY&nbsp;NAME <br><select id="partyNameOrder" onchange="getOUTSTANDINGSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
  <th class="hidePWSMGROSSAMT trPartyHead"   style="display:none;" >GROSSAMT <select id="GROSSAMTCountOrder" onchange="getOUTSTANDINGSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
  <th class="hidePWSMGST trPartyHead"   style="display:none;">GST <select id="GSTOrder" onchange="getOUTSTANDINGSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
  <th class="hidePWSMNETBILLAMT trPartyHead" style="display:none;">NET.BILL.AMT <select id="NETBILLAMTOrder" onchange="getOUTSTANDINGSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
  <th class="hidePWSMGOODSRETURN trPartyHead" style="display:none;">GOODS.RETURN <select id="GOODSRETURNOrder" onchange="getOUTSTANDINGSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
  <th class="hidePWSMPAIDAMT trPartyHead" style="display:none;">PAID.AMT <select id="PAIDAMTOrder" onchange="getOUTSTANDINGSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
  <th class="hidePWSMPENDAMT trPartyHead">PEND.AMT <select id="PENDAMTOrder" onchange="getOUTSTANDINGSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
  </tr>
  </thead>
  <tbody id="summery"></tbody>`;
  $('#result').html(smtr);
  tr = getOUTSTANDINGSummery();
}


var finalARR=[];
function getOUTSTANDINGSummery() {
  $("#loader").addClass('has-loader');
  var partyNameOrder = $('#partyNameOrder').val();
  var GROSSAMTCountOrder = $('#GROSSAMTCountOrder').val();
  var GSTOrder = $('#GSTOrder').val();
  var NETBILLAMTOrder = $('#NETBILLAMTOrder').val();
  var GOODSRETURNOrder = $('#GOODSRETURNOrder').val();
  var PAIDAMTOrder = $('#PAIDAMTOrder').val();
  var PENDAMTOrder = $('#PENDAMTOrder').val();

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
  if (GROSSAMTCountOrder != null && GROSSAMTCountOrder != "") {
    if (GROSSAMTCountOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.totalGROSSAMT - b.totalGROSSAMT;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.totalGROSSAMT - a.totalGROSSAMT;
      });
    }
  }
  if (GSTOrder != null && GSTOrder != "") {
    if (GSTOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.totalGST - b.totalGST;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.totalGST - a.totalGST;
      });
    }
  }
  if (NETBILLAMTOrder != null && NETBILLAMTOrder != "") {
    if (NETBILLAMTOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.totalNETBILLAMT - b.totalNETBILLAMT;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.totalNETBILLAMT - a.totalNETBILLAMT;
      });
    }
  }
  if (GOODSRETURNOrder != null && GOODSRETURNOrder != "") {
    if (GOODSRETURNOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.totalGOODSRETURN - b.totalGOODSRETURN;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.totalGOODSRETURN - a.totalGOODSRETURN;
      });
    }
  }

  if (PAIDAMTOrder != null && PAIDAMTOrder != "") {
    if (PAIDAMTOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.totalPAIDAMT - b.totalPAIDAMT;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.totalPAIDAMT - a.totalPAIDAMT;
      });
    }
  }
  if (PENDAMTOrder != null && PENDAMTOrder != "") {
    if (PENDAMTOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.totalAmount - b.totalAmount;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.totalAmount - a.totalAmount;
      });
    }
  }
  var smTr = '';
  var brokerList=[];
  var brokerFlg=[];
  for (let id = 0; id < ARR.length; id++) {
    var element = ARR[id];
    var ccode=element.ccode;
    if (ccode.length > 0) {
      broker = ccode[0].broker;
      if(!brokerFlg[broker]){
        brokerList.push(broker);
        brokerFlg[broker]=true;
      }
      element.broker=broker;
    }
  }
finalARR = ARR;

  if (ARR.length > 0) {
    smTr += `
    `;
    var grandtotalGROSSAMT = 0;
    var grandtotalGST = 0;
    var grandtotalNETBILLAMT = 0;
    var grandtotalGOODSRETURN = 0;
    var grandtotalPAIDAMT = 0;
    var grandtotalAmount = 0;
    for (let b = 0; b < brokerList.length; b++) {
      const broker = brokerList[b];
      smTr += `
      <tr class="pinkHeading">
      <td colspan="15">`+ (broker) + `</td>
      </tr>`;
      var partyArr = brokerPartyData(broker);
      for (let i = 0; i < partyArr.length; i++) {
        const element = partyArr[i];
        var idCode = stringHashCode(element.code);
        smTr += `
        <tr>
        <td><input type="checkbox" style="margin:10px;" id="selectFieldCode_`+ idCode + `" code="` + element.code + `"/></td>
        <td class="hidePWSMATYPE_NAME">`+ (element.ATYPE_NAME) + `</td>
        <td style="text-align:left;" onclick="openSubR('`+ element.code + `')">  ` + element.code + `</td>
        <td class="hidePWSMGROSSAMT" style="display:none;">`+ parseFloat(element.totalGROSSAMT).toFixed(2) + `</td>
        <td class="hidePWSMGST" style="display:none;">`+ parseFloat(element.totalGST).toFixed(2) + `</td>
        <td class="hidePWSMNETBILLAMT" style="display:none;">`+ valuetoFixed(element.totalNETBILLAMT) + `</td>
        <td class="hidePWSMGOODSRETURN" style="display:none;">`+ valuetoFixed(element.totalGOODSRETURN) + `</td>
        <td class="hidePWSMPAIDAMT" style="display:none;">`+ valuetoFixed(element.totalPAIDAMT) + `</td>
        <td class="hidePWSMPENDAMT">`+ valuetoFixed(element.totalAmount) + `</td>
        </tr>`;
  
        grandtotalGROSSAMT += parseFloat(element.totalGROSSAMT);
        grandtotalGST += parseFloat(element.totalGST);
        grandtotalNETBILLAMT += parseFloat(element.totalNETBILLAMT);
        grandtotalGOODSRETURN += parseFloat(element.totalGOODSRETURN);
        grandtotalPAIDAMT += parseFloat(element.totalPAIDAMT);
        grandtotalAmount += parseFloat(element.totalAmount);
      }
    }
    
    smTr += `
    <tr class="tfootcard">
    <th></th>
    <td class="hidePWSMATYPE_NAME"></td>
    <th style="text-align:left;">TOTAL</th>
    <th class="hidePWSMGROSSAMT" style="display:none;">`+ parseFloat(grandtotalGROSSAMT).toFixed(2) + `</th>
    <th class="hidePWSMGST" style="display:none;">`+ parseFloat(grandtotalGST).toFixed(2) + `</th>
    <th class="hidePWSMNETBILLAMT" style="display:none;">`+ parseFloat(grandtotalNETBILLAMT).toFixed(2) + `</th>
    <th class="hidePWSMGOODSRETURN" style="display:none;">`+ parseFloat(grandtotalGOODSRETURN).toFixed(2) + `</th>
    <th class="hidePWSMPAIDAMT" style="display:none;">`+ parseFloat(grandtotalPAIDAMT).toFixed(2) + `</th>
    <th class="hidePWSMPENDAMT">`+ parseFloat(grandtotalAmount).toFixed(2) + `</th>
    </tr>`;
  }
  $('#summery').html(smTr);
  $("#loader").removeClass('has-loader');
  $('#footerSummery').html(` <div style="width: 100%;display:inline;float: left;">
    <button class="btn btn-lg btn-block" style="background-color: #f08827;color: white;"
      onclick="sendToWhatsappOUTSTANDINGSummery();">CREATE PDF  & SHARE</button>
    </div>`);
  return smTr;
}
var newPartyListForPdf = [];
function sendToWhatsappOUTSTANDINGSummery() {
  newPartyListForPdf = [];
  $('input[type=checkbox]').each(function () {
    var id = $(this).attr('id');
    var obj = {};
    if (id && id.indexOf("selectFieldCode_") > -1) {
      if ($(this).is(':checked')) {
        var code = $(this).attr('code');
        var ccode = getPartyDetailsBySendCode(code);
        obj.ccode = ccode.length > 0 ? ccode[0] : {};
        obj.id = id;
        obj.code = code;
        var urlLink = window.location.href;
        urlLink = SubPartylinkReplace(urlLink)
        var partycode = encodeURIComponent(code);
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


function brokerPartyData(broker){
  return finalARR.filter(function(d){
      return d.broker==broker;
  });
}