

function challanTakaDetailsInChallan(CRD) {
  var trp = "";
  var D_CHALTRNdata = CHALTRNdata.filter(function (Chdata) {
      return Chdata.CRD.trim() == CRD.trim();
    })
  var totalMTS = 0;
  if (D_CHALTRNdata.length > 0) {
    var productDet = (D_CHALTRNdata[0].billDetails);
    var sr = 0;
    totalMTS = 0;
    if (productDet.length > 0) {
      var pr = checkForDouble(productDet);
      console.log(pr);
      trp = "<div style='display: inline;'>";
      for (let p = 0; p < pr.length; p++) {
        const element = pr[p];
        var items = element["List"];
        trp += `<div style="min-width:25%;float:left;">`;
        if (items.length > 0) {
          items = items.sort(function (a, b) {
            return a.SR - b.SR;
          })
          trp += `<table class="table" style="font-size:14px;width:100%;">`;
          trp += `
          <thead>
          <tr style="border-bottom:2px solid black;font-weight:bold;">
            <th class="hideSR"class="alignRight">Sr.</th>
            <th class="alignRight">MTR</th>
            <th class="alignRight">REC.MTR</th>
          </tr>
          </thead>`;
          var subTotalNMT = 0;
          for (let q = 0; q < items.length; q++) {

            const it = items[q];
            billNoChallan = getValueNotDefine(it.BLL);
            purchaseNo = getValueNotDefine(it.VNO);
            subTotalNMT += parseFloat(it.DMT);
            trp += `<tr>
            <td class="alignRight">`+ it.SR + `</td>
            <td class="alignRight">`+ parseFloat(it.DMT).toFixed(2) + `</td>
            <td class="alignRight">`+ parseFloat(it.RMT).toFixed(2) + `</td>
              </tr>`;
          }
          trp += `					
          </table>
          </div>`;
        }
      }

      trp += "</div>";

    }
  }

  return trp;
}





function challanTakaDetails(CRD) {
  var trp = "";
  var D_CHALTRNdata = CHALTRNdata.filter(function (Chdata) {
      return Chdata.CRD == CRD;
    })
  var totalMTS = 0;
  if (D_CHALTRNdata.length > 0) {
    var productDet = (D_CHALTRNdata[0].billDetails);
    var sr = 0;
    totalMTS = 0;
    if (productDet.length > 0) {
      var pr = checkForDouble(productDet);
      console.log(pr);
      for (let p = 0; p < pr.length; p++) {
        const element = pr[p];
        var items = element["List"];
        if (items.length > 0) {
          items = items.sort(function (a, b) {
            return a.SR - b.SR;
          })
          trp += `
          <tr>
            <th class="hideSR"class="alignRight">Sr.</th>
            <th class="alignRight">MTR</th>
            <th class="alignRight">REC.MTR</th>
          </tr>`;
          var subTotalNMT = 0;
          for (let q = 0; q < items.length; q++) {

            const it = items[q];
            billNoChallan = getValueNotDefine(it.BLL);
            purchaseNo = getValueNotDefine(it.VNO);
            subTotalNMT += parseFloat(it.DMT);
            trp += `<tr>
            <td class="alignRight">`+ it.SR + `</td>
            <td class="alignRight">`+ parseFloat(it.DMT).toFixed(2) + `</td>
            <td class="alignRight">`+ parseFloat(it.RMT).toFixed(2) + `</td>
              </tr>`;
          }
        }
      }
    }
  }

  return trp;
}


function checkForDouble(d) {
  var productLength = d.length;
  var limit = 12;
  var devide = productLength / limit;
  var loop = Math.ceil(devide);
  newArr = [];
  startIndex = 0;
  limitIndex = limit;
  for (var k = 0; k < loop; k++) {
    if (k != 0) {
      startIndex += limit;
      limitIndex += limit;
    }
    console.log(startIndex, limitIndex);
    var obj = {}
    ReturnArr = filterBillData(d, startIndex, limitIndex);
    obj.List = ReturnArr;
    newArr.push(obj);
  }
  console.log(newArr);
  return newArr;
}


function filterBillData(productDetails, startIndex, limitIndex) {
  var subArr = [];
  for (let l = startIndex; l < limitIndex; l++) {
    // console.log(k, startIndex, limitIndex);
    ele = productDetails[l];
    subArr.push(ele);
  }
  subArr = subArr.filter(function (d) {
    return d != undefined;
  })
  return subArr;
}