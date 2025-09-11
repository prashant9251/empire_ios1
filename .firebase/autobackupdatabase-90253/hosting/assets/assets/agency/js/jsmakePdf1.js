
var url = window.location.href;
var BLS;
var DET;
var DETdata;
var div = '';

function loadBillPdfCall() {
  $("#loader").addClass('has-loader');
  // console.log(Data);


  // console.log(BLS);



  if (BLS.length > 0) {
    for (var i = 0; i < BLS.length; i++) {
      for (var j = 0; j < BLS[i].billDetails.length; j++) {

        firmArray = getFirmDetailsBySendCode(BLS[i].billDetails[j].CNO);
        partyArray = getPartyDetailsBySendCode(BLS[i].COD);
        COMPANY_GSTIN = firmArray[0].COMPANY_GSTIN;
        COMPANY_GSTIN = COMPANY_GSTIN == null || COMPANY_GSTIN == '' ? '' : COMPANY_GSTIN;
        var firmStateCode = COMPANY_GSTIN.substring(0, 2);
        // console.log(partyArray)
        partyStateCode = '';
        var pcode = '';
        var city = '';
        var broker = '';
        var label = '';
        var MO = '';
        var ATYPE = '';
        var AD1 = '';
        var AD2 = '';
        var GST = '';
        var ST = '';
        var dhara = '';
        var partyStateCode = '';
        if (partyArray.length > 0) {
          pcode = getValueNotDefine(partyArray[0].partyname);
          city = getValueNotDefine(partyArray[0].city);
          broker = getValueNotDefine(partyArray[0].broker);
          label = getValueNotDefine(partyArray[0].label);
          MO = getValueNotDefine(partyArray[0].MO);
          ATYPE = getValueNotDefine(partyArray[0].ATYPE);
          AD1 = getValueNotDefine(partyArray[0].AD1);
          AD2 = getValueNotDefine(partyArray[0].AD2);
          GST = getValueNotDefine(partyArray[0].GST);
          GST = GST == null || GST == '' ? '' : GST;
          ST = getValueNotDefine(partyArray[0].ST);
          dhara = getValueNotDefineNo(partyArray[0].dhara);
          partyStateCode = (GST).substring(0, 2);
          lbl = parseInt(ATYPE) == 1 ? "CUST : " : parseInt(ATYPE) == 2 ? "SUPP : " : "";
        }
        // console.table(firmArray)
        div += `
        <div class="page" style="min-height: auto;">
      <table class="table-responsive" style="width:100%;font-size:12px;">

      <tr  class="upperCase">
      <td style="text-align:center;" colspan="3"> ! ! SHREE GANESHAYA NAMAH ! ! </td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:left;">SUBJECT TO SURAT JURIDICTION ONLY</td>
      <td style="text-align:center;"></td>
      <td style="text-align:left;">PH :  `+ getValueNotDefine(firmArray[0].MOBILE) + `,  ` + getValueNotDefine(firmArray[0].PHONE1) + `</td>
      </tr>
      
      <tr  class="upperCase"style="font-weight:bold;">
      <td style="text-align:left;">TAX INVOICE</td>
      <td style="text-align:center;">GSTIN : `+ getValueNotDefine(firmArray[0].COMPANY_GSTIN) + `</td>
      <td style="text-align:right;">PAN : `+ getValueNotDefine(firmArray[0].PANNO) + `</td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:left;">ORIGINAL FOR RECEIPIENT</td>
      <td style="text-align:center;">DUPLICATE FOR TRANSPORT</td>
      <td style="text-align:right;">TRIPLICATE FOR SUPPLIER</td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:center;font-size: 30px;font-weight: bolder;" colspan="3">`+ firmArray[0].FIRM + `</td>
      </tr>

      <tr class="upperCase">
      <td style="text-align:center;" colspan="3">`+ getValueNotDefine(firmArray[0].ADDRESS1) + `,` + getValueNotDefine(firmArray[0].ADDRESS2) + `,<b>` + getValueNotDefine(firmArray[0].CITY1) + `</td>
      </tr>
      
      <tr>
      <td colspan="3"><hr class="pdfhr"></td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2">M/S `+ pcode + `</td>
      <td style="text-align:left;"> BILL NO: `+ (BLS[i].billDetails[j].BLL) + `</td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2"> `+ getValueNotDefine(AD1) + `</td>
      <td style="text-align:left;"> DATE : `+ formatDate(BLS[i].billDetails[j].DTE) + ` </td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2">`+ getValueNotDefine(AD2) + ` </td>
      <td style="text-align:left;"> PARTY NO :  `+ getValueNotDefine(BLS[i].billDetails[j].PS) + ` </td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2"> `+ city + ` </td>
      <td style="text-align:left;"> STATE : `+ getValueNotDefine(BLS[i].billDetails[j].STC) + ` </td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2"> GSTIN : `+ GST + ` </td>
      <td style="text-align:left;">HSN/SAC: `+ getValueNotDefine(BLS[i].billDetails[j].HSN) + ` </td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2"> E-WAY BILL NO: `+ getValueNotDefine(BLS[i].billDetails[j].EWB) + ` </td>
      <td style="text-align:left;">case no: `+ getValueNotDefine(BLS[i].billDetails[j].CSNO) + ` </td>

      </tr>

      <tr>
      <td colspan="11"><hr class="pdfhr"></td>
      </tr>
      </table>      
      <div style="min-height:35%;">
        `;

        DET = DETdata.filter(function (data) {
          return data.CNO.toUpperCase() == BLS[i].billDetails[j].CNO.toUpperCase() &&
            data.TYPE.toUpperCase() == BLS[i].billDetails[j].TYPE.toUpperCase() &&
            data.VNO.toUpperCase() == BLS[i].billDetails[j].VNO.toUpperCase();
        })
        // console.log(DET);
        if (DET.length > 0) {
          div += `
          <table  class="table-responsive" style="width:100%;font-size:12px;">
          <tr style="font-weight:bold;" class="upperCase">
          <td>SR</td>
          <td>ITEM</td>
          <td>SUPPLIER</td>
          <td></td>
          <td></td>
          <td></td>
          <td align="center">PCS</td>
          <td>CUT</td>
          <td>MTS</td>
          <td>RATE</td>
          <td align="right">AMOUNT</td>
          </tr>
    
          <tr>
          <td colspan="11"><hr class="pdfhr"></td>
          </tr>`;
          var sr = 0;
          var billDet = DET[0].billDetails;
          for (var k = 0; k < billDet.length; k++) {
            ccode = getPartyDetailsBySendCode(billDet[k].SP);
            var ccdpcode = "";
            if (ccode.length > 0) {
              ccdpcode = getValueNotDefine(ccode[0].partyname);
            }
            var RATE = parseInt(billDet[k].RATE);
            var DHARA = parseInt(billDet[k].DR);
            var finalRate = RATE - (DHARA * RATE / 100);
            sr += 1;
            div += `<tr class="upperCase">
              <td>`+ sr + `</td>
              <td>`+ billDet[k].qual + `</td>
              <td>`+ ccdpcode + `</td>
              <td>`+ RATE + `</td>
              <td>-</td>
              <td>`+ DHARA + `</td>
              <td align="center">`+ valuetoFixedNo(billDet[k].PCS) + `</td>
              <td>`+ billDet[k].CUT + `</td>
              <td>`+ valuetoFixed(billDet[k].MTS) + `</td>
              <td>`+ finalRate + `</td>
              <td align="right">`+ valuetoFixed(billDet[k].AMT) + `</td>
              </tr>`;
          }
          div += ` </table>
          `;
        }
        div += ` 
        </div>    
    <hr class="pdfhr">      
      <table style="width:100%;">
      <tr class="upperCase">
      <td colspan="5">DUE DAYS : </td>
      <td>TOTAL `+ BLS[i].billDetails[j].PCS + `</td>
      <td>`+ valuetoFixed(BLS[i].billDetails[j].MTS) + `</td>
      <td></td>
      <td>`+ valuetoFixed(BLS[i].billDetails[j].GAMT) + `</td>
      </tr>
      </table>
    <hr class="pdfhr">
    <table style="width:100%;font-size:12px;">
      <tr>    
        <td style="text-align:left;">CASE NO  `+ getValueNotDefine(BLS[i].billDetails[j].CSNO) + `</td>
        <td style="text-align:left;">LR NO `+ getValueNotDefine(BLS[i].billDetails[j].RNO) + ` * `+getValueNotDefine(BLS[i].billDetails[j].PRL)+`</td>
        <td style="text-align:left;">TRANSPORT  `+ getValueNotDefine(BLS[i].billDetails[j].TRN) + `</td>
`;
        if (getValueNotDefineNo(BLS[i].billDetails[j].OT_LS) != 0) {
          div += `
        <td style="text-align:right;">`+ valuetoFixed(BLS[i].billDetails[j].OT_LS) + `</td>
        `;
        } else {
          div += `
        <td style="text-align:right;">0.00</td>
        `;
        }
        div += `
      </tr>      
      <tr>    
      <td style="text-align:left;">LR DATE `+ formatDate(BLS[i].billDetails[j].RDT) + `</td>
      <td style="text-align:left;">STATION `+ getValueNotDefine(BLS[i].billDetails[j].PLC) + `</td>
      <td></td>
      <td style="text-align:right;">0.00</td>
      </tr>`;
        if (parseInt(BLS[i].billDetails[j].VTAMT) != 0) {
          // console.log(partyStateCode, firmStateCode);
          if (parseInt(partyStateCode) == parseInt(firmStateCode)) {
            if (parseInt(BLS[i].billDetails[j].VTRT) != 0) {
              div += `<tr>    
              <td style="text-align:left;"></td>
              <td  colspan="2"style="text-align:left;">CGST @ `+ BLS[i].billDetails[j].VTRT + `% ON TAXABLE VALUE ` + valuetoFixed(BLS[i].billDetails[j].GAMT) + ` = </td>
              <td style="text-align:right;">` + parseInt(BLS[i].billDetails[j].VTAMT) + `</td>
              </tr>
              `;
            }
            if (parseInt(BLS[i].billDetails[j].ADVTRT) != 0) {
              div += `<tr>    
              <td style="text-align:left;"></td>
              <td  colspan="2"style="text-align:left;">SGST @ `+ BLS[i].billDetails[j].ADRT + `% ON TAXABLE VALUE ` + valuetoFixed(BLS[i].billDetails[j].GAMT) + ` = </td>
              <td style="text-align:right;">` + parseInt(BLS[i].billDetails[j].ADAMT) + `</td>
              </tr>
              `;
            }
          } else {
            if (parseInt(BLS[i].billDetails[j].VTRT) != 0) {
              div += `<tr>    
              <td style="text-align:left;"></td>
              <td  colspan="2"style="text-align:left;">IGST @ `+ BLS[i].billDetails[j].VTRT + `% ON TAXABLE VALUE ` + valuetoFixed(BLS[i].billDetails[j].GAMT) + ` = </td>
              <td style="text-align:right;">` + parseInt(BLS[i].billDetails[j].VTAMT) + `</td>
              </tr>
              `;
            }
          }
        }

        div += `
      <tr>
      <td colspan="4"><hr class="pdfhr"></td>
      </tr>

      <tr style="font-weight:bold;font-size:15px;">    
      <td style="text-align:left;">REMARK:  `+ getValueNotDefine(BLS[i].billDetails[j].RMK) + `</td>
      <td style="text-align:left;"> </td>
      <td align="right">BILL AMOUNT </td>
      <td style="text-align:right;"> `+ valuetoFixed(BLS[i].billDetails[j].BAMT) + `</td>
      </tr>
      
      
      <tr>
      <td colspan="4"><hr class="pdfhr"></td>
      </tr>

      <tr style="font-weight:bold;">    
      <td  colspan="2"></td>
      <td  colspan="2"style="text-align:right;">FOR `+ firmArray[0].FIRM + `</td>
      </tr>

      <tr class="upperCase bold">
      <td colspan="4">A/C NO : `+ getValueNotDefine(firmArray[0].ADDRESS3) + ` IFSC : ` + getValueNotDefine(firmArray[0].ADDRESS4) + `</td>
      </tr>
      
      <tr class="upperCase ">
      <td colspan="4">TERMS</td>
      </tr>
      <tr class="upperCase ">
      <td colspan="4"> (1) THE ABOVE GOODS ARE DESPATCHED ON YOUR A/C RISK</td>
      </tr>
      
      <tr class="upperCase">
      <td colspan="4">(2) PAYMENT SHOULD BE SEND BY A/C PAY CHEQUE OR NEFT ,RTGS ONLY</td>
      </tr>
      
      <tr class="upperCase">
      <td colspan="4"> (3)INTEREST WILL BE CHARGED 18% YEARLY</td>
      </tr>
    </table>
    </div>
      `;
        BILL = BLS[i].billDetails[j].BLL;
        var BILL = BILL.replaceAll(/[^\w\s]/gi, '');
        document.title = "BILL NO " + BILL;
      }
    }

    div += ``;
    // document.body.innerHTML = div;
    $("#loader").removeClass('has-loader');
    $("body").append(div)
  } else {
    document.body.innerHTML = "<h1 align='center'>NO DATA FOUND<h1>";
    $("#loader").removeClass('has-loader');
  }
  try {
  } catch (error) {
    document.body.innerHTML = div;
    // alert(error);
    $("#loader").removeClass('has-loader');
  }
}
