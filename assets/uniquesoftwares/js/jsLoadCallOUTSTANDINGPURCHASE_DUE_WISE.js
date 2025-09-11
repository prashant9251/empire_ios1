

function filterByBrokerOrPartyList(partyName, bcode) {
    return TransectionArray.filter(function (d) {
        return d.code == partyName && d.BCODE == bcode;
    });
}
function getBrokerPartyListDue(code) {
    return PartyNameList.filter(function (d) {
        return d.BCODE == code;
    })
}
var hideAbleTr = getUrlParams(url, "hideAbleTr");
var GRD;
function jsLoadCallOUTSTANDINGPURCHASE_DUE_WISE(data) {
    var todayDueOnly = "true";
    var todayDate = new Date();
    var CNOArray = [];
    var flgCno = [];
    var totalAmount = 0;
    tr = '';
    TransectionArray = [];
    BrokerNameList = [];
    PartyNameList = [];
    Data = data;

    var DL = Data.length;
    if (DL > 0) {
        var flagParty = [];
        var flagBroker = [];

        for (var i = 0; i < Data.length; i++) {
            for (var j = 0; j < Data[i].billDetails.length; j++) {
                var obj = {};
                obj.code = Data[i].code;
                obj.CNO = Data[i].billDetails[j].CNO;
                obj.TYPE = Data[i].billDetails[j].TYPE;
                obj.VNO = Data[i].billDetails[j].VNO;
                obj.IDE = Data[i].billDetails[j].IDE;
                obj.BILL = Data[i].billDetails[j].BILL;
                obj.FRM = Data[i].billDetails[j].FRM;
                obj.DATE = Data[i].billDetails[j].DATE;
                obj.GRSAMT = Data[i].billDetails[j].GRSAMT;
                obj.GST = Data[i].billDetails[j].GST;
                obj.FAMT = Data[i].billDetails[j].FAMT;
                obj.CLAIMS = Data[i].billDetails[j].CLAIMS;
                obj.RECAMT = Data[i].billDetails[j].RECAMT;
                obj.PAMT = Data[i].billDetails[j].PAMT;
                obj.BCODE = Data[i].billDetails[j].BCODE;
                obj.GRD = Data[i].billDetails[j].GRD;
                obj.HST = Data[i].billDetails[j].HST;
                obj.DT = Data[i].billDetails[j].DT;
                obj.L1R = Data[i].billDetails[j].L1R;
                obj.L1P = Data[i].billDetails[j].L1P;
                obj.L2R = Data[i].billDetails[j].L2R;
                obj.L2P = Data[i].billDetails[j].L2P;
                obj.L3R = Data[i].billDetails[j].L3R;
                obj.L3P = Data[i].billDetails[j].L3P;
                obj.T = Data[i].billDetails[j].T;
                obj.R1 = Data[i].billDetails[j].R1;

                TransectionArray.push(obj);
                if (!flagBroker[Data[i].billDetails[j].BCODE]) {
                    BrokerNameList.push(Data[i].billDetails[j].BCODE);
                    flagBroker[Data[i].billDetails[j].BCODE] = true;
                }
                if (!flagParty[Data[i].code + Data[i].billDetails[j].BCODE]) {
                    var obj = {};
                    obj.code = Data[i].code;
                    obj.BCODE = Data[i].billDetails[j].BCODE;
                    PartyNameList.push(obj);
                    flagParty[Data[i].code + Data[i].billDetails[j].BCODE] = true;
                }
            }
        }
        BrokerNameList = BrokerNameList.sort()
        for (var i = 0; i < BrokerNameList.length; i++) {
            var BrokerArr = getPartyDetailsBySendCode(BrokerNameList[i]);
            var BMO = '';
            var BContact = '';
            if (BrokerArr.length > 0) {
                BMO = getValueNotDefine(BrokerArr[0].MO);
                BContact = `,<a onclick="dialNo(` + getValueNotDefine(BrokerArr[0].MO) + `)">` + getValueNotDefine(BrokerArr[0].MO) + `</a>`;
                BContact += `,<a onclick="dialNo(` + getValueNotDefine(BrokerArr[0].PH1) + `)">` + getValueNotDefine(BrokerArr[0].PH1) + `</a>`;
                BContact += `,<a onclick="dialNo(` + getValueNotDefine(BrokerArr[0].PH1) + `)">` + getValueNotDefine(BrokerArr[0].PH1) + `</a>`;
            }
            var brokerTr = `<tr class="pinkHeading">
            <th  colspan="15"><b  onclick="openBrokerSupR('`+ BrokerNameList[i] + `','` + BMO + `')">` + BrokerNameList[i] + "</b>" + BContact + `</th>
            </tr>`;

            var uniqBrokerPartyList = getBrokerPartyListDue(BrokerNameList[i]);
            uniqBrokerPartyList = uniqBrokerPartyList.sort((a, b) => {
                if (a.code > b.code)
                    return 1;
                if (a.code < b.code)
                    return -1;
                return 0;
            });

            for (var j = 0; j < uniqBrokerPartyList.length; j++) {
                ccode = getPartyDetailsBySendCode(uniqBrokerPartyList[j].code);
                var pcode = "";
                var city = "";
                var broker = "";
                var dhara = 0;
                if (ccode.length > 0) {
                    label = getValueNotDefine(ccode[0].label);
                    pcode = getValueNotDefine(ccode[0].value);
                    city = getValueNotDefine(ccode[0].city);
                    broker = getValueNotDefine(ccode[0].broker);
                    dhara = 60;//getValueNotDefine(ccode[0].dhara);
                }
                var partyTr = `<tr class="trPartyHead"  onclick="trOnClick('` + pcode + `','` + city + `','` + broker + `');">
                        <th class="trPartyHead" colspan="23">`+ label + `</th>
                    </tr>`;

                var Data = filterByBrokerOrPartyList(uniqBrokerPartyList[j].code, BrokerNameList[i]);
                var oldDueList = Data.filter(function (d) {
                    var days = getDaysDif(d.DATE, todayDate)
                    if (days > dhara) {
                        d.isOldDue = true;
                    } else if (days == dhara) {
                        d.isTodayDue = false;
                    } else if (days < dhara) {
                        d.isNextDue = true;
                    }
                });
                // var todayDueList = Data.filter(function (d) {
                //     var days = getDaysDif(d.DATE, todayDate)
                //     if (days == dhara) {
                //         d.isTodayDue = false;
                //         return true;
                //     }
                //     return false;
                // }
                // );
                // var nextDueList = Data.filter(function (d) {
                //     var days = getDaysDif(d.DATE, todayDate)
                //     if (days < dhara) {
                //         d.isNextDue = true;
                //         return true;
                //     }
                //     return false;
                // }
                // );


                var mergedDueList = [...oldDueList, ...todayDueList, ...nextDueList];
                if (todayDueOnly != null && todayDueOnly == "true") {
                    mergedDueList = mergedDueList.filter(function (d) {
                        return d.isTodayDue == true;
                    });
                }
                if (mergedDueList.length > 0) {
                    tr += brokerTr;
                    tr += partyTr;
                    tr += getTableFromData(mergedDueList, ccode[0], "OLD");
                }
            }
        }

        $('#result').html(tr);
        $("#loader").removeClass('has-loader');
        if (GRD == '' || GRD == null) {
            $('.GRD').css("display", "none");
        }

        // BuildAccountdetaisl(CNOArray);
        hideList();
        BuildAccountdetaisl(CNOArray);

    } else {
        $('#result').html('<h1>No Data Found</h1>');
        $("#loader").removeClass('has-loader');

    }
    try {


    } catch (e) {
        $('#result').html(tr);
        $('#result').prepend(e);
        $("#loader").removeClass('has-loader');
    }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);




function getTableFromData(arrayData, ccodeObj, type) {
    var tr = '';
    var style = '';
    if (type == "OLD" && arrayData.length > 0) {
        style = 'color: black;Font-weight:Bold;border-top: 5px solid #588c7e;';
    } else if (type == "TODAY" && arrayData.length > 0) {
        style = 'color: red;Font-weight:Bold;';
    } else if (type == "NEXT" && arrayData.length > 0) {
        style = 'color:black;';
    }
    if (hideAbleTr == "true") {
        tr += `<tr style="` + style + `">
                <td colspan="1">`+ type + `</td>
                <td colspan="5">` + ccodeObj.partyname + `</td>
               <td colspan="1">` + arrayData.length + ` Bill</td>
                <td colspan="1">Amt Shows here</td>
                </tr>`;
        return tr;
    }
    for (var i = 0; i < arrayData.length; i++) {
        var days = getDaysDif(arrayData[i].DATE, new Date());
        var billDate = getValueNotDefine(arrayData[i].DATE);
        var billNo = getValueNotDefine(arrayData[i].BILL);
        var billAmt = getValueNotDefine(arrayData[i].GRSAMT);
        var netBillAmt = getValueNotDefine(arrayData[i].FAMT);
        var goodsRet = getValueNotDefine(arrayData[i].CLAIMS);
        var paidAmt = getValueNotDefine(arrayData[i].RECAMT);
        var pendAmt = getValueNotDefine(arrayData[i].PAMT);
        var GRD = getValueNotDefine(arrayData[i].GRD);
        var HST = getValueNotDefine(arrayData[i].HST);
        var L1R = getValueNotDefine(arrayData[i].L1R);
        var L1P = getValueNotDefine(arrayData[i].L1P);
        var L2R = getValueNotDefine(arrayData[i].L2R);
        var L2P = getValueNotDefine(arrayData[i].L2P);
        var L3R = getValueNotDefine(arrayData[i].L3R);
        var L3P = getValueNotDefine(arrayData[i].L3P);
        var T = getValueNotDefine(arrayData[i].T);
        var R1 = getValueNotDefine(arrayData[i].R1);

        tr += `<tr  style="` + style + `">
                <td class="selectBoxReport" style="display:none;">
                SELECT<input type="checkbox" checked onchange="checkAllEntry(this);"/>
                </td>
                <td class="hideBWPWNETBILL AMT" >` + billNo + `</td>
                <td>` + billNo + `</td>
                <td class="hideBWPWFIRM">` + arrayData[i].FRM + `</td>
                <td class="hideBWPWBILLDATE">` + billDate + `</td>
                <td class="hideBWPWGROSSAMT">` + billAmt + `</td>
                <td class="hideBWPWNETBILL AMT">` + netBillAmt + `</td>
                <td class="hideBWPWGOODSRET">` + goodsRet + `</td>
                <td class="hideBWPWPAIDAMT">` + paidAmt + `</td>    
                <td class="hideBWPWPENDAMT">` + pendAmt + `</td>
                <td class="hideBWPWDAYS">` + days + `</td>
                <td class="GRD">` + GRD + `</td>
                <td class="hidePWMWTDSTCS" style="display:none;">` + HST + `</td>
                <td class="hideBWPWL1R" style="display:none;">` + L1R + `</td>
                <td class="hideBWPWL1P" style="display:none;">` + L1P + `</td>
                <td class="hideBWPWL2R" style="display:none;">` + L2R + `</td>
                <td class="hideBWPWL2P" style="display:none;">` + L2P + `</td>
                <td class="hideBWPWL3R" style="display:none;">` + L3R + `</td>
                <td class="hideBWPWL3P" style="display:none;">` + L3P + `</td>
                <td class="hideBWPWRMK" style="display:none;">` + T + `</td>
                <td class="hideBWPWBAL" style="display:none;">` + arrayData[i].BILL + `</td>
                <td class="hideBWPWVNO" style="display:none;">` + arrayData[i].VNO + `</td>
                </tr>`;
    }
    return tr;
}