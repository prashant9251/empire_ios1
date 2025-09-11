var smArray = [];


function loadCall() {
  smArray = [];

  if (qualcode != '' && qualcode != null) {
    Data = Data.filter(function (data) {
      return data.qcode == qualcode;
    })
  }
  if (mainscreenname != '' && mainscreenname != null) {
    Data = Data.filter(function (data) {
      return data.MS == mainscreenname;
    })
  }
  if (clothType != '' && clothType != null) {
    Data = Data.filter(function (data) {
      return data.CT == clothType;
    })
  }
  console.log(qualcode, Data);
  if (cno != '' && cno != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => (billDetails.CNO) == (cno));
    }).map(function (subdata) {
      return {
        qcode: subdata.qcode,
        MS: subdata.MS,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails.CNO) == (cno);
        })
      }
    })
  }
  if (partycode != '' && partycode != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => (billDetails.cod) == (partycode));
    }).map(function (subdata) {
      return {
        qcode: subdata.qcode,
        MS: subdata.MS,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails.cod) == (partycode);
        })
      }
    })
  }
  if (category != '' && category != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => (billDetails.CT).toString().toUpperCase() == (category).toUpperCase());
    }).map(function (subdata) {
      return {
        qcode: subdata.qcode,
        MS: subdata.MS,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails.CT).toString().toUpperCase() == (category).toUpperCase();
        })
      }
    })
  }
  
  if (godown != '' && godown != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => (billDetails.G) == (godown));
    }).map(function (subdata) {
      return {
        qcode: subdata.qcode,
        MS: subdata.MS,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails.G) == (godown);
        })
      }
    })
  }

  if (fromdate != '' && fromdate != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => new Date(DateRpl(billDetails.DT)).setHours(24, 0, 0, 0) >= new Date(DateRpl(fromdate)).setHours(0, 0, 0, 0));
    }).map(function (subdata) {
      return {
        qcode: subdata.qcode,
        MS: subdata.MS,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return new Date(DateRpl(billDetails.DT)).setHours(24, 0, 0, 0) >= new Date(DateRpl(fromdate)).setHours(0, 0, 0, 0);
        })
      }
    })
  }
  if (todate != '' && todate != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => new Date(DateRpl(billDetails.DT)).setHours(24, 0, 0, 0) <= new Date(DateRpl(todate)).setHours(24, 0, 0, 0));
    }).map(function (subdata) {
      return {
        qcode: subdata.qcode,
        MS: subdata.MS,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return new Date(DateRpl(billDetails.DT)).setHours(24, 0, 0, 0) <= new Date(DateRpl(todate)).setHours(24, 0, 0, 0);
        })
      }
    })
  }

  console.log("FNL---", Data);

  if (Data.length > 0) {
    var grandOP_Stock = 0;
    var grandSale_Stock = 0;
    var grandPEND_STOCK = 0;
    var grandtotalPCS = 0;
    var row;
    for (i = 0; i < Data.length; i++) {
      row = `<tr class="trPartyHead" style="font-weight:bolder;height:50px;"align="left">
                          <th  class="trPartyHead" colspan="8">` + Data[i].qcode + ` </th>                                    
                          <th  class="trPartyHead">` + clothType + ` </th>                                    
                          
                        </tr>
                `;
      var OP_Stock = 0;
      var Sale_Stock = 0;
      var PEND_STOCK = 0;
      if (Data[i].billDetails.length > 0) {
        row += `<tr>
                        <th>DATE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                        <th class="hidePARTY">PARTY</th>
                        <th class="hideITEM">ITEM</th>
                        <th class="hideBILL">BILL</th>
                        <th class="hideTYPE">TYPE</th>
                        <th class="hideSTOCK">STOCK</th>
                        <th class="hideCATEGORY">CATEGORY</th>
                        <th class="hideMAINSCREEN">MAIN SCREEN</th>
                        </tr>`;
        var totalPCS = 0;
        var totalFinalAmt = 0;
        for (j = 0; j < Data[i].billDetails.length; j++) {
          var PCS = parseInt(Data[i].billDetails[j].CPS);
          totalPCS += PCS;
          row += `<tr >
                    <th>`+ formatDate(Data[i].billDetails[j].DT) + `</th>
                    <th class="hidePARTY">`+ Data[i].billDetails[j].cod + `</th>
                    <th class="hideITEM">`+ Data[i].qcode + `</th>
                    <th class="hideBILL">`+ Data[i].billDetails[j].BIL + `</th>
                    <th class="hideTYPE">`+ Data[i].billDetails[j].SRS + `</th>
                    <th class="hideSTOCK">`+ PCS + `</th>
                    <th class="hideCATEGORY">`+ Data[i].billDetails[j].CT + `</th>
                    <th class="hideMAINSCREEN">`+ Data[i].MS + `</th>
                    </tr>`;
                    Data[i].CT=Data[i].billDetails[j].CT ;
        }
        row += `<tr>
                <th>TOTAL</th>
                <th  class="hidePARTY"></th>
                <th  class="hideITEM"></th>
                <th  class="hideBILL"></th>
                <th  class="hideTYPE"></th>
                <th  class="hideSTOCK">`+ totalPCS + `</th>
                <th  class="hideCATEGORY"></th>
                <th  class="hideMAINSCREEN"></th>
                </tr>`;
        if (totalPCS == 0) {
          row = "";
        } else {
          tr += row;
          grandtotalPCS += totalPCS;
          obj = {};
          obj.qcode = Data[i].qcode;
          obj.MS = Data[i].MS;
          obj.CT =Data[i].CT;
          obj.totalPCS = totalPCS;
          smArray.push(obj);
        }
      }
    }

    tr += `<tr>
        <th>GRAND TOTAL</th>
        <th  class="hidePARTY"></th>
        <th  class="hideITEM"></th>
        <th  class="hideBILL"></th>
        <th  class="hideTYPE"></th>
        <th  class="hideSTOCK">`+ grandtotalPCS + `</th>
        <th  class="hideCATEGORY"></th>
        <th  class="hideMAINSCREEN"></th>
        </tr>`;

    var hideAbleTr = getUrlParams(url, "hideAbleTr");
    if (hideAbleTr == "true") {
      createSummeryReport();
    } else {
      $('#result').html(tr);
      $("#loader").removeClass('has-loader');
    }
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }
  try { } catch (e) {
    alert(e);
    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
  }
  //   try {

  // } catch (error) {
  //   alert(error);
  // }
}





function createSummeryReport() {
  var smtr = `<thead>›
    <tr class="trPartyHead">
    <th class="hideIMG trPartyHead">IMG</th>
    <th class="trPartyHead">MAIN SCREEN<select id="mainScrennOrder" onchange="getSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
    <th class="trPartyHead">QUALITY<select id="QualNameOrder" onchange="getSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
    <th class="trPartyHead">CATEGORY	</th>
    <th class="trPartyHead">CLOTH TYPE	</th>
    <th class="trPartyHead" >PCS <select id="pcsOrder" onchange="getSummery();"><option></option><option>ASC</option><option>DSC</option></select>	</th>
    </tr>
    </thead>
    <tbody id="summery"></tbody>`;
  $('#result').html(smtr);
  tr = getSummery();
}



function getSummery() {
  $("#loader").addClass('has-loader');
  var QualNameOrder = $('#QualNameOrder').val();
  var pcsOrder = $('#pcsOrder').val();
  var mainScrennOrder = $('#mainScrennOrder').val();

  var ARR = smArray;
  if (QualNameOrder != null && QualNameOrder != "") {
    if (QualNameOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        if (a.qcode > b.qcode)
          return 1;
        if (a.qcode < b.qcode)
          return -1;
        return 0;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        if (a.qcode < b.qcode)
          return 1;
        if (a.qcode > b.qcode)
          return -1;
        return 0;
      });
    }
  }
  if (mainScrennOrder != null && mainScrennOrder != "") {
    if (mainScrennOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        if (a.MS > b.MS)
          return 1;
        if (a.MS < b.MS)
          return -1;
        return 0;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        if (a.MS < b.MS)
          return 1;
        if (a.MS > b.MS)
          return -1;
        return 0;
      });
    }
  }
  if (pcsOrder != null && pcsOrder != "") {
    if (pcsOrder == "ASC") {
      ARR = smArray.sort(function (a, b) {
        return a.totalPCS - b.totalPCS;
      });
    } else {
      ARR = smArray.sort(function (a, b) {
        return b.totalPCS - a.totalPCS;
      });
    }
  }
  console.log(ARR);
  var smTr = '';
  if (ARR.length > 0) {
    smTr += `
      `;
    var grandtotalPCS = 0;
    for (let i = 0; i < ARR.length; i++) {
      const element = ARR[i];
      var {url,clothType} = getImgUrl(element.qcode);
      var imgTag = '';
      if (url == null || url == "") {
        url='https://firebasestorage.googleapis.com/v0/b/autobackupdatabase-90253.appspot.com/o/noImg.png?alt=media&token=665c7944-35fd-4242-973f-92268cac5bc6';
      }
      console.log(url);
      imgTag = `<img src="`+url+`" height='120px' width='120px'/>`;
      var id = stringHashCode(element.qcode);
      smTr += `
        <tr>
        <td class="hideIMG">`+ imgTag + `</td> 
        <td style="text-align:left;" onclick="openSubR('`+ element.qcode + `')">` + element.MS + `</td>
        <td style="text-align:left;" onclick="openSubR('`+ element.qcode + `')">` + element.qcode + `</td>
        <td style="text-align:left;" onclick="openSubR('`+ element.qcode + `')">` + element.CT + `</td>
        <td style="text-align:left;" onclick="openSubR('`+ element.qcode + `')">` + clothType + `</td>
        <td >`+ parseFloat(element.totalPCS).toFixed(2) + `</td>
        </tr>`;
      grandtotalPCS += parseFloat(element.totalPCS);
    }
    smTr += `
      <tr class="tfootcard">
      <th class="hideIMG"></th>
      <th style="text-align:left;">TOTAL</th>
      <th style="text-align:left;"></th>
      <th style="text-align:left;"></th>
      <th style="text-align:left;"></th>
      <th >`+ parseFloat(grandtotalPCS).toFixed(2) + `</th>
      </tr>`;
  }
  $('#summery').html(smTr);
  $("#loader").removeClass('has-loader');
  hideList();

  return smTr;
}


function getImgUrl(name) {
  var p = QUAL_LIST.filter(function (d) {
    return getValueNotDefine(d.value).toUpperCase() == name.toUpperCase();
  });
  var url = "";
  var clothType='';
  try {
    var qualPath = p[0]["P"];
    if (qualPath != null && qualPath != "") {
      url =
      `http://${privateNetworkIp}/${LFolder}/photoLink.php?CL=${clnt}&CLDB=${ClDb}&p=${encodeURIComponent(qualPath)}`;
    }
    var clothType = p[0]["QT"];
  } catch (error) {
   alert(error);
  }
  return {url,clothType};
}

function handleImageError(id) {
  $('#' + id).css("display:none;")
}