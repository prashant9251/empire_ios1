
function checkAllEntry(ele){
     var checkboxes = document.getElementsByTagName('input');
    if (ele.checked) {
        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].type == 'checkbox') {
                checkboxes[i].checked = true;
            }
        }
    } else {
        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].type == 'checkbox') {
                checkboxes[i].checked = false;
            }
        }
    }
}
var DataForCalcutaion = [];
function OutstandingCalculate() {
    var SelectList = [];
    $('input[type=checkbox]').each(function () {
        var CNO = $(this).attr('CNO');
        var TYPE = $(this).attr('DTYPE');
        var VNO = $(this).attr('VNO');
        if ($(this).is(':checked')) {
            var obj = {};
            obj.CNO = CNO;
            obj.TYPE = TYPE;
            obj.VNO = VNO;
            SelectList.push(obj);
        } else {
        }
    });

    SelectList = SelectList.filter(function (d) {
        return d.CNO != undefined;
    })
    var MainArry = Data;

    MainArry = MainArry.map(function (subdata) {
        return {
            code: subdata.code,
            billDetails: getFilteredBillDetails(subdata.billDetails, SelectList)
        }
    })

    DataForCalcutaion = [];
    for (let i = 0; i < MainArry.length; i++) {
        const element = MainArry[i];
        var model = '';
        var party = getPartyDetailsBySendCode(element.code);
        var Address = getValueNotDefine(party[0].AD1) + " ," + getValueNotDefine(party[0].AD2) + " ," + getValueNotDefine(party[0].city);
        model += ` <div id="OutstandingCalculate" class="modal" style="overflow: auto;height:100%">
        <div id="OutstandingCalculateContent" class="modal-content">
          <div class="modal-header"style="text-align:left;">
          <h2 >Calculation</h2>
          <span class="close"onclick="closeOutstandingCalculate();">&times;</span><br>          
          </div>
          <div class="modal-body" style="    width: 100%;">`;
        for (let j = 0; j < MainArry[i].billDetails.length; j++) {
            const detaileEle = MainArry[i].billDetails[j];
            DataForCalcutaion.push(detaileEle);
        }
        // DataForCalcutaion = MainArry[i].billDetails;
        model += `        
            <div class="tab">
            <button class="tablinks" onclick="openTab(event, 'BROKRAGE')">BROKRAGE</button>
            <button class="tablinks" onclick="openTab(event, 'INTERESTCALCULATION')" style="display:none;">INTEREST </button>
            </div>

            <div id="BROKRAGE" class="tabcontent">
            <h3>BROKRAGE</h3>
                <select class="form-control" onchange="brokrageCalculation(this);">
                <option value="GRSAMT">ON GROSS AMOUNT</option>
                <option value="FAMT">ON BILL AMOUNT</option>
                </select>
                <br>
                <div id="brokrageCalcy"></div>
            </div>

            <div id="INTERESTCALCULATION" class="tabcontent">
            <h3>COMING SOON</h3>
            </div>
            `;
    }

    $('body').append(model);
    brokrageCalculation();
    var OutstandingCalculate = document.getElementById("OutstandingCalculate");

    var btn = document.getElementById("myBtn");
    var span = document.getElementsByClassName("close")[0];
    OutstandingCalculate.style.display = "block";
    document.getElementById("BROKRAGE").style.display = "block";
    // FilteringData(SelectList);
}
function openTab(evt, cityName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(cityName).style.display = "block";
    evt.currentTarget.className += " active";
}


function brokrageCalculation(EVT) {
    var Details = DataForCalcutaion;
    var newTr = '';
    var totalGROSSAMT = 0;
    var totalGST = 0;
    var totalNETBILLAMT = 0;
    var totalGOODSRETURN = 0;
    var totalPAIDAMT = 0;
    var totalAmount = 0;
    var count = 0;
    for (let j = 0; j < Details.length; j++) {
        count++;
        const details = Details[j];
        var GRSAMT = details.GRSAMT == null || details.GRSAMT == "" ? 0 : details.GRSAMT;
        var GST = details.GST == null || details.GST == "" ? 0 : details.GST;
        try {
            if (details.DT.trim() != "os") {
                GRSAMT = 0;
                GST = 0;
            }
        } catch (error) {

        }
        var FAMT = details.FAMT == null || details.FAMT == "" ? 0 : details.FAMT;
        var CLAIMS = details.CLAIMS == null || details.CLAIMS == "" ? 0 : details.CLAIMS;
        var RECAMT = details.RECAMT == null || details.RECAMT == "" ? 0 : details.RECAMT;
        var PAMT = details.PAMT == null || details.RECAMT == "" ? 0 : details.PAMT;
        totalGROSSAMT += parseFloat(getValueNotDefineNo(GRSAMT));
        totalGST += parseFloat(getValueNotDefineNo(GST));
        totalNETBILLAMT += parseFloat(getValueNotDefineNo(FAMT));
        totalGOODSRETURN += parseFloat(getValueNotDefineNo(CLAIMS));
        totalPAIDAMT += parseFloat(getValueNotDefineNo(RECAMT));
        totalAmount += parseFloat(getValueNotDefineNo(PAMT));
    }
    var AMOUNT = totalGROSSAMT;
    if (EVT != null) {
        var value = EVT.value;
        if (value == "FAMT") {
            AMOUNT = totalNETBILLAMT;
        }
    }

    newTr += `
    
    <div style="display:flex;">
        <div style="width:50%;"><b>BILL COUNT :</b></div>
        <div style="width:50%;text-align:right;">
        <input type="text"class="form-control" style="min-width: 50%;text-align:right;" value="`+ parseInt(count) + `" disabled/>
        </div>
    </div>

    <div style="display:flex;">
        <div style="width:50%;"><b>AMOUNT :</b></div>
        <div style="width:50%;text-align:right;">
        <input type="text"class="form-control" style="min-width: 50%;text-align:right;" value="`+ parseFloat(AMOUNT).toFixed(2) + `" disabled/>
        </div>
    </div>  
    <div style="display:flex;">
        <div style="width:50%;"><b>COMMISSION % :</b></div>
        <div style="width:50%;text-align: -webkit-right;">
        <input type="text"class="form-control" style="min-width: 50%;text-align:right;" id="commPersent"onkeyup="getCommAmount('`+ AMOUNT + `'); saveToLocal(this,'commPersent');"  /> </div>
    </div>  

    <div style="display:flex;">
        <div style="width:50%;"><b>COMMISSION AMOUNT :</b></div>
        <div style="width:50%;text-align: -webkit-right;">
        <input type="text"class="form-control" id="commAmount" style="min-width: 50%;text-align:right;" value="0.00" disabled/> </div>
        </div>
    </div> 
    
    <div style="display:flex;">
        <div style="width:50%;"><b>TDS % :</b></div>
        <div style="width:50%;text-align: -webkit-right;">
        <input type="text"class="form-control" id="tdscommPersent" style="min-width: 50%;text-align:right;"onkeyup="getTdsAmount();saveToLocal(this,'tdscommPersent');"/> </div>
    </div>     
       
    <div style="display:flex;">
        <div style="width:50%;"><b>TDS AMOUNT :</b></div>
        <div style="width:50%;text-align:right;">
        <input type="text"class="form-control"id="tdsAmt" style="min-width: 50%;text-align:right;" value="0.00" disabled/>
        </div>
    </div> 
    
    <div style="display:flex;">
        <div style="width:50%;"><b>FINAL COMMISSION AMT </b></div>
        <div style="width:50%;text-align:right;">        
        <input type="text"class="form-control"id="finalCommAmt" style="min-width: 50%;text-align:right; font-weight: 900;" value="0.00" disabled/></div>
    </div>
    <br>
    <div style="display:flex;">
        <div style="width:50%;"></div>
        <div style="width:50%;text-align:right;"><b onclick="closeOutstandingCalculate();"> Close</b></div>
    </div>
    `;
    var totalBalsummery = totalAmount;
    $('#brokrageCalcy').html(newTr);

    var commPersent = readToLocal('commPersent');
    $('#commPersent').val(commPersent);
    var tdscommPersent = readToLocal('tdscommPersent');
    $('#tdscommPersent').val(tdscommPersent);
    getCommAmount(AMOUNT);
    getTdsAmount();
}

function getCommAmount(AMOUNT) {
    var val = $('#commPersent').val();
    var commAmount = 0;
    if (val.length > 0) {
        commAmount = AMOUNT * val / 100;
    }
    $('#commAmount').val(commAmount);
}

function getTdsAmount() {
    var commAmt = parseFloat($('#commAmount').val());
    var tds = $('#tdscommPersent').val();
    var tdsAmt = commAmt * tds / 100;
    var finalCommAmt = commAmt - tdsAmt;
    $('#tdsAmt').val(parseFloat(tdsAmt).toFixed(2));
    $('#finalCommAmt').val(parseFloat(finalCommAmt).toFixed(2));
}

function closeOutstandingCalculate() {
    $('#OutstandingCalculate').css('display', "none");
}



///---------------------------calculation

function filterSelected() {
    var SelectList = [];
    $('input[type=checkbox]').each(function () {
        var CNO = $(this).attr('CNO');
        var TYPE = $(this).attr('DTYPE');
        var VNO = $(this).attr('VNO');
        if ($(this).is(':checked')) {
            var obj = {};
            obj.CNO = CNO;
            obj.TYPE = TYPE;
            obj.VNO = VNO;
            SelectList.push(obj);
        } else {
        }
    });
    SelectList = SelectList.filter(function (d) {
        return d.CNO != undefined;
    })
    FilteringData(SelectList);
}


function FilteringData(SelectList) {
    var MainArry = Data;

    MainArry = MainArry.map(function (subdata) {
        return {
            ATYPE: subdata.ATYPE,
            ATYPE_NAME: subdata.ATYPE_NAME,
            PartyAtypeDetails: subdata.PartyAtypeDetails,
            code: subdata.code,
            ccode: subdata.ccode,
            GP: subdata.GP,
            MARKET: subdata.MARKET,
            billDetails: getFilteredBillDetails(subdata.billDetails, SelectList)
        }
    })
    loadCall(MainArry)
    hideselectBoxReport();
}

function getFilteredBillDetails(billDetails, SelectList) {
    return billDetails.filter((el) => {
        return SelectList.some((f) => {
            return f.CNO === el.CNO && f.TYPE === el.TYPE && f.VNO === el.VNO;
        });
    });
}

var SelectList = [];
function filterLedgerSelected() {
    SelectList = [];
    $('input[type=checkbox]').each(function () {
        var CNO = $(this).attr('CNO');
        var TYPE = $(this).attr('DTYPE');
        var VNO = $(this).attr('VNO');
        if ($(this).is(':checked')) {
            var obj = {};
            obj.CNO = CNO;
            obj.TYPE = TYPE;
            obj.VNO = VNO;
            SelectList.push(obj);
        } else {
        }
    });
    FilteringLedgerData(SelectList);
}

function FilteringLedgerData(SelectList) {
    var MainArry = Data;

    MainArry = MainArry.filter((el) => {
        return SelectList.some((f) => {
            return f.CNO === el.CNO && f.TYPE === el.TYPE && f.VNO === el.VNO;
        });
    });
    loadCall(MainArry)
    hideselectBoxReport();
}