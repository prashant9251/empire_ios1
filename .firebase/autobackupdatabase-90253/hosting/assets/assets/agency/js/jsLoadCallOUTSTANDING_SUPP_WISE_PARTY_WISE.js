

//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
var MainArr = [];
function filterBy(oncode, value) {
  return MainArr.filter(function (d) {
    return d[oncode] == value;
  });
}
const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];
var GRD;


function getCustomerListBySupp(ccd) {
  return supplier_party_nameList.filter(function (d) {
    return d.ccd == ccd;
  })
}

function getDataCustomerSupplier(COD, ccd) {
  return MainArr.filter(function (d) {
    return d.COD == COD && d.ccd == ccd;
  })
}
var SupplierList = [];
var supplier_party_nameList = [];
function loadCall(data) {
  var FlgSupplierList = [];
  var flg_supplier_party_nameList = [];
  Data = data;
  var ccode;
  var pcode;
  var city;
  var broker;
  var label;
  var grandtotalNETBILLAMT = 0;
  var grandtotalGROSSAMT = 0;
  var grandtotalGOODSRETURN = 0;
  var grandtotalPAIDAMT = 0;
  var grandtotalAmount = 0;
  var totalNETBILLAMT = 0;
  var totalGROSSAMT = 0;
  var totalGOODSRETURN = 0;
  var totalPAIDAMT = 0;
  var totalAmount = 0;
  var subtotalNETBILLAMT = 0;
  var subtotalGROSSAMT = 0;
  var subtotalGOODSRETURN = 0;
  var subtotalPAIDAMT = 0;
  var subtotalAmount = 0;
  var BLL;
  var FdataUrl
  var DL = Data.length;
  tr = "<tbody>";

  var DtArray = [];
  for (i = 0; i < Data.length; i++) {
    if (Data[i].billDetails.length > 0) {
      for (j = 0; j < Data[i].billDetails.length; j++) {
        var obj = {};
        obj.COD = Data[i].COD;
        obj.ATP = Data[i].ATP;
        obj.CT = Data[i].CT;
        obj.CNO = Data[i].billDetails[j].CNO;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.VNO = Data[i].billDetails[j].VNO;
        obj.IDE = Data[i].billDetails[j].IDE;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.ccd = Data[i].billDetails[j].ccd;
        obj.BCD = Data[i].billDetails[j].BCD;
        obj.BAMT = Data[i].billDetails[j].BAMT;
        obj.FAMT = Data[i].billDetails[j].FAMT;
        obj.CLM = Data[i].billDetails[j].CLM;
        obj.RAMT = Data[i].billDetails[j].RAMT;
        obj.PAMT = Data[i].billDetails[j].PAMT;
        obj.BLL = Data[i].billDetails[j].BLL;
        obj.DTE = Data[i].billDetails[j].DTE;
        obj.TR = Data[i].billDetails[j].TR;
        obj.LR = Data[i].billDetails[j].LR;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.DTE = Data[i].billDetails[j].DTE;
        obj.SG = Data[i].billDetails[j].SG;
        obj.DR = Data[i].billDetails[j].DR;
        obj.DA = Data[i].billDetails[j].DA;
        var monthName = "";

        if (!FlgSupplierList[Data[i].billDetails[j].ccd]) {
          var Nobj = {}
          Nobj.ccd = Data[i].billDetails[j].ccd;
          SupplierList.push(Nobj);
          FlgSupplierList[Data[i].billDetails[j].ccd] = true;
        }
        if (!flg_supplier_party_nameList[Data[i].COD + Data[i].billDetails[j].ccd]) {
          var Nobj = {}
          Nobj.ccd = Data[i].billDetails[j].ccd;
          Nobj.COD = Data[i].COD;
          supplier_party_nameList.push(Nobj);
          flg_supplier_party_nameList[Data[i].COD + Data[i].billDetails[j].ccd] = true;
        }
        MainArr.push(obj);



      }
    }
  }

  console.log(supplier_party_nameList);
  SupplierList = SupplierList.sort(function (a, b) {
    return a.ccd < b.ccd ? -1 : 1;
  })
  console.log(SupplierList);
  if (SupplierList.length > 0) {
    for (let i = 0; i < SupplierList.length; i++) {
      const ccd = SupplierList[i];

      ccode = getPartyDetailsBySendName(ccd.ccd);
      if (ccode.length > 0) {
        pcode = getValueNotDefine(ccode[0].partyname);
        city = getValueNotDefine(ccode[0].city);
        broker = getValueNotDefine(ccode[0].broker);
        label = getValueNotDefine(ccode[0].label);
        MO = getValueNotDefine(ccode[0].MO);
      }
      var trRow = `<tr class="trPartyHead">
                        <th colspan="16" class="trPartyHead">` + label + `<a href="tel:` + MO + `"><button>MO:` + getValueNotDefine(MO) + `</button></a></th>
                      </tr>
                      `;

      var customerList = getCustomerListBySupp(ccd.ccd);
      // console.log(customerList);
      for (let m = 0; m < customerList.length; m++) {
        const customer = customerList[m];
        var supcode = getPartyDetailsBySendCode(customer.COD);
        var suppcode = "";
        var supcity = "";
        var supbroker = "";
        var suplabel = "";
        var supMO = "";
        if (supcode.length > 0) {
          suppcode = getValueNotDefine(supcode[0].partyname);
          supcity = getValueNotDefine(supcode[0].city);
          supbroker = getValueNotDefine(supcode[0].broker);
          suplabel = getValueNotDefine(supcode[0].label);
          supMO = getValueNotDefine(supcode[0].MO);
        }
        // <tr >
        // <th colspan="16"class="hideCUSTOMER_NAME" style="display:none;font-weight:bolder;font-size:20px;background-color:#f3f3f3;color:#c107a2;text-align:left;" onclick="openSubR('`+ customer.COD + `','` + ccd.ccd + `')">` + suplabel + `<a href="tel:` + supMO + `"></th>
        //   </tr>
        trRow += `
          <tr style="font-weight:bold;"align="center">                    
          <th >BILL</th>
          <th >DATE</th>
          <th class="hideSWPWCUST">CUST.</th>
          <th class="hideSWPWFRM" style="display:none;">FIRM</th>
          <th class="hideSWPWGROSSAMT">GROSS <br>AMT</th>
          <th class="hideSWPWTYPE" style="display:none;">TYPE</th>
          <th class="hideSWPWNETBILLAMT">NET AMT</th>
          <th class="hideSWPWGOODSRET">GOODS<br>RET.</th>
          <th class="hideSWPWPAID">PAID <BR> AMT</th>
          <th class="hideSWPWPEND">PEND<br>AMT.</th>
          <th class="hideSWPWDIS" style="display:none;">DIS%</th>
          <th class="hideSWPWDISAMT" style="display:none;">DISAMT</th>
          <th class="hideSWPWGROUP">GROUP</th>
          <th class="hideSWPWBROKER"style="display:none;">BROKER</th>
          <th class="hideSWPWDAYS">DAYS</th>
          <th class="hideSWPWTRANSPORT">TRANSPORT</th>
          <th class="hideSWPWLR">LR NO</th>
          <th class="hideSWPWVNO">VNO</th>
          </tr> 
          `;

        var DataCustomerSupplier = getDataCustomerSupplier(customer.COD, ccd.ccd);
        // console.log(DataCustomerSupplier);

        for (let n = 0; n < DataCustomerSupplier.length; n++) {
          const element = DataCustomerSupplier[n];
          var transport = (element.TR);

          var UrlPaymentSlip = getUrlPaymentSlip(element.CNO, (element.TYPE).replace("ZS", ""), element.VNO, (element.IDE).replace("ZS", ""));
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(element.CNO, element.TYPE, element.VNO, getFirmDetailsBySendCode(element.CNO)[0].FIRM, element.IDE);
          var urlopen = '';
          var TYPEforLink = (element.TYPE).toUpperCase();
          if (TYPEforLink.indexOf('B') > -1) {

            urlopen = UrlPaymentSlip;
          } else if (TYPEforLink.indexOf('S') > -1 || TYPEforLink.indexOf('P') > -1) {
            urlopen = FdataUrl;
          }
          var BAMT = 0;
          var FAMT = 0;
          var CLM = 0;
          var RAMT = 0;
          var PAMT = 0;
          BAMT = parseInt((element.BAMT == null) ? 0 : element.BAMT);
          FAMT = parseInt((element.FAMT == null) ? 0 : element.FAMT);
          CLM = parseInt((element.CLM == null) ? 0 : element.CLM);
          RAMT = parseInt((element.RAMT == null) ? 0 : element.RAMT);
          PAMT = parseInt((element.PAMT == null) ? 0 : element.PAMT);
          subtotalGROSSAMT += (BAMT);
          subtotalNETBILLAMT += (FAMT);
          subtotalGOODSRETURN += (CLM);
          subtotalPAIDAMT += (RAMT);
          subtotalAmount += (PAMT);
          var BCD = "";
          var BrokerArr = getPartyDetailsBySendCode(element.BCD);
          if (BrokerArr.length > 0) {
            BCD = getValueNotDefine(BrokerArr[0].partyname);
          }
          trRow += ` 
                   <tr align="center"style="">
                   <td><a href="`+ FdataUrl + `" target="_blank"><button class="PrintBtnHide">` + element.BLL + `</button></a></td>
                   <td onclick="openSubR('','` + ccd.ccd + `')">` + formatDate(element.DTE) + `</td>
                                  <td class="hideSWPWCUST" onclick="openSubR('','` + ccd.ccd + `')">` + (suppcode) + `</td>
                                  <td class="hideSWPWFRM" style="display:none;" onclick="openSubR('','` + ccd.ccd + `')">` + (element.FRM) + `</td>
                                  <td class="hideSWPWGROSSAMT" onclick="openSubR('','` + ccd.ccd + `')">` + (BAMT) + `</td>
                                  <td class="hideSWPWTYPE" style="display:none;" onclick="openSubR('','` + ccd.ccd + `')">` + (element.TYPE) + `</td>
                                  <td class="hideSWPWNETBILLAMT" onclick="openSubR('','` + ccd.ccd + `')">` + (FAMT) + `</td>
                                  <td class="hideSWPWGOODSRET" onclick="openSubR('','` + ccd.ccd + `')">` + (CLM) + `</td>
                                  <td class="hideSWPWPAID" onclick="openSubR('','` + ccd.ccd + `')">` + (RAMT) + `</td>
                                  <td class="hideSWPWPEND"onclick="openSubR('','` + ccd.ccd + `')">` + (PAMT) + `</td>
                                  <td class="hideSWPWDIS" style="display:none;"onclick="openSubR('','` + ccd.ccd + `')">` + getValueNotDefine(element.DR) + ` </td> 
                                  <td class="hideSWPWDISAMT" style="display:none;"onclick="openSubR('','` + ccd.ccd + `')">` + getValueNotDefine(element.DA) + ` </td> 
                                  <td class="hideSWPWGROUP"onclick="openSubR('','` + ccd.ccd + `')">` + getValueNotDefine(element.SG) + ` </td>                                    
                                  <td class="hideSWPWBROKER"style="display:none;"onclick="openSubR('','` + ccd.ccd + `')">` + getValueNotDefine(BCD) + ` </td>
                                  <td class="hideSWPWDAYS"onclick="openSubR('','` + ccd.ccd + `')">` + getDaysDif(element.DTE, nowDate) + ` </td>
                                  <td class="hideSWPWTRANSPORT" onclick="openSubR('','` + ccd.ccd + `')">` + getValueNotDefine(transport) + ` </td>
                                  <td class="hideSWPWLR"onclick="openSubR('','` + ccd.ccd + `')">` + getValueNotDefine(element.LR) + ` </td>
                                  <td class="hideSWPWVNO" onclick="openSubR('','` + ccd.ccd + `')">` + (element.VNO) + `</td>
                                      
                                  </tr>`;

        }
        trRow += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
          <tr class="tfootcard"style="background-color:#3e3b3b26;text-align: center;">
              <tH class="" style="text-align:left;"colspan="2">SUB TOTAL</tH>
          <th class="hideSWPWCUST"></th>
          <tH class="hideSWPWFRM" style="display:none;" ></tH>
              <tH class="hideSWPWGROSSAMT">` + valuetoFixed(subtotalGROSSAMT) + `</tH>
              <tH class="hideSWPWTYPE" style="display:none;" ></tH>
              <tH class="hideSWPWNETBILLAMT">` + valuetoFixed(subtotalNETBILLAMT) + `</tH>
              <tH class="hideSWPWGOODSRET" >` + valuetoFixed(subtotalGOODSRETURN) + `</tH>
              <tH class="hideSWPWPAID" >` + valuetoFixed(subtotalPAIDAMT) + `</tH>
              <tH class="hideSWPWPEND" >` + valuetoFixed(subtotalAmount) + `</tH>
              <tH class="hideSWPWDIS" style="display:none;" ></tH>
              <tH class="hideSWPWDISAMT" style="display:none;" ></tH>
              <tH class="hideSWPWGROUP" ></tH>
              <tH class="hideSWPWBROKER"style="display:none;"></tH>
              <tH class="hideSWPWDAYS"></tH>
              <tH class="hideSWPWTRANSPORT"></tH>
              <tH class="hideSWPWLR"></tH>
              <tH class="hideSWPWVNO" ></tH>
          </tr>`;
        totalNETBILLAMT += subtotalNETBILLAMT;
        totalGROSSAMT += subtotalGROSSAMT;
        totalGOODSRETURN += subtotalGOODSRETURN;
        totalPAIDAMT += subtotalPAIDAMT;
        totalAmount += subtotalAmount;
        subtotalNETBILLAMT = 0;
        subtotalGROSSAMT = 0;
        subtotalGOODSRETURN = 0;
        subtotalPAIDAMT = 0;
        subtotalAmount = 0;


      }
      if (customerList.length > 1) {
        trRow += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
      <tr class="tfootcard"style="background-color:#3e3b3b26;text-align: center;">
          <tH class="" style="text-align:left;"colspan="2">TOTAL</tH>
          <th class="hideSWPWCUST"></th>
          <tH class="hideSWPWFRM" style="display:none;" ></tH>
          <tH class="hideSWPWGROSSAMT">` + valuetoFixed(totalGROSSAMT) + `</tH>
          <tH class="hideSWPWTYPE" style="display:none;" ></tH>
          <tH class="hideSWPWNETBILLAMT">` + valuetoFixed(totalNETBILLAMT) + `</tH>
          <tH class="hideSWPWGOODSRET" >` + valuetoFixed(totalGOODSRETURN) + `</tH>
          <tH class="hideSWPWPAID" >` + valuetoFixed(totalPAIDAMT) + `</tH>
          <tH class="hideSWPWPEND" >` + valuetoFixed(totalAmount) + `</tH>
          <tH class="hideSWPWDIS" style="display:none;" ></tH>
          <tH class="hideSWPWDISAMT" style="display:none;" ></tH>
          <tH class="hideSWPWGROUP" ></tH>
          <th class="hideSWPWBROKER"style="display:none;"></th>
          <tH class="hideSWPWDAYS"></tH>
          <tH class="hideSWPWTRANSPORT"></tH>
          <tH class="hideSWPWLR"></tH>
          <tH class="hideSWPWVNO" ></tH>
      </tr>`;
      }
      if (totalAmount != 0) {
        tr += trRow;
      }
      grandtotalGROSSAMT += totalGROSSAMT;
      grandtotalNETBILLAMT += totalNETBILLAMT;
      grandtotalGOODSRETURN += totalGOODSRETURN;
      grandtotalPAIDAMT += totalPAIDAMT;
      grandtotalAmount += totalAmount;
      totalGROSSAMT = 0;
      totalNETBILLAMT = 0;
      totalGOODSRETURN = 0;
      totalPAIDAMT = 0;
      totalAmount = 0;
    }
    if (SupplierList.length > 1) {
      tr += `<tr class="tfootcard grandTotel"style="background-color:#3e3b3b26;color:#080844;">
    <tH colspan="2" >GRAND TOTAL</tH>
    <th class="hideSWPWCUST"></th>
    <tH class="hideSWPWFRM" style="display:none;" ></tH>
    <tH class="hideSWPWGROSSAMT">` + valuetoFixed(grandtotalGROSSAMT) + `</tH>
    <tH class="hideSWPWTYPE" style="display:none;" ></tH>
    <tH class="hideSWPWNETBILLAMT">` + valuetoFixed(grandtotalNETBILLAMT) + `</tH>
    <tH class="hideSWPWGOODSRET" >` + valuetoFixed(grandtotalGOODSRETURN) + `</tH>
    <tH class="hideSWPWPAID" >` + valuetoFixed(grandtotalPAIDAMT) + `</tH>
    <tH class="hideSWPWPEND" >` + valuetoFixed(grandtotalAmount) + `</tH>
    <tH class="hideSWPWGROUP" ></tH>
    <th class="hideSWPWBROKER"style="display:none;"></th>
    <tH class="hideSWPWDAYS"></tH>
    <tH class="hideSWPWTRANSPORT"></tH>
    <tH class="hideSWPWLR"></tH>
    <tH class="hideSWPWVNO" ></tH>
    </tr>`;
    }
    $('#result').html(tr);
    $("#loader").removeClass('has-loader');

    var hideAbleTr = getUrlParams(url, "hideSWPWAbleTr");
    if (hideAbleTr == "true") {
      $('.hideAbleTr').css("display", "none");
      $('.unhideAbleTr').css("display", "");
    } else {
      $('.unhideAbleTr').css("display", "none");
    }

    AddHeaderTbl();
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }

  try {

  } catch (e) {

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
  }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

