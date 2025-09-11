
var  url =window.location.href; 
var Data;
var CHALTRN; 
var CHALTRNdata;
var div=''; 

function loadBillPdfCall() {   
    $("#loader").addClass('has-loader'); 
    
  if (IDE != '' && IDE != null) {
      Data = Data.filter(function(data) {
          return data.IDE == IDE;
        })
    }
    console.log(Data);
    //   if (this.cno != '' && this.cno != null) {
//     Data = Data.filter(function(data) {
//       return data.billDetails.some((billDetails) => billDetails['CNO'] === this.cno);
//     }).map(function(subdata) {
//     return {
//       code: subdata.code,
//       billDetails: subdata.billDetails.filter(function(billDetails) {
//         return (billDetails['CNO'] === this.cno);
//       })
//     }
//   })
//   }

  
  // if (this.broker != '' && this.broker != null) {
  //   Data = Data.filter(function(data) {
  //     return data.billDetails.some((billDetails) => billDetails['BCODE'] === this.broker);
  //   }).map(function(subdata) {
  //     return {
  //       code: subdata.code,
  //       billDetails: subdata.billDetails.filter(function(billDetails) {
  //         return (billDetails['BCODE'] === this.broker);
  //       })
  //     }
  //   })
  // }
  // 
  // if (CITY != '' && CITY != null) {
  //   Data = Data.filter(function(data) {
  //     return data.billDetails.some((billDetails) => billDetails['CITY'] == this.CITY);
  //   }).map(function(subdata) {
  //     return {
  //       code: subdata.code,
  //       billDetails: subdata.billDetails.filter(function(billDetails) {
  //         return (billDetails['CITY'] == this.CITY);
  //       })
  //     }
  //   })
  // }
  // 
  // if (haste != '' && haste != null) {
  //   Data = Data.filter(function(data) {
  //     return data.billDetails.some((billDetails) => billDetails['haste'] === haste);
  //   }).map(function(subdata) {
  //     return {
  //       code: subdata.code,
  //       billDetails: subdata.billDetails.filter(function(billDetails) {
  //         return (billDetails['haste'] === haste);
  //       })
  //     }
  //   })
  // }
  // 
//   if (fromdate != '' && fromdate != null) {
//     Data = Data.filter(function(data) {
//       return data.billDetails.some((billDetails) => new Date(billDetails.DATE) >= new Date(fromdate).setHours(0,0,0,0));
//     }).map(function(subdata) {
//     return {
//       code: subdata.code,
//       billDetails: subdata.billDetails.filter(function(billDetails) {
//         return  new Date(billDetails.DATE) >= new Date(fromdate).setHours(0,0,0,0);
//       })
//     }
//   })
//   }
  
//   if (todate != '' && todate != null) {
//     Data = Data.filter(function(data) {
//       return data.billDetails.some((billDetails) => new Date(billDetails.DATE) <= new Date(todate).setHours(24,0,0,0));
//     }).map(function(subdata) {
//     return {
//       code: subdata.code,
//       billDetails: subdata.billDetails.filter(function(billDetails) {
//         return  new Date(billDetails.DATE) <= new Date(todate).setHours(24,0,0,0);
//       })
//     }
//   })
//   }
  
  Data = Data;  

    if (Data.length > 0) {    
        var adjustAmt = 0;
        for (var i = 0; i < 1; i++) {                
                partyArray = getPartyDetailsBySendCode(Data[i].code);                
                firmArray = getFirmDetailsBySendCode(Data[i].CNO);
                // console.log(Data);
              div += `
  <div class="page">
    <div class="">
   
        <div style="width:100%"> 
                  <div style="text-align: center;font-size:11px;width: 100%;">
                  SHREE GANESHAYA NAMAH
                  </div>                        
        </div>
       
        <div style="width:100%">        
                    <div style="font-size:30px;text-align: center;font-weight:bold;">`+ firmArray[0]["FIRM"] + `</div>
        </div>

        <div style="width:100%"> 
            <div style="text-align: center; font-size:14px;
            ">`+ getValueNotDefine(firmArray[0]["ADDRESS1"]) + `,` + getValueNotDefine(firmArray[0]["ADDRESS2"]) + `,` + getValueNotDefine(firmArray[0]["CITY1"]) + `</div>
        </div>
        
        <hr class="pdfhr">   
      
       
              
        <div style="width:100%;"class="halfBold">
                  <div style="text-align: left;float: left;width: 100%;font-size:14px;">
                  PARTY NAME : `+ partyArray[0]["partyname"] +getValueNotDefine(partyArray[0]["AD1"]) +  getValueNotDefine(partyArray[0]["AD2"])+  getValueNotDefine(partyArray[0]["PH1"])+  getValueNotDefine(partyArray[0]["PH2"]) +  getValueNotDefine(partyArray[0]["MO"])+`</div>                 
                  
        </div>   

        <div style="width:100%";>
                  <div style="text-align: left;float: left;width: 50%;font-size:14px;">
                 BROKER /AGENT : `+ getValueNotDefine(partyArray[0]["broker"]) + `</div>
                
                <div style="text-align: left;float: right;width: 50%;font-size:14px;">
                VOUCHER NO. :: ` + getValueNotDefine(Data[i].VNO) + `
                </div>
       </div>
           
        <div style="width:100%;">
              <div style="text-align: left;float: left;width: 100%;font-size:14px;">
              CHQ. NO. : `+ getValueNotDefine(Data[i].DOCNO) + ` DATED :` + getValueNotDefine(formatDate(Data[i].DATE)) + ` AMT :` + valuetoFixed(parseFloat(Data[i].CRAMT)+parseFloat(Data[i].DRAMT)) + `
              </div>
        </div>

        <div style="width:100%;">
            <div style="text-align: left;float: left;width: 100%;font-size:14px;">
            DEAR SIR, THE PAYMENT HAS BEEN MADE AGAINST THE FOLL. BILLS
            </div>
        </div>
        <hr class="pdfhr">  

         <div style="width:100%;font-size:4px;" >
                <div style="text-align: center;float: left;width:5.5%;">
                    BILL
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    DATE
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    ITEM AMT
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                  ADD/LS %
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                ADD/LS AMT
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    TAXABLE
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    + GST
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    BILL AMT
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    GR AMT
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    TDS
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    DIS%
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    B.C.
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    LESS OTH
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    ADD/INT
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    NET AMT
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    ADJUSTED
                </div>
                <div style="text-align:center;width:.1%;float:left;">|</div>
                <div style="text-align: center;float: left;width:5.5%;">
                    PEND.
                </div>
        </div>
        <hr class="pdfhr"> 

        <div style="width:100%;font-size:6px;"align="center">
        `;
        var TGA=0;
        var TL1A=0;
        var TTXA=0;
        var TGST=0;
        var TBA=0;
        var TRGA=0;
        var TTDA=0;
        var TOLA=0;
        var TOLA=0;
        var TADA=0;
        var TFA=0;
        var TTDA=0;
        var TAMT=0;
        var TACA=0;
        var TPA=0;
            // console.log(DETdata);
            CHALTRNdata = DETdata.filter(function (DET) {
                return DET.IDE == Data[i].IDE;
            });
            // console.log(CHALTRNdata);
            
            if (CHALTRNdata.length > 0) {
                sr = 0;
                var billDet = (CHALTRNdata[0].billDetails);
                for (var j = 0; j < billDet.length; j++){
                    
                    TGA +=parseFloat(billDet[j].GA);
                    TL1A +=parseFloat(billDet[j].L1A);
                    TTXA +=parseFloat(billDet[j].TXA);
                    TGST +=parseFloat(billDet[j].GST);
                    TBA +=parseFloat(billDet[j].BA);
                    TRGA += parseFloat(billDet[j].RGA);
                    
                    TTDA +=parseFloat(billDet[j].TDA);
                    TOLA +=parseFloat(billDet[j].OLA);
                    TADA +=parseFloat(billDet[j].ADA);
                    TFA += parseFloat(billDet[j].FA);
                    TTDA +=parseFloat(billDet[j].TDA);
                    TAMT +=parseFloat(billDet[j].AMT);
                    TACA +=parseFloat(billDet[j].ACA);
                    TPA += parseFloat(billDet[j].PA);
                    if ((billDet[j].TYPE) == 'XX') {
                        adjustAmt =TAMT -parseFloat(billDet[j].AMT);
                        sr += 1;
                        if (sr == 1) {

                            div += `
                             <div style="width:100%;"class="halfBold">
                                <div style="text-align: left;float: left;width: 100%;font-size:10px;">
                                UNADJ PAYMENT
                                </div>   
                            </div><br>`;
                        }
                        if (billDet[j].CN != null) {
                            div += `
                            <div style="width:100%;">
                                <div style="text-align: left;float: left;width: 100%;font-size:9px;">
                                PREV CHQ NO. : `+billDet[j].CN+`
                                </div>   
                            </div>`; 
                        }
                        div += `
                        <div style="width:100%;font-size:4px;">                
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(billDet[j].BL)+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(formatDate(billDet[j].DT))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].GA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(valuetoFixedNo(Math.abs(billDet[j].L1R)))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(Math.abs(billDet[j].L1A)))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].TXA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].GST))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].BA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].RGA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].TDA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].DC))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].ADA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].OLA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].ADA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].FA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].AMT))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].PA))+`
                        </div>
                        </div><br>
                        `; 
                    } else {
                        div += `
                        <div style="width:100%;font-size:4px;">                
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(billDet[j].BL)+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(formatDate(billDet[j].DT))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].GA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(valuetoFixedNo(Math.abs(billDet[j].L1R)))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(Math.abs(billDet[j].L1A)))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].TXA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].GST))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].BA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].RGA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].TDA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].DC))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].ADA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].OLA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].ADA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].FA))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].AMT))+`
                        </div>
                        <div style="text-align:center;width:.1%;float:left;">|</div>
                        <div style="text-align: center;float: left;width:5.5%;">
                        `+getValueNotDefineNo(Math.round(billDet[j].PA))+`
                        </div>
                        </div><br>
                        `; 
                    }
                    

                }

            }
            div += `
            <hr class="pdfhr"> `;
            if (Data[i].otherrmk != null && Data[i].otherrmk != undefined && Data[i].otherrmk != '') {
                div += `
                <hr class="pdfhr"> 
                <div  style="width:100%;">
                    <div style="text-align: left;float: left;width: 100%;font-size:10px;">
                   `+Data[i].otherrmk+`
                    </div>   
                </div>
                `;
            }
            totalAdjustAmt = TAMT;
            totalCHQAmt = parseFloat(Data[i].CRAMT) + parseFloat(Data[i].DRAMT);
            diff = totalAdjustAmt - totalCHQAmt;
            if (diff > 0 || diff <0) {
                div += `
                <div  style="width:100%;">
                    <div style="text-align: left;float: left;width: 100%;font-size:10px;">
                        RECEIVABLE DIFFERNCE : `+totalAdjustAmt+` - `+totalCHQAmt+` = `+diff+`
                    </div>   
                </div>
                `; 
            }
             }    
        div += `
            </div>

        <div style="width:100%;font-size:4px;">

            <div style="text-align: center;float: left;width:12%;">
            TOTAL </div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+getValueNotDefineNo(valuetoFixedNo(TGA))+`</div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            -
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(Math.abs(TL1A))+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TTXA)+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TGST)+`</div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TBA)+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TRGA)+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TTDA)+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            -
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TOLA)+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TOLA)+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TADA)+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TFA)+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TAMT)+`
            </div>
            <div style="text-align:center;width:.1%;float:left;">|</div>
            <div style="text-align: center;float: left;width:5.5%;">
            `+Math.round(TPA)+`</div>
    </div>
        <hr class="pdfhr"> 
        `;
  
        div +=`
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
              document.body.innerHTML="<h1 align='center'>NO DATA FOUND<h1>";	
                $("#loader").removeClass('has-loader');
    }
   
//   try {  
// } catch (error) {
//     document.body.innerHTML = div;
//     // alert(error);
//     $("#loader").removeClass('has-loader');
//   }
}
