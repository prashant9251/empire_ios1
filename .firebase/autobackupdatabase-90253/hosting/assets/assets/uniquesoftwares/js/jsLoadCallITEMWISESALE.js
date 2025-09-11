function loadCall(Data) {
    var mainqualname = getUrlParams(url, "mainqualname");
    var MainScreenQualArray = JSON.parse(localStorage.getItem("MainScreenQualArray"));
    if (mainqualname != "" && mainqualname != null) {
      if (MainScreenQualArray != "" && MainScreenQualArray != null) {
        Data = Data.filter(function (data) { 
          return this.indexOf(data.qcode) > -1; }, MainScreenQualArray)
      }
    }

    if (qualcode != '' && qualcode != null) {
      Data = Data.filter(function (data) {
        return data.qcode == qualcode;
      })
    }

    if (CNO != '' && CNO != null) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => (billDetails.CNO) == (CNO));
      }).map(function (subdata) {
        return {
          qcode: subdata.qcode,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return (billDetails.CNO) == (CNO);
          })
        }
      })
    }
    // console.log(CNO + "---", Data);
    if (partycode != '' && partycode != null) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => (billDetails.cod) == (partycode));
      }).map(function (subdata) {
        return {
          qcode: subdata.qcode,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return (billDetails.cod) == (partycode);
          })
        }
      })
    }
    if (this.broker != '' && this.broker != null) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => (billDetails.BCD) == (this.broker));
      }).map(function (subdata) {
        return {
          qcode: subdata.qcode,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return (billDetails.BCD) == (this.broker);
          })
        }
      })
    }
    if (this.fromdate != '' && this.fromdate != null) {
      // console.log(this.fromdate)
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => new Date(billDetails.DT).setHours(0, 0, 0, 0) >= new Date(this.fromdate).setHours(0, 0, 0, 0));
      }).map(function (subdata) {
        return {
          qcode: subdata.qcode,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return new Date(billDetails.DT).setHours(0, 0, 0, 0) >= new Date(this.fromdate).setHours(0, 0, 0, 0);
          })
        }
      })
    }
    if (this.todate != '' && this.todate != null) {
      Data = Data.filter(function (data) {
        return data.billDetails.some((billDetails) => new Date(billDetails.DT).setHours(24, 0, 0, 0) < new Date(this.todate).setHours(24, 0, 0, 0));
      }).map(function (subdata) {
        return {
          qcode: subdata.qcode,
          billDetails: subdata.billDetails.filter(function (billDetails) {
            return new Date(billDetails.DT).setHours(24, 0, 0, 0) < new Date(this.todate).setHours(24, 0, 0, 0);
          })
        }
      })
    }

    // console.log("ITEMWISESALE", Data);

    var grandtotalPCS;
    var grandTotalfinalAmt;
    var grandTotalMTS;
    var totalPCS;
    var totalFinalAmt;
    var totalMTS;
    var totalNET_MTS;
    var grandtotalNET_MTS;
    var BLL;
    var FdataUrl
    var DL = Data.length;
    if (DL > 0) {
      grandtotalPCS = 0;
      grandTotalfinalAmt = 0;
      grandTotalMTS = 0;
      grandtotalNET_MTS = 0;


      for (i = 0; i < DL; i++) {
        tr += `<tr class="trPartyHead" style="font-weight:bolder;height:50px;"align="left">
                          <th class="trPartyHead"  colspan="15">` + Data[i].qcode + `</th>                                    
                        </tr>
                `;
        BLL = Data[i].billDetails.length
        if (BLL > 0) {
          tr += `<tr>
                        <th>PDF</th>
                        <th>PARTY NAME</th>
                        <th>DATE</th>
                        <th>BILL NO</th>
                        <th>PCS</th>
                        <th>PACK</th>
                        <th>RATE</th>
                        <th>MTS</th>
                        <th class="hideNETMTS"  style="display:none;">NET MTS.</th>
                        <th class="hideFOLDLESS"  style="display:none;" >FOLD.LESS.</th>
                        <th>AMT</th>
                        <th>FIRM</th>
                        <th>TYPE</th>
                        </tr>`;
          totalPCS = 0;
          totalFinalAmt = 0;
          totalMTS = 0;
          totalNET_MTS = 0;
          for (j = 0; j < BLL; j++) {
            totalPCS += parseInt(Data[i].billDetails[j].PCS);
            totalFinalAmt += parseFloat(Data[i].billDetails[j].AMT);
            totalMTS += parseFloat(Data[i].billDetails[j].MTS);
            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE);


            var LESS_FOLD = parseInt(Data[i].billDetails[j].LF);;
            var NET_MTS = parseInt(Data[i].billDetails[j].MTS);
            if (Data[i].billDetails[j].LF != "" && Data[i].billDetails[j].LF != null && Data[i].billDetails[j].LF != undefined) {
              var MTS = parseInt(Data[i].billDetails[j].MTS);
              LESS_FOLD = parseInt(Data[i].billDetails[j].LF);
              var lessMts = (MTS * LESS_FOLD) / 100;
              NET_MTS = MTS - lessMts;
            }

            totalNET_MTS += NET_MTS;
            var SERIES_ARR=getSeriesDetailsBySendType(Data[i].billDetails[j].TYPE);
            SERIES="";
            if(SERIES_ARR.length>0){
              SERIES=SERIES_ARR[0].SERIES;
            }
            tr += `<tr class="hideAbleTr" >
                        <th><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                        <th>`+ Data[i].billDetails[j].cod + `</button></th>
                        <th>`+ formatDate(Data[i].billDetails[j].DT) + `</th>
                        <th><a target="_blank"href="`+ FdataUrl + `"><button>` + Data[i].billDetails[j].BLL + `</button></a></th>
                        <th>`+ valuetoFixedNo(Data[i].billDetails[j].PCS) + `</th>
                        <th>`+ (Data[i].billDetails[j].PCK) + `</th>
                        <th>`+ valuetoFixed(Data[i].billDetails[j].RET) + `</th>
                        <th>`+ valuetoFixed(Data[i].billDetails[j].MTS) + `</th>
                        <th  class="hideNETMTS"  style="display:none;" >`+ getValueNotDefineNo(NET_MTS) + `</th>
                        <th  class="hideFOLDLESS"  style="display:none;">`+ (valuetoFixed(LESS_FOLD)) + `</th>
                        <th>`+ valuetoFixed(Data[i].billDetails[j].AMT) + `</th>
                        <th>`+ Data[i].billDetails[j].FRM + `</th>
                        <th>`+ SERIES + `</th>
                        </tr>`;
            if (Data[i].billDetails[j].DET != null && Data[i].billDetails[j].DET != "" && Data[i].billDetails[j].DET != undefined) {
              tr += `<tr class="hideAbleTr" >
                        <td colspan="11">REMARK: `+ Data[i].billDetails[j].DET + `</td>
                      </tr>`;
            }
          }
        }
        grandtotalPCS += totalPCS;
        grandTotalfinalAmt += totalFinalAmt;
        grandTotalMTS += totalMTS;
        grandtotalNET_MTS += totalNET_MTS;
        tr += `<tr class="tfootcard">
                        <th colspan="4">TOTAL </th>
                        <th>`+ valuetoFixedNo(totalPCS) + `</th>
                        <th colspan="2"></th>
                            <th colspan="1">`+ valuetoFixed(totalMTS) + `</th>
                            <th>`+ valuetoFixed(totalNET_MTS) + `</th>
                            <th></th>
                        <th>`+ valuetoFixed(totalFinalAmt) + `</th>
                        <th colspan="2"></th>
                        </tr>`;
      }
      tr += `
                    <tr class="tfootcard">
                    <th colspan="4">GRAND TOTAL</th>
                    <th>`+ valuetoFixedNo(grandtotalPCS) + `</th>
                    <th colspan="2"></th>
                    <th colspan="1">`+ valuetoFixed(grandTotalMTS) + `</th>
                            <th>`+ valuetoFixed(grandtotalNET_MTS) + `</th>
                            <th></th>
                            <th>`+ valuetoFixed(grandTotalfinalAmt) + `</th>
                    <th colspan="2"></th>
                    </tr>`;

      $('#result').html(tr);
      $("#loader").removeClass('has-loader');
      var hideAbleTr = getUrlParams(url, "hideAbleTr");
      if (hideAbleTr == "true") {
        $('.hideAbleTr').css("display", "none");
      }

      try {
        AddHeaderTbl();
        hideList();
      } catch (error) { }
    } else {
      $('#result').html('<h1>No Data Found</h1>');
      $("#loader").removeClass('has-loader');

    }
    try {
    } catch (e) {
    // alert(e);
    $('#result').html(tr);
    $('#result').prepend(e);
    $("#loader").removeClass('has-loader');
  }

}