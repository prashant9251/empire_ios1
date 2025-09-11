var BILLDET;
jsGetObjectByKey(DSN, "DET", "").then(function (data) {
    BILLDET = data;
    // console.log(BILLDET);
});
function jsgetArrayProductdetailsbyIDE(IDE) {
    var DETAILSDET = BILLDET.filter(function (BILLDET) {
        return BILLDET.IDE == IDE;
    }).map(function (BILLDET) {
        return BILLDET.billDetails;
    });
    var trd = "";
    if (DETAILSDET.length > 0) {

        trd += `

                <tr style="color:brown;">
                    <th style="border-top: 1px solid black;border-bottom: 1px solid black;"></th>
                    <th class="hide_ITEM text-center" style="border-top: 1px solid black;border-bottom: 1px solid black;" >ITEM</th>
                    <th class="hide_MAINSCREEN text-center" style="border-top: 1px solid black;border-bottom: 1px solid black; display:none;" >MAIN SCREEN</th>
                    <th class="hide_PCS text-center" style="border-top: 1px solid black;border-bottom: 1px solid black;" >PCS</th>
                    <th class="hide_PACK text-center" style="border-top: 1px solid black;border-bottom: 1px solid black;" >PACK</th>
                    <th class="hide_UNIT text-center" style="border-top: 1px solid black;border-bottom: 1px solid black;" >UNIT</th>
                    <th class="hide_CUT text-center" style="border-top: 1px solid black;border-bottom: 1px solid black;" >CUT</th>
                    <th class="hide_RATE text-center" style="border-top: 1px solid black;border-bottom: 1px solid black;" >RATE</th>
                    <th class="hide_MTS text-center" style="border-top: 1px solid black;border-bottom: 1px solid black;" >MTS</th>
                    <th class="hide_AMT text-center" style="border-top: 1px solid black;border-bottom: 1px solid black;" class="text-right">AMT</th>
                </tr>
                `;
        for (m = 0; m < DETAILSDET[0].length; m++) {
            trd += `<tr  style="border-bottom: 1px solid black;">
                      <td class="text-center"></td>
                      <td  class="hide_ITEM text-center">`+ DETAILSDET[0][m]['qual'] + `</td>
                      <td  class="hide_MAINSCREEN text-center" style="display:none;">`+ DETAILSDET[0][m]['altql'] + `</td>
                      <td  class="hide_PCS text-center">`+ Number(DETAILSDET[0][m]['PCS']) + `</td>
                    <td  class="hide_PACK text-center">`+ DETAILSDET[0][m]['PCK'] + `</td>
                    <td  class="hide_UNIT text-center">`+ DETAILSDET[0][m]['UNIT'] + `</td>
                    <td  class="hide_CUT text-center">`+ DETAILSDET[0][m]['CUT'] + `</td>
                    <td  class="hide_RATE text-center">`+ valuetoFixed(DETAILSDET[0][m]['RATE']) + `</td>
                    <td  class="hide_MTS text-center">`+ parseFloat(DETAILSDET[0][m]['MTS']).toFixed(2) + `</td>
                    <td  class="hide_AMT text-center">`+ valuetoFixed(DETAILSDET[0][m]['AMT']) + `</td>
                    </tr>`;

            if (DETAILSDET[0][m].DET != undefined && DETAILSDET[0][m].DET != null && DETAILSDET[0][m].DET != "") {
                trd += `<tr class="hideBWPWAbleTr">
                  <td class="text-center" colspan="10">REMARK : `+ DETAILSDET[0][m]['DET'] + `</td>
                  </tr>`;
            }
        }
    }
    return trd;
}



function jsgetArrayProductdetailsbyIDEShowOneRow(IDE) {
    var returnTr = '';
    DETAILSDET = BILLDET.filter(function (BILLDET) {
        return BILLDET.IDE == IDE;
    }).map(function (BILLDET) {
        return BILLDET.billDetails;
    });

    var productDet = getUrlParams(url, "productDet");
    if (DETAILSDET.length > 0) {
        var DETAILSDET_length = DETAILSDET[0].length;
        // console.log(DETAILSDET_length);
        var ShowLengthDetail = "";
        if (DETAILSDET_length > 1 && productDet != 'Y') {
            var MoreProductAvaiable = parseInt(DETAILSDET_length) - 1;
            ShowLengthDetail = ` + ` + MoreProductAvaiable + " Product";
            DETAILSDET_length = 1;
        }
        for (m = 0; m < DETAILSDET_length; m++) {
            returnTr += `<tr class="hideProductDetailsDetails" style="display:none;">
                            <td class="text-center"><b style="color:#c107a2;">PRODUCTS</b></td>
                            <td class="text-center"><b style="color:#c107a2;">`+ DETAILSDET[0][m]['qual'] + ShowLengthDetail + `</b></td>
                            <td class="text-center"><b style="color:#c107a2;">PCS</b>:`+ Number(DETAILSDET[0][m]['PCS']) + `</td>
                            <td class="text-center"><b style="color:#c107a2;">PACK</b>:`+ DETAILSDET[0][m]['PCK'] + `</td>
                            <td class="text-center">`+ DETAILSDET[0][m]['UNIT'] + `</td>
                            <td class="text-center"><b style="color:#c107a2;">CUT</b>: `+ DETAILSDET[0][m]['CUT'] + `</td>
                            <td class="text-center"><b style="color:#c107a2;">RATE:</b> `+ valuetoFixedNo(DETAILSDET[0][m]['RATE']) + `</td>
                            <td class="text-center"><b style="color:#c107a2;">MTS</b>: `+ parseFloat(DETAILSDET[0][m]['MTS']).toFixed(2) + `</td>
                            <td class="text-center"><b style="color:#c107a2;">AMT</b>: `+ valuetoFixedNo(DETAILSDET[0][m]['AMT']) + `</td>
                            </tr>
                  
                  
                            `;
        }
    }
    return returnTr;
}





function jsgetArrayProductdetailsbyIDEShowOneRow2(IDE) {
    var returnTr = '';
    DETAILSDET = BILLDET.filter(function (BILLDET) {
        return BILLDET.IDE == IDE;
    }).map(function (BILLDET) {
        return BILLDET.billDetails;
    });

    var productDet = getUrlParams(url, "productDet");
    var totalPcs = 0;
    var totalMts = 0;
    var totalAmt = 0;
    if (DETAILSDET.length > 0) {
        var DETAILSDET_length = DETAILSDET[0].length;
        // console.log(DETAILSDET[0]);
        var ShowLengthDetail = "";
        if (DETAILSDET_length > 1 && productDet != 'Y') {
            var MoreProductAvaiable = parseInt(DETAILSDET_length) - 1;
            ShowLengthDetail = ` + ` + MoreProductAvaiable + " Product";
            DETAILSDET_length = 1;
        }
        for (m = 0; m < DETAILSDET_length; m++) {
            returnTr += `<tr>
                            <th class="text-center"><b style="color:#c107a2;"></b></th>
                            <th class="text-center"><b style="color:#c107a2;">`+ DETAILSDET[0][m]['qual'] + ShowLengthDetail + `</b></th>
                            <th class="text-center"><b style="color:#c107a2;">PCS</b>:`+ (DETAILSDET[0][m]['PCS']) + `</th>
                            <th class="text-center"><b style="color:#c107a2;">PACK</b>:`+ DETAILSDET[0][m]['PCK'] + `</th>
                            <th class="text-center">`+ DETAILSDET[0][m]['UNIT'] + `</th>
                            <th class="text-center"><b style="color:#c107a2;">CUT</b>: `+ DETAILSDET[0][m]['CUT'] + `</th>
                            <th class="text-center"><b style="color:#c107a2;">RATE:</b> `+ valuetoFixedNo(DETAILSDET[0][m]['RATE']) + `</th>
                            <th class="text-center"><b style="color:#c107a2;">MTS</b>: `+ parseFloat(DETAILSDET[0][m]['MTS']).toFixed(2) + `</th>
                            <th class="text-center"><b style="color:#c107a2;">AMT</b>: `+ valuetoFixedNo(DETAILSDET[0][m]['AMT']) + `</th>
                            </tr>
                            `;
            totalPcs += parseInt(getValueNotDefineNo(DETAILSDET[0][m]['PCS']));
            totalMts += parseInt(getValueNotDefineNo(DETAILSDET[0][m]['MTS']));
            totalAmt += parseInt(getValueNotDefineNo(DETAILSDET[0][m]['AMT']));
        }
        returnTr += `<tr>
        <th class="text-center"></th>
        <th class="text-center">Product Sub</th>
        <th class="text-center">`+ totalPcs + `</th>
        <th class="text-center"></th>
        <th class="text-center"></th>
        <th class="text-center"></th>
        <th class="text-center"></th>
        <th class="text-center">`+ parseFloat(totalMts).toFixed(0) + `</th>
        <th class="text-center">`+ parseFloat(totalAmt).toFixed(2) + `/-</th>
        </tr>


        `;

    }
    return returnTr;
}