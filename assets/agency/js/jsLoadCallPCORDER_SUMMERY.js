var obj = {};          
          obj.CN = customer.CN;
          obj.SN = supplier.SN;
          obj.CS = subTotalOrderCs;
          obj.P = subTotalOrderPcs;
          obj.SP = subTotalSlPcs;
          obj.SC = subTotalSlCs;
          obj.PP = subTotalPendPcs;
          obj.PC = subTotalPendCs;
          smArray.push(obj);

function jsLoadCallPCORDER_SUMMERY(){
    var smtr = `<thead>›
    <tr class="trPartyHead">
    <td>SUPP</td>
    <td>CUST</td>
    <td>CASES</td>
    <td>PCS</td>
    <td>SLPCS</td>
    <td>SL CASES</td>
    <td>PENDPCS</td>
    <td>PENDCS</td>
    </tr>
    </thead>
    <tbody id="summery"></tbody>`;
    $('#result').html(smtr);
    tr = getjsLoadCallPCORDER_SUMMERY();
  }


  function getjsLoadCallPCORDER_SUMMERY(){
    $("#loader").addClass('has-loader');
    var smTr = '';
    var flgCustList = [];
    var CustList = [];

    for (let i = 0; i < smArray.length; i++) {
        const element = smArray[i];
        if(!flgCustList[element.CN]){
            CustList.push(element.CN);
            flgCustList[element.CN] = true;
        }
    }
  }