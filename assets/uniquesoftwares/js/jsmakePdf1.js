
var url = window.location.href;
var lastBillNo = "";
var BLS;
var DET;
var DETdata = [];
var div = '';
var CurrentBillDetails = [];
var billNos = (getUrlParams(url, "billNos"));
var CNO = (getUrlParams(url, "CNO"));
var TYPE = (getUrlParams(url, "TYPE"));
var VNO = (getUrlParams(url, "VNO"));
var BillDetSetting = (getUrlParams(url, "BillDetSetting"));
BillDetSetting = BillDetSetting == null ? "[]" : BillDetSetting;
BillDetSettingJson = JSON.parse(BillDetSetting);
var productLimit = 15;
if (BillDetSettingJson.length > 0) {
  var newroductLimit = BillDetSettingJson[0].billProductlimit;
  productLimit = newroductLimit == undefined || newroductLimit == null || newroductLimit == "" ? productLimit : newroductLimit;
}
function TaxArraySum(DTVTRET) {
  return CurrentBillDetails.filter(function (d) {
    return d.DTVTRET == DTVTRET;
  })
}
function TaxArrayRet(TaxArray, billDetails, STC, CNO_stateCode) {
  CurrentBillDetails = billDetails;
  console.log(TaxArray)
  var tr = ` <table style="width: 100%;border-collapse: collapse;font-size: 12px;text-align:right;">`;
  for (let i = 0; i < TaxArray.length; i++) {
    var TaxArrayFiltered = TaxArraySum(TaxArray[i]);
    console.log(TaxArrayFiltered)
    if (TaxArrayFiltered.length > 0) {
      var HSN = "";
      var TotalTaxableAMT = 0;
      var DTVTAMT = 0;
      var DTVTRET = 0;
      var TotalCgst = 0;
      for (let j = 0; j < TaxArrayFiltered.length; j++) {
        HSN = getValueNotDefine(TaxArrayFiltered[j].hsn);
        TotalTaxableAMT += parseFloat(TaxArrayFiltered[j].AMT);
        DTVTAMT += parseFloat(TaxArrayFiltered[j].DTVTAMT);
        DTVTRET = parseFloat(TaxArrayFiltered[j].DTVTRET);
      }
      console.log(STC, CNO_stateCode);
      if (parseInt(STC) != (CNO_stateCode)) {
        tr += `
      <tr >
      <td>HSN: `+ (HSN) + `</td>
      <td> @ `+ (DTVTRET) + `%</td>
      <td> GST AMT:<b>`+ parseFloat(DTVTAMT).toFixed(2) + `</b></td>
      </tr>
      `;
      } else {
        // DTVTAMT=DTVTAMT/2;
        tr += `
        <tr >
        <td>HSN: `+ (HSN) + `</td>
        <td> @ `+ (DTVTRET) + `%</td>
        <td> CGST AMT:<b>`+ parseFloat(DTVTAMT).toFixed(2) + `</b></td>
        </tr>
        <tr >
        <td>HSN: `+ (HSN) + `</td>
        <td> @ `+ (DTVTRET) + `%</td>
        <td> SGST AMT:<b>`+ parseFloat(DTVTAMT).toFixed(2) + `</b></td>
        </tr>
      `;
      }
    }
  }
  tr += `
  </table>`;
  // console.log(tr)
  return tr;
}
function filterBillDetailsByBillNos(billDetails, FilterArr) {
  // console.log(FilterArr)
  return billDetails.filter((el) => {
    return FilterArr.some((f) => {
      return f === el.VNO;
    });
  });
}

function boolfilterBillDetailsByBillNos(billDetails, FilterArr) {
  // console.log(FilterArr)
  var billDetails = billDetails.filter((el) => {
    return FilterArr.some((f) => {
      return f === el.VNO;
    });
  });
  if (billDetails.length > 0) {
    return true;
  } else {
    return false;
  }
}
function loadBillPdfCall() {
  div = '';
  Data = BLSdata
  $("#loader").addClass('has-loader');
  try {
    if (PDFBILLTYPE != "BULK" && PDFBILLTYPE != "BULK_FILTERED") {
      if (VNO == null || VNO == "") {
        showErrorInBill();
        return;
      }
    }

    if ((CNO != '' && CNO != null) && (TYPE != '' && TYPE != null) && (VNO != '' && VNO != null)) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => billDetails['CNO'].toUpperCase().trim() == CNO.toUpperCase().trim()
          && billDetails['TYPE'].toUpperCase().trim() == TYPE.toUpperCase().trim()
          && billDetails['VNO'].toUpperCase().trim() == VNO.toUpperCase().trim());
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return ((billDetails['CNO'].toUpperCase().trim() == CNO.toUpperCase().trim()
              && billDetails['TYPE'].toUpperCase().trim() == TYPE.toUpperCase().trim()
              && billDetails['VNO'].toUpperCase().trim() == VNO.toUpperCase().trim()));
          })
        }
      })
    } else {
      Data = Data;

      if (this.cno != '' && this.cno != null) {

        Data = Data.filter(function (data) {
          return data.billDetails.some((billDetails) => billDetails['CNO'] === this.cno);
        }).map(function (subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function (billDetails) {
              return (billDetails['CNO'] === this.cno);
            })
          }
        })
      }

      if (partycode != '' && partycode != null) {
        partycode = partycode
        Data = Data.filter(function (d) {
          return d.code.trim().toUpperCase() == partycode.trim().toUpperCase();
        })
      }

      if (this.broker != '' && this.broker != null) {
        Data = Data.filter(function (data) {
          return data.billDetails.some((billDetails) => billDetails['BCODE'] === this.broker);
        }).map(function (subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function (billDetails) {
              return (billDetails['BCODE'] === this.broker);
            })
          }
        })
      }
      if (this.haste != '' && this.haste != null) {
        Data = Data.filter(function (data) {
          return data.billDetails.some((billDetails) => billDetails['haste'] === this.haste);
        }).map(function (subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function (billDetails) {
              return (billDetails['haste'] === this.haste);
            })
          }
        })
      }
      if (fromdate != '' && fromdate != null) {
        Data = Data.filter(function (data) {
          return data.billDetails.some((billDetails) => new Date(DateRpl(billDetails.DATE)).setHours(0, 0, 0, 0) >= new Date(DateRpl(fromdate)).setHours(0, 0, 0, 0));
        }).map(function (subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function (billDetails) {
              return new Date(DateRpl(billDetails.DATE)).setHours(0, 0, 0, 0) >= new Date(DateRpl(fromdate)).setHours(0, 0, 0, 0);
            })
          }
        })
      }
      // console.log(fromdate, Data);

      if (todate != '' && todate != null) {
        Data = Data.filter(function (data) {
          return data.billDetails.some((billDetails) => new Date(DateRpl(billDetails.DATE)).setHours(24, 0, 0, 0) <= new Date(DateRpl(todate)).setHours(24, 0, 0, 0));
        }).map(function (subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function (billDetails) {
              return new Date(DateRpl(billDetails.DATE)).setHours(24, 0, 0, 0) <= new Date(DateRpl(todate)).setHours(24, 0, 0, 0);
            })
          }
        })
      }

      if (search_FromVNO != '' && search_FromVNO != null) {
        Data = Data.filter(function (data) {
          return data.billDetails.some((billDetails) => parseInt(billDetails['VNO']) >= parseInt(search_FromVNO));
        }).map(function (subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function (billDetails) {
              return (parseInt(billDetails['VNO']) >= parseInt(search_FromVNO));
            })
          }
        })
      }

      if (search_ToVNO != '' && search_ToVNO != null) {
        Data = Data.filter(function (data) {
          return data.billDetails.some((billDetails) => parseInt(billDetails['VNO']) <= parseInt(search_ToVNO));
        }).map(function (subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function (billDetails) {
              return (parseInt(billDetails['VNO']) <= parseInt(search_ToVNO));
            })
          }
        })
      }

      if (billNos != null && billNos != "" && billNos != undefined) {
        billNosList = (billNos.split(","));
        if (billNosList.length > 0) {
          Data = Data.filter(function (data) {
            return boolfilterBillDetailsByBillNos(data.billDetails, billNosList);
          }).map(function (subdata) {
            return {
              code: subdata.code,
              billDetails: filterBillDetailsByBillNos(subdata.billDetails, billNosList)
            }
          })
        }
      }
    }

    // alert("-"+CNO+"-"+TYPE+"-"+VNO+"-");

    // console.log(todate, Data);
    BLS = Data;
    var sortBls = [];
    for (var i = 0; i < BLS.length; i++) {
      var billDetails = BLS[i].billDetails;
      billDetails = billDetails.map(function (a, b) {
        a.code = BLS[i].code;
        sortBls.push(a);
        return a;
      })
    }
    sortBls.sort(function (a, b) {
      return parseInt(a.VNO) - parseInt(b.VNO);
    });
    $("#billNoId").html("titleBillName")

    if (sortBls.length > 0) {
      for (var i = 0; i < sortBls.length; i++) {

        var titleBill = "";
        // BLS[i].billDetails[j].code = BLS[i].code;
        var billElement = sortBls[i];
        var NEWBLS = checkForDouble([billElement]);
        console.log(NEWBLS);
        for (let x = 0; x < NEWBLS.length; x++) {
          // console.log(NEWBLS[x].billDetails);
          partyArray = getPartyDetailsBySendCode(NEWBLS[x].code);
          // console.log("partyArray", partyArray);
          var AD3 = "";
          var AD4 = "";
          var partyEmail = ""
          var partyname = "";
          var FIRM_NAME = "";
          if (partyArray.length > 0) {
            try {
              partyname = getValueNotDefine(partyArray[0]["partyname"]);
              AD3 = getValueNotDefine(partyArray[0]["AD3"]);
              AD4 = getValueNotDefine(partyArray[0]["AD4"]);
              var MO = getValueNotDefine(partyArray[0]["MO"]);
              var EML = getValueNotDefine(partyArray[0]["EML"]);
              partyEmail = EML;
              passMobileNoEmail(MO, EML);

            } catch (error) {

            }
          }
          firmArray = getFirmDetailsBySendCode(NEWBLS[x].billDetails.CNO);
          // console.log("FIRM", firmArray);
          var stateCode = parseInt(firmArray[0].COMPANY_GSTIN.substring(0, 2));

          titleBillName = NEWBLS[x].billDetails.BILL;
          titleBillName = titleBillName.replace("\/", "-");

          titleBill = titleBillName;
          var OtherRmk = getValueNotDefine(firmArray[0]["MSME"]);
          if (OtherRmk == '' || OtherRmk == null) {
            OtherRmk = (firmArray[0]["EMAIL"]);
            if (OtherRmk == '' || OtherRmk == null) {
              OtherRmk = '-';
            }
          }
          try {
            document.getElementById("type").value = NEWBLS[x].billDetails.TYPE;
            document.getElementById("firm").value = NEWBLS[x].billDetails.CNO;
            document.getElementById("billNo").value = NEWBLS[x].billDetails.VNO;

          } catch (error) {

          }
          // Clnt = DSN.replace(Currentyear, "");
          // Clnt = atob(Clnt);
          var logoBll = getDataUserSetting("logoBll");
          var logoBillStyle = "background-image: url('http://aashaimpex.com/logos/" + Clnt + ".jpeg";
          if (logoBll == 0) {
            logoBillStyle = "background-image:none;";
          }
          var imgObjList = [];

          try {
            ReportType = " SALES ";
            ReportATypeCode = "1";
            ReportSeriesTypeCode = "S";
            ReportDOC_TYPECode = "";
            var hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(NEWBLS[x].code) + "&partyname=" + encodeURIComponent(NEWBLS[x].code) + "&FIRM=" + encodeURIComponent(firmArray[0].FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&mobileNo=" + partyArray[0].MO + "&partyEmail=" + encodeURIComponent(partyEmail);
            // console.log(hrefLink)
            document.getElementById("hrefSALE").href = "ALLSALE_AJXREPORT.html" + hrefLink + "&";
            document.getElementById("hrefOUTSTANDING").href = "OUTSTANDING_AJXREPORT.html" + hrefLink;
            document.getElementById("hrefLEDGER").href = "LEDGER_AJXREPORT.html" + hrefLink;
            document.getElementById("hrefITEMWISESALE").href = "ALLSALE_AJXREPORT.html" + hrefLink + "&REPORTTYPE=ITEM+WISE+PARTY+WISE";
            document.getElementById("hrefBank").href = "bankPassBook_AJXREPORT.html" + hrefLink + "&REPORTTYPE=ITEM+WISE+PARTY+WISE";


          } catch (error) {
            alert(error);
          }
          iosTransformCss = "";
          if (deviceIsIos == "true") {
            // iosTransformCss=`transform: scale(1);transform-origin: 0 0;`;
          }
          var transportArr = getTransportId(NEWBLS[x].billDetails.TRNSP);
          var transportId = "";
          if (transportArr.length > 0) {
            transportId = getValueNotDefine(transportArr[0]["value"]);
          }
          div += `
            <div class="pageNew table-responsive" style="
              background-size: 300px 100px;
              background-position-x: center;
              background-position-y: 82%;
              background-repeat: no-repeat;
              max-height:100%;
              ${logoBillStyle}">
              <div class="table-responsive">
                <div style="width:100%;display:flex;${iosTransformCss}">
                  <div style="display:inline; text-align: right;float: left;width: 60%;">
                    <div class="hideShreeGaneshayNamaha font12">
                      !!Shree Ganeshay Namaha!!
                    </div>
                  </div>
                  <div style="display:inline;text-align: right; float: left;width: 40%;" class="font12">
                    Phone: ${getValueNotDefine(firmArray[0]["MOBILE"])}, ${getValueNotDefine(firmArray[0]["PHONE1"])}
                  </div>
                </div>
                <div style="width:100% !important;display:flex;">
                  <div class="font11" style="display:inline;text-align: left; float: left;font-weight:bold;width: 33.33%;">
                    <b class="hideOriginalForBuyer">Original For Buyer</b>
                  </div>
                  <div class="font11" style="display:inline;text-align: center; float: left;font-weight:bold;width: 33.33%;">
                    <b class="hideDuplicateForTransporter">Duplicate For Transporter</b>
                  </div>
                  <div class="font11" style="display:inline;text-align: right; float: left;font-weight:bold;width: 33.33%;">
                    <b class="hideTriplicateForConsignor">Triplicate for Consignor</b>
                  </div>
                </div>
                <div style="width:100%;text-align:center !important;">
                  <div class="font26" style="text-align:center !important;font-weight:700;">
                    ${firmArray[0]["FIRM"]}
                  </div>
                </div>
                <div style="width:100%;display:flex;">
                  <div style="display:inline;text-align: left; float: left;width: 25%;font-weight: bold;" class="font12">
                    GSTIN: ${getValueNotDefine(firmArray[0]["COMPANY_GSTIN"])}
                  </div>
                  <div style="display:inline;text-align: center; float: left;width: 50%;font-weight: bold;" class="font12">
                    ${getValueNotDefine(OtherRmk)}
                  </div>
                  <div style="display:inline;text-align: right; float: left;width: 25%;font-weight: bold;" class="font12">
                    PAN NO.: ${getValueNotDefine(firmArray[0]["PANNO"])}
                  </div>
                </div>
                <div style="width:100%;">
                  <div class="font14" style="text-align: center;">
                    ${getValueNotDefine(firmArray[0]["ADDRESS1"])}, ${getValueNotDefine(firmArray[0]["ADDRESS2"])}, ${getValueNotDefine(firmArray[0]["CITY1"])}
                  </div>
                </div>
              `;

          var Series = (NEWBLS[x].billDetails.SERIES);
          var Type = (NEWBLS[x].billDetails.TYPE);
          // console.log(Series, Type);
          var BillType = Series;
          if (((Series).toUpperCase()).indexOf('SALE') > -1 && ((Type).toUpperCase()).indexOf('S') > -1 && ((Series).toUpperCase()).indexOf('RETURN') < 0) {
            BillType = "TAX INVOICE";
          }
          lastBillNo = "-" + NEWBLS[x].billDetails.BILL;
          div += `
            <div style="width:100%;"> 
              <div class="font23" style="text-align: center;">${BillType}</div>
            </div>
            <hr class="pdfhr">
            <div style="width:100%;display:flex;">
              <div class="font14" style="text-align: left; float: left; width: 50%; font-weight: bold;">
                Buyer: ${getValueNotDefine(partyArray[0]["partyname"])}
              </div>
              <div class="font14" style="text-align: right; float: right; width: 50%; font-weight: bold;">
                BILL NO: ${getValueNotDefine(NEWBLS[x].billDetails.BILL)}
              </div>
            </div>
            <div style="width:100%;display:flex;">
              <div class="font14" style="text-align: left; float: left; width: 50%;">
                -${getValueNotDefine(partyArray[0]["AD1"])}
              </div>
              <div class="font14" style="text-align: right; float: right; width: 50%;">
                CHALLAN: ${getValueNotDefine(NEWBLS[x].billDetails.O)}
              </div>
            </div>
            <div style="width:100%;display:flex;">
              <div class="font14" style="text-align: left; float: left; width: 50%;">
                -${getValueNotDefine(partyArray[0]["AD2"])}
              </div>
              <div class="font14" style="text-align: right; float: right; width: 50%;">
                DATE: ${formatDate(NEWBLS[x].billDetails.DATE)}
              </div>
            </div>
            <div style="width:100%;display:flex;">
              <div class="font14" style="display:inline; text-align: left; float: left; width: 40%;">
                -${getValueNotDefine(partyArray[0]["city"])}
              </div>
              <div class="font14" style="display:inline; text-align: center; float: left; width: 40%;">
                -${getValueNotDefine(partyArray[0]["PNO"])}
              </div>
              <div class="font14" style="display:inline; text-align: right; float: left; width: 20%;">
                P.O.: ${getValueNotDefine(NEWBLS[x].billDetails.O)}
              </div>
            </div>
            <div style="width:100%;">
              <div class="font14" style="display:inline; text-align: left; float: left; width: 33.33%;">
                GSTIN: ${getValueNotDefine(partyArray[0]["GST"])}
              </div>
              <div class="font14" style="display:inline; text-align: center; float: left; width: 66%;">
                Place of Supply: ${getValueNotDefine(NEWBLS[x].billDetails.STC)}
              </div>
            </div>
            <hr class="pdfhr">
          `;
          div += `
            <div style="width:100%;">
              <div style="display:inline; text-align: left; float: left; width: 100%;" class="font14">
              Consignee: <b class="hidehaste">${getValueNotDefine(NEWBLS[x].billDetails.haste)}</b>
              </div>
            </div>
            <div style="width:100%;"> 
              <div style="display:inline; text-align: left; float: left; width: 100%;" class="font14">
              DELIVERY: <b class="hideDeilvery">${AD3}, ${AD4}</b>
              </div>
            </div>
            <hr class="pdfhr">
            `;

          // div += `
          // <div style="width:100%";>
          // <div style="display:inline;text-align: left; float: left;
          // width: 100%;
          // "class="font14"></div>
          // </div>
          // <div style="width:100%"> 
          //             <div style="display:inline;text-align: left; float: left;
          //             width:100%;
          //             "class="font14">GSTIN:</div>
          // </div>

          // <hr class="pdfhr">
          // `;

          if (NEWBLS[x].billDetails.BCODE != null && NEWBLS[x].billDetails.BCODE != '') {
            var brokerArray = (getPartyDetailsBySendCode(NEWBLS[x].billDetails.BCODE));
            div += `
              <div style="width:100%;">
                <div style="display:inline; text-align: left; float: left; width: 50%;" class="font14">
                  AGENT: ${getValueNotDefine(brokerArray[0]["partyname"])}
                </div>
                <div style="display:inline; text-align: center; float: left; width: 50%;" class="font14">
                  PHONES: ${getValueNotDefine(brokerArray[0]["PH1"])}, ${getValueNotDefine(brokerArray[0]["MO"])}
                </div>
              </div>
              <div style="width:100%;"> 
                <div style="display:inline; text-align: left; float: left; width:100%;" class="font14">
                  ADDRESS: ${getValueNotDefine(brokerArray[0]["AD1"])}, ${getValueNotDefine(brokerArray[0]["AD2"])}
                </div>
              </div>
            `;

          } else {
            div += `
              <div style="width:100%;">
                <div style="display:inline; text-align: left; float: left; width: 50%;" class="font14">
                  AGENT:
                </div>
                <div style="display:inline; text-align: center; float: left; width: 50%;" class="font14">
                  PHONES:
                </div>
              </div>
              <div style="width:100%;"> 
                <div style="display:inline; text-align: left; float: left; width:100%;" class="font14">
                  ADDRESS:
                </div>
              </div>
            `;
          }



          div += `
            <hr class="pdfhr">
            <div style="width:100%">
              <div style="display:inline; text-align: left; float: left; width: 40%;" class="font14">
                L.R. NO.: ${getValueNotDefine(NEWBLS[x].billDetails.RRNO)}
              </div>
              <div style="display:inline; text-align: left; float: left; width: 30%;" class="font14">
                LR DATE: ${getValueNotDefine(formatDate(NEWBLS[x].billDetails.RRDET))}
              </div>
              <div style="display:inline; text-align: center; float: left; width: 30%;" class="font14">
                WEIGHT: ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.WGT))}
              </div>
            </div>
            <div style="width:100%">
              <div style="display:inline; text-align: left; float: left; width: 40%;" class="font14">
                TRANSPORT: ${getValueNotDefine(NEWBLS[x].billDetails.TRNSP)}
              </div>
              <div style="display:inline; text-align: left; float: left; width: 30%;" class="font14">
                CASE NO: ${getValueNotDefine(NEWBLS[x].billDetails.CSNO)} X ${getValueNotDefine(NEWBLS[x].billDetails.PRCL)}
              </div>
              <div style="display:inline; text-align: center; float: left; width: 30%;" class="font14">
                FREIGHT: ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.FRT))}
              </div>
            </div>
            <div style="width:100%">
              <div style="display:inline; text-align: left; float: left; width: 50%;" class="font14">
                STATION: ${getValueNotDefine(NEWBLS[x].billDetails.PLC)}
              </div>
              <div style="display:inline; text-align: left; float: left; width: 50%;" class="font14">
                HSN/SAC:
              </div>
            </div>
            <div style="width:100%">
              <div class="font14" style="display:inline; text-align: left; float: left; font-weight: bold; width: 33.33%;">
                Distance(Km): ${getValueNotDefine(NEWBLS[x].billDetails.DST)}
              </div>
              <div class="font12" style="display:inline; text-align: left; float: left; font-weight: bold; width: 33.33%;">
                Transporter ID: ${transportId}
              </div>
              <div class="font14" style="display:inline; text-align: center; float: left; font-weight: bold; width: 33.33%;">
                E-Way Bill no: ${getValueNotDefine(NEWBLS[x].billDetails.EWB)}
              </div>
            </div>
            <hr class="pdfhr">
            <div class="bottomBorder font10 table-responsive" style="width: 100%; min-height: 35vh; display: flex; font-weight: 900;">
              <div style="display: flex; width: 100%;">
          `;
          var Gst_Slab = '';
          DET = NEWBLS[x].productDetails;

          if (DET.length > 0) {
            div += `
              <table class="table font12" style="width: 100%; height: fit-content; text-align: left;">
                <thead>
                  <tr style="width:100%;">
                    <th class="hideQualityparticulars">SR. PARTICULARS</th>
                    <th class="hidebaleNo" style="display:none;">BALE</th>
                    <th class="hideMainScreen" style="display:none;">MAINSCREEN</th>
                    <th class="hideCOLOR" style="display:none;">COLOR</th>
                    <th class="hideCategory" style="display:none;">CATEGORY</th>
                    <th class="hidePCK" style="display:none;">PACKING</th>
                    <th class="hidePCKRATE" style="display:none;">PACK.RATE</th>
                    <th class="hideQUALITYNAME" style="display:none;">QUALITY</th>
                    <th class="hideHSN">HSN</th>
                    <th class="hidePCS">PCS</th>
                    <th class="hideCUT">CUT</th>
                    <th class="hideMTR">MTR</th>
                    <th class="hideNETMTS" style="display:none;">NET MTS.</th>
                    <th class="hideFOLDLESS" style="display:none;">FOLD.LESS.</th>
                    <th class="hideRATE">RATE</th>
                    <th class="hidePER">PER</th>
                    <th class="hideDISC" style="display:none;">DISC</th>
                    <th class="hideAMOUNT">AMOUNT</th>
                  </tr>
                </thead>
                <tbody>
            `;

            var billDet = (NEWBLS[x].productDetails);
            console.log(billDet);
            var sr = 0;
            billDet = billDet.sort(function (a, b) {
              return parseInt(a.SRNO) - parseInt(b.SRNO);
            })

            var TaxArray = [];
            var flagTaxArray = [];
            for (var k = 0; k < billDet.length; k++) {
              sr += 1
              console.log(billDet[k].DTVTRET)
              if (!flagTaxArray[billDet[k].DTVTRET]) {
                TaxArray.push(billDet[k].DTVTRET);
                flagTaxArray[billDet[k].DTVTRET] = true;
              }
              var CTGRY = billDet[k].CTGRY == null || billDet[k].CTGRY == "" ? "" : billDet[k].CTGRY;
              var LESS_FOLD = parseFloat(billDet[k].LF);;
              var NET_MTS = parseFloat(billDet[k].MTS);
              if (billDet[k].LF != "" && billDet[k].LF != null && billDet[k].LF != undefined) {
                var MTS = parseFloat(billDet[k].MTS);
                LESS_FOLD = parseFloat(billDet[k].LF);
                var lessMts = (MTS * LESS_FOLD) / 100;
                NET_MTS = MTS - lessMts;
              }
              var url = getImgUrl(billDet[k].qual);
              if (url != "") {
                billDet[k].url = url;
                imgObjList.push(billDet[k]);
              }
              div += `
                <tr>
                  <td class="hideQualityparticulars">${getValueNotDefine(billDet[k].SR_NEW)}-${getValueNotDefine(billDet[k].qual)}</td>
                  <td class="hidebaleNo" style="display:none;">${getValueNotDefine(billDet[k].CN)}</td>
                  <td class="hideMainScreen" style="display:none;">${getValueNotDefine(billDet[k].altql)}</td>
                  <td class="hideCOLOR" style="display:none;">${CTGRY}</td>
                  <td class="hideCategory" style="display:none;">${CTGRY}</td>
                  <td class="hidePCK" style="display:none;">${getValueNotDefine(billDet[k].PCK)}</td>
                  <td class="hidePCKRATE" style="display:none;">${parseFloat(getValueNotDefineNo(billDet[k].disamt)).toFixed(2)}</td>
                  <td class="hideQUALITYNAME" style="display:none;">${getValueNotDefine(billDet[k].BSQL)}</td>
                  <td class="hideHSN">${billDet[k].hsn}</td>
                  <td class="hidePCS">${getValueNotDefine(valuetoFixedNo(billDet[k].PCS))}</td>
                  <td class="hideCUT">${getValueNotDefine(parseFloat(billDet[k].CUT).toFixed(2))}</td>
                  <td class="hideMTR">${getValueNotDefine(parseFloat(billDet[k].MTS).toFixed(2))}</td>
                  <td class="hideNETMTS" style="display:none;">${NET_MTS}</td>
                  <td class="hideFOLDLESS" style="display:none;">${parseFloat(LESS_FOLD).toFixed(2)}</td>
                  <td class="hideRATE">${getValueNotDefine(parseFloat(billDet[k].RATE).toFixed(2))}</td>
                  <td class="hidePER">${getValueNotDefine(billDet[k].UNIT)}</td>
                  <td class="hideDISC" style="display:none;">${getValueNotDefine(billDet[k].DR)}</td>
                  <td class="hideAMOUNT">${getValueNotDefine(valuetoFixed(billDet[k].AMT))}</td>
                </tr>
              `;

              if (billDet[k].DET != undefined && billDet[k].DET != null && billDet[k].DET != "") {
                div += `
                  <tr>
                    <td class="hideCOLORSBOTTOM" colspan="12">- ${getValueNotDefine(billDet[k].DET)}</td>
                  </tr>
                `;
              }

            }
            Gst_Slab = TaxArrayRet(TaxArray, billDet, NEWBLS[x].billDetails.STC, stateCode);


            div += ` </table>`;
          } else {
            // console.log(JSON.stringify(NEWBLS[x]));
            if (getValueNotDefine(NEWBLS[x].billDetails.QUAL) != "") {
              div += `
                <table class="table font12" style="width: 100%; height: fit-content; text-align: left;">
                  <tr style="width:100%;">
                    <th class="hideQualityparticulars">ITEM</th>
                    <th class="hidePCS">PCS</th>
                    <th class="hideMTR">MTR</th>
                    <th class="hideRATE">RATE</th>
                    <th class="hideAMOUNT">AMOUNT</th>
                  </tr>
                  <tr>
                    <td class="hideQualityparticulars">${getValueNotDefine(NEWBLS[x].billDetails.QUAL)}</td>
                    <td class="hidePCS">${getValueNotDefine(NEWBLS[x].billDetails.TPCS)}</td>
                    <td class="hideMTR">${parseFloat(getValueNotDefineNo(NEWBLS[x].billDetails.TMTS)).toFixed(2)}</td>
                    <td class="hideRATE">${getValueNotDefine(NEWBLS[x].billDetails.GRT)}</td>
                    <td class="hideAMOUNT">${parseFloat(getValueNotDefine(NEWBLS[x].billDetails.grsamt)).toFixed(2)}</td>
                  </tr>
                </table>
              `;
            }
          }

          var grossAmt = (getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.grsamt)));
          div += `
            </div>
                </div>
                <div>
            <hr class="pdfhr">
            <div style="display:inline; text-align: left; float: left; width: 100%; font-weight: bold;" class="font12">
              BANK A/C NO.: ${getValueNotDefine(firmArray[0]["ADDRESS3"])} - IFSC CODE: ${getValueNotDefine(firmArray[0]["ADDRESS4"])}
            </div>
            <div style="width:100%;">          
              <div style="display:inline; text-align: left; float: left; font-weight:bold; width: 50%;" class="font12">
                REMARK: ${getValueNotDefine(NEWBLS[x].billDetails.RMK)}
              </div>
            </div>
            <hr class="pdfhr">
            <div style="display:inline; text-align: left; float: left; width: 30%;" class="font14">
              SUB TOTAL
            </div>
            <div style="display:inline; text-align: left; float: left; width: 20%;" class="font14">
              PCS - ${getValueNotDefine(valuetoFixedNo(NEWBLS[x].billDetails.TPCS))}
            </div>
            <div class="hMts" style="display:inline; text-align: left; float: left; width: 30%;" class="font14">
              MTS - ${getValueNotDefine(parseFloat(NEWBLS[x].billDetails.TMTS).toFixed(2))}
            </div>
            <div style="display:inline; text-align: right; float: left; width: 20%;" class="font14">
              ${grossAmt}
            </div>
            <hr class="pdfhr">
                </div>
          `;
          var taxablevalue = parseFloat(grossAmt);

          if (NEWBLS[x].billDetails.LA1RATE != 0) {
            div += `
              <div class="hideAddLess1" style="display:inline; text-align: right; float: left; width:92%;" class="font14">
                ${getValueNotDefine(NEWBLS[x].billDetails.LA1RMK)} -> ${getValueNotDefine(NEWBLS[x].billDetails.LA1qty)} X ${getValueNotDefine(NEWBLS[x].billDetails.LA1RATE)}% : ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.LA1AMT))}
              </div>
            `;
            taxablevalue = taxablevalue + parseFloat(getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.LA1AMT)));
          }
          if (NEWBLS[x].billDetails.LA2RATE != 0) {
            div += `
              <div class="hideAddLess2" style="display:inline; text-align: right; float: left; width:92%;" class="font14">
              ${getValueNotDefine(NEWBLS[x].billDetails.LA2RMK)} -> ${getValueNotDefine(NEWBLS[x].billDetails.LA2qty)} X ${getValueNotDefine(NEWBLS[x].billDetails.LA2RATE)} : ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.LA2AMT))}
              </div>
            `;
            taxablevalue = taxablevalue + parseFloat(getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.LA2AMT)));
          }


          if (NEWBLS[x].billDetails.LA3RATE != 0) {
            div += `
              <div class="hideAddLess3" style="display:inline; text-align: right; float: left; width:92%;" class="font14">
              ${getValueNotDefine(NEWBLS[x].billDetails.LA3RMK)} -> ${getValueNotDefine(NEWBLS[x].billDetails.LA3qty)} X ${getValueNotDefine(NEWBLS[x].billDetails.LA3RATE)} : ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.LA3AMT))}
              </div>
            `;
            taxablevalue = taxablevalue + parseFloat(getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.LA3AMT)));
          }

          if ((NEWBLS[x].billDetails.VTAMT) != null && (NEWBLS[x].billDetails.VTAMT) != "" && parseInt(NEWBLS[x].billDetails.VTAMT) != 0) {

            var stateCode = parseInt(firmArray[0].COMPANY_GSTIN.substring(0, 2));
            if (parseInt(NEWBLS[x].billDetails.STC) != (stateCode)) {

              if (getValueNotDefineNo(NEWBLS[x].billDetails.VTRET) != 0) {
                div += `
                  <div style="width:100%">
                    <div style="display:inline; text-align: right; float: left; width:92%;" class="font14">
                      IGST @ ${getValueNotDefine(NEWBLS[x].billDetails.VTRET)}% on Taxable Value ${valuetoFixed(getValueNotDefine(taxablevalue))} = ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.VTAMT))}
                    </div>
                  </div>
                `;
              } else {
                div += `
                  <div style="width:100%">
                    <div style="display:inline; text-align: right; float: right; width:60%;">
                      ${Gst_Slab}
                    </div>
                  </div>
                `;
              }
            } else {
              if (getValueNotDefineNo(NEWBLS[x].billDetails.VTRET) != 0) {
                div += `
                  <div style="width:100%">
                    <div style="display:inline; text-align: right; float: left; width:92%;" class="font14">
                      CGST @ ${getValueNotDefine(NEWBLS[x].billDetails.VTRET)}% on Taxable Value ${grossAmt} = ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.VTAMT))}
                    </div>
                  </div>
                  <div style="width:100%">
                    <div style="display:inline; text-align: right; float: left; width:92%;" class="font14">
                      SGST @ ${getValueNotDefine(NEWBLS[x].billDetails.ADVTRET)}% on Taxable Value ${grossAmt} = ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.ADVTAMT))}
                    </div>
                  </div>
                `;
              } else {
                div += `
                  <div style="width:100%">
                    <div style="display:inline; text-align: right; float: right; width:60%;">
                      ${Gst_Slab}
                    </div>
                  </div>
                `;
              }
            }
          }
          if (getValueNotDefineNo(NEWBLS[x].billDetails.TDSAMT) != 0) {
            var tdsTcsTitle = "TDS";
            if (BillType == "TAX INVOICE") {
              tdsTcsTitle = "TCS";
            }
            div += `
              <div style="display:inline; text-align: right; float: left; width: 92%;" class="font14">
                ${tdsTcsTitle} @ ${getValueNotDefine(NEWBLS[x].billDetails.TDSRATE)}% : ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.TDSAMT))}
              </div>
            `;
          }

          div += `
            <hr class="pdfhr">
            <div style="display: flex; width: 100%; align-items: flex-start;">
              <div style="text-align: left; float: left; width: 70%; font-weight: bold;" class="font13">
                DUE DAYS FROM BILL DATE: ${getValueNotDefine(getDaysDif(NEWBLS[x].billDetails.DATE, new Date()))}
              </div>
              <div style="text-align: right; width: 30%; font-weight: bolder;" class="font13">
                GRAND TOTAL: ${getValueNotDefine(valuetoFixed(NEWBLS[x].billDetails.BAMT))}
              </div>
            </div>
            <hr class="pdfhr">
            <div style="width:100%;">
              <div class="font8" style="display:inline; text-align: left; float: left; width: 50%;">
                TERMS & CONDITIONS:-
              </div>
              <div class="font10" style="display:inline; text-align: right; float: right; width: 50%;">
                FOR: ${getValueNotDefine(firmArray[0]["FIRM"])}
              </div>
            </div>
            <div class="font8" style="display:inline; text-align: left; float: left; width: 100%;">
              1. SUBJECT TO SURAT JURISDICTION.
            </div>
            <div class="font8" style="display:inline; text-align: left; float: left; width: 100%;">
              2. GOODS HAVE BEEN SOLD & DESPATCHED AT ENTIRE RISK OF PURCHASER.
            </div>
            <div class="font8" style="display:inline; text-align: left; float: left; width: 100%;">
              3. COMPLAINTS, IF ANY REGARDING THIS INVOICE MUST BE INFORMED IN WRITING WITHIN 48 HOURS
            </div>
            <div style="width:100%; display: flex;">
              <div class="font8" style="text-align: left; width: 33.33%;">CHECKED BY</div>
              <div class="font8" style="text-align: center; width: 33.33%;">DELIVERED BY</div>
              <div class="font8" style="text-align: right; width: 33.33%;">AUTH. SIGNATORY</div>
            </div>
            <div class="font8" style="text-align:left; overflow-wrap: break-word; word-wrap: break-word; width: 100%; max-width: 100%;">
              Einvoice IRN: ${getValueNotDefine((NEWBLS[x].billDetails.I))}
            </div>
          </div>
          </div>
          `;
          if (imgObjList.length > 0) {
            var pdfFileExist = false;
            var imgCard = "";
            for (let index = 0; index < imgObjList.length; index++) {
              const element = imgObjList[index];
              var id = stringHashCode(element.qual);
              console.log(element.url);
              var mimeType = getMimeType(element.url);
              if (mimeType == "pdf") {
                pdfFileExist = true;
                $("body").append(`<div id="pdfContainer" class="hidePdfAttach" style="width: 100%;"></div>`)
                var container = document.getElementById("pdfContainer");

                pdfjsLib.getDocument(element.url).promise.then(pdf => {
                  const numPages = pdf.numPages;
                  for (let pageNumber = 1; pageNumber <= numPages; pageNumber++) {
                    pdf.getPage(pageNumber).then(page => {
                      const scale = 1;
                      const viewport = page.getViewport({ scale });
                      const canvas = document.createElement("canvas");
                      const context = canvas.getContext("2d");
                      canvas.height = viewport.height;
                      canvas.width = viewport.width;
                      container.appendChild(canvas);

                      const renderContext = {
                        canvasContext: context,
                        viewport: viewport
                      };
                      page.render(renderContext);
                    });
                  }
                });
              } else {
                imgCard += `
                  <div class="image-wrapper" id="`+ id + `">
                    <img src="`+ element.url + `" onerror="handleImageError('` + id + `')"onclick="viewImageByLink('` + url + `')"/>
                    <div class="image-name">`+ element.qual + `</div>
                  </div>
                   `;
              }
            }
            if (!pdfFileExist) {
              div += `<div style="min-height:100%;width:100%"  class="hideBillImg image-container">`;
              div += imgCard;
              div += `</div>`;
            }
          }
          getExtraProductImageFile(imgObjList);
        }

      }

      // document.body.innerHTML = div;
      // console.log(div);
      $("#result").html(div)
      $("#loader").removeClass('has-loader');
      $("#billNoId").html(titleBillName)
      hideList();
      document.title = "BILL NO- " + titleBill;
      //   JsBarcode("#barcode", "123456789", {
      //     height: 10 // Set the desired height in pixels
      // });
    } else {
      showErrorInBill();
    }

  } catch (error) {
    noteError(error);
  }
}




function checkForDouble(d) {
  console.log(d);
  var ReturnArr = [];
  var Data = d;
  var limit = productLimit;
  console.log((limit));
  newArr = [];
  for (let i = 0; i < Data.length; i++) {
    var productDet = getProductDetailsArray(Data[i].CNO, Data[i].TYPE, Data[i].VNO);
    console.log(productDet, Data[i].CNO, Data[i].TYPE, Data[i].VNO);
    var productLength = 1;
    if (productDet.length > 0) {
      productLength = productDet.length;
    }
    var obj = {};
    // console.log("111")
    ReturnArr = filterBillData(Data, Data[i], productDet, productLength, limit)
    // console.log(ReturnArr)
    obj.code = Data[i].code;
    obj.BLS = ReturnArr;
    newArr.push(obj);
  }
  return ReturnArr;
}

function filterBillData(Data, billDetails, productDetails, productLength, limit) {
  try {
    var startIndex = 0;
    var limitIndex = limit;
    var devide = productLength / limit;
    var loop = Math.ceil(devide);
    var newArr = [];
    var pointLoop = devide.toString().substring(1, 3);
    lastIndexLength = parseFloat(pointLoop).toFixed(2) * limit;
    for (let k = 0; k < loop; k++) {
      if (k != 0) {
        startIndex += limit;
        limitIndex += limit;
      }
      var obj = {};
      obj.code = Data[0].code;
      var subArr = [];
      console.log(productDetails);
      for (let l = startIndex; l < limitIndex; l++) {
        // console.log(k, startIndex, limitIndex);
        try {
          productDetails[l].SR_NEW = l + 1;
        } catch (error) {
        }
        ele = productDetails[l];
        subArr.push(ele);
      }
      subArr = subArr.filter(function (d) {
        return d != undefined;
      })
      obj.billDetails = billDetails;
      obj.productDetails = subArr;
      newArr.push(obj);
    }
    console.log(newArr);
    return newArr;
  } catch (error) {
    noteError(error);
  }
}


function getProductDetailsArray(CNO, TYPE, VNO) {

  var newArr = [];
  for (let z = 0; z < DETdata.length; z++) {
    // console.log(DETdata[z].billDetails);
    if (DETdata[z].CNO.toUpperCase() == CNO.toUpperCase() && DETdata[z].TYPE.toUpperCase() == TYPE.toUpperCase() && DETdata[z].VNO.toUpperCase() == VNO.toUpperCase()) {
      newArr = (DETdata[z].billDetails);
    }
  }
  return newArr;
}


function getImgUrl(name) {
  var url = "";
  if (PRODUCTIMG_LIST != null) {
    var p = PRODUCTIMG_LIST.filter(function (d) {
      return getValueNotDefine(d.name).toUpperCase() == name.toUpperCase();
    });
    if (p.length > 0) {
      url = p[0]["img"]["0"];
    }
  }
  return url;
}

function handleImageError(id) {
  $('#' + id).css("display:none;")
}


function showErrorInBill() {
  msgshoerror = "";
  try {
    VNO = document.getElementById('billNo').value
    selectedType = document.getElementById("type").options[document.getElementById("type").selectedIndex].text;
    selectedFirm = document.getElementById("firm").options[document.getElementById("firm").selectedIndex].text;

    msgshoerror = "<h3>COMPANY = " + selectedFirm + "</h3>";
    if (PDFBILLTYPE != "BULK" && PDFBILLTYPE != "BULK_FILTERED") {
      msgshoerror += `<h3 style="color:red;">TYPE = ` + selectedType + `</h3>`;
    }
    msgshoerror += "<h3>VNO = " + VNO + "</h3>";
  } catch (error) {

  }
  var innerHTML = "<h1 align='center'>Invalid input<h1><br>" + msgshoerror;
  $("#result").html(innerHTML)
  $("#loader").removeClass('has-loader');
  $("#billNoId").html("Invalid input")
}


function getTransportId(transportName) {
  return TRANSPORT.filter(function (d) {
    return d.label.toString().trim() == transportName.toString().trim()
  })
}