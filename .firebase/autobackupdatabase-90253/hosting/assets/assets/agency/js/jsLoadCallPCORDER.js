

var url = window.location.href;
var OrderArray = [];
var smArray=[];
function loadCall(Data) {
  smArray=[];
  OrderArray = [];
  var flgCustList = [];
  var flgSuppList = [];
  var CustList = [];
  var SuppList = [];

  for (let i = 0; i < Data.length; i++) {
    var hideAbleTr = getUrlParams(url,'hideAbleTr');
    var tr = "<tbody>";
    const element = Data[i];
    var obj = {};
    obj.S = element.S;
    obj.D = element.D;
    obj.CN = element.CN;
    obj.SN = element.SN;
    obj.O = element.O;
    obj.CS = element.CS;
    obj.P = element.P;
    obj.SP = element.SP;
    obj.SC = element.SC;
    obj.PP = element.PP;
    obj.PC = element.PC;
    obj.R = element.R;
    OrderArray.push(obj);
    if (!flgCustList[element.C]) {
      var o = {};
      o.C = element.C;
      o.CN = element.CN;
      CustList.push(o);
      flgCustList[element.C] = true;
    }
    if (!flgSuppList[element.S + element.C]) {
      var o = {};
      o.S = element.S;
      o.SN = element.SN;
      o.C = element.C;
      SuppList.push(o);
      flgSuppList[element.S + element.C] = true;
    }
  }
  if (CustList.length > 0) {
    grandTotalOrderPcs = 0;
    grandTotalOrderCs = 0;
    grandTotalSlPcs = 0;
    grandTotalSlCs = 0;
    grandTotalPendPcs = 0;
    grandTotalPendCs = 0;


    for (let i = 0; i < CustList.length; i++) {
      const customer = CustList[i];
      tr += `<tr>
      <td colspan="11"class="pinkHeading" style="font-weight:500;font-size:25px;font-weight:bold;">`+ customer.CN.toUpperCase() + `</td>
      </tr>`;

      var SuppListByCust = SuppList.filter(x => x.C == customer.C);
      var totalOrderPcs = 0;
      var totalOrderCs = 0;
      var totalSlPcs = 0;
      var totalSlCs = 0;
      var totalPendPcs = 0;
      var totalPendCs = 0;

      for (let j = 0; j < SuppListByCust.length; j++) {
        const supplier = SuppListByCust[j];
        tr += `<tr>
        <td colspan="11"class="trPartyHead" style="font-weight:500;font-weight:bold;">`+ supplier.SN.toUpperCase()  + `</td>
        </tr>`;
        var OrderList = OrderArray.filter(x => x.S == supplier.S && x.CN == customer.CN);
        if (OrderList.length > 0) {
          tr += `
          <tr style="font-weight:500;font-weight:bold;"align="center">                    
          <th class="hideDATE">DATE&nbsp;&nbsp;&nbsp;&nbsp;</th>
          <th class="hideCUST">CUST</th>
          <th class="hideSUPP">SUPP</th>
          <th class="hideORDNO">ORD.NO</th>
          <th class="hideCASE">CASE</th>
          <th class="hidePCS">PCS</th>
          <th class="hideSLPCS">SL PCS</th>
          <th class="hideSLCS">SL CS</th>
          <th class="hidePENDPCS">PEND PCS</th>
          <th class="hidePENDCS">PEND CS</th>
          <th class="hideRMK">RMK</th>
          </tr> 
            `;
          var subTotalOrderPcs = 0;
          var subTotalOrderCs = 0;
          var subTotalSlPcs = 0;
          var subTotalSlCs = 0;
          var subTotalPendPcs = 0;
          var subTotalPendCs = 0;

          for (let k = 0; k < OrderList.length; k++) {
            const order = OrderList[k];
            subTotalOrderPcs += parseInt(order.P || "0");
            subTotalOrderCs += parseFloat(order.CS || "0");
            subTotalSlPcs += parseInt(order.SP || "0");
            subTotalSlCs += parseFloat(order.SC || "0");
            subTotalPendPcs += parseInt(order.PP || "0");
            subTotalPendCs += parseFloat(order.PC || "0");

            tr += ` <tr  align="center" class="hideAbleTr">                    
                <td class="hideDATE">`+ formatDate(order.D) + `</td>
                <td class="hideCUST">`+ getValueNotDefine(order.CN).toUpperCase()  + `</td>
                <td class="hideSUPP">`+ getValueNotDefine(order.SN).toUpperCase()  + `</td>
                <td class="hideORDNO">`+ getValueNotDefine(order.O) + `</td>
                <td class="hideCASE">`+ getValueNotDefine(order.CS) + `</td>
                <td class="hidePCS">`+ getValueNotDefine(order.P) + `</td>
                <td class="hideSLPCS">`+ getValueNotDefine(order.SP) + `</td>
                <td class="hideSLCS">`+ getValueNotDefine(order.SC) + `</td>
                <td class="hidePENDPCS">`+ getValueNotDefine(order.PP) + `</td>
                <td class="hidePENDCS">`+ getValueNotDefine(order.PC) + `</td>
                <td class="hideRMK">`+ getValueNotDefine(order.R) + `</td>
                </tr> `;
          }
          

          tr += `<tr  align="center" class="tfootcard">
          <td class="hideDATE">Sub Total</td>
          <td class="hideCUST"></td>
          <td class="hideSUPP"></td>
          <td class="hideORDNO"></td>
          <td class="hideCASE">`+ subTotalOrderCs + `</td>
          <td class="hidePCS">`+ subTotalOrderPcs + `</td>
          <td class="hideSLPCS">`+ subTotalSlPcs + `</td>
          <td class="hideSLCS">`+ subTotalSlCs + `</td>
          <td class="hidePENDPCS">`+ subTotalPendPcs + `</td>
          <td class="hidePENDCS">`+ subTotalPendCs + `</td>
          <td class="hideRMK"></td>`;
          // var obj = {};          
          // obj.CN = customer.CN;
          // obj.SN = supplier.SN;
          // obj.CS = subTotalOrderCs;
          // obj.P = subTotalOrderPcs;
          // obj.SP = subTotalSlPcs;
          // obj.SC = subTotalSlCs;
          // obj.PP = subTotalPendPcs;
          // obj.PC = subTotalPendCs;
          // smArray.push(obj);
          
          totalOrderPcs += subTotalOrderPcs;
          totalOrderCs += subTotalOrderCs;
          totalSlPcs += subTotalSlPcs;
          totalSlCs += subTotalSlCs;
          totalPendPcs += subTotalPendPcs;
          totalPendCs += subTotalPendCs;
          subTotalOrderPcs=0;
          subTotalOrderCs=0;
          subTotalSlPcs=0;
          subTotalSlCs=0;
          subTotalPendPcs=0;
          subTotalPendCs=0;
        }
      }
      tr += `<tr  align="center" class="tfootcard">
      <td  class="hideDATE">Total</td>
      <td  class="hideCUST"></td>
      <td  class="hideSUPP"></td>
      <td  class="hideORDNO"></td>
      <td  class="hideCASE">`+ totalOrderCs + `</td>
      <td  class="hidePCS">`+ totalOrderPcs + `</td>
      <td  class="hideSLPCS">`+ totalSlPcs + `</td>
      <td  class="hideSLCS">`+ totalSlCs + `</td>
      <td  class="hidePENDPCS">`+ totalPendPcs + `</td>
      <td  class="hidePENDCS">`+ totalPendCs + `</td>
      <td  class="hideRMK"></td>`;
      grandTotalOrderPcs += totalOrderPcs;
      grandTotalOrderCs += totalOrderCs;
      grandTotalSlPcs += totalSlPcs;
      grandTotalSlCs += totalSlCs;
      grandTotalPendPcs += totalPendPcs;
      grandTotalPendCs += totalPendCs;
      totalOrderPcs=0;
      totalOrderCs=0;
      totalSlPcs=0;
      totalSlCs=0;
      totalPendPcs=0;
      totalPendCs=0;

    }

    tr += `<tr  align="center" class="tfootcard ">
    <td  class="hideDATE">Grand Total</td>
    <td  class="hideCUST"></td>
    <td  class="hideSUPP"></td>
    <td  class="hideORDNO"></td>
    <td  class="hideCASE">`+ grandTotalOrderCs + `</td>
    <td  class="hidePCS">`+ grandTotalOrderPcs + `</td>
    <td  class="hideSLPCS">`+ grandTotalSlPcs + `</td>
    <td  class="hideSLCS">`+ grandTotalSlCs + `</td>
    <td  class="hidePENDPCS">`+ grandTotalPendPcs + `</td>
    <td  class="hidePENDCS">`+ grandTotalPendCs + `</td>
    <td  class="hideRMK"></td>`;

    
    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    if (hideAbleTr == "true") {
      $('.hideAbleTr').css('display', 'none');
    }

    hideList();

  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }

}