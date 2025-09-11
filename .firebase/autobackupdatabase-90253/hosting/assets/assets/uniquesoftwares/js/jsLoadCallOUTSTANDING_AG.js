
var ReportType = getUrlParams(url, "ReportType");
var ReportSeriesTypeCode = getUrlParams(url, "ReportSeriesTypeCode");
var ReportATypeCode = getUrlParams(url, "ReportATypeCode");
var ReportDOC_TYPECode = getUrlParams(url, "ReportDOC_TYPECode");
var chqFilterOnDate = getUrlParams(url, "chqFilterOnDate");

console.log(ReportType, ReportSeriesTypeCode, ReportATypeCode, ReportDOC_TYPECode);

//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
//-----------function-------
function SaleOutstandingReportFilter(Data) {

  if (ReportATypeCode != "" && ReportATypeCode != "" && ReportATypeCode != undefined) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((bill) => bill.ATYPE == ReportATypeCode);
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (bill) {
          return bill.ATYPE == ReportATypeCode;
        })
      }
    })
  }

  //------
  if (ReportDOC_TYPECode != "" && ReportDOC_TYPECode != "" && ReportDOC_TYPECode != undefined) {
    console.log(ReportDOC_TYPECode)
    Data = Data.filter(function (data) {

      return data.billDetails.some((bill) =>
        (bill.DT != null && bill.DT.toUpperCase() == ReportDOC_TYPECode.toUpperCase())
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('DN') > -1)
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('CN') > -1)
        || bill.TYPE.toUpperCase().indexOf('XX') > -1
        || bill.TYPE.toUpperCase().indexOf('B') > -1
        || bill.TYPE.toUpperCase().indexOf('C') > -1
        || bill.TYPE.toUpperCase().indexOf('J') > -1
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('ZP') > -1));
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (bill) {
          return (bill.DT != null && bill.DT.toUpperCase() == ReportDOC_TYPECode.toUpperCase())
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('DN') > -1)
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('CN') > -1)
            || bill.TYPE.toUpperCase().indexOf('XX') > -1
            || bill.TYPE.toUpperCase().indexOf('B') > -1
            || bill.TYPE.toUpperCase().indexOf('C') > -1
            || bill.TYPE.toUpperCase().indexOf('J') > -1
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('ZP') > -1);
        })
      }
    })
    console.log(Data);

  }
  //------



  if (ReportSeriesTypeCode != "" && ReportSeriesTypeCode != "" && ReportSeriesTypeCode != undefined) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((bill) => bill.TYPE.toUpperCase().indexOf(ReportSeriesTypeCode.toUpperCase()) > -1
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('DN') > -1)
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('CN') > -1)
        || bill.TYPE.toUpperCase().indexOf('XX') > -1
        || bill.TYPE.toUpperCase().indexOf('B') > -1
        || bill.TYPE.toUpperCase().indexOf('C') > -1
        || bill.TYPE.toUpperCase().indexOf('J') > -1
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('ZP') > -1));
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (bill) {
          return bill.TYPE.toUpperCase().indexOf(ReportSeriesTypeCode.toUpperCase()) > -1
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('DN') > -1)
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('CN') > -1)
            || bill.TYPE.toUpperCase().indexOf('XX') > -1
            || bill.TYPE.toUpperCase().indexOf('B') > -1
            || bill.TYPE.toUpperCase().indexOf('C') > -1
            || bill.TYPE.toUpperCase().indexOf('J') > -1
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('ZP') > -1);
        })
      }
    })
  }
  return Data;
}
//-----------function-------
function PurchaseOutstandingReportFilter(Data) {
  if (ReportATypeCode != "" && ReportATypeCode != "" && ReportATypeCode != undefined) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((bill) => bill.ATYPE == ReportATypeCode);
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (bill) {
          return bill.ATYPE == ReportATypeCode;
        })
      }
    })
  }

  //------
  if (ReportDOC_TYPECode != "" && ReportDOC_TYPECode != "" && ReportDOC_TYPECode != undefined) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((bill) => (bill.DT != null && bill.DT.toUpperCase() == ReportDOC_TYPECode.toUpperCase())
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('DN') > -1)
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('CN') > -1)
        || bill.TYPE.toUpperCase().indexOf('XX') > -1
        || bill.TYPE.toUpperCase().indexOf('B') > -1
        || bill.TYPE.toUpperCase().indexOf('C') > -1
        || bill.TYPE.toUpperCase().indexOf('J') > -1
      );
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (bill) {
          return (bill.DT != null && bill.DT.toUpperCase() == ReportDOC_TYPECode.toUpperCase())
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('DN') > -1)
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('CN') > -1)
            || bill.TYPE.toUpperCase().indexOf('XX') > -1
            || bill.TYPE.toUpperCase().indexOf('B') > -1
            || bill.TYPE.toUpperCase().indexOf('C') > -1
            || bill.TYPE.toUpperCase().indexOf('J') > -1
            ;
        })
      }
    })
  }
  //------
  if (ReportSeriesTypeCode != "" && ReportSeriesTypeCode != "" && ReportSeriesTypeCode != undefined) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((bill) => (bill.DT != null && bill.TYPE.toUpperCase().indexOf(ReportSeriesTypeCode.toUpperCase()) > -1)
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('DN') > -1)
        || (bill.DT != null && bill.DT.toUpperCase().indexOf('CN') > -1)
        || bill.TYPE.toUpperCase().indexOf('XX') > -1
        || bill.TYPE.toUpperCase().indexOf('B') > -1
        || bill.TYPE.toUpperCase().indexOf('C') > -1
        || bill.TYPE.toUpperCase().indexOf('J') > -1
      );
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (bill) {
          return (bill.DT != null && bill.TYPE.toUpperCase().indexOf(ReportSeriesTypeCode.toUpperCase()) > -1)
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('DN') > -1)
            || (bill.DT != null && bill.DT.toUpperCase().indexOf('CN') > -1)
            || bill.TYPE.toUpperCase().indexOf('XX') > -1
            || bill.TYPE.toUpperCase().indexOf('B') > -1
            || bill.TYPE.toUpperCase().indexOf('C') > -1
            || bill.TYPE.toUpperCase().indexOf('J') > -1
            ;
        })
      }
    })
  }

  return Data;
}
var GRD;
function loadCall(data) {
  try {
    Data = data;

    if (cno != '' && cno != null) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => billDetails['CNO'] == cno);
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return (billDetails['CNO'] == cno);
          })
        }
      })
    }
    if (partycode != '' && partycode != null) {
      partycode = partycode.trim();
      Data = Data.filter(function (data) {
        return data['code'] == partycode;
      })
    }

    if (this.broker != '' && this.broker != null) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => billDetails['BCODE'] == this.broker);
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return (billDetails['BCODE'] == this.broker);
          })
        }
      })
    }

    if (CITY != '' && CITY != null) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => billDetails['CITY'] === CITY);
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return (billDetails['CITY'] === CITY);
          })
        }
      })
    }

    if (haste != '' && haste != null) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => billDetails['HST'] === haste);
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return (billDetails['HST'] === haste);
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
    if (fromdate != '' && fromdate != null && chqFilterOnDate == "true") {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) =>
          new Date(billDetails.DATE).setHours(0, 0, 0, 0) >= new Date(fromdate).setHours(0, 0, 0, 0))
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return ((billDetails.TYPE.toUpperCase().indexOf("B") > -1 || billDetails.TYPE.toUpperCase().indexOf("C") > -1)
              || (new Date(billDetails.DATE).setHours(0, 0, 0, 0) >= new Date(fromdate).setHours(0, 0, 0, 0)));
          })
        }
      })
    } else if (fromdate !== '' && fromdate !== null) {
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

    if (todate != '' && todate != null && chqFilterOnDate == "true") {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) =>
          new Date(billDetails.DATE).setHours(24, 0, 0, 0) <= new Date(todate).setHours(24, 0, 0, 0)
        )
      }).map(function (subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return ((billDetails.TYPE.toUpperCase().indexOf("B") > -1 || billDetails.TYPE.toUpperCase().indexOf("C") > -1) || (new Date(billDetails.DATE).setHours(24, 0, 0, 0) <= new Date(todate).setHours(24, 0, 0, 0)))

          })
        }
      })
    } else if (todate !== '' && todate !== null) {
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


    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => !(billDetails.TYPE.toUpperCase() == 'XX' && billDetails.VNO < 100000));
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return !(billDetails.TYPE.toUpperCase() == 'XX' && billDetails.VNO < 100000);
        })
      }
    })


    //---------------

    if (ReportType != "" && ReportType != null) {

      if (ReportSeriesTypeCode.toUpperCase() == 'P') {
        ReportDOC_TYPECode = "zp";
        Data = PurchaseOutstandingReportFilter(Data);
      } else if (ReportSeriesTypeCode.toUpperCase() == 'S') {
        ReportDOC_TYPECode = "os";
        ReportATypeCode = 1;
        Data = SaleOutstandingReportFilter(Data);
      } else {


        if (ReportATypeCode != "" && ReportATypeCode != "" && ReportATypeCode != undefined) {
          Data = Data.filter(function (data) {
            return data.billDetails.some((bill) => bill.ATYPE == ReportATypeCode);
          }).map(function (subdata) {
            return {
              code: subdata.code,
              billDetails: subdata.billDetails.filter(function (bill) {
                return bill.ATYPE == ReportATypeCode;
              })
            }
          })
        }

        //------
        if (ReportDOC_TYPECode != "" && ReportDOC_TYPECode != "" && ReportDOC_TYPECode != undefined) {
          Data = Data.filter(function (data) {
            return data.billDetails.some((bill) => (bill.DT != null && bill.DT.toUpperCase() == ReportDOC_TYPECode.toUpperCase()));
          }).map(function (subdata) {
            return {
              code: subdata.code,
              billDetails: subdata.billDetails.filter(function (bill) {
                return (bill.DT != null && bill.DT.toUpperCase() == ReportDOC_TYPECode.toUpperCase());
              })
            }
          })
        }
        //------
        if (ReportSeriesTypeCode != "" && ReportSeriesTypeCode != "" && ReportSeriesTypeCode != undefined) {
          Data = Data.filter(function (data) {
            return data.billDetails.some((bill) => bill.TYPE.toUpperCase() == ReportSeriesTypeCode.toUpperCase());
          }).map(function (subdata) {
            return {
              code: subdata.code,
              billDetails: subdata.billDetails.filter(function (bill) {
                return bill.TYPE.toUpperCase() == ReportSeriesTypeCode.toUpperCase();
              })
            }
          })
        }

      }


    }
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
    var totalDAYS30AMT = 0;
    var totalDAYS60AMT = 0;
    var totalDAYS90AMT = 0;
    var totalDAYS90UPAMT = 0;
    var grandtotalDAYS30AMT = 0;
    var grandtotalDAYS60AMT = 0;
    var grandtotalDAYS90AMT = 0;
    var grandtotalDAYS90UPAMT = 0;
    var BLL;
    var FdataUrl
    var DL = Data.length;
    var CNOArray = [];
    if (DL > 0) {

      grandtotalNETBILLAMT = 0;
      grandtotalGROSSAMT = 0;
      grandtotalGOODSRETURN = 0;
      grandtotalPAIDAMT = 0;
      grandtotalAmount = 0;
      grandtotalDAYS30AMT = 0;
      grandtotalDAYS60AMT = 0;
      grandtotalDAYS90AMT = 0;
      grandtotalDAYS90UPAMT = 0;
      for (var i = 0; i < DL; i++) {
        totalNETBILLAMT = 0;
        totalGROSSAMT = 0;
        totalGOODSRETURN = 0;
        totalPAIDAMT = 0;
        totalAmount = 0;
        totalDAYS30AMT = 0;
        totalDAYS60AMT = 0;
        totalDAYS90AMT = 0;
        totalDAYS90UPAMT = 0;
        ccode = getPartyDetailsBySendCode(Data[i].code);
        // console.log(Data[i].code+"-",ccode)
        pcode = ccode[0].partyname;
        city = ccode[0].city;
        broker = ccode[0].broker;
        label = ccode[0].label;

        tr += `<tr class="trPartyHead"onclick="trOnClick('` + Data[i].code + `','` + city + `','` + broker + `');">
                          <th colspan="17" class="trPartyHead">` + label + `<a href="tel:` + ccode[0].MO + `"><button>MO:` + getValueNotDefine(ccode[0].MO) + `</button></a></th>
                        </tr>
            <tr style="font-weight:500;"align="center">
            
            <td>BILL</td>
            <td>BILL NO.</td>
            <td>FIRM</td>
              <td>BILL&nbsp;DATE</td>
              <td>GROSS AMT</td>
              <td>NET BILL AMT</td>
              <td>GOODS RET.</td>
              <td>PAID AMT.</td>
              <td>AG./HASTE</td>
              <td class="GRD">GRADE</td>
              <td> DAYS</td>
              <td style="background-color:#0000ff4f;">1-30 DAYS</td>
              <td style="background-color:#588c7e91;">31-60 DAYS</td>
              <td style="background-color:#a761187a;">61-90 DAYS</td>
              <td style="background-color:#ff000030;">>90 DAYS</td>
              </tr>
            `;

        BLL = Data[i].billDetails.length;
        if (BLL > 0) {
          for (j = 0; j < BLL; j++) {

            if (CNOArray.indexOf(Data[i].billDetails[j].CNO) < 0) {
              CNOArray.push(Data[i].billDetails[j].CNO);
            }
            var GRSAMT = Data[i].billDetails[j].GRSAMT == null ? 0 : Data[i].billDetails[j].GRSAMT;
            var GST = Data[i].billDetails[j].GST == null ? 0 : Data[i].billDetails[j].GST;
            try {
              if (Data[i].billDetails[j].DT.trim() != "os") {
                GRSAMT = 0;
                GST = 0;
              }
            } catch (error) {

            }

            var FAMT = Data[i].billDetails[j].FAMT == null ? 0 : Data[i].billDetails[j].FAMT;
            var CLAIMS = Data[i].billDetails[j].CLAIMS == null ? 0 : Data[i].billDetails[j].CLAIMS;
            var RECAMT = Data[i].billDetails[j].RECAMT == null ? 0 : Data[i].billDetails[j].RECAMT;
            var PAMT = Data[i].billDetails[j].PAMT == null ? 0 : Data[i].billDetails[j].PAMT;
            totalGROSSAMT += parseFloat(GRSAMT);
            totalNETBILLAMT += parseFloat(FAMT);
            totalGOODSRETURN += parseFloat(CLAIMS);
            totalPAIDAMT += parseFloat(RECAMT);
            totalAmount += parseFloat(PAMT);
            var UrlPaymentSlip = getUrlPaymentSlip(Data[i].billDetails[j].CNO, (Data[i].billDetails[j].TYPE).replace("ZS", ""), Data[i].billDetails[j].VNO, (Data[i].billDetails[j].IDE).replace("ZS", ""));
            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE, ccode[0].MO);
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
            var DAYS30AMT = 0;
            var DAYS60AMT = 0;
            var DAYS90AMT = 0;
            var DAYS90UPAMT = 0;
            var DAYS30_STYLE = "";
            var DAYS60_STYLE = "";
            var DAYS90_STYLE = "";
            var DAYS90UP_STYLE = "";
            var daysDiff = getDaysDif(Data[i].billDetails[j].DATE, nowDate);
            trstyle = "";
            console.log(PAMT)
            if (daysDiff <= 30) {
              DAYS30AMT = PAMT;
              DAYS30_STYLE = "background-color:#0000ff4f;";
              trstyle = DAYS30_STYLE;
            } else if (daysDiff > 30 && daysDiff <= 60) {
              DAYS60AMT = PAMT;
              DAYS60_STYLE = "background-color:#588c7e91;";
              trstyle = DAYS60_STYLE;
            } else if (daysDiff > 60 && daysDiff <= 90) {
              DAYS90AMT = PAMT;
              DAYS90_STYLE = "background-color:#a761187a;";
              trstyle = DAYS90_STYLE;
            } else if (daysDiff > 90) {
              DAYS90UPAMT = PAMT;
              DAYS90UP_STYLE = "background-color:#ff000030;";
              trstyle = DAYS90UP_STYLE;
            }
            totalDAYS30AMT += parseFloat(DAYS30AMT);
            totalDAYS60AMT += parseFloat(DAYS60AMT);
            totalDAYS90AMT += parseFloat(DAYS90AMT);
            totalDAYS90UPAMT += parseFloat(DAYS90UPAMT);
            console.log(totalDAYS90UPAMT)
            tr += `  <tr class="hideAbleTr"align="center"style="">
                    <th class="ageingColor"  style="` + trstyle + `"><a href="` + FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                    <td class="ageingColor"  style="` + trstyle + `"><a target="_blank" href="` + FdataUrl + `"><button>` + getValueNotDefine(Data[i].billDetails[j].BILL) + `</button></a></td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + trstyle + `">` + getValueNotDefine(Data[i].billDetails[j].FRM) + `</td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + trstyle + `">` + formatDate(Data[i].billDetails[j].DATE) + `</td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + trstyle + `">` + getValueNotDefine(GRSAMT) + `</td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + trstyle + `">` + getValueNotDefine(FAMT) + `</td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + trstyle + `">` + getValueNotDefine(CLAIMS) + `</td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + trstyle + `">` + getValueNotDefine(RECAMT) + `</td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + trstyle + `">` + getValueNotDefine(BrokerHaste) + ` </td>
                    <td class="hideGRD ageingColor" style="display:none;"onclick="openSubR('`+ Data[i].code + `')" style="` + trstyle + `">` + getValueNotDefine(Data[i].billDetails[j].GRD) + ` </td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + trstyle + `">` + daysDiff + ` </td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + DAYS30_STYLE + `">` + getValueNotDefine(DAYS30AMT) + ` </td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + DAYS60_STYLE + `">` + getValueNotDefine(DAYS60AMT) + ` </td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + DAYS90_STYLE + `">` + getValueNotDefine(DAYS90AMT) + ` </td>
                    <td class="ageingColor" onclick="openSubR('`+ Data[i].code + `')" style="` + DAYS90UP_STYLE + `">` + getValueNotDefine(DAYS90UPAMT) + ` </td>
                    
                </tr>`;


          }
          grandtotalNETBILLAMT += totalNETBILLAMT;
          grandtotalGROSSAMT += totalGROSSAMT;
          grandtotalGOODSRETURN += totalGOODSRETURN;
          grandtotalPAIDAMT += totalPAIDAMT;
          grandtotalAmount += totalAmount;
          grandtotalDAYS30AMT += totalDAYS30AMT;
          grandtotalDAYS60AMT += totalDAYS60AMT;
          grandtotalDAYS90AMT += totalDAYS90AMT;
          grandtotalDAYS90UPAMT += totalDAYS90UPAMT;
          tr += `<tr class="tfootcard">
                                <td  colspan="4">Total Amount</td>
                                <td>` + valuetoFixed(totalGROSSAMT) + `</td>
                                <td>` + valuetoFixed(totalNETBILLAMT) + `</td>
                                <td>` + valuetoFixed(totalGOODSRETURN) + `</td>
                                <td>` + valuetoFixed(totalPAIDAMT) + `</td>
                                <td colspan="2"></td>
                                <td class="GRD"colspan="1"></td>
                                <td style="background-color:#0000ff4f;">`+ valuetoFixed(totalDAYS30AMT) + `</td>
                                <td style="background-color:#588c7e91;">`+ valuetoFixed(totalDAYS60AMT) + `</td>
                                <td style="background-color:#a761187a;">`+ valuetoFixed(totalDAYS90AMT) + `</td>
                                <td style="background-color:#ff000030;">`+ valuetoFixed(totalDAYS90UPAMT) + `</td>
                                </tr>`;


        }

      }
      tr += `<tr class="tfootcard">
    <td  colspan="4">GRAND TOTAL</td>
    <td>` + valuetoFixed(grandtotalGROSSAMT) + `</td>
    <td>` + valuetoFixed(grandtotalNETBILLAMT) + `</td>
    <td>` + valuetoFixed(grandtotalGOODSRETURN) + `</td>
    <td>` + valuetoFixed(grandtotalPAIDAMT) + `</td>
    <td colspan="2"></td>
    <td class="GRD"colspan="1"></td>
    <td style="background-color:#0000ff4f;">`+ valuetoFixed(grandtotalDAYS30AMT) + `</td>
    <td style="background-color:#588c7e91;">`+ valuetoFixed(grandtotalDAYS60AMT) + `</td>
    <td style="background-color:#a761187a;">`+ valuetoFixed(grandtotalDAYS90AMT) + `</td>
    <td style="background-color:#ff000030;">`+ valuetoFixed(grandtotalDAYS90UPAMT) + `</td>
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

      $('td').css('width', '50px');
      BuildAccountdetaisl(CNOArray);
    } else {
      $('#result').html('<h1>No Data Found</h1>');
      $("#loader").removeClass('has-loader');

    }


  } catch (e) {
    $('#result').html(tr);
    $('#result').prepend(e);
    $("#loader").removeClass('has-loader');
  }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

