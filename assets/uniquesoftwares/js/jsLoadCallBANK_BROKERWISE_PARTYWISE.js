function getBrokerPartyList(code) {
  return PartyNameList.filter(function (d) {
    return d.broker == code;
  })
}
function filterByBrokerOrParty(partyName, bcode) {
  return TransectionArray.filter(function (d) {
    return d.RFCODE == partyName && d.broker == bcode;
  });
}
function jsLoadCallBANK_BROKERWISE_PARTYWISE(data) {

  var Data = data;

  var DOCNO;
  var BALANCE;
  var DEBIT;
  var CREDIT;
  var bankHeadTotal;
  var BLL;
  var DL = Data.length;

  if (DL > 0) {

    for (let i = 0; i < BrokerNameList.length; i++) {
      const element = BrokerNameList[i];
      var BrokerArr = getPartyDetailsBySendCode(BrokerNameList[i]);
      var BContact = "";
      var BMO = "";
      if (BrokerArr.length > 0) {
        BMO = getValueNotDefine(BrokerArr[0].MO);
        BContact = `,<a onclick="dialNo(` + getValueNotDefine(BrokerArr[0].MO) + `)">` + getValueNotDefine(BrokerArr[0].MO) + `</a>`;
        BContact += `,<a onclick="dialNo(` + getValueNotDefine(BrokerArr[0].PH1) + `)">` + getValueNotDefine(BrokerArr[0].PH1) + `</a>`;
        BContact += `,<a onclick="dialNo(` + getValueNotDefine(BrokerArr[0].PH1) + `)">` + getValueNotDefine(BrokerArr[0].PH1) + `</a>`;
      }
      tr += `<tr class="pinkHeading">
        <th  colspan="15" onclick="openBrokerSupR('`+ BrokerNameList[i] + `','` + BMO + `')">` + getValueNotDefine(BrokerNameList[i]) + BContact + `</th>
       </tr>`;

      var uniqBrokerPartyList = getBrokerPartyList(BrokerNameList[i])
      uniqBrokerPartyList = uniqBrokerPartyList.sort((a, b) => {
        if (a.REFCODE > b.REFCODE)
          return 1;
        if (a.REFCODE < b.REFCODE)
          return -1;
        return 0;
      });
      // console.log(uniqBrokerPartyList)
      for (var j = 0; j < uniqBrokerPartyList.length; j++) {
        ccode = getPartyDetailsBySendCode(uniqBrokerPartyList[j].REFCODE);
        var pcode = "";
        var city = "";
        var broker = "";
        if (ccode.length > 0) {
          label = getValueNotDefine(ccode[0].label);
          pcode = getValueNotDefine(ccode[0].value);
          city = getValueNotDefine(ccode[0].city);
          broker = getValueNotDefine(ccode[0].broker);
        }
        tr += `<tr class="trPartyHead"  onclick="trOnClick('` + pcode + `','` + city + `','` + broker + `');">
            <th class="trPartyHead" colspan="22">`+ label + `</th>
        </tr>`;

        tr += ` 
      <tr style="font-weight:700;"align="center">                        
      <tr>
      <th class="hideBWPWDATE">DATE</th>
      <th class="hideBWPWFIRM">FIRM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
      <th class="hideBWPWDOCNO">DOCNO</th>
      <th class="hideBWPWCRAMT">CRAMT</th>
      <th class="hideBWPWDRAMT">DRAMT</th>
      <th class="hideBWPWTOTAL">TOTAL</th>
      <th class="hideBWPWVNO">VNO</th>
      <th class="hideBWPWRMK" style="width: 150px;">RMK</th>
      </tr>
          </tr>`;
        var Data = filterByBrokerOrParty(uniqBrokerPartyList[j].REFCODE, BrokerNameList[i]);
        // console.log(Data);
        if (Data.length > 0) {
          var BALANCE = 0;
          var DEBIT = 0;
          var CREDIT = 0;
          for (var k = 0; k < Data.length; k++) {
            ccode = getPartyDetailsBySendCode(Data[k].RFCODE);
            var MO = getValueNotDefine(ccode[0].MO);
            DEBIT += parseFloat(Data[k].DRAMT);
            CREDIT += parseFloat(Data[k].CRAMT);
            BALANCE += parseFloat(Data[k].DRAMT) - parseFloat(Data[k].CRAMT)
            DOCNO = getValueNotDefine(Data[k].DOCNO);
            var paymentSlipUrl = getUrlPaymentSlip(Data[k].CNO, Data[k].TYPE, Data[k].VNO, Data[k].IDE, MO);
            if (DOCNO == '' || DOCNO == null) {
              DOCNO = getValueNotDefine(Data[k].BILLNO);
              billbutton = `<a target="_blank" href="` + paymentSlipUrl + `"><button>OPEN</button></a>`;
            } else {
              billbutton = `<a target="_blank" href="` + paymentSlipUrl + `"><button>` + DOCNO + `</button></a>`;
            }
            tr += ` <tr>
            <td class="hideBWPWDATE">`+ formatDate(Data[k].DATE) + `</td>
            <td class="hideBWPWFIRM">`+ Data[k].FRM + `</td>
            <td class="hideBWPWDOCNO">`+ billbutton + `</td>
            <td class="hideBWPWCRAMT" >`+ valuetoFixed(Data[k].DRAMT) + `</td>
            <td class="hideBWPWDRAMT" >`+ valuetoFixed(Data[k].CRAMT) + `</td>
            <td class="hideBWPWTOTAL" >`+ (valuetoFixed(BALANCE)) + `</td>
            <td class="hideBWPWVNO">`+ Data[k].VNO + `</td>
            <td class="hideBWPWRMK" style=width: 150px;word-wrap: break-word;"> `+ getValueNotDefine(Data[k].RMK) + `</td>
            </tr>
            `;
            if (adjustDet == "Y") {
              tr += getAdjustDetails(Data[k].IDE, Data[k].DATE);
            }
          }
          tr += `     <tr class="tfootcard">
          <td class="hideBWPWDATE">TOTAL</td>
          <td class="hideBWPWFIRM"></td>
          <td class="hideBWPWDOCNO"></td>
          <td class="hideBWPWCRAMT">`+ valuetoFixed(DEBIT) + `</td>
          <td class="hideBWPWDRAMT">`+ valuetoFixed(CREDIT) + `</td>
          <td class="hideBWPWTOTAL">`+ (valuetoFixed(BALANCE)) + `</td>
          <td class="hideBWPWVNO"></td>
          <td class="hideBWPWRMK"></td>
          </tr>
          `;
        }
      }

    }


    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    hideList();
  } else {
    $('#result').html('<h1 align="center">No Data Found</h1>');
    $("#loader").removeClass('has-loader');
  }


}

