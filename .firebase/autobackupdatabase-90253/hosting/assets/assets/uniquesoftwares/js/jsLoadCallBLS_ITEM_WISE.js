
var TransectionArray = [];
var partyNameList = [];
var QualityList = [];
function getQualPartyfilterData(partyName, qual) {
  return TransectionArray.filter(function (d) {
    return d.code == partyName && d.qual == qual;
  });
}
function getproductPartyList(code) {
  return partyNameList.filter(function (d) {
    return d.qual == code;
  })
}
// console.log(ReportType, ReportSeriesTypeCode, ReportATypeCode, ReportDOC_TYPECode);

var GRD;
function jsLoadCallBLS_ITEM_WISE(data) {
  tr = '';
  TransectionArray = [];
  partyNameList = [];
  QualityList = [];
  Data = data;
  var ccode;
  var pcode = "";
  var city;
  var broker = "";
  var label = "";
  var qualcode = getUrlParams(url, "qualcode");
  var qualname = getUrlParams(url, "qualname");
  if(qualname==null || qualname ==""){
    qualcode="";
  }
  var BLL;
  var FdataUrl
  var DL = Data.length;
  var DET = [];
  function getProductDetails(CNO, TYPE, VNO) {
    return DET.filter(function (d) {
      return d.CNO == CNO && d.TYPE == TYPE && d.VNO == VNO;
    })
  }
  // console.log(Data);
  var flagQuality = [];
  var flagpartyName = [];
  jsGetObjectByKey(DSN, "DET", "").then(function (productDet) {
    DET = productDet;
    // console.log(DET);
    for (var i = 0; i < Data.length; i++) {
      for (var j = 0; j < Data[i].billDetails.length; j++) {
       
        var productDetails = getProductDetails(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO);
        for (let k = 0; k < productDetails.length; k++) {
          const product = productDetails[k];
          for (let l = 0; l < product.billDetails.length; l++) {
            const element = product.billDetails[l];
            // console.log(element);
            var obj = {};
            obj.code = Data[i].code;
            obj.IDE = Data[i].billDetails[j].IDE;
            obj.sft = Data[i].billDetails[j].sft;
            obj.year = Data[i].billDetails[j].year;
            obj.FRM = Data[i].billDetails[j].FRM;
            obj.CITY = Data[i].billDetails[j].CITY;
            obj.SERIES = Data[i].billDetails[j].SERIES;
            obj.ACCODE = Data[i].billDetails[j].ACCODE;
            obj.ATYP = Data[i].billDetails[j].ATYP;
            obj.CNO = Data[i].billDetails[j].CNO;
            obj.TYPE = Data[i].billDetails[j].TYPE;
            obj.VNO = Data[i].billDetails[j].VNO;
            obj.ADAT = Data[i].billDetails[j].ADAT;
            obj.BILL = Data[i].billDetails[j].BILL;
            obj.DATE = Data[i].billDetails[j].DATE;
            obj.CHLN = Data[i].billDetails[j].CHLN;
            obj.RRNO = Data[i].billDetails[j].RRNO;
            obj.RRDET = Data[i].billDetails[j].RRDET;
            obj.WGT = Data[i].billDetails[j].WGT;
            obj.FRT = Data[i].billDetails[j].FRT;
            obj.CSNO = Data[i].billDetails[j].CSNO;
            obj.PLC = Data[i].billDetails[j].PLC;
            obj.TRNSP = Data[i].billDetails[j].TRNSP;
            obj.BAMT = Data[i].billDetails[j].BAMT;
            obj.TMTS = Data[i].billDetails[j].TMTS;
            obj.TPCS = Data[i].billDetails[j].TPCS;
            obj.RC_AMT = Data[i].billDetails[j].RC_AMT;
            obj.DISC = Data[i].billDetails[j].DISC;
            obj.OTH_LS = Data[i].billDetails[j].OTH_LS;
            obj.RD_AMT = Data[i].billDetails[j].RD_AMT;
            obj.clms = Data[i].billDetails[j].clms;
            obj.SWTS_AMT = Data[i].billDetails[j].SWTS_AMT;
            obj.DDCOM = Data[i].billDetails[j].DDCOM;
            obj.AD_AMT = Data[i].billDetails[j].AD_AMT;
            obj.PART = Data[i].billDetails[j].PART;
            obj.WT_LS = Data[i].billDetails[j].WT_LS;
            obj.WT_LSRATE = Data[i].billDetails[j].WT_LSRATE;
            obj.WT_LSAMT = Data[i].billDetails[j].WT_LSAMT;
            obj.fnlamt = Data[i].billDetails[j].fnlamt;
            obj.paid = Data[i].billDetails[j].paid;
            obj.RMK = Data[i].billDetails[j].RMK;
            obj.grsamt = Data[i].billDetails[j].grsamt;
            obj.billdis = Data[i].billDetails[j].billdis;
            obj.BCODE = Data[i].billDetails[j].BCODE;
            obj.PRCL = Data[i].billDetails[j].PRCL;
            obj.PAYCHQ = Data[i].billDetails[j].PAYCHQ;
            obj.PAYDET = Data[i].billDetails[j].PAYDET;
            obj.CNVTAMT = Data[i].billDetails[j].CNVTAMT;
            obj.ad_oth2 = Data[i].billDetails[j].ad_oth2;
            obj.haste = Data[i].billDetails[j].haste;
            obj.WT_LSBASE = Data[i].billDetails[j].WT_LSBASE;
            obj.TDSRATE = Data[i].billDetails[j].TDSRATE;
            obj.TDSAMT = Data[i].billDetails[j].TDSAMT;
            obj.QUAL = Data[i].billDetails[j].QUAL;
            obj.GRT = Data[i].billDetails[j].GRT;
            obj.discamt = Data[i].billDetails[j].discamt;
            obj.LA1qty = Data[i].billDetails[j].LA1qty;
            obj.LA2qty = Data[i].billDetails[j].LA2qty;
            obj.LA3qty = Data[i].billDetails[j].LA3qty;
            obj.LA1RMK = Data[i].billDetails[j].LA1RMK;
            obj.LA2RMK = Data[i].billDetails[j].LA2RMK;
            obj.LA3RMK = Data[i].billDetails[j].LA3RMK;
            obj.LA1RATE = Data[i].billDetails[j].LA1RATE;
            obj.LA2RATE = Data[i].billDetails[j].LA2RATE;
            obj.LA3RATE = Data[i].billDetails[j].LA3RATE;
            obj.LA1AMT = Data[i].billDetails[j].LA1AMT;
            obj.LA2AMT = Data[i].billDetails[j].LA2AMT;
            obj.LA3AMT = Data[i].billDetails[j].LA3AMT;
            obj.OTHRTYPE = Data[i].billDetails[j].OTHRTYPE;
            obj.GRYCT = Data[i].billDetails[j].GRYCT;
            obj.LDRRMK = Data[i].billDetails[j].LDRRMK;
            obj.VTRET = Data[i].billDetails[j].VTRET;
            obj.VTAMT = Data[i].billDetails[j].VTAMT;
            obj.ADVTRET = Data[i].billDetails[j].ADVTRET;
            obj.ADVTAMT = Data[i].billDetails[j].ADVTAMT;
            obj.EWB = Data[i].billDetails[j].EWB;
            obj.STC = Data[i].billDetails[j].STC;
            obj.DT = Data[i].billDetails[j].DT;
            obj.GRD = Data[i].billDetails[j].GRD;
            obj.SR = element.SR;
            obj.PCK = element.PCK;
            obj.qual = element.qual;
            obj.RATE = element.RATE;
            obj.MTS = element.MTS;
            obj.CUT = element.CUT;
            obj.PCS = element.PCS;
            obj.UNIT = element.UNIT;
            obj.AMT = element.AMT;
            obj.disamt = element.disamt;
            obj.DR = element.DR;
            obj.CTGRY = element.CTGRY;
            obj.DET = element.DET;
            obj.BSQL = element.BSQL;
            obj.altql = element.altql;
            obj.DTVTRET = element.DTVTRET;
            obj.DTVTAMT = element.DTVTAMT;
            obj.hsn = element.hsn;
            obj.LF = element.LF;
            TransectionArray.push(obj);
            
          }

        }

      }
    }


    // console.log(partyNameList, QualityList);
    if(qualcode!=null && qualcode !=""){
      TransectionArray=TransectionArray.filter(function(d){
        return d.qual=qualcode;
      })
    }

    var mainqualname = getUrlParams(url, "mainqualname");
    var MainScreenQualArray = JSON.parse(localStorage.getItem("MainScreenQualArray"));
    if (mainqualname != "" && mainqualname != null) {
      if (MainScreenQualArray != "" && MainScreenQualArray != null) {
        TransectionArray = TransectionArray.filter(function (d) {
          return this==d.qual;
        }, MainScreenQualArray)
      }
    }

    tr = '';
    if (TransectionArray.length > 0) {

      var subtotalPCS = 0;
      var subtotalFinalAmt = 0;
      var subtotalMTS = 0;
      var subtotalNET_MTS = 0;


      var totalPCS = 0;
      var totalFinalAmt = 0;
      var totalMTS = 0;
      var totalNET_MTS = 0;


      var grandtotalPCS = 0;
      var grandtotalFinalAmt = 0;
      var grandtotalMTS = 0;
      var grandtotalNET_MTS = 0;

     
      tr += `<tr class="trPartyHead">
      <th class="pdfBtnHide">PDF</th>
      <th class="hideIWBILLNO">BILLNO</th>
      <th class="hideIWITEM">ITEM</th>
      <th class="hideIWMAINSCREEN" style="display:none;">MAINSCREEN</th>
      <th class="hideIWPARTY">PARTY</th>
      <th class="hideIWDATE">BILL&nbsp;DATE</th>
      <th class="hideIWPCS alignCenter alignRight">PCS</th>
      <th class="hideIWPACK ">PACK</th>
      <th class="hideIWRATE alignRight">RATE</th>
      <th class="hideIWMTS alignRight">MTS</th>
      <th class="hideIWNETMTS alignRight">NETMTS</th>
      <th class="hideIWFOLDLESS alignRight">FOLDLESS</th>
      <th class="hideIWAMT alignRight">AMT</th>
      <th class="hideIWBROKER">BROKER</th>
      <th class="hideIWFIRM">FIRM</th>
      <th class="hideIWTYPE">TYPE</th>
      <th class="hideIWDAYS" style="display:none;">DAYS</th>
      <th class="hideIWTRANSPORT" style="display:none;">TRANSPORT</th>
      <th class="hideIWLR" style="display:none;">LR</th>
      </tr>`;

  // var order = getUrlParams(url, "order");
  // if(order=="DESC"){
  //   TransectionArray=TransectionArray.sort(function(a,b){
  //     return parseInt(getValueNotDefine(b.CNO)) - parseInt(getValueNotDefine(a.CNO)) || parseInt(getValueNotDefine(b.VNO)) - parseInt(getValueNotDefine(a.VNO));
  //   })
  // }else{
  // }

    TransectionArray=TransectionArray.sort(function(a,b){
      return new Date(a.DATE) - new Date(b.DATE) || parseInt(getValueNotDefine(a.VNO)) - parseInt(getValueNotDefine(b.VNO))|| parseInt(getValueNotDefine(a.SR)) - parseInt(getValueNotDefine(b.SR));
    })
      for (let i = 0; i < TransectionArray.length; i++) {

          var ccode = getPartyDetailsBySendCode(TransectionArray[i].code);
          var pcode = "";
          var city = "";
          var broker = "";
          var MO = "";
          if (ccode.length > 0) {
            label = getValueNotDefine(ccode[0].label);
            pcode = getValueNotDefine(ccode[0].value);
            city = getValueNotDefine(ccode[0].city);
            broker = getValueNotDefine(ccode[0].broker);
            MO = getValueNotDefine(ccode[0].MO);
          }
            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(TransectionArray[i].CNO, TransectionArray[i].TYPE, TransectionArray[i].VNO, getFirmDetailsBySendCode(TransectionArray[i].CNO)[0].FIRM, TransectionArray[i].IDE,MO);


            var LESS_FOLD = parseInt(TransectionArray[i].LF);;
            var NET_MTS = parseInt(TransectionArray[i].MTS);
            if (TransectionArray[i].LF != "" && TransectionArray[i].LF != null && TransectionArray[i].LF != undefined) {
              var MTS = parseInt(TransectionArray[i].MTS);
              LESS_FOLD = parseInt(TransectionArray[i].LF);
              var lessMts = (MTS * LESS_FOLD) / 100;
              NET_MTS = MTS - lessMts;
            }

            subtotalPCS += parseInt(TransectionArray[i].PCS);
            subtotalFinalAmt += parseFloat(TransectionArray[i].AMT);
            subtotalMTS += parseFloat(TransectionArray[i].MTS);
            subtotalNET_MTS += NET_MTS;
            tr += `<tr >
                        <td class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></td>
                        <td class="hideIWBILLNO"><a target="_blank"href="`+ FdataUrl + `"><button>` + TransectionArray[i].BILL + `</button></a></td>
                        <td class="hideIWITEM" onclick="openSubRQ('`+ TransectionArray[i].qual + `')">` + (TransectionArray[i].qual) + `</td>
                        <td class="hideIWMAINSCREEN" style="display:none;" onclick="openSubRQ('`+ TransectionArray[i].qual + `')">` + (TransectionArray[i].altql) + `</td>
                        <td class="hideIWPARTY" onclick="openSubR('`+ TransectionArray[i].code + `')">` + (TransectionArray[i].code) + `</td>
                        <td class="hideIWDATE"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + formatDate(TransectionArray[i].DATE) + `</td>
                        <td class="hideIWPCS alignCenter alignRight"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + parseInt(TransectionArray[i].PCS) + `</td>
                        <td class="hideIWPACK "  onclick="openSubR('`+ TransectionArray[i].code + `')">` + (TransectionArray[i].PCK) + `</td>
                        <td class="hideIWRATE alignRight"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + valuetoFixed(TransectionArray[i].RATE) + `</td>
                        <td class="hideIWMTS alignRight"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + parseFloat(TransectionArray[i].MTS).toFixed(2) + `</td>
                        <td class="hideIWNETMTS alignRight"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + parseFloat(NET_MTS).toFixed(2) + `</td>
                        <td class="hideIWFOLDLESS alignRight"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + (parseFloat(LESS_FOLD).toFixed(2)) + `</td>
                        <td class="hideIWAMT alignRight"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + valuetoFixed(TransectionArray[i].AMT) + `</td>
                        <td class="hideIWBROKER"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + TransectionArray[i].BCODE + `</td>
                        <td class="hideIWFIRM"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + TransectionArray[i].FRM + `</td>
                        <td class="hideIWTYPE"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + getSeriesDetailsBySendType(TransectionArray[i].TYPE)[0].SERIES + `</td>
                        <td class="hideIWDAYS" style="display:none;"  onclick="openSubR('`+ TransectionArray[i].code + `')">` + getDaysDif(TransectionArray[i].DATE, nowDate)+ `</td>
                        <td class="hideIWTRANSPORT" style="display:none;" onclick="openSubR('`+ TransectionArray[i].code + `')">` + TransectionArray[i].TRNSP + `</td>
                        <td class="hideIWLR" style="display:none;" onclick="openSubR('`+ TransectionArray[i].code + `')">` + TransectionArray[i].RRNO + `</td>

                        </tr>`;
                if (TransectionArray[i].DET != null && TransectionArray[i].DET != "" && TransectionArray[i].DET != undefined) {
                  tr += `<tr class="hideAbTr" >
                            <td colspan="18">REMARK: `+ TransectionArray[i].DET + `</td>
                          </tr>`;
                }

          
          totalPCS += subtotalPCS;
          totalFinalAmt += subtotalFinalAmt;
          totalMTS += subtotalMTS;
          totalNET_MTS += subtotalNET_MTS;
          subtotalPCS = 0;
          subtotalFinalAmt = 0;
          subtotalMTS = 0;
          subtotalNET_MTS = 0;
        
        grandtotalPCS += totalPCS;
        grandtotalFinalAmt += totalFinalAmt;
        grandtotalMTS += totalMTS;
        grandtotalNET_MTS += totalNET_MTS;
        totalPCS = 0;
        totalMTS = 0;
        totalNET_MTS = 0;
        totalFinalAmt = 0;
      }

        tr += `<tr class="tfootcard">
      <th >GRAND TOTAL </th>
      <th class="hideIWBILLNO"></th>
      <th class="hideIWITEM"></th>
      <th class="hideIWMAINSCREEN" style="display:none;"></th>
      <th class="hideIWPARTY"></th>
      <th class="hideIWDATE"></th>
      <th class="hideIWPCS">`+ parseInt(grandtotalPCS) + `</th>
      <th class="hideIWPACK"></th>
      <th class="hideIWRATE"></th>
      <th class="hideIWMTS" >`+ valuetoFixed(grandtotalMTS) + `</th>
      <th class="hideIWNETMTS">`+ valuetoFixed(grandtotalNET_MTS) + `</th>
      <th class="hideIWFOLDLESS"></th>
      <th class="hideIWAMT">`+ valuetoFixed(grandtotalFinalAmt) + `</th>
      <th class="hideIWBROKER"></th>
      <th class="hideIWFIRM"></th>
      <th class="hideIWTYPE"></th>
      <th class="hideIWDAYS" style="display:none;"></th>
      <th class="hideIWTRANSPORT" style="display:none;"></th>
      <th class="hideIWLR" style="display:none;"></th>
      </tr>`;
      


      $('#result').html(tr);
      $("#loader").removeClass('has-loader');
      if (GRD == '' || GRD == null) {
        $('.GRD').css("display", "none");
      }
      var hideAbleTr = getUrlParams(url, "hideAbTr");
      if (hideAbleTr == "true") {
        $('.hideAbleTr').css("display", "none");
      }

      var PDFStore = getUrlParams(url, "PDFStore");
      if (PDFStore == "true") {
        alert("PDFStore=true");
      }

      var PDFStorePermission = getUrlParams(url, "PDFStorePermission");
      if (PDFStorePermission == "true") {
        UrlSendToAndroid(Data);
      }

      // BuildAccountdetaisl(CNOArray);
      hideList();
    } else {
      $('#result').html('<h1>No Data Found</h1>');
      $("#loader").removeClass('has-loader');

    }

  })

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

