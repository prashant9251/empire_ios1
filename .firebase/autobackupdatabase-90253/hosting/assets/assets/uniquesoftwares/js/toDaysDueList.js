
//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
var GRD;
function loadCall(data) {
  var tr = '';
  Data = data;
  var msg;
  var ccode;
  var pcode;
  var city;
  var broker;
  var label;
  var grandtotalNETBILLAMT;
  var grandtotalGROSSAMT;
  var grandtotalGOODSRETURN;
  var grandtotalPAIDAMT;
  var grandtotalAmount;
  var totalNETBILLAMT;
  var totalGROSSAMT;
  var totalGOODSRETURN;
  var totalPAIDAMT;
  var totalAmount;
  var totalGST;
  var BLL;
  var FdataUrl
  var DL = Data.length;
  if (DL > 0) {

    grandtotalNETBILLAMT = 0;
    grandtotalGROSSAMT = 0;
    grandtotalGOODSRETURN = 0;
    grandtotalPAIDAMT = 0;
    grandtotalAmount = 0;
    var toDayDate = formatDate(toDaysDate('-'));
    var sr = 0;
    tr += `<tbody>
      
      <tr>
      <th colspan="12" style="text-align:center;font-weight:bold;font-size: 20px;background-color: lightgray;">Today's Due List</th>
      
      </tr>

      <tr>
      <th class="trPartyHead">SR</th>
      <th class="trPartyHead" style="display:none;"> SELECT<input type="checkbox"  onchange="checkAllEntry(this);"/></th>
      <th class="trPartyHead">PARTY NAME</th>
      <th class="trPartyHead">CITY</th>
      <th class="trPartyHead">BROKER</th>
      <th class="trPartyHead">DUE AMOUNT</th>
      <th class="trPartyHead" style="display:none;"><img  src="whatsappIcon.png" width="40" height="40" /></th>
      <th class="trPartyHead">CONTACT</th>
      </tr>`;
    for (var i = 0; i < DL; i++) {
      totalNETBILLAMT = 0;
      totalGROSSAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;
      totalGST = 0;
      sr += 1;
      var id = Data[i].code.replaceAll(/[^\w\s]/gi, 'x');
      id = id.replaceAll(" ", "");
      ReminderArray = getReminders(Data[i].code);
      ReminderTime = "";

      if (ReminderArray.length > 0) {
        ReminderTime = ReminderArray[0].DateTime.replace(":00.000Z", "");
      }
      ccode = getPartyDetailsBySendCode(Data[i].code);
      // console.log(Data[i].code+"-",ccode)
      pcode = ccode[0].partyname;
      city = ccode[0].city;
      broker = ccode[0].broker;
      label = ccode[0].label;
      MO = ccode[0].MO;
      tr += `
        <tr style="font-weight:bold;">
                          <td colspan="1" >` + (sr) + ` </td>                       
                          <td style="text-align: center;display:none;">
                          <input type="checkbox" id="select_`+ id + `"  code="` + Data[i].code + `" onchange="check(this);"/></td>
                          <td colspan="1" onclick="openSubReportByUrl('` + Data[i].code + `','toDaysDueList.html','OUTSTANDING_AJXREPORT.html','SALE','1','S','','');"  >` + Data[i].code + `</td>                       
                          <td colspan="1" >` + getValueNotDefine(city) + `</td>                       
                          <td colspan="1" >` + getValueNotDefine(broker) + `</td>                       
                      
                        `;

      msg += "DEAR " + Data[i].code + "\n";
      BLL = Data[i].billDetails.length;
      if (BLL > 0) {
        for (j = 0; j < BLL; j++) {

          var GRSAMT = Data[i].billDetails[j].GRSAMT == null || Data[i].billDetails[j].GRSAMT == "" ? 0 : Data[i].billDetails[j].GRSAMT;
          var GST = Data[i].billDetails[j].GST == null || Data[i].billDetails[j].GST == "" ? 0 : Data[i].billDetails[j].GST;
          try {
            if (Data[i].billDetails[j].DT.trim() != "os") {
              GRSAMT = 0;
              GST = 0;
            }
          } catch (error) {

          }


          var FAMT = Data[i].billDetails[j].FAMT == null || Data[i].billDetails[j].FAMT == "" ? 0 : Data[i].billDetails[j].FAMT;
          var CLAIMS = Data[i].billDetails[j].CLAIMS == null || Data[i].billDetails[j].CLAIMS == "" ? 0 : Data[i].billDetails[j].CLAIMS;
          var RECAMT = Data[i].billDetails[j].RECAMT == null || Data[i].billDetails[j].RECAMT == "" ? 0 : Data[i].billDetails[j].RECAMT;
          var PAMT = Data[i].billDetails[j].PAMT == null || Data[i].billDetails[j].RECAMT == "" ? 0 : Data[i].billDetails[j].PAMT;
          totalGROSSAMT += parseFloat(getValueNotDefineNo(GRSAMT));
          totalGST += parseFloat(getValueNotDefineNo(GST));
          totalNETBILLAMT += parseFloat(getValueNotDefineNo(FAMT));
          totalGOODSRETURN += parseFloat(getValueNotDefineNo(CLAIMS));
          totalPAIDAMT += parseFloat(getValueNotDefineNo(RECAMT));
          totalAmount += parseFloat(getValueNotDefineNo(PAMT));
          var UrlPaymentSlip = getUrlPaymentSlip(Data[i].billDetails[j].CNO, (Data[i].billDetails[j].TYPE).replace("ZS", ""), Data[i].billDetails[j].VNO, (Data[i].billDetails[j].IDE).replace("ZS", ""));
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE);
          var urlopen = '';
          var TYPEforLink = (Data[i].billDetails[j].TYPE).toUpperCase();
          if (TYPEforLink.indexOf('B') > -1) {

            urlopen = UrlPaymentSlip;
          } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
            urlopen = FdataUrl;
          }
          var BrokerHaste = '';
          var HST = Data[i].billDetails[j].HST;
          if (HST != '' && HST != null && HST != undefined) {
            BrokerHaste = HST;
          } else {
            BrokerHaste = Data[i].billDetails[j].BCODE;
          }
          // tr += ` 

          //                     <tr class="hideAbleTr"align="center"style="">
          //                     <th><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
          //                     <td><a target="_blank" href="` + FdataUrl + `"><button>` + getValueNotDefine(Data[i].billDetails[j].BILL) + `</button></a></td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].FRM) + `</td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + formatDate(Data[i].billDetails[j].DATE) + `</td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(GRSAMT) + `</td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(GST) + `</td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(FAMT) + `</td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(CLAIMS) + `</td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(RECAMT) + `</td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(PAMT) + `</td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + getDaysDif(Data[i].billDetails[j].DATE, nowDate) + ` </td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
          //                         <td onclick="openSubR('`+ Data[i].code + `')"class="GRD">` + getValueNotDefine(Data[i].billDetails[j].GRD) + ` </td>

          //                     </tr>`;

          msg += "DOC: " + getValueNotDefine(Data[i].billDetails[j].BILL) + " DATE: " + formatDate(Data[i].billDetails[j].DATE) + " AMT:  " + getValueNotDefine(PAMT) + "\n\n";
        }
        grandtotalNETBILLAMT += totalNETBILLAMT;
        grandtotalGROSSAMT += totalGROSSAMT;
        grandtotalGOODSRETURN += totalGOODSRETURN;
        grandtotalPAIDAMT += totalPAIDAMT;
        grandtotalAmount += totalAmount;
        msg += ` IS DUE     \n
          TOTAL PENDING AMT : `+ valuetoFixed(totalAmount) + `\n\n\n`;
        msg = "Hello Sir";
        // MO="8469190530";
        var sendingOptionClick = `<img  src="whatsappIcon.png" width="40" height="40" onclick="openSubReportByUrl('` + Data[i].code + `','toDaysDueList.html','OUTSTANDING_AJXREPORT.html','SALE','1','S','','true');"/>`;
        ContectOptionClick = `<button class="btn btn-secondary btn btn-block"  onclick="sendingOptionClick('` + Data[i].code + `','` + MO + `','` + encodeURIComponent(msg) + `');"style="color:white;">` + MO + `</button>`;
        if (MO == "" || MO == null) {
          ContectOptionClick = ``;
        }
        tr += `
                <td>` + valuetoFixed(totalAmount) + `</td>
                <td colspan="1" style="display:none;" >`+ sendingOptionClick + `</td>                       
                <td colspan="1" ><a>`+ ContectOptionClick + `</a></td>    
                </tr>`;
        msg = "";
        // console.log(msg);
      }

    }
    tr += `<tr class="tfootcard" style="color:#c107a2;font-size: 18px;" >
    <td  colspan="5">GRAND TOTAL</td>
    <td>` + valuetoFixed(grandtotalAmount) + `</td>
    <td colspan="3"></td>
    </tr>`;

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    if (GRD == '' || GRD == null) {
      $('.GRD').css("display", "none");
    }
    var hideAbleTr = getUrlParams(url, "hideAbleTr");
    if (hideAbleTr == "true") {
      $('.hideAbleTr').css("display", "none");
    }


    var PDFStore = getUrlParams(url, "PDFStore");
    if (PDFStore == "true") {
      alert("PDFStore=true");
    }

    var PDFStorePermission = getUrlParams(url, "PDFStorePermission");
    if (PDFStorePermission == "true") {
      UrlSendToAndroid(Data);
    }
    document.title = " Todays due list";
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }

  try {
  } catch (e) {
    $('#result').html(tr);
    $('#result').prepend(e);
    $("#loader").removeClass('has-loader');
  }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

// $('.footer').css("display", "none");
document.getElementById('footer').style.display = "none";


var newPartyListForPdf = [];
function sendToWhatsapp() {
  newPartyListForPdf = [];


  $('input[type=checkbox]').each(function () {
    var id = $(this).attr('id');
    var code = $(this).attr('code');
    var obj = {};
    if ($(this).is(':checked')) {
      obj.id = id;
      obj.code = code;
      console.log(obj);
      newPartyListForPdf.push(obj);
    } else {
      newPartyListForPdf = newPartyListForPdf.filter(function (d) {
        return !(d.code == code);
      })
    }
  });

  if (newPartyListForPdf.length > 0) {
    document.getElementById('footer').style.display = "";
  } else {
    document.getElementById('footer').style.display = "none";
  }
  console.log(newPartyListForPdf);
  UrlSendToAndroidFromTodaysDueList(newPartyListForPdf);
}

function checkAllEntry(ele) {
  var checkboxes = document.getElementsByTagName('input');
  if (ele.checked) {
    for (var i = 0; i < checkboxes.length; i++) {
      if (checkboxes[i].type == 'checkbox') {
        checkboxes[i].checked = true;
      }
    }
    
  document.getElementById('footer').style.display = "";
  } else {
    for (var i = 0; i < checkboxes.length; i++) {
      //  console.log(i)
      if (checkboxes[i].type == 'checkbox') {
        checkboxes[i].checked = false;
      }
    }    
  }
}

function check(ele){
  var checkboxes = document.getElementsByTagName('input');
  if (ele.checked) {
    
  document.getElementById('footer').style.display = "";
  } else {

  }
}