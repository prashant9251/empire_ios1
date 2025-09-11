var GRD;
var url = window.location.href;
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

function loadCall(Data) {
  //---------------
  // Data = Data.filter(function (data) {
  //   return data.billDetails.some((bill) => (bill.DT) != null);
  // }).map(function (subdata) {
  //   return {
  //     code: subdata.code,
  //     billDetails: subdata.billDetails.filter(function (bill) {
  //       return (bill.DT) != null;
  //     })
  //   }
  // })

  var ReportType = getUrlParams(url, "ReportType");
  var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
  var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
  var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");

  console.log(ReportType, ReportSeriesTypeCode, ReportATypeCode, ReportDOC_TYPECode);
  var ReportDOC_TYPECode_CN = "";
  var ReportDOC_TYPECode_DN = "";
  if (ReportType != "" && ReportType != null) {
    if (ReportSeriesTypeCode.toUpperCase() == 'P') {
      ReportDOC_TYPECode = "ZP";
      ReportDOC_TYPECode_CN = "CN";
      ReportDOC_TYPECode_DN = "DN";
      ReportSeriesTypeCode = "";
    } else if (ReportSeriesTypeCode.toUpperCase() == 'S') {
      ReportDOC_TYPECode = "OS";
      ReportDOC_TYPECode_CN = "CN";
      ReportDOC_TYPECode_DN = "DN";
      ReportSeriesTypeCode = "";
    }

    if (ReportATypeCode != "" && ReportATypeCode != "" && ReportATypeCode != undefined) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((bill) => ((bill.ATYP)) == (ReportATypeCode) && (bill.DT) != null);
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (bill) {
            return ((bill.ATYP)) == (ReportATypeCode) && (bill.DT) != null;
          })
        }
      })
    }
    if (ReportDOC_TYPECode_CN != "" && ReportDOC_TYPECode_DN != "" && ReportDOC_TYPECode != "") {
      Data = Data.filter(function (data) {
        return data.billDetails.some((bill) =>
          bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode_CN) > -1
          || bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode_DN) > -1 ||
          bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode) > -1);
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (bill) {
            return bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode_CN) > -1
              || bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode_DN) > -1 ||
              bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode) > -1;
          })
        }
      })
    }
    if (ReportDOC_TYPECode != "" && ReportDOC_TYPECode != "" && ReportDOC_TYPECode != undefined) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((bill) => bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode) > -1
          || bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode_DN) > -1 ||
          bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode_CN) > -1);
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (bill) {
            return bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode) > -1
              || bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode_DN) > -1 ||
              bill.DT.toUpperCase().indexOf(ReportDOC_TYPECode_CN) > -1;
          })
        }
      })
    }

    if (ReportSeriesTypeCode != "" && ReportSeriesTypeCode != "" && ReportSeriesTypeCode != undefined) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((bill) => ((bill.TYPE).toUpperCase()).indexOf(ReportSeriesTypeCode.toUpperCase())) > -1;
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (bill) {
            return ((bill.TYPE).toUpperCase()).indexOf(ReportSeriesTypeCode.toUpperCase()) > -1;
          })
        }
      })
    }


  }

  if (cno != '' && cno != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => billDetails['CNO'] === cno);
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails['CNO'] === cno);
        })
      }
    })
  }
  //  console.log("BLS",Data);
  if (partycode != '' && partycode != null) {
    partycode = partycode.trim();
    Data = Data.filter(function (data) {
      return data.code == partycode;
    })
  }
  //  console.log("BLS",Data);
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
  //  console.log("BLS",Data);
  if (CITY != '' && CITY != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => billDetails['CITY'] == this.CITY);
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails['CITY'] == this.CITY);
        })
      }
    })
  }
  //  console.log("BLS",Data);
  if (haste != '' && haste != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => billDetails['haste'] === haste);
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails['haste'] === haste);
        })
      }
    })
  }
  // console.log("BLS", Data);
  if (fromdate !== '' && fromdate !== null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => new Date(billDetails.DATE).setHours(0, 0, 0, 0) >= new Date(fromdate).setHours(0, 0, 0, 0));
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return new Date(billDetails.DATE).setHours(0, 0, 0, 0) >= new Date(fromdate).setHours(0, 0, 0, 0);
        })
      }
    })
  }
  // console.log("BLS", Data);
  if (todate !== '' && todate !== null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => new Date(billDetails.DATE).setHours(24, 0, 0, 0) <= new Date(todate).setHours(24, 0, 0, 0));
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return new Date(billDetails.DATE).setHours(24, 0, 0, 0) <= new Date(todate).setHours(24, 0, 0, 0);
        })
      }
    })
  }

  if (GRD != '' && GRD != null && GRD != undefined) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => billDetails['GRD'] === GRD);
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails['GRD'] === GRD);
        })
      }
    })
  }
  // console.log("grd", Data);
  var GST;
  var FdataUrl;
  var DETAILSDET;
  var ccode;
  var pcode;
  var city;
  var broker;
  var label;
  var grandTotalGrossAmt;
  var grandTotalfinalAmt;
  var grandtotalMTS;
  var totalGrossAmt;
  var totalFinalAmt;
  var DL = Data.length;
  var BLL;
  var totalsr = 0;
  if (DL > 0) {
    grandTotalGrossAmt = 0;
    grandTotalfinalAmt = 0;
    grandtotalMTS = 0;
    tr = "<tbody>";
    for (i = 0; i < DL; i++) {

      ccode = getPartyDetailsBySendCode(Data[i].code);
      // console.log(Data[i].code+"-",ccode);
      pcode = getValueNotDefine(ccode[0].partyname);
      city = getValueNotDefine(ccode[0].city);
      broker = getValueNotDefine(ccode[0].broker);
      label = getValueNotDefine(ccode[0].label);
      tr += `
                <tr class="trPartyHead"  onclick="trOnClick('` + Data[i].code + `','` + city + `','` + broker + `');">
                          <th  class="trPartyHead" colspan="13">` + label + `</th>                                    
                        </tr>`;
      tr += `<tr style="font-weight:500;"align="center">
                    
                        <td>PDF</td>
                        <td>BILL</td>
                        <td>DATE</td>
                        <td>FIRM</td>
                        <td>GROSS.AMT</td>
                        <td>GST</td>
                        <td>TYPE</td>
                        <td class="hqual" >QUAL</td>
                        <td class="hmts" >MTS</td>
                        <td>FINAL AMT</td>
                        <td>PAID</td>
                        <td>AG./HASTE</td>
                        <td class="TRNSPT">TRANSPORT</td>
                        <td class="TRNSPT">LR NO</td>
                        <td class="GRD">GRADE</td>
                        </tr>`;
      BLL = Data[i].billDetails.length;
      if (BLL > 0) {

        totalGrossAmt = 0;
        totalFinalAmt = 0;
        totalMTS = 0;
        sr = 0;
        for (j = 0; j < BLL; j++) {
          sr += 1;
          var grsAmt = 0;
          var fnlAmt = 0;
          if (Data[i].billDetails[j].DT != null && Data[i].billDetails[j].DT != "") {
            if (Data[i].billDetails[j].DT.toUpperCase().indexOf('CN')) {
              grsAmt = +Math.abs(Data[i].billDetails[j].grsamt);
              fnlAmt = +Math.abs(Data[i].billDetails[j].BAMT);
            } else if (Data[i].billDetails[j].DT.toUpperCase().indexOf('DN')) {
              grsAmt = -Math.abs(Data[i].billDetails[j].grsamt);
              fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
            } else if (Data[i].billDetails[j].DT.toUpperCase().indexOf('OS')) {
              grsAmt = -Math.abs(Data[i].billDetails[j].grsamt);
              fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
            } else {
              grsAmt = -Math.abs(Data[i].billDetails[j].grsamt);
              fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
            }
          } else {
            grsAmt = -Math.abs(Data[i].billDetails[j].grsamt);
            fnlAmt = -Math.abs(Data[i].billDetails[j].BAMT);
          }
          TMTS = Data[i].billDetails[j].TMTS == null ? 0 : parseFloat(Data[i].billDetails[j].TMTS);
          totalGrossAmt += parseFloat(grsAmt);
          totalFinalAmt += parseFloat(fnlAmt);
          totalMTS += TMTS;
          GST = parseFloat(Data[i].billDetails[j].VTAMT) + parseFloat(Data[i].billDetails[j].ADVTAMT);
          FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE);

          var BrokerHaste = '';
          var HST = Data[i].billDetails[j].haste;
          if (HST != '' && HST != null && HST != undefined) {
            BrokerHaste = HST;
          } else {
            BrokerHaste = Data[i].billDetails[j].BCODE;
          }
          tr += `<tr align="center"class="hideAbleTr">
                        <th><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                        <td><a href="`+ FdataUrl + `" target="_blank"><button>` + Data[i].billDetails[j].BILL + `</button><a></td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + formatDate(Data[i].billDetails[j].DATE) + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].FRM + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(grsAmt) + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(GST) + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].SERIES + `</td>
                        <td class="hqual" onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].QUAL) + `</td>
                        <td class="hmts" onclick="openSubR('`+ Data[i].code + `')">` + TMTS + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + valuetoFixed(fnlAmt) + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + Data[i].billDetails[j].paid + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(BrokerHaste) + ` </td>
                        <td class="TRNSPT"onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].TRNSP) + `</td>
                        <td class="TRNSPT"onclick="openSubR('`+ Data[i].code + `')">` + getValueNotDefine(Data[i].billDetails[j].RRNO) + `</td>
                        <td onclick="openSubR('`+ Data[i].code + `')"class="GRD">` + getValueNotDefine(Data[i].billDetails[j].GRD) + ` </td>
                        </tr>`;
          if (productDet == 'Y') {
            // console.log(Data[i].billDetails[j].IDE);
            DETAILSDET = jsgetArrayProductdetailsbyIDE(Data[i].billDetails[j].IDE);
            // console.log(DETAILSDET);
            if (DETAILSDET.length > 0) {

              tr += `

                      <tr>
                          <td><strong></strong></td>
                          <td class="text-center">ITEM</td>
                          <td class="text-center"><strong>PCS</strong></td>
                          <td class="text-center"><strong>PACK</strong></td>
                          <td class="text-center"><strong>UNIT</strong></td>
                          <td class="text-center"><strong>CUT</strong></td>
                          <td class="text-center"><strong>RATE</strong></td>
                          <td class="text-center"><strong>MTS</strong></td>
                          <td class="text-right"><strong>AMT</strong></td>
                      </tr>
                      `;
              for (m = 0; m < DETAILSDET[0].length; m++) {
                tr += `<tr class="hideAbleTr">
                            <td class="text-center"></td>
                            <td class="text-center">`+ DETAILSDET[0][m]['qual'] + `</td>
                            <td class="text-center">`+ Number(DETAILSDET[0][m]['PCS']) + `</td>
                          <td class="text-center">`+ DETAILSDET[0][m]['PCK'] + `</td>
                          <td class="text-center">`+ DETAILSDET[0][m]['UNIT'] + `</td>
                          <td class="text-center">`+ DETAILSDET[0][m]['CUT'] + `</td>
                          <td class="text-center">`+ valuetoFixed(DETAILSDET[0][m]['RATE']) + `</td>
                          <td class="text-center">`+ valuetoFixed(DETAILSDET[0][m]['MTS']) + `</td>
                          <td class="text-center">`+ valuetoFixed(DETAILSDET[0][m]['AMT']) + `</td>
                          </tr>`;
              }
            }
          }
        }
      }
      grandTotalGrossAmt += totalGrossAmt;
      grandTotalfinalAmt += totalFinalAmt;
      grandtotalMTS += totalMTS;
      tr += `<tr class="tfootcard">
                        <td colspan="3">TOTAL</td>
                        <td>(`+ sr + `)<td>
                        <td class="text-center">`+ valuetoFixed(totalGrossAmt) + `</td>
                        <td colspan="3"></td>
                        <td  class="hmts" colspan="1">`+ valuetoFixed(totalMTS) + `</td>
                        <td class="text-center">`+ valuetoFixed(totalFinalAmt) + `</td>
                        <td colspan="1"></td>
                        <td colspan="1"></td>
                        <td class="TRNSPT"colspan="2"></td>
                        <td class="GRD"colspan="1"></td>
                        </tr>`;

      totalsr += sr;
    }
    tr += `
                    <tr class="tfootcard">
                    <td colspan="3">GRAND TOTAL</td>
                    <td>(`+ totalsr + `)<td>
                    <td>`+ valuetoFixed(grandTotalGrossAmt) + `</td>
                    <td colspan="3"></td>
                    <td  class="hmts" colspan="1">`+ valuetoFixed(grandtotalMTS) + `</td>
                    <td>`+ valuetoFixed(grandTotalfinalAmt) + `</td>
                    <td colspan="1"></td>
                    <td colspan="1"></td>
                    <td class="TRNSPT"colspan="2"></td>
                    <td class="GRD"colspan="1"></td>
                    </tr></tbody>`;

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    //    if ((url).indexOf('ALLSALE_AJXREPORT') < 0) {
    //      $(".TRNSPT").css("display", "none");
    //    }
    if (GRD == '' || GRD == null) {
      $('.GRD').css("display", "none");
    }

    var hideAbleTr = getUrlParams(url, "hideAbleTr");
    if (hideAbleTr == "true") {
      $('.hideAbleTr').css("display", "none");
    }
    if (url.indexOf('PURCHASE_AJXREPORT') < 0) {
      $('.hmts').css("display", "none");
      $('.hqual').css("display", "none");
    }

    var aftr_loadtime = new Date().getTime();
    // Time calculating in seconds  
    pgloadtime = (aftr_loadtime - before_loadtime) / 1000
    // alert(pgloadtime);
  } else {
    $('#result').html('<h1 align="center">No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }
  // try { } catch (error) {
  //   alert(error)
  // $('#result').html(tr);
  // $("#loader").removeClass('has-loader');

  // }
}
