
var url = window.location.href;
var BLS;
var DET;
var DETdata;
var div = '';
function getProductDetails(CNO, TYPE, VNO) {
  console.log(DETdata)
  return DETdata.filter(function (data) {
    return data.IDE.toUpperCase() == IDE.toUpperCase()
  })
}
ACTYPE = getUrlParams(url, "ACTYPE");
function loadBillPdfCall() {

  // console.log(Data);


  console.log(BLS);


  try {

    if (BLS.length > 0) {
      for (var i = 0; i < BLS.length; i++) {
        var BillName = 'TAX INVOICE';
        var SERIESArr = getSeriesDetailsBySendType(BLS[i].TYPE);
        if (BLS[i].DT != "os") {
          if (SERIESArr.length > 0) {
            BillName = SERIESArr[0].SERIES;
          }
        }
        BillName = "";
        firmArray = getFirmDetailsBySendCode(BLS[i].CNO);
        partyArray = getPartyDetailsBySendCode(BLS[i].RFCD);
        var SuppArray = getPartyDetailsBySendCode(BLS[i].COD);
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
        var lbl = '';
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
        var CO_ADD1 = "";
        var CO_ADD2 = "";
        var CO_ADD3 = "";
        var CO_ADD4 = "";
        var CO_CITY = "";
        var CO_COMPANY_GSTIN = "";
        var CO_PANNO = "";
        var MainFirmName = getValueNotDefine(BLS[i].ccd);

        MainFirmName = firmArray[0].FIRM;
        CO_ADD1 = getValueNotDefine(firmArray[0].ADDRESS1);
        CO_ADD2 = getValueNotDefine(firmArray[0].ADDRESS2);
        CO_ADD3 = getValueNotDefine(firmArray[0].ADDRESS3);
        CO_ADD4 = getValueNotDefine(firmArray[0].ADDRESS4);
        CO_CITY = getValueNotDefine(firmArray[0].CITY1);
        CO_COMPANY_GSTIN = getValueNotDefine(firmArray[0].COMPANY_GSTIN);
        CO_PANNO = getValueNotDefine(firmArray[0].PANNO);
        var SuppName = "";
        var SuppADD1 = "";
        var SuppADD2 = "";
        var SuppADD3 = "";
        var SuppADD4 = "";
        var SuppCITY = "";
        var SuppCOMPANY_GSTIN = "";
        var SuppPANNO = "";
        var SuppMO = "";
        var SuppPH1 = "";
        var SuppGROUPcode = "";
        var SuppGroupName = "";
        console.log(SuppArray, BLS[i].ccd)
        if (SuppArray.length > 0) {
          SuppName = getValueNotDefine(SuppArray[0].partyname);
          SuppADD1 = getValueNotDefine(SuppArray[0].AD1);
          SuppADD2 = getValueNotDefine(SuppArray[0].AD2);
          SuppADD3 = getValueNotDefine(SuppArray[0].AD3);
          SuppADD4 = getValueNotDefine(SuppArray[0].AD4);
          SuppCITY = getValueNotDefine(SuppArray[0].CITY1);
          SuppCOMPANY_GSTIN = getValueNotDefine(SuppArray[0].COMPANY_GSTIN);
          SuppPANNO = getValueNotDefine(SuppArray[0].PANNO);
          SuppMO = getValueNotDefine(SuppArray[0].MO);
          SuppPH1 = getValueNotDefine(SuppArray[0].PH1);
          SuppGROUPcode = getValueNotDefine(SuppArray[0].GP);
          suppGroupArr = getGroupDetailsBySendCode(SuppGROUPcode);
          if (suppGroupArr.length > 0) {
            SuppGroupName = suppGroupArr[0].partyname;
          }
        }
        console.log(BLS[i].DT)
        document.title = BLS[i].VNO;

        var chqAmt = parseFloat(BLS[i].DRA) + parseFloat(BLS[i].CRA);

        div += `
        <div class="page" style="min-height: auto;">
      <table class="table-responsive" style="width:100%;font-size:10px;">

      <tr  class="upperCase">
      <td style="text-align:left;"></td>
      <td style="text-align:center;"> ! ! SHREE GANESHAYA NAMAH ! ! </td>
      <td style="text-align:right;">PH :  `+ getValueNotDefine(firmArray[0].MOBILE) + `,  ` + getValueNotDefine(firmArray[0].PHONE1) + `</td>
    
      </tr>
    
      <tr  class="upperCase">
      <td style="text-align:center;font-size: 28px;font-weight: bolder;" colspan="3">`+ MainFirmName + `</td>
      </tr>
  
      <tr  class="upperCase"style="font-weight:bold;">
      <td style="text-align:left;"><p class="hideCoGST" style="display:none;">GSTIN : `+ CO_COMPANY_GSTIN + `</p></td>
      <td style="text-align:center;">`+ CO_ADD1 + `,` + CO_ADD1 + `,` + CO_CITY + `</td>
      <td style="text-align:right;"><p class="hideCoPanNo" style="display:none;">PAN : `+ CO_PANNO + `</p></td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:center;font-size: 27px;font-weight: bolder;" colspan="3">`+ BillName + `</td>
      </tr>

      <tr>
      <td colspan="3"><hr class="pdfhr"></td>
      </tr>
      
      <tr  class="upperCase" style="font-weight:bold;">
      <td style="text-align:left;"colspan="2">VOUCHER  NO .`+ BLS[i].VNO + `</td>
      <td style="text-align:left;">  DATE : `+ formatDate(BLS[i].DT) + `  </td>
      </tr>
      
      <tr  class="upperCase" style="">
      <td style="text-align:left;"colspan="2"> FROM: `+ pcode + `</td>
      <td style="text-align:left;"><p class="hideSupplierName">  TO  : `+ SuppName + ` </p> </td>
      </tr>
      
      
      <tr  class="upperCase" style="">
      <td style="text-align:left;"colspan="2">CITY : `+ city + `</td>
      <td style="text-align:left;"> <p class="hideSupplierName">    `+ SuppADD1 + ` </p> </td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2"> `+ getValueNotDefine(AD1) + `</td>
      <td style="text-align:left;"><p class="hideSupplierName">  `+ SuppADD2 + ` ,` + SuppCITY + ` </p></td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:left;"colspan="2">`+ getValueNotDefine(AD2) + ` , ` + city + `  </td>
      <td style="text-align:left;"><p class="hideSupplierName"> PH: `+ SuppMO + `,` + SuppPH1 + ` </p></td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:left;font-weight:bolder;"colspan="2"> <p class="hidesupplierGroupname">SUPPLIER GROUP : `+ SuppGroupName + ` </p></td>
      <td style="text-align:left;"> </td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:left;"colspan="3"><p class="hideMSG1">WE ARE ENCLOSING FOLLOWING CHEQUE/DDS. PLEASE ACKNOWLEDGE</p></td>
      </tr>
      
      <tr  class="upperCase">
      <td style="text-align:left;">CHQ/DD NO. : `+ getValueNotDefine(BLS[i].DCNO) + ` </td>
      <td style="text-align:left;">CHQ/DD. DATE :`+ (BLS[i].OD) + `</td>
      <td style="text-align:left;">AMOUNT :`+ parseFloat(chqAmt).toFixed(2) + `</td>
      </tr>

      <tr  class="upperCase">
      <td style="text-align:left;"colspan="3">DRAWEE BANK: `+ getValueNotDefine(BLS[i].OC) + `</td>
      </tr>

      <tr>
      <td colspan="3"><hr class="pdfhr"></td>
      </tr>
      
      </table>      
      <div style="min-height:15%;">
        `;

        DET = getProductDetails(BLS[i].CNO, BLS[i].TYPE, BLS[i].VNO);
        // DET = DETdata.filter(function (data) {
        //   return data.CNO.toUpperCase() == .toUpperCase() &&
        //     data.TYPE.toUpperCase() == BLS[i].TYPE.toUpperCase() &&
        //     data.VNO.toUpperCase() == BLS[i].VNO.toUpperCase();
        // })
        console.log(DET);
        var totalG = 0;
        var totalBA = 0;
        var totalAD = 0;
        var totalC = 0;
        var totalRD = 0;
        var totalD = 0;
        var totalA = 0;
        var totalO = 0;
        if (DET.length > 0) {
          div += `
          <table  class="" style="width:100%;font-size:12px;">
          <tr style="font-weight:bold;" class="upperCase">
          <td>BILL NO</td>
          <td>DATE</td>
          <td class="hideGross alignRight">GROSS AMT</td>
          <td class="alignRight">BILL AMT</td>
          <td class="hideGRAMT alignRight">GR AMT</td>
          <td class="hideRDAMT alignRight">RD AMT</td>
          <td class="hideDISC alignRight">DISC%</td>
          <td class="hideDISCAMT alignRight">DISC AMT</td>
          <td class="hideADDAMT alignRight">ADD AMT</td>
          <td class="hideOTHLS alignRight">OTH LS</td>
          <td class="alignRight">DAYS</td>    
          <td class="alignRight">ADJUSTED</td>    
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
            sr += 1;

            var C = parseFloat(billDet[k].C);
            var RD = parseFloat(billDet[k].RD);
            var D = parseFloat(billDet[k].D);
            var A = parseFloat(billDet[k].A);
            var O = parseFloat(billDet[k].O);
            var G = parseFloat(getValueNotDefineNo(billDet[k].G));
            var BA = parseFloat(billDet[k].BA);
            var AD = parseFloat(billDet[k].AD);

            // console.log(billDet[k]);
            div += `<tr class="upperCase">
              <td>`+ getValueNotDefine(billDet[k].BL) + `</td>
              <td >`+ formatDate(billDet[k].DTE) + `</td>
              <td class="hideGross alignRight">`+ parseFloat(G).toFixed(2) + `</td>
              <td class="alignRight">`+ parseFloat(BA).toFixed(2) + `</td>
              <td class="hideGRAMT alignRight">`+ parseFloat(getValueNotDefineNo(billDet[k].C)).toFixed(2) + `</td>
              <td class="hideRDAMT alignRight">`+ parseFloat(getValueNotDefineNo(billDet[k].RD)).toFixed(2) + `</td>
              <td class="hideDISC alignRight">`+ parseFloat(getValueNotDefineNo(billDet[k].DA)).toFixed(2) + `</td>
              <td class="hideDISCAMT alignRight">`+ parseFloat(getValueNotDefineNo(billDet[k].D)).toFixed(2) + `</td>
              <td class="hideADDAMT alignRight">`+ parseFloat(getValueNotDefineNo(billDet[k].A)).toFixed(2) + `</td>
              <td class="hideOTHLS alignRight">`+ parseFloat(getValueNotDefineNo(billDet[k].O)).toFixed(2) + `</td>
              <td class="alignRight">`+ getDaysDif(billDet[k].DTE, getValueNotDefine(BLS[i].CD))+ `</td>
              <td class="alignRight">`+ parseFloat(AD).toFixed(2) + `</td>
              </tr>`;

            totalG += G;
            totalBA += BA;
            totalAD += AD;
            totalC += C;
            totalRD += RD;
            totalD += D;
            totalA += A;
            totalO += O;
          }
        }

        var dif= chqAmt- totalAD;
        div += ` 
       
      <tr>
      <td colspan="15"><hr class="pdfhr"></td>
      </tr>

      <tr>
            <td >Total</td>
            <td ></td>
            <td class="hideGross alignRight">`+ parseFloat(totalG).toFixed(2) + `</td>
            <td class="alignRight">`+ parseFloat(totalBA).toFixed(2) + `</td>
            <td class="hideGRAMT alignRight">`+ parseFloat(totalC).toFixed(2) + `</td>
            <td class="hideRDAMT alignRight">`+ parseFloat(totalRD).toFixed(2) + `</td>
            <td class="hideDISC alignRight"></td>
            <td class="hideDISCAMT alignRight">`+ parseFloat(totalD).toFixed(2) + `</td>
            <td class="hideADDAMT alignRight">`+ parseFloat(totalA).toFixed(2) + `</td>
            <td class="hideOTHLS alignRight">`+ parseFloat(totalO).toFixed(2) + `</td>
            <td class="hideDISC alignRight"></td>
            <td class="alignRight">`+ parseFloat(totalAD).toFixed(2) + `</td>
          </tr>
     

      </table>
      </div>   
        
    <table style="width:100%;font-size:12px;">   
`;


        div += `
      <tr>
      <td colspan="3"><hr class="pdfhr"></td>
      </tr>`;

      if(dif!=0){
        div += `
        
        <tr style="font-weight:bold;" class="hideRemark1">    
        <td  colspan="2"style="text-align:left;"> DIFF. ADJUSTMENT:- `+ parseFloat(dif).toFixed(2) + `</td>
        <td  colspan="1"style="text-align:RIGHT;"></td>
        </tr>`;
      }

      div += `
      <tr style="font-weight:bold;" class="hideRemark1">    
      <td  colspan="2"style="text-align:left;">REMARK :- `+ getValueNotDefine(BLS[i].RMK) + `</td>
      <td  colspan="1"style="text-align:RIGHT;"></td>
      </tr>

      <tr style="font-weight:bold;" class="hideRemark2">    
      <td  colspan="2"style="text-align:left;">REMARK OTHER:- `+ getValueNotDefine(BLS[i].ORMK) + `</td>
      <td  colspan="1"style="text-align:RIGHT;"></td>
      </tr>

      <tr style="font-weight:bold;" class="hideCommAmt" >    
      <td  colspan="2"style="text-align:left;"></td>
      <td  colspan="1"style="text-align:RIGHT;">COMM. AMT `+ parseFloat(getValueNotDefineNo(BLS[i].CM)).toFixed(2) + `</p></td>
      </tr>
      <tr>
      <td colspan="3"></td>
      </tr>
      <tr>
      <td colspan="3"></td>
      </tr>
      <tr>
      <td colspan="3"></td>
      </tr>
      <tr>
      <td colspan="3"></td>
      </tr>
      
      <tr STYLE="">
      <td style="text-align:left;">RECEIVER'S SIGNATURE</td>
      <td style="text-align:CENTER;"> </td>
      <td style="text-align:RIGHT;font-weight:bold;">FOR `+ MainFirmName + `</td>
      </tr>

    </table>
    </div>
      `;
        BILL = getValueNotDefine(BLS[i].VNO);
        var BILL = BILL.replaceAll(/[^\w\s]/gi, '');
        document.title = "V NO " + BILL;

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
