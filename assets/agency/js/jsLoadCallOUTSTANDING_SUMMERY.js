

function createOUTSTANDINGSummeryReport() {
  var smtr = `<thead>
  <tr>
  <th class="" colspan="3" style="text-align: center; font-size: 20px;">
   PARTY WISE SUPPLIER WISE SUMMERY
  </th>
  </tr>
  <tr class="trPartyHead">
  <th class="hidePWSMCUSTOMER">CUSTOMER</th>
  <th class="hidePWSMPENDAMT">PEND.AMT </th>
  </tr>
  </thead>
  <tbody id="summery"></tbody>`;
  $('#result').html(smtr);
  tr = getOUTSTANDINGSummery();
}


var finalARR = [];
function getSUPP_WISE_PARTY_WISE_OUTSTANDINGSummery() {
  $("#loader").addClass('has-loader');
  var ARR = smArray;
  var smTr = '';
  finalARR = ARR;
  if (ARR.length > 0) {
    var totalPendingAmt = 0;
    for (let b = 0; b < ARR.length; b++) {
      const element = ARR[b];
      if (element.ccode.length > 0) {
        pcode = getValueNotDefine(element.ccode[0].partyname);
        city = getValueNotDefine(element.ccode[0].city);
        broker = getValueNotDefine(element.ccode[0].broker);
        label = getValueNotDefine(element.ccode[0].label);
        MO = getValueNotDefine(element.ccode[0].MO);
      }
      smTr += `
      <tr class="pinkHeading">
      <td colspan="2">`+ (pcode) + `</td>
      </tr>
      <tr>
      <td style="font-size:20px;">`+ element.ccd + `</td>
      <td style="font-size:20px;" class="alignRight">`+ element.totalAmount + `/-</td>
      </tr>
      `;
      totalPendingAmt += parseFloat(element.totalAmount);

    }
    smTr += `
    <tr class="pinkHeading">
    <td style="font-size:20px;" colspan="1">TOTAL</td>
    <td style="font-size:20px;" class="alignRight">`+ totalPendingAmt + `/-</td>
    </tr>
    `;
    $('#summery').html(smTr);
  }
  $("#loader").removeClass('has-loader');
  return smTr;
}
function getOUTSTANDINGSummery() {
  $("#loader").addClass('has-loader');


  var ARR = smArray;

  var smTr = '';

  finalARR = ARR;

  if (ARR.length > 0) {
    var totalPendingAmt = 0;
    for (let b = 0; b < ARR.length; b++) {
      const element = ARR[b];
      if (element.ccode.length > 0) {
        pcode = getValueNotDefine(element.ccode[0].partyname);
        city = getValueNotDefine(element.ccode[0].city);
        broker = getValueNotDefine(element.ccode[0].broker);
        label = getValueNotDefine(element.ccode[0].label);
        MO = getValueNotDefine(element.ccode[0].MO);
      }
      smTr += `
      <tr class="pinkHeading">
      <td colspan="2">`+ (pcode) + `</td>
      </tr>
      <tr>
      <td style="font-size:20px;">`+ element.ccd + `</td>
      <td style="font-size:20px;" class="alignRight">`+ element.totalAmount + `/-</td>
      </tr>
      `;
      totalPendingAmt += parseFloat(element.totalAmount);
    }
    smTr += `
    <tr class="pinkHeading">
    <td style="font-size:20px;" colspan="1">TOTAL</td>
    <td style="font-size:20px;" class="alignRight">`+ totalPendingAmt + `/-</td>
    </tr>
    `;

  }
  $('#summery').html(smTr);
  $("#loader").removeClass('has-loader');
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


function brokerPartyData(broker) {
  return finalARR.filter(function (d) {
    return d.broker == broker;
  });
}