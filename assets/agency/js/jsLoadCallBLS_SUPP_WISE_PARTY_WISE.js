

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
        obj.BLL = Data[i].billDetails[j].BLL;
        obj.DTE = Data[i].billDetails[j].DTE;
        obj.TRN = Data[i].billDetails[j].TRN;
        obj.LA1RT = Data[i].billDetails[j].LA1RT;
        obj.DCAMT = Data[i].billDetails[j].DCAMT;
        obj.RNO = Data[i].billDetails[j].RNO;
        obj.DT = Data[i].billDetails[j].DT;
        obj.PD = Data[i].billDetails[j].PD;
        obj.SG = Data[i].billDetails[j].SG;
        obj.FAMT = Data[i].billDetails[j].FAMT;
        obj.BAMT = Data[i].billDetails[j].BAMT;
        obj.SRS = Data[i].billDetails[j].SRS;
        obj.RD = Data[i].billDetails[j].RD;

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
      tr += `<tr class="trPartyHead">
                        <th colspan="15" class="trPartyHead">` + label + `<a href="tel:` + MO + `"><button>MO:` + getValueNotDefine(MO) + `</button></a></th>
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
        tr += `<tr >
        <th colspan="15" style="font-weight:bolder;font-size:20px;background-color:#f3f3f3;color:#c107a2;" onclick="openSubR('`+ customer.COD + `','` + ccd.ccd + `')">` + suplabel + `<a href="tel:` + supMO + `"></th>
          </tr>
          <tr style="font-weight:500;font-weight:bold;"align="center">                    
          <th>BILL</th>
          <th>BILL&nbsp;DATE</th>
          <th style="text-align:right;">FINAL AMT</th>
          <th>FIRM</th>
          <th>TYPE</th>
          <th>PAID</th>
          <th class="hideSWPWRECDATE">REC&nbsp;DATE</th>
          <th class="hideSWPWSPDIS" style="display:none;">DIS%</th>
          <th class="hideSWPWSPDISCAMT" style="display:none;">DISCAMT</th>
          <th class="hideSWPWTRNSPT">TRANSPORT</th>
          <th class="hideSWPWLR">LR NO</th>
          <th class="hideSWPWGROUP">GROUP</th>
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

          var FAMT = 0;
          if (element.DT != null && element.DT != "") {
            if (element.DT.toUpperCase().indexOf('CN')) {
              FAMT = +Math.abs(element.BAMT);
            } else if (element.DT.toUpperCase().indexOf('DN')) {
              FAMT = -Math.abs(element.BAMT);
            } else if (element.DT.toUpperCase().indexOf('OS')) {
              FAMT = -Math.abs(element.BAMT);
            } else {
              FAMT = -Math.abs(element.BAMT);
            }
          } else {
            FAMT = -Math.abs(element.BAMT);
          }
          var BCD = "";
          var BrokerArr = getPartyDetailsBySendCode(element.BCD);
          if (BrokerArr.length > 0) {
            BCD = getValueNotDefine(BrokerArr[0].partyname);
          }
          var supGrpName = element.SG;

          tr += ` 
            <tr align="center"class="hideAbleTr">
            <th><a href="`+ FdataUrl + `" target="_blank"><button  class="PrintBtnHide">` + element.BLL + `</button></a></th>
            <th onclick="openSubR('`+ element.COD + `')">` + formatDate(element.DTE) + `</th>
            <th style="text-align:right;" onclick="openSubR('`+ element.COD + `')">` + valuetoFixed(FAMT) + `</th>
            <th onclick="openSubR('`+ element.COD + `')">` + element.FRM + `</th>
            <th onclick="openSubR('`+ element.COD + `')">` + element.SRS + `</th>
            <th onclick="openSubR('`+ element.COD + `')">` + element.PD + `</th>
            <th onclick="openSubR('`+ element.COD + `')" class="hideSWPWRECDATE">` + formatDate(element.RD) + `</th>
            <th class="hideSWPWSPDIS" style="display:none;" onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.LA1RT) + `</th>
            <th class="hideSWPWSPDISCAMT" style="display:none;" onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.DCAMT) + `</th>
            <th class="hideSWPWTRNSPT"onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.TRN) + `</th>
            <th class="hideSWPWLR"onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.RNO) + `</th>
            <th class="hideSWPWGROUP" onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(supGrpName) + `</th>
            <th class="hideSWPWVNO" onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.VNO) + `</th>
            </tr>`;
          totalNETBILLAMT += FAMT;
        }
        tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
          <tr class="tfootcard"style="background-color:#3e3b3b26;">
          <th >TOTAL </th>
          <th></th>
          <th style="text-align:right;">` + valuetoFixed(totalNETBILLAMT) + `</th>
          <th></th>
          <th></th>
          <th></th>
          <th class="hideSWPWRECDATE"></th>
          <th class="hideSWPWSPDIS" style="display:none;" ></th>
          <th class="hideSWPWSPDISCAMT" style="display:none;" ></th>
          <th class="hideSWPWTRNSPT"></th>
          <th class="hideSWPWLR"></th>
          <th class="hideSWPWGROUP"></th>    
          <th class="hideSWPWVNO"></th>    
          </tr>`;

        subtotalNETBILLAMT += totalNETBILLAMT;
        totalNETBILLAMT = 0;
      }
      if (customerList.length > 1) {
        tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
      <tr class="tfootcard"style="background-color:#3e3b3b26;">
      <th >TOTAL </th>
      <th></th>
      <th style="text-align:right;">` + valuetoFixed(subtotalNETBILLAMT) + `</th>
      <th></th>
      <th></th>
      <th></th>
      <th class="hideSWPWRECDATE"></th>
      <th class="hideSWPWSPDIS" style="display:none;" ></th>
      <th class="hideSWPWSPDISCAMT" style="display:none;" ></th>
      <th class="hideSWPWTRNSPT"></th>
      <th class="hideSWPWLR"></th>
      <th class="hideSWPWGROUP"></th>      
          <th class="hideSWPWVNO"></th>    
          </tr>`;
      }
      grandtotalNETBILLAMT += subtotalNETBILLAMT;
      subtotalNETBILLAMT = 0;
    }
    if (SupplierList.length > 1) {
      tr += `<tr class="tfootcard"style="background-color:#3e3b3b26;">
    <tr class="tfootcard"style="background-color:#3e3b3b26;">
    <th >TOTAL </th>
    <th></th>
    <th style="text-align:right;">` + valuetoFixed(grandtotalNETBILLAMT) + `</th>
    <th></th>
    <th></th>
    <th></th>
    <th class="hideSWPWRECDATE"></th>
    <th class="hideSWPWSPDIS" style="display:none;" ></th>
    <th class="hideSWPWSPDISCAMT" style="display:none;" ></th>
    <th class="hideSWPWTRNSPT"></th>
    <th class="hideSWPWLR"></th>
    <th class="hideSWPWGROUP"></th>      
          <th class="hideSWPWVNO"></th>    
          </tr>`;
    }

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');

    var hideAbleTr = getUrlParams(url, "hideAbleTr");
    if (hideAbleTr == "true") {
      $('.hideAbleTr').css("display", "none");
      $('.unhideAbleTr').css("display", "");
    } else {
      $('.unhideAbleTr').css("display", "none");
    }

    // AddHeaderTbl();
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

