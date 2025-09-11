
var url = window.location.href;
var Data;
var CHALTRN;
var CHALTRNdata;
var div = '';

function loadBillPdfCall() {
    $("#loader").addClass('has-loader');
    try {


        if (IDE != '' && IDE != null) {
            Data = Data.filter(function (data) {
                return data['IDE'].toUpperCase() == IDE.toUpperCase() && data['SRNO'] == "1";
            })
        }
        console.log(Data);

        Data = Data;

        if (Data.length > 0) {
            var adjustAmt = 0;
            for (var i = 0; i < 1; i++) {
                partyArray = getPartyDetailsBySendCode(Data[i].RFCODE);
                firmArray = getFirmDetailsBySendCode(Data[i].CNO);
                // console.log(Data);
                document.title = getValueNotDefine(Data[i].VNO) + " " + partyArray[0]["partyname"];
                div += ` 
  <div class="page">
    <div class="">
   
        <div style="width:100%"> 
                  <div style="text-align: center;font-size:11px;width: 100%;">
                  SHREE GANESHAYA NAMAH
                  </div>                        
        </div>
       
        <div style="width:100%">        
                    <div style="font-size:25px;text-align: center;font-weight:bold;">`+ firmArray[0]["FIRM"] + `</div>
        </div>

        <div style="width:100%"> 
            <div style="text-align: center; font-size:12px;
            ">`+ getValueNotDefine(firmArray[0]["ADDRESS1"]) + `,` + getValueNotDefine(firmArray[0]["ADDRESS2"]) + `,` + getValueNotDefine(firmArray[0]["CITY1"]) + `</div>
        </div>
        
        <hr class="pdfhr">   
      
       
              
        <div style="width:100%;"class="halfBold">
                  <div style="text-align: left;float: left;width: 100%;font-size:12px;">
                  PARTY NAME : `+ partyArray[0]["partyname"] + getValueNotDefine(partyArray[0]["AD1"]) + getValueNotDefine(partyArray[0]["AD2"]) + getValueNotDefine(partyArray[0]["PH1"]) + getValueNotDefine(partyArray[0]["PH2"]) + getValueNotDefine(partyArray[0]["MO"]) + `</div>                 
                  
        </div>   

        <div style="width:100%";>
                  <div style="text-align: left;float: left;width: 50%;font-size:12px;">
                 BROKER /AGENT : `+ getValueNotDefine(partyArray[0]["broker"]) + `</div>
                
                <div style="text-align: left;float: right;width: 50%;font-size:12px;">
                VOUCHER NO. :: ` + getValueNotDefine(Data[i].VNO) + `
                </div>
       </div>
           
        <div style="width:100%;">
              <div style="text-align: left;float: left;width: 100%;font-size:12px;">
              CHQ. NO. : `+ getValueNotDefine(Data[i].DOCNO) + ` DATED :` + getValueNotDefine(formatDate(Data[i].DATE)) + ` AMT :` + valuetoFixed(parseFloat(Data[i].CRAMT) + parseFloat(Data[i].DRAMT)) + `
              </div>
        </div>

        <div style="width:100%;">
            <div style="text-align: left;float: left;width: 100%;font-size:12px;">
            DEAR SIR, THE PAYMENT HAS BEEN MADE AGAINST THE FOLLOWING BILLS
            </div>
        </div>
       
        <table style="width:100%;font-size:6px;border-:"align="center">
         <tr style="width:100%;" >
                <th style="text-align: center;">
                    BILL
                </th>
                
                <th style="text-align: center;">
                    DATE
                </th>
                
                <th style="text-align: center;">
                    ITEM AMT
                </th>
                
                <th style="text-align: center;" class="hideADLS1">
                  ADLS1 %
                </th>
                
                <th style="text-align: center;" class="hideADLS_AMT1">
                ADLS1 AMT
                </th>
                
                <th style="text-align: center;display:none;" class="hideADLS2">
                  ADLS2 %
                </th>
                
                <th style="text-align: center;display:none;" class="hideADLS_AMT2">
                ADLS2 AMT
                </th>
                
                <th style="text-align: center;display:none;" class="hideADLS3">
                  ADLS3 %
                </th>
                
                <th style="text-align: center;display:none;" class="hideADLS_AMT3">
                ADLS3 AMT
                </th>
                
                <th style="text-align: center;">
                    TAXABLE
                </th>
                
                <th style="text-align: center;">
                    + GST
                </th>
                
                <th style="text-align: center;">
                    BILL AMT
                </th>
                
                <th style="text-align: center;">
                    GR AMT
                </th>
                
                <th style="text-align: center;">
                    TDS
                </th>
                
                <th style="text-align: center;">
                    DIS%
                </th>
                
                <th style="text-align: center;">
                    B.C.
                </th>
                
                <th style="text-align: center;">
                    LESS OTH
                </th>
                
                <th style="text-align: center;">
                    ADD/INT
                </th>
                
                <th style="text-align: center;">
                    NET AMT
                </th>
                
                <th style="text-align: center;">
                    ADJUSTED
                </th>
                
                <th style="text-align: center;">
                    PEND.
                </th>
                <th style="text-align: center;">
                DAYS.
            </th>
        </tr>
            <tr>
                <th colspan="35"><hr class="pdfhr">  </th>
            </tr>
        `;
                var TGA = 0;
                var TL1A = 0;
                var TTXA = 0;
                var TGST = 0;
                var TBA = 0;
                var TRGA = 0;
                var TTDA = 0;
                var TOLA = 0;
                var TOLA = 0;
                var TADA = 0;
                var TFA = 0;
                var TAMT = 0;
                var TACA = 0;
                var TPA = 0;
                // console.log(DETdata);
                CHALTRNdata = DETdata.filter(function (DET) {
                    return DET.IDE == Data[i].IDE;
                });
                // console.log(CHALTRNdata);

                if (CHALTRNdata.length > 0) {
                    sr = 0;
                    var billDet = (CHALTRNdata[0].billDetails);
                    for (var j = 0; j < billDet.length; j++) {
                        var GA = (billDet[j].GA);
                        var L1A = (billDet[j].L1A);
                        var TXA = (billDet[j].TXA);
                        var GST = (billDet[j].GST);
                        var BA = (billDet[j].BA);
                        var RGA = (billDet[j].RGA);
                        var TDA = (billDet[j].TDA);
                        var OLA = (billDet[j].OLA);
                        var ADA = (billDet[j].ADA);
                        var FA = (billDet[j].FA);
                        var AMT = (billDet[j].AMT);
                        var ACA = (billDet[j].ACA);
                        var PA = (billDet[j].PA);

                        TGA += parseFloat(GA);
                        TL1A += parseFloat(L1A);
                        TTXA += parseFloat(TXA);
                        TGST += parseFloat(GST);
                        TBA += parseFloat(BA);
                        TRGA += parseFloat(RGA);
                        TTDA += parseFloat(TDA);
                        TOLA += parseFloat(OLA);
                        TADA += parseFloat(ADA);
                        TFA += parseFloat(FA);
                        TAMT += parseFloat(AMT);
                        TACA += parseFloat(ACA);
                        TPA += parseFloat(PA);

                        if ((billDet[j].TYPE) == 'XX') {
                            adjustAmt = TAMT - parseFloat(billDet[j].AMT);
                            sr += 1;
                            if (sr == 1) {

                                div += `
                             <tr style="width:100%;"class="halfBold">
                                <td colspan="35"style="text-align: left;float: left;width: 100%;font-size:10px;">
                                UNADJ PAYMENT
                                </td>   
                            </tr><br>`;
                            }
                            if (billDet[j].CN != null) {
                                div += `
                            <tr style="width:100%;">
                                <td colspan="35"style="text-align: left;float: left;width: 100%;font-size:9px;">
                                PREV CHQ NO. : `+ billDet[j].CN + `
                                </td>   
                            </tr>`;
                            }
                            div += `
                        <tr style="width:100%;">                
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(billDet[j].BL) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(formatDate(billDet[j].DT)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(GA)) + `
                        </td>
                        
                        <td style="text-align: center;"class="hideADLS1">
                        `+ getValueNotDefineNo(valuetoFixedNo(+Math.abs(billDet[j].L1R))) + `
                        </td>
                        
                        <td style="text-align: center;"class="hideADLS_AMT1">
                        `+ getValueNotDefineNo(Math.round(+Math.abs(billDet[j].L1A))) + `
                        </td>
                        
                        <td style="text-align: center;display:none;" class="hideADLS2">
                        `+ getValueNotDefineNo(valuetoFixedNo(+Math.abs(billDet[j].L2R))) + `
                        </td>
                        
                        <td style="text-align: center;display:none;" class="hideADLS_AMT2">
                        `+ getValueNotDefineNo(Math.round(+Math.abs(billDet[j].L2A))) + `
                        </td>
                        
                        <td style="text-align: center;display:none;" class="hideADLS3">
                        `+ getValueNotDefineNo(valuetoFixedNo(+Math.abs(billDet[j].L3R))) + `
                        </td>
                        
                        <td style="text-align: center;display:none;" class="hideADLS_AMT3">
                        `+ getValueNotDefineNo(Math.round(+Math.abs(billDet[j].L3A))) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(TXA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(GST)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(BA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(RGA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(TDA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(billDet[j].DC)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(ADA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(OLA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(ADA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(FA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(AMT)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(PA)) + `
                        </td>
                        <td style="text-align: center;">
                        `+ getDaysDif(billDet[j].DT, Data[i].DATE) + `
                        </td>
                        </tr>
                        `;
                        } else {
                            div += `
                        <tr style="width:100%;">                
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(billDet[j].BL) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(formatDate(billDet[j].DT)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(GA)) + `
                        </td>
                        
                        <td style="text-align: center;"class="hideADLS1">
                        `+ getValueNotDefineNo(valuetoFixedNo(+Math.abs(billDet[j].L1R))) + `
                        </td>
                        
                        <td style="text-align: center;"class="hideADLS_AMT1">
                        `+ getValueNotDefineNo(Math.round(+Math.abs(billDet[j].L1A))) + `
                        </td>
                        
                        <td style="text-align: center;display:none;" class="hideADLS2">
                        `+ getValueNotDefineNo(valuetoFixedNo(+Math.abs(billDet[j].L2R))) + `
                        </td>
                        
                        <td style="text-align: center;display:none;" class="hideADLS_AMT2">
                        `+ getValueNotDefineNo(Math.round(+Math.abs(billDet[j].L2A))) + `
                        </td>
                        
                        <td style="text-align: center;display:none;" class="hideADLS3">
                        `+ getValueNotDefineNo(valuetoFixedNo(+Math.abs(billDet[j].L3R))) + `
                        </td>
                        
                        <td style="text-align: center;display:none;" class="hideADLS_AMT3">
                        `+ getValueNotDefineNo(Math.round(+Math.abs(billDet[j].L3A))) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(TXA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(GST)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(BA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(RGA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(TDA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(billDet[j].DC)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(ADA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(OLA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(ADA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(FA)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(AMT)) + `
                        </td>
                        
                        <td style="text-align: center;">
                        `+ getValueNotDefineNo(Math.round(PA)) + `
                        </td>
                        <td style="text-align: center;">
                        `+ getDaysDif(billDet[j].DT, Data[i].DATE) + `
                        </td>
                        </tr>
                        `;
                        }


                    }

                }
                div += `
            <hr class="pdfhr"> `;
                if (Data[i].otherrmk != null && Data[i].otherrmk != undefined && Data[i].otherrmk != '') {
                    div += `
                <hr class="pdfhr"> 
                <tr  style="width:100%;">
                    <td colspan="35"style="text-align: left;float: left;width: 100%;font-size:10px;">
                   `+ Data[i].otherrmk + `
                    </td>   
                </tr>
                `;
                }
                var totalAdjustAmt = Math.abs(TAMT);
                totalCHQAmt = parseFloat(Data[i].CRAMT) + parseFloat(Data[i].DRAMT);
                diff = (totalAdjustAmt) - totalCHQAmt;
                if (diff > 0 || diff < 0) {
                    // div += `
                    // <tr  style="width:100%;">
                    //     <td colspan="35"style="text-align: left;font-size:10px;">
                    //         DIFFERNCE : `+ totalAdjustAmt + ` - ` + totalCHQAmt + ` = ` + diff + `
                    //     </td>   
                    // </tr>
                    // `;
                }
            }
            div += `
            </div>
            <tr>
            <th colspan="35"><hr class="pdfhr">  </th>
            </tr>
        <tr style="width:100%;text-align:center;">

            <td colspan="2" >
            TOTAL </td>
            <td style="text-align: center;">
            `+ getValueNotDefineNo(valuetoFixedNo(TGA)) + `</td>
           
            <td style="text-align: center;">
            -
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(+Math.abs(TL1A)) + `
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TTXA) + `
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TGST) + `</td>
           
            <td style="text-align: center;">
            `+ Math.round(TBA) + `
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TRGA) + `
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TTDA) + `
            </td>
           
            <td style="text-align: center;">
            -
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TOLA) + `
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TOLA) + `
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TADA) + `
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TFA) + `
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TAMT) + `
            </td>
           
            <td style="text-align: center;">
            `+ Math.round(TPA) + `</td>
    </tr>
    
    </table>
        <hr class="pdfhr"> 
        `;

            div += `
            <div style="width:100%;"class="halfBold">
                    <div style="text-align: left;float: left;width: 33%;font-size:10px;">
                    PREPARED BY
                   </div>   
                   <div style="text-align: left;float: left;width: 33%;font-size:10px;">
                  CHECKED BY
                  </div> 
                  <div style="text-align: left;float: left;width: 33%;font-size:10px;">
                  RECEIVERS SINGNATURE
                 </div>               
            </div>  
         </div>
         </div> 
         </div> `;
            document.body.innerHTML = div;
            // $("#result").append(div)
            $("#loader").removeClass('has-loader');


        } else {
            document.body.innerHTML = "<h1 align='center'>NO DATA FOUND<h1>";
            $("#loader").removeClass('has-loader');
        }
        hideList();
    } catch (error) {
        noteError(noteError)
    }
}
