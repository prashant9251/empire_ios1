
var Transection = [];
var TransectiontypeArray = [];
var PartyNameList = [];
var MonthList = [];
// console.log(ReportType, ReportSeriesTypeCode, ReportATypeCode, ReportDOC_TYPECode);
const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];
var GRD;

function getPartyListOfType(atype){
  return PartyNameList.filter(function(d){
    return d.ATYPE==atype;
  })
}

function getpartyTransectionMonthWise(atype,code){
  return MonthList.filter(function(d){
    return d.ATYPE==atype && d.code==code;
  })
}

function getpartyTransection(atype, code,monthName,selectYear){
  return Transection.filter(function(d){
    return d.ATYPE==atype && d.code==code && d.monthName == monthName && d.selectYear == selectYear;
  })
}
function loadCall(data) {
  tr = '';
  Transection = [];
  TransectiontypeArray = [];
  PartyNameList = [];
  MonthList = [];
  Data = data;
  var ccode;
  var FdataUrl
  var DL = Data.length;
  if (DL > 0) {
    // console.log(Data);
    var flagParty = [];
    var flagTransectionType = [];
    var MonthListFlg = [];

    for (var i = 0; i < Data.length; i++) {
      for (var j = 0; j < Data[i].billDetails.length; j++) {
        var obj = {};
        obj.code = Data[i].code;
        obj.CNO = Data[i].billDetails[j].CNO;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.VNO = Data[i].billDetails[j].VNO;
        obj.DT = Data[i].billDetails[j].DT;
        obj.TG = Data[i].billDetails[j].TG;
        obj.TA = Data[i].billDetails[j].TA;
        var mst_obj=getPartyDetailsBySendCode(Data[i].code);
        if(mst_obj.length>0){
          obj.ATYPE=mst_obj[0]["ATYPE"];
          obj.PNO=mst_obj[0]["PNO"];
          obj.partyname=mst_obj[0]["partyname"];
          obj.MO=mst_obj[0]["MO"];
          obj.label=mst_obj[0]["label"];
        }
        var monthName = "";
        try {
          var d = new Date(Data[i].billDetails[j].DT);
          var selectYear = d.getFullYear();
          var monthName = monthNames[d.getMonth()];
          obj.monthName=monthName;
          obj.monthNo=d.getMonth();
          obj.selectYear=selectYear;
          // console.log(selectYear);
        } catch (error) {

        }
        Transection.push(obj);
        if (!flagTransectionType[obj.ATYPE]) {
          TransectiontypeArray.push(obj.ATYPE);
          flagTransectionType[obj.ATYPE] = true;
        }
        if (!flagParty[Data[i].code + obj.ATYPE]) {
          var nobj = {};
          nobj.code = Data[i].code;
          nobj.ATYPE = obj.ATYPE;
          PartyNameList.push(nobj);
          flagParty[Data[i].code + obj.ATYPE] = true;
        }

        if (!MonthListFlg[Data[i].code + monthName + selectYear + obj.ATYPE]) {
          var Nobj = {}
          Nobj.code = Data[i].code;
          Nobj.monthName = monthName;
          Nobj.selectYear = selectYear;
          obj.monthNo=d.getMonth();
          Nobj.ATYPE = obj.ATYPE;
          MonthList.push(Nobj);
          MonthListFlg[Data[i].code + monthName + selectYear + obj.ATYPE] = true;
        }
      }
    }
    console.log(MonthList);
    // console.log(TransectiontypeArray);
   
    TransectiontypeArray = TransectiontypeArray.sort()
    var tr = '';
    
    var supgrandtotaltdsAmt =0;
    var supgrandtotaltdsGrossAmt =0;
    var grandtotaltdsAmt =0;
    var grandtotaltdsGrossAmt =0;
    for (let i = 0; i < TransectiontypeArray.length; i++) {
      const Transectiontype_element = TransectiontypeArray[i];
      var Transectiontype= getAtypeDetails(Transectiontype_element);
      // console.log(Transectiontype);
      var tr_label = Transectiontype_element;

      if(Transectiontype.length>0){
        tr_label = Transectiontype[0]["NAME"];
      }
      tr += `<tr class="trPartyHead">
            <th  class="trPartyHead" colspan="15"><b>` + tr_label +`</b></th>
        </tr>`;

        tr += ` 
          <tr style="font-weight:700;"align="center">                    
              <th class="alignLeft">DATE</th>
              <th class="alignRight">AMT</th>
              <th class="alignRight">TDS AMT</th>
          </tr>`;
      var PartyListOfType= getPartyListOfType(Transectiontype_element);

      var totaltdsAmt =0;
      var totaltdsGrossAmt =0;
      for (let j = 0; j < PartyListOfType.length; j++) {
        const party_element = PartyListOfType[j];
        tr += `<tr class="pinkHeading"  onclick="trOnClick('` + party_element.code + `','','');">
            <th class="pinkHeading" colspan="22">`+ party_element.code + `</th>
        </tr>`;

        var partyTransectionMonthWise= getpartyTransectionMonthWise(Transectiontype_element, party_element.code);
          // console.log(partyTransectionMonthWise);
          var subtotaltdsAmt =0;
          var subtotaltdsGrossAmt =0;
        for (let k = 0; k < partyTransectionMonthWise.length; k++) {
          const monthWiseTr = partyTransectionMonthWise[k];
           
          var partyTransection =getpartyTransection(Transectiontype_element, party_element.code, monthWiseTr.monthName, monthWiseTr.selectYear);

                      // console.log(party_element.code,partyTransection);
                      for (let l = 0; l < partyTransection.length; l++) {
                        const element = partyTransection[l];
                        subtotaltdsGrossAmt +=parseFloat(element.TG);
                        subtotaltdsAmt +=parseFloat(element.TA);           
                      }
          
                      tr+=`
                      <tr>
                      <th class="alignLeft">`+ monthWiseTr.monthName +"-"+ monthWiseTr.selectYear+`</th>
                      <th class="alignRight">`+parseFloat(subtotaltdsGrossAmt).toFixed(2)+`</th>
                      <th class="alignRight">`+parseFloat(subtotaltdsAmt).toFixed(2)+`</th>
                      </tr>
                      `;   
                      totaltdsAmt +=subtotaltdsAmt;
                      totaltdsGrossAmt +=subtotaltdsGrossAmt;
                      subtotaltdsAmt =0;
                      subtotaltdsGrossAmt =0;
        }

        if(partyTransectionMonthWise.length>1){
          tr+=`
          <tr class="tfootcard">
          <th class="alignLeft">SUB TOTAL</th>
          <th class="alignRight">`+parseFloat(totaltdsGrossAmt).toFixed(2)+`</th>
          <th class="alignRight">`+parseFloat(totaltdsAmt).toFixed(2)+`</th>
          </tr>
          `;
        }
        grandtotaltdsAmt +=totaltdsAmt;
        grandtotaltdsGrossAmt +=totaltdsGrossAmt;
        totaltdsAmt =0;
        totaltdsGrossAmt =0;
      }
       tr+=`
        <tr class="tfootcard">
        <th class="alignLeft"> TOTAL</th>
        <th class="alignRight">`+parseFloat(grandtotaltdsGrossAmt).toFixed(2)+`</th>
        <th class="alignRight">`+parseFloat(grandtotaltdsAmt).toFixed(2)+`</th>
        </tr>
        `;
        supgrandtotaltdsAmt += grandtotaltdsAmt;
        supgrandtotaltdsGrossAmt += grandtotaltdsGrossAmt;
        grandtotaltdsAmt=0;
        grandtotaltdsGrossAmt=0;
    }

    tr+=`
    <tr class="tfootcard">
    <th class="alignLeft">GRAND TOTAL</th>
    <th class="alignRight">`+parseFloat(supgrandtotaltdsGrossAmt).toFixed(2)+`</th>
    <th class="alignRight">`+parseFloat(supgrandtotaltdsAmt).toFixed(2)+`</th>
    </tr>
    `;

    // console.log(Transection, TransectiontypeArray, PartyNameList);
    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
    hideList();
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

