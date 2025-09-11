

function createLEDGERSummeryReport(){
  var smtr = `<thead>›
  <tr class="trPartyHead">
  <th>SELECT&nbsp;ALL<input type="checkbox" style="margin:20px;" onchange="checkAllEntryCode(this);"/></th>
  <th class="trPartyHead">PARTY&nbsp;NAME <br><select id="partyNameOrder" onchange="getLEDGERSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
  <th class="hidePWSMDEBIT trPartyHead"    >TOTAL DEBIT <br><select id="DEBITCountOrder" onchange="getLEDGERSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
  <th class="hidePWSMCREDIT trPartyHead"   >TOTAL CREDIT <br><select id="CREDITOrder" onchange="getLEDGERSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
  <th class="hidePWSMBALANCE trPartyHead" >BALANCE<select id="BALANCEOrder" onchange="getLEDGERSummery();"><option></option><option>ASC</option><option>DSC</option></select></th>
   </tr>
  </thead>
  <tbody id="summery"></tbody>`;
  $('#result').html(smtr);
  tr = getLEDGERSummery();
}



function getLEDGERSummery(){
  $("#loader").addClass('has-loader');
  var partyNameOrder=$('#partyNameOrder').val();
  var DEBITCountOrder=$('#DEBITCountOrder').val();
  var CREDITOrder=$('#CREDITOrder').val();
  var BALANCEOrder=$('#BALANCEOrder').val();
  
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
  if(DEBITCountOrder!=null && DEBITCountOrder !=""){
    if(DEBITCountOrder=="ASC"){
      ARR = smArray.sort(function(a,b){
          return a.totalDEBIT-b.totalDEBIT;
      });
    }else{
      ARR = smArray.sort(function(a,b){
        return b.totalDEBIT-a.totalDEBIT;
      });
    }
  }
  if(CREDITOrder!=null && CREDITOrder !=""){
    if(CREDITOrder=="ASC"){
      ARR = smArray.sort(function(a,b){
          return a.totalCREDIT-b.totalCREDIT;
      });
    }else{
      ARR = smArray.sort(function(a,b){
        return b.totalCREDIT-a.totalCREDIT;
      });
    }
  }
  if(BALANCEOrder!=null && BALANCEOrder !=""){
    if(BALANCEOrder=="ASC"){
      ARR = smArray.sort(function(a,b){
          return a.totalBALANCE-b.totalBALANCE;
      });
    }else{
      ARR = smArray.sort(function(a,b){
        return b.totalBALANCE-a.totalBALANCE;
      });
    }
  }
  var smTr ='';
  if(ARR.length>0){
     smTr +=`
    `;
    var grandtotalDEBIT = 0;
    var grandtotalCREDIT = 0;
    var grandtotalBALANCE = 0;
    for (let i = 0; i < ARR.length; i++) {
      const element = ARR[i];
      var idCode = stringHashCode(element.code);
      smTr+=`
      <tr>
      <td><input type="checkbox" style="margin:10px;" id="selectFieldCode_`+  idCode + `" code="` +  element.code + `"/></td>
      <td style="text-align:left;" onclick="openSubR('`+ element.code + `')">  `+element.code+`</td>
      <td class="hidePWSMDEBIT" >`+ parseFloat(element.totalDEBIT).toFixed(2) + `</td>
      <td class="hidePWSMCREDIT" >`+ parseFloat(element.totalCREDIT).toFixed(2) + `</td>
      <td class="hidePWSMBALANCE" >`+ valuetoFixed(element.totalBALANCE) + `</td>
      </tr>`;

    grandtotalDEBIT += parseFloat(element.totalDEBIT);
    grandtotalCREDIT += parseFloat(element.totalCREDIT);
    grandtotalBALANCE += parseFloat(element.totalBALANCE);
    }
    smTr+=`
    <tr class="tfootcard">
    <th></th>
    <th style="text-align:left;">TOTAL</th>
    <th class="hidePWSMDEBIT" >`+ parseFloat(grandtotalDEBIT).toFixed(2) + `</th>
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
  return smTr;
}
var newPartyListForPdf = [];
function sendToWhatsappOUTSTANDINGSummery() {
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
