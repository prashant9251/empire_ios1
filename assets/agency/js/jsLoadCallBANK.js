function getUrlPaymentSlip(CNO,TYPE,VNO,IDE) {
  return "paymentSlip.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
function loadCall(data) {
    var Data = data;
    if (cno != '' && cno!=null) {
      Data = Data.filter(function(data) {
        return data.CNO == cno;
      })
    }
    if (partycode != ''&& partycode !=null) {
      Data = Data.filter(function(data) {
        return data.RFCD == partycode;
      })
    }
    console.log(Data); 
    if (ccdcode != '' && ccdcode != null) {
      Data = Data.filter(function (data) {
        return data.COD == ccdcode;
      })
    }
    console.log(Data);

    if (fromdate != '' && fromdate != null) {
        Data = Data.filter(function(billDetails) {
          return  new Date(DateRpl(billDetails.DT)).setHours(0, 0, 0, 0)  >= new Date(DateRpl(fromdate)).setHours(0, 0, 0, 0) ;
        })
    }
    if (todate != '' && todate != null) {
        Data = Data.filter(function(billDetails) {
          return  new Date(DateRpl(billDetails.DT)).setHours(24, 0, 0, 0)  <= new Date(DateRpl(todate)).setHours(24, 0, 0, 0) ;
        })
      }
    Data = Data.sort((a, b) => new Date(b.DT) - new Date(a.DT));
    var DCNO;
    var BALANCE;
    var DEBIT;
    var CREDIT;
    var bankHeadTotal;
    var BLL;
    var DL=Data.length;
    if (DL > 0) {
       BALANCE=0;
       DEBIT=0;
         CREDIT = 0;
         bankHeadTotal = "";
      tr += ` <thead id="bankHeadTotal"> </thead> <thead><tr>
                        <th>DATE</th>
                        <th>FIRM</th>
                        <th>DOCNO</th>
                        <th>PARTY</th>
                        <th>RFCODE</th>
                        <th class="CREDIT">CRA</th>
                        <th class="DEBIT">DRAMT</th>
                        <th>BALANCE</th>
                        <th>VNO</th>
                        <th>RMK</th>
                        </tr>
                        </thead>
                        `;
      for (var i = 0; i < DL; i++) {
         DEBIT +=parseFloat(Data[i].DRA);
         CREDIT+=parseFloat(Data[i].CRA);
         BALANCE +=parseFloat(Data[i].DRA)-parseFloat(Data[i].CRA)
         DCNO = getValueNotDefine(Data[i].DCNO);
        var paymentSlipUrl = getUrlPaymentSlip(Data[i].CNO, Data[i].TYPE, Data[i].VNO, Data[i].IDE);
        if(DCNO==''||DCNO==null){
          DCNO=getValueNotDefine(Data[i].BILLNO);
          billbutton = `<a target="_blank" href="` + paymentSlipUrl + `"><button>OPEN</button></a>`;
        } else {
          billbutton = `<a target="_blank" href="` + paymentSlipUrl + `"><button>`+DCNO+`</button></a>`;  
        }
        var RFCD = Data[i].RFCD;
        var RFCDArr = getPartyDetailsBySendCode(RFCD);
        if (RFCDArr.length > 0) {
          RFCD = RFCDArr[0].partyname;
        }
        var ccode = getPartyDetailsBySendCode(Data[i].COD);
        var pcode ="";
        var city ="";
        var broker ="";
        var label ="";
        var MO ="";
        var ATYPE ="";
        var lbl ="";
        if (ccode.length > 0) {
          pcode = getValueNotDefine(ccode[0].partyname);
          city = getValueNotDefine(ccode[0].city);
          broker = getValueNotDefine(ccode[0].broker);
          label = getValueNotDefine(ccode[0].label);
          MO = getValueNotDefine(ccode[0].MO);
          ATYPE = getValueNotDefine(ccode[0].ATYPE);
          lbl = parseInt(ATYPE) == 1 ? "CUST : " : parseInt(ATYPE) == 2 ? "SUPP : " : "";
    
        }
        console.log(Data[i]);
                tr += ` <tr>
                        <td>`+formatDate(Data[i].DT)+`</td>
                        <td>`+Data[i].FRM+`</td>
                        <td>`+billbutton+`</td>
                        <td>`+RFCD+`</td>
                        <td>`+lbl+`-`+pcode+`</td>
                        <td class="CREDIT">`+valuetoFixed(Data[i].DRA)+`</td>
                        <td class="DEBIT">`+valuetoFixed(Data[i].CRA)+`</td>
                        <td>`+(valuetoFixed(BALANCE))+`</td>
                        <td>`+Data[i].VNO+`</td>
                        <td> `+getValueNotDefine(Data[i].RMK)+`</td>
                        </tr>
                        `;
      }
      bankHeadTotal += `     <tr class="tfootcard">
                        <td colspan="5">GRAND TOTAL</td>
                        <td class="CREDIT">`+valuetoFixed(DEBIT)+`</td>
                        <td class="DEBIT">`+valuetoFixed(CREDIT)+`</td>
                        <td>`+(valuetoFixed(BALANCE))+`</td>
                        <td colspan="2"></td>
                        
                        </tr>
                        `;
        $('#result').html(tr);
        $('#bankHeadTotal').html(bankHeadTotal);
      $("#loader").removeClass('has-loader');
      if (CrDrEntryType != "") {        
        $(`.` + CrDrEntryType).css("display", "none");
      }
      
AddHeaderTbl();
devideTablesFieldWidth(10);

    }else{
      $('#result').html('<h1 align="center">No Data Found</h1>');
      $("#loader").removeClass('has-loader');  
    }
 

  }