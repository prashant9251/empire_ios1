

//-----------function-------
function getUrlPaymentSlip(CNO, TYPE, VNO, IDE) {
  return "paymentSlipPdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + CNO + "&TYPE=" + TYPE + "&VNO=" + VNO;
}
var MainArr = [];
function filterBy(oncode, value) {
  return MainArr.filter(function (d) {
    return d[oncode] == value;
  });
}
const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];
var GRD;


function currentPartyListOfMonth(monthNo,selectYear) {
  return PartynameList.filter(function (d) {
    return  d.monthNo == monthNo && d.selectYear == selectYear;
  })
}

function getSuppParryMonthList(COD, monthNo, selectYear) {
  return SuppnameList.filter(function (d) {
    return d.COD == COD && d.monthNo == monthNo && d.selectYear == selectYear;
  })
}
function getmonthPartySuppWiseDetails(COD,ccd, monthNo, selectYear) {
  return MainArr.filter(function (d) {
    return d.COD == COD &&d.ccd == ccd && d.monthNo == monthNo && d.selectYear == selectYear;
  })
}
var MonthList = [];
var PartynameList = [];
var SuppnameList = [];
function loadCall(data) {
  var MonthListFlg = [];
  var PartynameListFlg = [];
  var SuppnameListFlg = [];
  Data = data;
  var ccode;
  var pcode="";
  var city="";
  var broker="";
  var label="";
  var grandtotalNETBILLAMT = 0;
  var grandtotalGROSSAMT = 0;
  var grandtotalGOODSRETURN = 0;
  var grandtotalPAIDAMT = 0;
  var grandtotalAmount = 0;
  var totalNETBILLAMT = 0;
  var totalGROSSAMT = 0;
  var totalGOODSRETURN = 0;
  var totalPAIDAMT = 0;
  var totalAmount = 0;
  var subtotalNETBILLAMT = 0;
  var subtotalGROSSAMT = 0;
  var subtotalGOODSRETURN = 0;
  var subtotalPAIDAMT = 0;
  var subtotalAmount = 0;
  var BLL;
  var FdataUrl
  var DL = Data.length;
  tr = "<tbody>";

  var DtArray = [];
  for (i = 0; i < Data.length; i++) {
    if (Data[i].billDetails.length > 0) {
      for (j = 0; j < Data[i].billDetails.length; j++) {
        var obj = {};
        obj.COD = Data[i].COD;
        obj.ATP = Data[i].ATP;
        obj.CT = Data[i].CT;
        obj.CNO = Data[i].billDetails[j].CNO;
        obj.TYPE = Data[i].billDetails[j].TYPE;
        obj.VNO = Data[i].billDetails[j].VNO;
        obj.IDE = Data[i].billDetails[j].IDE;
        obj.FRM = Data[i].billDetails[j].FRM;
        obj.ccd = Data[i].billDetails[j].ccd;
        obj.BLL = Data[i].billDetails[j].BLL;
        obj.DTE = Data[i].billDetails[j].DTE;
        obj.TRN = Data[i].billDetails[j].TRN;
        obj.RNO = Data[i].billDetails[j].RNO;
        obj.LA1RT = Data[i].billDetails[j].LA1RT;
        obj.DCAMT = Data[i].billDetails[j].DCAMT;
        obj.DT = Data[i].billDetails[j].DT;
        obj.PD = Data[i].billDetails[j].PD;
        obj.SG = Data[i].billDetails[j].SG;
        obj.BAMT = getValueNotDefine(Data[i].billDetails[j].BAMT);
        obj.FAMT = Data[i].billDetails[j].FAMT;
        obj.SRS = Data[i].billDetails[j].SRS;
        obj.RD = Data[i].billDetails[j].RD;
        var monthName = "";
        try {
          var d = new Date(Data[i].billDetails[j].DTE);
          var selectYear = d.getFullYear();
          var monthName = monthNames[d.getMonth()];
          var monthNo = d.getMonth();
          // console.log(selectYear);
        } catch (error) {

        }
        if (!MonthListFlg[monthName + selectYear]) {
          var Nobj = {}
          Nobj.COD = Data[i].COD;
          Nobj.monthName = monthName;
          Nobj.selectYear = selectYear;
          Nobj.monthNo = monthNo;
          Nobj.monthyear =selectYear.toString()+ monthNo.toString();
          
          MonthList.push(Nobj);
          MonthListFlg[monthName + selectYear] = true;
        }
        if (!PartynameListFlg[Data[i].COD+selectYear +monthNo]) {
          var npobj={};
          npobj.selectYear=selectYear;
          npobj.monthName=monthName;
          npobj.monthNo=monthNo;
          npobj.COD=Data[i].COD;
          PartynameList.push(npobj);
          PartynameListFlg[Data[i].COD+selectYear +monthNo] = true;
        }
        if (!SuppnameListFlg[Data[i].COD+Data[i].billDetails[j].ccd+selectYear +monthNo]) {
          var npobj={};
          npobj.selectYear=selectYear;
          npobj.monthName=monthName;
          npobj.monthNo=monthNo;
          npobj.COD=Data[i].COD;
          npobj.ccd=Data[i].billDetails[j].ccd;
          SuppnameList.push(npobj);
          SuppnameListFlg[Data[i].COD+Data[i].billDetails[j].ccd+selectYear +monthNo] = true;
        }
        obj.monthNo = monthNo;
        obj.monthName = monthName;
        obj.selectYear = selectYear;
        MainArr.push(obj);

      }
    }
  }
  console.table(SuppnameList);
  MonthList=MonthList.sort(function(a,b){
    return   b.monthyear-a.monthyear ;
  })
  // PartynameList=PartynameList.sort(function(a,b){
  //   if (a.COD > b.COD)
  //     return 1;
  //   if (a.COD < b.COD)
  //     return -1;
  //     return 0;
  // })
  // console.log(MainArr);
  var grandtotalFinalAmt=0;

  if (MonthList.length > 0) {
    for (let i = 0; i < MonthList.length; i++) {
      const partyName = MonthList[i];


      var totalGrossAmt=0;
      var totalFinalAmt=0;
      tr += `<tr >
               <th colspan="17" class="pinkHeading">` + MonthList[i].monthName+`-` + MonthList[i].selectYear + `</th>
            </tr>
            `;

      var currentPartyListOfMonthArr=currentPartyListOfMonth( MonthList[i].monthNo, MonthList[i].selectYear);
      // console.log(currentPartyListOfMonthArr);
      for (let j = 0; j < currentPartyListOfMonthArr.length; j++) {
        const partyObj = currentPartyListOfMonthArr[j];
        ccode = getPartyDetailsBySendCode(partyObj.COD);
          var CST_GRP = "";
          if (ccode.length > 0) {
            pcode = getValueNotDefine(ccode[0].partyname);
            city = getValueNotDefine(ccode[0].city);
            broker = getValueNotDefine(ccode[0].broker);
            label = getValueNotDefine(ccode[0].label);
            CST_GRP = getValueNotDefine(ccode[0].GP);
          }
          var subtotalGrossAmt=0;
          var subtotalFinalAmt=0;
          tr += ` 
          <tr class="trPartyHead"  onclick="trOnClick('` + partyObj.COD + `','` + city + `','` + broker + `');">
                    <th  class="trPartyHead" colspan="13">` + label + `</th>                                    
                  </tr>
                  
                  <tr style="font-weight:500;font-weight:bold;"align="center">                    
          <th>BILL</th>
          <th>BILL&nbsp;DATE</th>
          <th>SUPP</th>
          <th>FINAL AMT</th>
          <th class="hideMWPWSPFRM">FIRM</th>
          <th class="hideMWPWSPSRS">TYPE</th>
          <th class="hideMWPWSPPD">PAID</th>
          <th class="hideMWPWRECDATE">REC&nbsp;DATE</th>
          <th class="hidePWSPDIS" style="display:none;">DIS%</th>
          <th class="hidePWSPDISCAMT" style="display:none;">DISCAMT</th>
          <th class="hideMWPWSPTRN">TRANSPORT</th>
          <th class="hideMWPWSPRNO">LR NO</th>
          <th class="hideMWPWSPGRP">GROUP</th>
          <th class="hideMWPWSPVNO">VNO</th>
          </tr>  
                  `;

            var suppList=getSuppParryMonthList(partyObj.COD , MonthList[i].monthNo, MonthList[i].selectYear );
            suppList=suppList.sort(function(a,b){
              if (a.ccd > b.ccd)
              return 1;
              if (a.ccd < b.ccd)
                return -1;
              return 0;
            });
            for (let l = 0; l < suppList.length; l++) {
              const supelement = suppList[l];
              tr += ` 
              <tr>
                    <th  class=""onclick="openSubR('`+ partyObj.COD + `','` + supelement.ccd + `')" colspan="13">` + supelement.ccd + `</th>                                    
                      </tr>`;

          var partyTranssection = getmonthPartySuppWiseDetails(partyObj.COD , supelement.ccd  , MonthList[i].monthNo, MonthList[i].selectYear )
          
          // console.log(partyTranssection);
          for (let k = 0; k < partyTranssection.length; k++) {
            const element = partyTranssection[k];

            var grsAmt = 0;
            var fnlAmt = 0;
            if (element.DT != null && element.DT != "") {
              if (element.DT.toUpperCase().indexOf('CN')) {
                grsAmt = +Math.abs(element.GAMT);
                fnlAmt = +Math.abs(element.BAMT);
              } else if (element.DT.toUpperCase().indexOf('DN')) {
                grsAmt = -Math.abs(element.GAMT);
                fnlAmt = -Math.abs(element.BAMT);
              } else if (element.DT.toUpperCase().indexOf('OS')) {
                grsAmt = -Math.abs(element.GAMT);
                fnlAmt = -Math.abs(element.BAMT);
              } else {
                grsAmt = -Math.abs(element.GAMT);
                fnlAmt = -Math.abs(element.BAMT);
              }
            } else {
              grsAmt = -Math.abs(element.GAMT);
              fnlAmt = -Math.abs(element.BAMT);
            }
            subtotalGrossAmt += parseInt(grsAmt);
            subtotalFinalAmt += parseInt(fnlAmt);
            GST = parseFloat(element.VTAMT) + parseFloat(element.ADVTAMT);
            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(element.CNO, element.TYPE, element.VNO, getFirmDetailsBySendCode(element.CNO)[0].FIRM, element.IDE);
  
            var supGrpName = element.SG;
  

            tr += `<tr align="center">
            <th><a href="`+ FdataUrl + `" target="_blank"><button class="PrintBtnHide">` + element.BLL + `</button></a></th>
            <th onclick="openSubR('`+ element.COD + `')">` + formatDate(element.DTE) + `</th>
            <th onclick="openSubR('`+ element.COD + `')" onclick="openSubR('`+ partyObj.COD + `','` + supelement.ccd + `')">` + getValueNotDefine(element.ccd) + `</th>
            <th onclick="openSubR('`+ element.COD + `')">` + valuetoFixed(fnlAmt) + `</th>
            <th class="hideMWPWSPFRM"onclick="openSubR('`+ element.COD + `')">` + element.FRM + `</th>
            <th class="hideMWPWSPSRS"onclick="openSubR('`+ element.COD + `')">` + element.SRS + `</th>
            <th class="hideMWPWSPPD"onclick="openSubR('`+ element.COD + `')">` + element.PD + `</th>
            
            <th onclick="openSubR('`+ element.COD + `')" class="hideMWPWRECDATE">` + formatDate(element.RD) + `</th>
            <th class="hidePWSPDIS" style="display:none;" onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.LA1RT) + `</th>
            <th class="hidePWSPDISCAMT" style="display:none;" onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.DCAMT) + `</th>
            <th class="hideMWPWSPTRN"onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.TRN) + `</th>
            <th class="hideMWPWSPRNO"onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.RNO) + `</th>
            <th class="hideMWPWSPGRP"onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(supGrpName) + `</th>
            <th class="hideMWPWSPVNO"onclick="openSubR('`+ element.COD + `')">` + getValueNotDefine(element.VNO) + `</th>
            </tr>`;

          }
            }
            if(currentPartyListOfMonthArr.length>1){
            tr += `  
            <tr class="tfootcard">
            <th>SUBTOTAL</th>
            <th></th>
            <th></th>
            <th>` + valuetoFixed(subtotalFinalAmt) + `</th>   
            <th ></th>
            <th class="hideMWPWSPFRM"></th>
            <th class="hideMWPWSPSRS"></th>
            <th class="hideMWPWRECDATE"></th>
            <th class="hideMWPWSPPD"></th>
            <th class="hidePWSPDIS" style="display:none;"></th>
            <th class="hidePWSPDISCAMT" style="display:none;"></th>
            <th class="hideMWPWSPTRN"></th>
            <th class="hideMWPWSPRNO"></th>
            <th class="hideMWPWSPGRP"></th>
            <th class="hideMWPWSPVNO"></th>
            </tr>  `;
          }
            totalFinalAmt+= subtotalFinalAmt;
            subtotalFinalAmt =0;
      }
      if(MonthList.length>1){
      tr += `  
            <tr class="tfootcard">
            <th>TOTAL</th>
            <th></th>
            <th></th>
            <th>` + valuetoFixed(totalFinalAmt) + `</th>   
            <th ></th>
            <th class="hideMWPWSPFRM"></th>
            <th class="hideMWPWSPSRS"></th>
            <th class="hideMWPWSPPD"></th>
            <th class="hideMWPWRECDATE"></th>
            <th class="hidePWSPDIS" style="display:none;"></th>
            <th class="hidePWSPDISCAMT" style="display:none;"></th>
            <th class="hideMWPWSPTRN"></th>
            <th class="hideMWPWSPRNO"></th>
            <th class="hideMWPWSPGRP"></th>
            <th class="hideMWPWSPVNO"></th>
            </tr>  `;
          } 
            grandtotalFinalAmt +=totalFinalAmt;
            totalFinalAmt=0;
        }

    tr += `  
    <tr class="tfootcard">
    <th>GRAND TOTAL</th>
    <th></th>
    <th></th>
    <th>` + valuetoFixed(grandtotalFinalAmt) + `</th>   
    <th ></th>
    <th class="hideMWPWSPFRM"></th>
    <th class="hideMWPWSPSRS"></th>
    <th class="hideMWPWSPPD"></th>
    <th class="hideMWPWRECDATE"></th>
    <th class="hidePWSPDIS" style="display:none;"></th>
    <th class="hidePWSPDISCAMT" style="display:none;"></th>
    <th class="hideMWPWSPTRN"></th>
    <th class="hideMWPWSPRNO"></th>
    <th class="hideMWPWSPGRP"></th>
    <th class="hideMWPWSPVNO"></th>
    </tr>  `;
    $('#result').html(tr);
    $("#loader").removeClass('has-loader');

    var hideAbleTr = getUrlParams(url, "hidePWMWAbleTr");
    if (hideAbleTr == "true") {
      $('.hideAbleTr').css("display", "none");
      $('.unhideAbleTr').css("display", "");
    } else {
      $('.unhideAbleTr').css("display", "none");
    }

    // AddHeaderTbl();
  } else {
    $('#result').html('<h1>No Data Found</h1>');
    $("#loader").removeClass('has-loader');

  }

  try {

  } catch (e) {

    $('#result').html(tr);
    $("#loader").removeClass('has-loader');
  }
}
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);

