

function createBLSSummeryReport(){
  var smtr = `<thead>›
  <tr class="trPartyHead">
  <th>SELECT&nbsp;ALL<input type="checkbox" style="margin:20px;" onchange="checkAllEntryCode(this);"/></th>
  <th class="trPartyHead">PARTY&nbsp;NAME<br> <select id="partyNameOrder" onchange="getBLSSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
  <th class="hidePWSMPARCEL trPartyHead" >BILLCOUNT <select id="parcelCountOrder" onchange="getBLSSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
  <th class="hidePWSMMTS trPartyHead">MTS <select id="mtsOrder" onchange="getBLSSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
  <th class="hidePWSMAMOUNT trPartyHead">AMOUNT <select id="amountOrder" onchange="getBLSSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
  </tr>
  </thead>
  <tbody id="summery"></tbody>`;
  $('#result').html(smtr);
  tr = getBLSSummery();
}



function getBLSSummery(){
  $("#loader").addClass('has-loader');
  var partyNameOrder=$('#partyNameOrder').val();
  var parcelCountOrder=$('#parcelCountOrder').val();
  var mtsOrder=$('#mtsOrder').val();
  var amountOrder=$('#amountOrder').val();
  
  var ARR=smArray;
  if(partyNameOrder!=null && partyNameOrder !=""){
    if(partyNameOrder=="ASC"){
      ARR = smArray.sort(function(a,b){
        if (a.code > b.code)
            return 1;
          if (a.code < b.code)
            return -1;
          return 0;
      });
    }else{
      ARR = smArray.sort(function(a,b){
        if (a.code < b.code)
            return 1;
          if (a.code > b.code)
            return -1;
          return 0;
      });
    }
  }
  if(parcelCountOrder!=null && parcelCountOrder !=""){
    if(parcelCountOrder=="ASC"){
      ARR = smArray.sort(function(a,b){
          return a.sr-b.sr;
      });
    }else{
      ARR = smArray.sort(function(a,b){
        return b.sr-a.sr;
      });
    }
  }
  if(mtsOrder!=null && mtsOrder !=""){
    if(mtsOrder=="ASC"){
      ARR = smArray.sort(function(a,b){
          return a.totalMTS-b.totalMTS;
      });
    }else{
      ARR = smArray.sort(function(a,b){
        return b.totalMTS-a.totalMTS;
      });
    }
  }
  if(amountOrder!=null && amountOrder !=""){
    if(amountOrder=="ASC"){
      ARR = smArray.sort(function(a,b){
          return a.totalFinalAmt-b.totalFinalAmt;
      });
    }else{
      ARR = smArray.sort(function(a,b){
        return b.totalFinalAmt-a.totalFinalAmt;
      });
    }
  }
  console.log(ARR);
  var smTr ='';
  if(ARR.length>0){
     smTr +=`
    `;
    var totalsr=0;
    var grandtotalMTS=0;
    var grandTotalfinalAmt = 0;
    for (let i = 0; i < ARR.length; i++) {
      const element = ARR[i];
      var idCode = stringHashCode(element.code);
      smTr+=`
      <tr>
      <td><input type="checkbox" style="margin:10px;" id="selectFieldCode_`+  idCode + `" code="` +  element.code + `"/></td>
      <td style="text-align:left;" onclick="openSubR('`+ element.code + `')">  `+element.code+`</td>
      <td class="hidePWSMPARCEL">`+ (element.sr) + `</td>
      <td class="hidePWSMMTS">`+ parseFloat(element.totalMTS).toFixed(2) + `</td>
      <td class="hidePWSMAMOUNT">`+ valuetoFixed(element.totalFinalAmt) + `</td>
      </tr>`;
      totalsr +=parseInt(element.sr);
      grandtotalMTS +=parseFloat(element.totalMTS);
      grandTotalfinalAmt  += parseFloat(element.totalFinalAmt);
    }
    smTr+=`
    <tr class="tfootcard">
    <th></th>
    <th style="text-align:left;">TOTAL</th>
    <th class="hidePWSMPARCEL">`+ (totalsr) + `</th>
    <th class="hidePWSMMTS">`+ parseFloat(grandtotalMTS).toFixed(2) + `</th>
    <th class="hidePWSMAMOUNT">`+ parseFloat(grandTotalfinalAmt).toFixed(2) + `</th>
    </tr>`;
  }
  $('#summery').html(smTr);
  $("#loader").removeClass('has-loader');
  $('#footerSummery').html(` <div style="width: 100%;display:inline;float: left;">
    <button class="btn btn-lg btn-block" style="background-color: #f08827;color: white;"
      onclick="sendToWhatsappBLSSummery();">CREATE PDF  & SHARE</button>
    </div>`);
  return smTr;
}
var newPartyListForPdf = [];
function sendToWhatsappBLSSummery() {
  newPartyListForPdf = [];
  $('input[type=checkbox]').each(function () {
    var id = $(this).attr('id');
    var obj = {};
    if(id && id.indexOf("selectFieldCode_")>-1){
      if ($(this).is(':checked')) {
        var code = $(this).attr('code');
        var ccode = getPartyDetailsBySendCode(code);
        obj.ccode = ccode.length > 0 ? ccode[0] : {};
        obj.id = id;
        obj.code = code;
        var urlLink = window.location.href;        
        urlLink = SubPartylinkReplace(urlLink)
        var partycode = encodeURIComponent(code);
        urlLink = urlLink + "&partyname=" + partycode + "&partycode=" + partycode +"&PDFStore=true";
        obj.urlLink=urlLink;
        newPartyListForPdf.push(obj);
    } else {
      newPartyListForPdf = newPartyListForPdf.filter(function (d) {
        return !(d.code == code);
      })
    }
  }
  });
  if (newPartyListForPdf.length == 0)  {
    alert("Please select at least 1 party");
  }else{
    bulkPdfStartCreateShare(newPartyListForPdf);
  }
}

function checkAllEntryCode(ele) {
  var checkboxes = document.getElementsByTagName('input');
  if (ele.checked) {
    for (var i = 0; i < checkboxes.length; i++) {
      if (checkboxes[i].type == 'checkbox' && checkboxes[i].id.indexOf("selectFieldCode_")>-1) {
        checkboxes[i].checked = true;
      }
    }
    
  document.getElementById('footerSummery').style.display = "";
  } else {
    for (var i = 0; i < checkboxes.length; i++) {
      //  console.log(i)
      if (checkboxes[i].type == 'checkbox' && checkboxes[i].id.indexOf("selectFieldCode_")>-1) {
        checkboxes[i].checked = false;
      }
    }    
  }
}
