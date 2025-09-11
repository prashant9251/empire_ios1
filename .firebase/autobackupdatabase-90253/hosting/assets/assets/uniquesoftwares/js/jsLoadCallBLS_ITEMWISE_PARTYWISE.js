
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
var smTr=`<thead></thead>`;
function loadCallITEMWISE_PARTYWISE(data) {
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
            // console.log(element.qual);
            if (!flagQuality[element.qual]) {
              QualityList.push(element.qual);
              flagQuality[element.qual] = true;
            }


            if (!flagpartyName[Data[i].code + element.qual]) {
              var newObj = {};
              newObj.code = Data[i].code;
              newObj.qual = element.qual;
              partyNameList.push(newObj);
              flagpartyName[Data[i].code + element.qual] = true;
            }
          }

        }

      }
    }


    // console.log(partyNameList, QualityList);


    tr = '';
    if (QualityList.length > 0) {

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

      var mainqualname = getUrlParams(url, "mainqualname");
      var MainScreenQualArray = JSON.parse(localStorage.getItem("MainScreenQualArray"));
      // console.log(MainScreenQualArray)
      if (mainqualname != "" && mainqualname != null) {
        if (MainScreenQualArray != "" && MainScreenQualArray != null) {
          QualityList = QualityList.filter(function (d) {
            return this==d;
          }, MainScreenQualArray)
        }
      }
      QualityList.sort((a, b) => a.localeCompare(b));

      for (let i = 0; i < QualityList.length; i++) {

        const QualityName = QualityList[i];
        // console.log(qualcode, QualityList)
        if (qualcode != null && qualcode != "") {
          if (qualcode == QualityName) {
          } else {
            continue;
          }
        }

        tr += `<tr class="pinkHeading">
          <th  colspan="20" style="text-align:left;"class="pinkHeading"onclick="openSubRQ('`+ QualityName + `')"><b>` + QualityName + `</b></th>
          </tr>`;
          smTr+=`

          <tr class="trPartyHead">
          <th class="trPartyHead" colspan="20" style="text-align:left;"class="pinkHeading"onclick="openSubRQ('`+ QualityName + `')"><b>` + QualityName + `</b></th>
          </tr>

  <tr class=""style="font-weight:bold;color: brown;">
  <th >PARTY NAME</th>
  <th class="hideIWPWSMPARCEL ">PCS</th>
  <th class="hideIWPWSMMTS ">MTS</th>
  <th class="hideIWPWSMNMTS ">NMTS</th>
  <th class="hideIWPWSMAMOUNT ">AMOUNT</th>
  </tr>
          `;
        var productPartyList = getproductPartyList(QualityName);
        // console.log(productPartyList);
        for (let j = 0; j < productPartyList.length; j++) {
          const productPartyListData = productPartyList[j];

          var ccode = getPartyDetailsBySendCode(productPartyListData.code);
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
          tr += `<tr class="trPartyHead">
            <th  colspan="20"class="trPartyHead" ><b>`+ label + `</b></th>
            </tr> 
            `;
          tr += `<tr>
              <th class="pdfBtnHide">PDF</th>
              <th class="hideIWPWITEM">ITEM</th>
              <th class="hideIWPWMAINSCREEN" style="display:none;">MAINSCREEN</th>
              <th class="hideIWPWDATE">BILL&nbsp;DATE</th>
              <th class="hideIWPWBILLNO">BILLNO</th>
              <th class="hideIWPWPCS alignCenter alignRight">PCS</th>
              <th class="hideIWPWPACK ">PACK</th>
              <th class="hideIWPWRATE alignRight">RATE</th>
              <th class="hideIWPWMTS alignRight">MTS</th>
              <th class="hideIWPWNETMTS alignRight">NETMTS</th>
              <th class="hideIWPWFOLDLESS alignRight">FOLDLESS</th>
              <th class="hideIWPWAMT alignRight">AMT</th>
              <th class="hideIWPWFIRM">FIRM</th>
              <th class="hideIWPWTYPE">TYPE</th>
              <th class="hideIWPWEWB" style="display:none;">EWB</th>
              <th class="hideIWPWTRANSPORT" style="display:none;">TRANSPORT</th>
              <th class="hideIWPWLR" style="display:none;">LR</th>
              <th class="hideIWPWDAYS" style="display:none;">DAYS</th>
              </tr>`;
          var filterData = getQualPartyfilterData(productPartyListData.code, QualityName);
          var qualcodeForSm ="";
          for (let k = 0; k < filterData.length; k++) {

            const filterDataArr = filterData[k];

            FdataUrl = getFullDataLinkByCnoTypeVnoFirm(filterDataArr.CNO, filterDataArr.TYPE, filterDataArr.VNO, getFirmDetailsBySendCode(filterDataArr.CNO)[0].FIRM, filterDataArr.IDE);


            var LESS_FOLD = parseInt(filterDataArr.LF);;
            var NET_MTS = parseInt(filterDataArr.MTS);
            if (filterDataArr.LF != "" && filterDataArr.LF != null && filterDataArr.LF != undefined) {
              var MTS = parseInt(filterDataArr.MTS);
              LESS_FOLD = parseInt(filterDataArr.LF);
              var lessMts = (MTS * LESS_FOLD) / 100;
              NET_MTS = MTS - lessMts;
            }

            subtotalPCS += parseInt(filterDataArr.PCS);
            subtotalFinalAmt += parseFloat(filterDataArr.AMT);
            subtotalMTS += parseFloat(filterDataArr.MTS);
            subtotalNET_MTS += NET_MTS;
            qualcodeForSm=filterDataArr.qual;
            var SeriesArr=getSeriesDetailsBySendType(filterDataArr.TYPE);
            var SERIES="";
            if(SeriesArr.length>0){
              SERIES =SeriesArr[0].SERIES;
            }
            tr += `<tr class="hideAbleTr" >
                        <th class="pdfBtnHide"><a href="`+ FdataUrl.replace("fData", "Billpdf") + `" target="_blank"><button>PDF</button><a></th>
                        <td class="hideIWPWITEM" onclick="openSubRQ('`+ filterDataArr.qual + `')">` + (filterDataArr.qual) + `</td>
                        <td class="hideIWPWMAINSCREEN" style="display:none;" onclick="openSubRQ('`+ filterDataArr.qual + `')">` + (filterDataArr.altql) + `</td>
                        <td class="hideIWPWDATE"  onclick="openSubR('`+ filterDataArr.code + `')">` + formatDate(filterDataArr.DATE) + `</td>
                        <td class="hideIWPWBILLNO"><a target="_blank"href="`+ FdataUrl + `"><button>` + filterDataArr.BILL + `</button></a></td>
                        <td class="hideIWPWPCS alignCenter alignRight"  onclick="openSubR('`+ filterDataArr.code + `')">` + parseInt(filterDataArr.PCS) + `</td>
                        <td class="hideIWPWPACK "  onclick="openSubR('`+ filterDataArr.code + `')">` + (filterDataArr.PCK) + `</td>
                        <td class="hideIWPWRATE alignRight"  onclick="openSubR('`+ filterDataArr.code + `')">` + valuetoFixed(filterDataArr.RATE) + `</td>
                        <td class="hideIWPWMTS alignRight"  onclick="openSubR('`+ filterDataArr.code + `')">` + valuetoFixed(filterDataArr.MTS) + `</td>
                        <td class="hideIWPWNETMTS alignRight"  onclick="openSubR('`+ filterDataArr.code + `')">` + getValueNotDefineNo(NET_MTS) + `</td>
                        <td class="hideIWPWFOLDLESS alignRight"  onclick="openSubR('`+ filterDataArr.code + `')">` + (valuetoFixed(LESS_FOLD)) + `</td>
                        <td class="hideIWPWAMT alignRight"  onclick="openSubR('`+ filterDataArr.code + `')">` + valuetoFixed(filterDataArr.AMT) + `</td>
                        <td class="hideIWPWFIRM"  onclick="openSubR('`+ filterDataArr.code + `')">` + filterDataArr.FRM + `</td>
                        <td class="hideIWPWTYPE"  onclick="openSubR('`+ filterDataArr.code + `')">` + SERIES+ `</td>
              <th class="hideIWPWEWB" style="display:none;"  onclick="openSubR('`+ filterDataArr.code + `')">` + getValueNotDefine(filterDataArr.EWB) + `</td>
              <th class="hideIWPWTRANSPORT" style="display:none;" onclick="openSubR('`+ filterDataArr.code + `')">` + getValueNotDefine(filterDataArr.TRNSP) + `</th>
              <th class="hideIWPWLR" style="display:none;" onclick="openSubR('`+ filterDataArr.code + `')">` + getValueNotDefine(filterDataArr.RRNO) + `</th>
              <th class="hideIWPWDAYS" style="display:none;" onclick="openSubR('`+ filterDataArr.code + `')">` + getDaysDif(filterDataArr.DATE, nowDate) + `</th>
              </tr>`;
            if (filterDataArr.DET != null && filterDataArr.DET != "" && filterDataArr.DET != undefined) {
              tr += `<tr class="hideAbleTr" >
                        <td colspan="16">REMARK: `+ filterDataArr.DET + `</td>
                      </tr>`;
            }

          }
          totalPCS += subtotalPCS;
          totalFinalAmt += subtotalFinalAmt;
          totalMTS += subtotalMTS;
          totalNET_MTS += subtotalNET_MTS;
          tr += `<tr class="tfootcard">
          <th >SUBTOTAL </th>
          <th class="hideIWPWITEM"></th>
          <th class="hideIWPWMAINSCREEN" style="display:none;"></th>
          <th class="hideIWPWDATE"></th>
          <th class="hideIWPWBILLNO"></th>
          <th class="hideIWPWPCS alignCenter">`+ parseInt(subtotalPCS) + `</th>
          <th class="hideIWPWPACK "></th>
          <th class="hideIWPWRATE alignRight"></th>
          <th class="hideIWPWMTS alignRight" >`+ parseFloat(subtotalMTS).toFixed(2) + `</th>
          <th class="hideIWPWNETMTS alignRight">`+ parseFloat(subtotalNET_MTS).toFixed(2) + `</th>
          <th class="hideIWPWFOLDLESS alignRight"></th>
          <th class="hideIWPWAMT alignRight">`+ valuetoFixed(subtotalFinalAmt) + `</th>
          <th class="hideIWPWFIRM"></th>
          <th class="hideIWPWTYPE"></th>
          <th class="hideIWPWEWB" style="display:none;"></th>
          <th class="hideIWPWTRANSPORT" style="display:none;"></th>
          <th class="hideIWPWLR" style="display:none;"></th>
          <th class="hideIWPWDAYS" style="display:none;"></th>
              </tr>`;
          smTr+=`
  <tr>
    <th onclick="openSubR('`+ productPartyListData.code + `')">`+productPartyListData.code+`</th>
    <th onclick="openSubRQ('`+ qualcodeForSm + `')" class="hideIWPWSMPARCEL">`+ parseInt(subtotalPCS) + `</th>
    <th onclick="openSubRQ('`+ qualcodeForSm + `')" class="hideIWPWSMMTS">`+ parseFloat(subtotalMTS).toFixed(2) + `</th>
    <th onclick="openSubRQ('`+ qualcodeForSm + `')" class="hideIWPWSMNMTS">`+ parseFloat(subtotalNET_MTS).toFixed(2) + `</th>
    <th onclick="openSubRQ('`+ qualcodeForSm + `')" class="hideIWPWSMAMOUNT">`+ valuetoFixed(subtotalFinalAmt) + `</th>
  </tr>
          `;
          subtotalPCS = 0;
          subtotalFinalAmt = 0;
          subtotalMTS = 0;
          subtotalNET_MTS = 0;
        }
        grandtotalPCS += totalPCS;
        grandtotalFinalAmt += totalFinalAmt;
        grandtotalMTS += totalMTS;
        grandtotalNET_MTS += totalNET_MTS;
        if (productPartyList.length > 1) {
          tr += `<tr class="tfootcard">
        <th >TOTAL </th>
        <th class="hideIWPWITEM"></th>
        <th class="hideIWPWMAINSCREEN" style="display:none;"></th>
        <th class="hideIWPWDATE"></th>
        <th class="hideIWPWBILLNO"></th>
        <th class="hideIWPWPCS alignCenter alignRight">`+ parseInt(totalPCS) + `</th>
        <th class="hideIWPWPACK "></th>
        <th class="hideIWPWRATE alignRight"></th>
        <th class="hideIWPWMTS alignRight">`+ parseFloat(totalMTS).toFixed(2) + `</th>
        <th class="hideIWPWNETMTS alignRight">`+ parseFloat(totalNET_MTS).toFixed(2) + `</th>
        <th class="hideIWPWFOLDLESS alignRight"></th>
        <th class="hideIWPWAMT alignRight">`+ valuetoFixed(totalFinalAmt) + `</th>
        <th class="hideIWPWFIRM"></th>
        <th class="hideIWPWTYPE"></th>
        <th class="hideIWPWEWB" style="display:none;"></th>
        <th class="hideIWPWDAYS" style="display:none;"></th>
        </tr>`;

        smTr+=`
        <tr class="tfootcard" style="font-weight:bold;color: #588c7e;font-size: 20px;">
          <th>TOTAL</th>
          <th class="hideIWPWSMPARCEL">`+ parseInt(totalPCS) + `</th>
          <th class="hideIWPWSMMTS">`+ parseFloat(totalMTS).toFixed(2) + `</th>
          <th class="hideIWPWSMNMTS">`+ parseFloat(totalNET_MTS).toFixed(2) + `</th>
          <th class="hideIWPWSMAMOUNT">`+ valuetoFixed(totalFinalAmt) + `</th>
        </tr>
                `;
        }
        totalPCS = 0;
        totalMTS = 0;
        totalNET_MTS = 0;
        totalFinalAmt = 0;
      }

      if (QualityList.length > 1) {
        tr += `<tr class="tfootcard">
      <th >GRAND TOTAL </th>
      <th  class="hideIWPWITEM"></th>
      <th  class="hideIWPWMAINSCREEN" style="display:none;"></th>
      <th  class="hideIWPWDATE"></th>
      <th  class="hideIWPWBILLNO"></th>
      <th  class="hideIWPWPCS alignCenter alignRight">`+ parseInt(grandtotalPCS) + `</th>
      <th  class="hideIWPWPACK "></th>
      <th  class="hideIWPWRATE alignRight"></th>
      <th  class="hideIWPWMTS alignRight" >`+ parseFloat(grandtotalMTS).toFixed(2) + `</th>
      <th  class="hideIWPWNETMTS alignRight">`+ parseFloat(grandtotalNET_MTS).toFixed(2) + `</th>
      <th  class="hideIWPWFOLDLESS alignRight"></th>
      <th  class="hideIWPWAMT alignRight">`+ valuetoFixed(grandtotalFinalAmt) + `</th>
      <th  class="hideIWPWFIRM"></th>
      <th  class="hideIWPWTYPE"></th>
      <th  class="hideIWPWEWB" style="display:none;"></th>
      <th  class="hideIWPWDAYS" style="display:none;"></th>
      </tr>`;


      smTr+=`
      <tr class="tfootcard">
        <th>GRAND TOTAL</th>
        <th class="hideIWPWSMPARCEL">`+ parseInt(grandtotalPCS) + `</th>
        <th class="hideIWPWSMMTS">`+ parseFloat(grandtotalMTS).toFixed(2) + `</th>
        <th class="hideIWPWSMNMTS">`+ parseFloat(grandtotalNET_MTS).toFixed(2) + `</th>
        <th class="hideIWPWSMAMOUNT">`+ valuetoFixed(grandtotalFinalAmt) + `</th>
      </tr>
              `;
      }


      var hideAbleTr = getUrlParams(url, "hideAbleTr");
      if (hideAbleTr == "true") {
        tr = smTr;
      }
      $('#result').html(tr);
      $("#loader").removeClass('has-loader');
      if (GRD == '' || GRD == null) {
        $('.GRD').css("display", "none");
      }
      var hideAbleTr = getUrlParams(url, "hideAbleTr");
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

