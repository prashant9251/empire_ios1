
var url = window.location.href;
var BLS;
var DET;
var DETdata;
var div = '';
function getProductDetails(CNO, TYPE, VNO) {
  return DETdata.filter(function (data) {
    return data.CNO.toUpperCase() == CNO.toUpperCase() &&
      data.TYPE.toUpperCase() == TYPE.toUpperCase() &&
      data.VNO.toUpperCase() == VNO.toUpperCase();
  })
}
// var billNos = (getUrlParams(url, "billNos"));

ACTYPE = getUrlParams(url, "ACTYPE");
function loadBillPdfCall() {

  try {
    // console.log(Data);


    // console.log(BLS);



    if (BLS.length > 0) {
      for (var i = 0; i < BLS.length; i++) {
        for (var j = 0; j < BLS[i].billDetails.length; j++) {
          var BillName = 'TAX INVOICE';
          var SERIESArr = getSeriesDetailsBySendType(BLS[i].billDetails[j].TYPE);
          if (BLS[i].billDetails[j].DT != "os") {
            BillName = SERIESArr[0].SERIES;
          }
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
          var PNO = '';
          var ATYPE = '';
          var AD1 = '';
          var AD2 = '';
          var GST = '';
          var ST = '';
          var dhara = '';
          var partyStateCode = '';
          var lbl = '';
          if (partyArray.length > 0) {
            pcode = getValueNotDefine(partyArray[0].partyname);
            city = getValueNotDefine(partyArray[0].city);
            broker = getValueNotDefine(partyArray[0].broker);
            label = getValueNotDefine(partyArray[0].label);
            MO = getValueNotDefine(partyArray[0].MO);
            ATYPE = getValueNotDefine(partyArray[0].ATYPE);
            PNO = getValueNotDefine(partyArray[0].PNO);
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
          var CO_ADD1 = "";
          var CO_ADD2 = "";
          var CO_ADD3 = "";
          var CO_ADD4 = "";
          var CO_MOBILE = "";
          var CO_PHONE1 = "";
          var CO_CITY = "";
          var CO_COMPANY_GSTIN = "";
          var CO_PANNO = "";
          var MainFirmName = getValueNotDefine(BLS[i].billDetails[j].ccd);
          if (ACTYPE != "AGENCY") {
            MainFirmName = firmArray[0].FIRM;
            CO_ADD1 = getValueNotDefine(firmArray[0].ADDRESS1);
            CO_ADD2 = getValueNotDefine(firmArray[0].ADDRESS2);
            CO_ADD3 = getValueNotDefine(firmArray[0].ADDRESS3);
            CO_ADD4 = getValueNotDefine(firmArray[0].ADDRESS4);
            CO_CITY = getValueNotDefine(firmArray[0].CITY1);
            CO_COMPANY_GSTIN = getValueNotDefine(firmArray[0].COMPANY_GSTIN);
            CO_PANNO = getValueNotDefine(firmArray[0].PANNO);
            CO_MOBILE = getValueNotDefine(firmArray[0].MOBILE)
            CO_PHONE1 = getValueNotDefine(firmArray[0].PHONE1)
          } else {
            var SuppArray = getPartyDetailsBySendName(BLS[i].billDetails[j].ccd);
            console.log(SuppArray, BLS[i].billDetails[j].ccd);
            if (SuppArray.length > 0) {
              CO_ADD1 = getValueNotDefine(SuppArray[0].AD1);
              CO_ADD2 = getValueNotDefine(SuppArray[0].AD2);
              CO_ADD3 = getValueNotDefine(SuppArray[0].AD3);
              CO_ADD4 = getValueNotDefine(SuppArray[0].AD4);
              CO_CITY = getValueNotDefine(SuppArray[0].city);
              CO_COMPANY_GSTIN = getValueNotDefine(SuppArray[0].GST);
              CO_PANNO = getValueNotDefine(SuppArray[0].PANNO);
              CO_MOBILE = getValueNotDefine(SuppArray[0].MO)
              CO_PHONE1 = getValueNotDefine(SuppArray[0].PH1)
            }
          }
          div += `
        <div class="page" style="min-height: auto;">
      <table class="table-responsive" style="width:100%;font-size:10px;">

      <tr  class="upperCase">
      <td style="text-align:center;" colspan="3"> ! ! SHREE GANESHAYA NAMAH ! ! </td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:left;">SUBJECT TO SURAT JURIDICTION ONLY</td>
      <td style="text-align:center;"></td>
      <td style="text-align:left;">PH :  `+ getValueNotDefine(CO_MOBILE) + `,  ` + getValueNotDefine(CO_PHONE1) + `</td>
      </tr>
    
      <tr  class="upperCase">
      <td style="text-align:left;">ORIGINAL FOR RECEIPIENT</td>
      <td style="text-align:center;">DUPLICATE FOR TRANSPORT</td>
      <td style="text-align:right;">TRIPLICATE FOR SUPPLIER</td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:center;font-size: 28px;font-weight: bolder;" colspan="3">`+ MainFirmName + `</td>
      </tr>
  
      <tr  class="upperCase"style="font-weight:bold;">
      <td style="text-align:left;">GSTIN : `+ CO_COMPANY_GSTIN + `</td>
      <td style="text-align:center;"></td>
      <td style="text-align:right;">PAN : `+ CO_PANNO + `</td>
      </tr>

      <tr class="upperCase">
      <td style="text-align:center;" colspan="3">`+ CO_ADD1 + `,` + CO_ADD1 + `,` + CO_CITY + `</td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:center;font-size: 27px;font-weight: bolder;" colspan="3">`+ BillName + `</td>
      </tr>

      <tr>
      <td colspan="3"><hr class="pdfhr"></td>
      </tr>
      
      <tr  class="upperCase" style="font-weight:bold;">
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
      <td style="text-align:left;"colspan="2"> `+ city + `,` + PNO + `,` + MO + ` </td>
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
      <td colspan="3"><hr class="pdfhr"></td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2">L.R.NO :  `+ getValueNotDefine(BLS[i].billDetails[j].RNO) + ` * ` + getValueNotDefine(BLS[i].billDetails[j].PRL) + `</td>
      <td style="text-align:left;">L. R. DATE : `+ formatDate(BLS[i].billDetails[j].RDT) + ` </td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2">TRANSPORT  `+ getValueNotDefine(BLS[i].billDetails[j].TRN) + `</td>
      <td style="text-align:left;">STATION `+ getValueNotDefine(BLS[i].billDetails[j].PLC) + ` </td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2">WEIGHT : `+ parseFloat(getValueNotDefine(BLS[i].billDetails[j].WGT)).toFixed(2) + `</td>
      <td style="text-align:left;">FREIGHT: `+ parseFloat(getValueNotDefine(BLS[i].billDetails[j].FRT)).toFixed(2) + ` </td>
      </tr>

      <tr>
      <td colspan="11"><hr class="pdfhr"></td>
      </tr>
      </table>      
      <div style="min-height:33%;">
        `;

          DET = getProductDetails(BLS[i].billDetails[j].CNO, BLS[i].billDetails[j].TYPE, BLS[i].billDetails[j].VNO);
          // DET = DETdata.filter(function (data) {
          //   return data.CNO.toUpperCase() == .toUpperCase() &&
          //     data.TYPE.toUpperCase() == BLS[i].billDetails[j].TYPE.toUpperCase() &&
          //     data.VNO.toUpperCase() == BLS[i].billDetails[j].VNO.toUpperCase();
          // })
          // console.log(DET);
          var subTotalAmt = 0;
          if (DET.length > 0) {
            div += `
          <table  class="table-responsive" style="width:100%;font-size:12px;">
          <tr style="font-weight:bold;" class="upperCase">
          <td>SR</td>
          <td class="hideSUPPLIER">SUPPLIER</td>
          <td class="hideQUALITY">ITEM</td>
          <td class="hideHSN">HSN</td>
          <td class="hidePCS" align="center">PCS</td>
          <td class="hideCUT">CUT</td>
          <td class="hideMTS">MTS</td>
          <td class="hideNMTS" style="display:none;">N.MTS</td>
          <td class="hideDISC_RATE" style="display:none;">D.RATE</td>
          <td class="hideDISC_AMT" style="display:none;">D.AMT</td>
          <td class="hideFOLD">FOLD</td>
          <td class="hidePURCHASERATE">P.RATE</td>
          <td class="hideRATE">RATE</td>
          <td class="hidePER">PER</td>
          <td align="right">AMOUNT</td>
          </tr>
    
          <tr>
          <td colspan="15"><hr class="pdfhr"></td>
          </tr>`;
            var sr = 0;
            var billDet = DET[0].billDetails;
            billDet = billDet.sort(function (a, b) {
              return parseInt(a.SR) - parseInt(b.SR);
            })
            for (var k = 0; k < billDet.length; k++) {
              ccode = getPartyDetailsBySendCode(billDet[k].SP);
              var ccdpcode = "";
              if (ccode.length > 0) {
                ccdpcode = getValueNotDefine(ccode[0].partyname);
              }
              var RATE = parseFloat(billDet[k].RATE);
              var DHARA = (billDet[k].DR) == "" || (billDet[k].DR) == null ? 0 : parseFloat(billDet[k].DR);
              var finalRate = RATE + (DHARA * RATE / 100);
              subTotalAmt += parseFloat(billDet[k].AMT);
              var LESS_FOLD = parseFloat(billDet[k].LF);;
              var NET_MTS = parseFloat(billDet[k].MTS);
              if (billDet[k].LF != "" && billDet[k].LF != null && billDet[k].LF != undefined && parseInt(billDet[k].LF) != 0) {
                var MTS = parseFloat(billDet[k].MTS);
                LESS_FOLD = parseFloat(billDet[k].LF);
                var lessMts = (MTS * LESS_FOLD) / 100;
                NET_MTS = MTS - lessMts;
              }
              sr += 1;
              div += `<tr class="upperCase">
              <td>`+ sr + `</td>
              <td class="hideSUPPLIER">`+ ccdpcode + `</td>
              <td class="hideQUALITY">`+ billDet[k].qual + `</td>
              <td class="hideHSN">`+ getValueNotDefine(billDet[k].hsn) + `</td>
              <td class="hidePCS" align="center">`+ valuetoFixedNo(billDet[k].PCS) + `</td>
              <td class="hideCUT">`+ billDet[k].CUT + `</td>
              <td class="hideMTS">`+ parseFloat(billDet[k].MTS).toFixed(2) + `</td>
              <td class="hideNMTS" style="display:none;">`+ parseFloat(NET_MTS).toFixed(2) + `</td>
              <td class="hideDISC_RATE" style="display:none;">`+ parseFloat(getValueNotDefineNo(billDet[k].D)).toFixed(2) + `</td>
              <td class="hideDISC_AMT" style="display:none;">`+ parseFloat(getValueNotDefineNo(billDet[k].DA)).toFixed(2) + `</td>
              <td class="hideFOLD">`+ parseFloat(getValueNotDefine(LESS_FOLD)) + `%</td>
              <td class="hidePURCHASERATE">`+ RATE + ifValNullGetBlank(DHARA, "*") + `</td>
              <td class="hideRATE">`+ finalRate + `</td>
              <td class="hidePER">`+ getValueNotDefine(billDet[k].UNIT) + `</td>
              <td align="right">`+ valuetoFixed(billDet[k].AMT) + `</td>
              </tr>`;
            }
            div += ` </table>
          `;
          }
          div += ` 
        </div>    
      <table style="width:100%;">
      
      <tr style="width:100%;"class="upperCase bold">
      <td colspan="5">A/C NO : `+ getValueNotDefine(CO_ADD3) + ` IFSC : ` + getValueNotDefine(CO_ADD4) + `</td>
      </tr>      
      <tr style="width:100%;"class="upperCase bold">        
        <td colspan="5"><hr class="pdfhr">  </td>
      </tr>

      <tr style="width:100%;"class="upperCase">
      <td>DUE DAYS : </td>
      <td>TOTAL `+ BLS[i].billDetails[j].PCS + `</td>
      <td>`+ parseFloat(BLS[i].billDetails[j].MTS).toFixed(2) + `</td>
      <td></td>
      <td align="right">`+ valuetoFixed(subTotalAmt) + `</td>
      </tr>
      </table>
    <hr class="pdfhr">
    <table style="width:100%;font-size:12px;">        
`;

          if (getValueNotDefineNo(BLS[i].billDetails[j].aia) != 0) {
            div += `
          <tr>
           <td style="text-align:right;width:100%;"colspan="3">INSURANCE ADD : `+ valuetoFixed(BLS[i].billDetails[j].aia) + `</td>
          </tr>
        `;
          }
          if (getValueNotDefineNo(BLS[i].billDetails[j].AA1) != 0) {
            div += `
          <tr>
           <td style="text-align:right;width:100%;"colspan="3">TOTAL ADD : `+ valuetoFixed(BLS[i].billDetails[j].AA1) + `</td>
          </tr>
        `;
          }

          if (getValueNotDefineNo(BLS[i].billDetails[j].AA2) != 0) {
            div += `
          <tr>
           <td style="text-align:right;width:100%;"colspan="3">OTHER ADD : `+ valuetoFixed(BLS[i].billDetails[j].AA2) + `</td>
          </tr>
        `;
          }

          if (getValueNotDefineNo(BLS[i].billDetails[j].O_LS) != 0) {
            div += `
          <tr>
        <td style="text-align:right;width:100%;"colspan="3">TOTAL LESS : `+ valuetoFixed(BLS[i].billDetails[j].O_LS) + `</td>
          </tr>
        `;
          }
          if (getValueNotDefineNo(BLS[i].billDetails[j].LA1RT) != 0) {
            div += `
          <tr>
        <td style="text-align:right;width:100%;"colspan="3">
         `+ getValueNotDefine(BLS[i].billDetails[j].LA1RMK) + ` 
         `+ valuetoFixed(BLS[i].billDetails[j].GAMT) + ` X 
         <strong>`+ BLS[i].billDetails[j].LA1RT + ` % </strong> 
         `+ BLS[i].billDetails[j].LA1AMT + ` 
        </td>
          </tr>
        `;
          }
          if (getValueNotDefineNo(BLS[i].billDetails[j].LA2RT) != 0) {
            div += `
          <tr>
        <td style="text-align:right;width:100%;"colspan="3">
         `+ getValueNotDefine(BLS[i].billDetails[j].LA2RMK) + ` 
         `+ BLS[i].billDetails[j].LA2qty + ` X 
         <strong>`+ BLS[i].billDetails[j].LA2RT + ` % </strong> 
         `+ BLS[i].billDetails[j].LA2AMT + ` 
        </td>
          </tr>
        `;
          }
          if (getValueNotDefineNo(BLS[i].billDetails[j].LA3RT) != 0) {
            div += `
          <tr>
        <td style="text-align:right;width:100%;"colspan="3">
         `+ getValueNotDefine(BLS[i].billDetails[j].LA3RMK) + ` 
         `+ BLS[i].billDetails[j].LA3qty + ` X 
         <strong>`+ BLS[i].billDetails[j].LA3RT + ` % </strong> 
         `+ BLS[i].billDetails[j].LA3AMT + ` 
        </td>
          </tr>
        `;
          }
          if (parseInt(BLS[i].billDetails[j].VTAMT) != 0) {
            // console.log(partyStateCode, firmStateCode);
            if (parseInt(partyStateCode) == parseInt(firmStateCode)) {
              if (BLS[i].billDetails[j].VTRT != null && parseInt(BLS[i].billDetails[j].VTRT) != 0) {
                div += `<tr>    
              <td style="text-align:right;width:100%;"colspan="3">CGST @ `+ BLS[i].billDetails[j].VTRT + `% ON TAXABLE VALUE ` + valuetoFixed(BLS[i].billDetails[j].GAMT) + ` = ` + valuetoFixed(BLS[i].billDetails[j].VTAMT) + `</td>
              </tr>
              `;
              }
              if (BLS[i].billDetails[j].ADVTRT != null && parseInt(BLS[i].billDetails[j].ADVTRT) != 0) {
                div += `<tr>    
              <td style="text-align:right;width:100%;" colspan="3">SGST @ `+ BLS[i].billDetails[j].ADRT + `% ON TAXABLE VALUE ` + valuetoFixed(BLS[i].billDetails[j].GAMT) + ` = ` + valuetoFixed(BLS[i].billDetails[j].ADAMT) + `</td>
              </tr>
              `;
              }
            } else {
              if (BLS[i].billDetails[j].VTRT != null && parseInt(BLS[i].billDetails[j].VTRT) != 0) {
                div += `<tr>    
              <td style="text-align:right;width:100%;" colspan="3">IGST @ `+ getValueNotDefine(BLS[i].billDetails[j].VTRT) + `% ON TAXABLE VALUE ` + valuetoFixed(BLS[i].billDetails[j].GAMT) + ` =  ` + valuetoFixed(BLS[i].billDetails[j].VTAMT) + `</td>
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
      <td align="right">NET AMOUNT </td>
      <td style="text-align:right;"> `+ valuetoFixed(BLS[i].billDetails[j].BAMT) + `</td>
      </tr>
      
      
      <tr>
      <td colspan="4"><hr class="pdfhr"></td>
      </tr>

      <tr style="font-weight:bold;">    
      <td  colspan="2"></td>
      <td  colspan="2"style="text-align:right;">FOR `+ MainFirmName + `</td>
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
          BILL = getValueNotDefine(BLS[i].billDetails[j].BLL);
          try {
            var BILL = BILL.replaceAll(/[^\w\s]/gi, '');
          } catch (error) {
          }
          document.title = "BILL NO " + BILL;
        }
      }

      div += ``;
      // document.body.innerHTML = div;
      $("#loader").removeClass('has-loader');
      $("body").append(div)
      hideList();
    } else {
      document.body.innerHTML = "<h1 align='center'>NO DATA FOUND<h1>";
      $("#loader").removeClass('has-loader');
    }
  } catch (error) {
    noteError(error);
  }
}
