
var  url =window.location.href; 
var BLS;
var DET; 
var DETdata;
var div='';

function loadBillPdfCall() {   
  $("#loader").addClass('has-loader');
  
    
  
  if (IDE != '' && IDE != null) {
    Data= Data.filter(function (data) {
      return data.billDetails.some((billDetails) => billDetails['IDE'] == IDE );
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return ((billDetails['IDE'] == IDE));
        })
      }
    })
  }
  console.log(IDE, Data);
  if (this.cno != '' && this.cno != null) {
    Data = Data.filter(function(data) {
      return data.billDetails.some((billDetails) => billDetails['CNO'] === this.cno);
    }).map(function(subdata) {
    return {
      code: subdata.code,
      billDetails: subdata.billDetails.filter(function(billDetails) {
        return (billDetails['CNO'] === this.cno);
      })
    }
  })
  }
  if (partycode != '' && partycode != null) {
    Data = Data.filter(function(data) {
      return data.code == partycode;
    })
  }
  console.log(partycode, Data);
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
  // console.log(this.broker, Data);
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
  // console.log(CITY, Data);
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
  // console.log(haste, Data);
  if (fromdate != '' && fromdate != null) {
    Data = Data.filter(function(data) {
      return data.billDetails.some((billDetails) => new Date(billDetails.DATE) >= new Date(fromdate).setHours(0,0,0,0));
    }).map(function(subdata) {
    return {
      code: subdata.code,
      billDetails: subdata.billDetails.filter(function(billDetails) {
        return  new Date(billDetails.DATE) >= new Date(fromdate).setHours(0,0,0,0);
      })
    }
  })
  }
  console.log(fromdate, Data);
  if (todate != '' && todate != null) {
    Data = Data.filter(function(data) {
      return data.billDetails.some((billDetails) => new Date(billDetails.DATE) <= new Date(todate).setHours(24,0,0,0));
    }).map(function(subdata) {
    return {
      code: subdata.code,
      billDetails: subdata.billDetails.filter(function(billDetails) {
        return  new Date(billDetails.DATE) <= new Date(todate).setHours(24,0,0,0);
      })
    }
  })
  }
  console.log(todate, Data);
  BLS = Data;
  console.log(BLS);

  try {  
 
  if (BLS.length > 0) {
    
        for (var i = 0; i < BLS.length; i++) {
                
            for (var j = 0; j < BLS[i].billDetails.length; j++) {
                partyArray = getPartyDetailsBySendCode(BLS[i].code);
                console.log("partyArray", partyArray);
                firmArray = getFirmDetailsBySendCode(BLS[i].billDetails[j].CNO);
                 console.log("FIRM", firmArray);
              var titleBill = BLS[0].billDetails[0].BILL;
              titleBill = titleBill.replace("\/", "-");
              document.title = "BILL NO- " + titleBill;

                div += `
  <div class="page">
    <div class="">
        <div style="width:100%"> 
                  <div style="display:inline; text-align: right;float: left;width: 60%;font-size:12px;">
                  !!Shree Ganeshay Namaha!!</div>
                  
                  <div style=" display:inline;text-align: right; float: left;width: 40%;font-size:12px;">
                Phone:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`+ getValueNotDefine(firmArray[0]["PHONE1"]) + `,` + getValueNotDefine(firmArray[0]["MOBILE"]) + `</div>
        </div>
   
        <div style="width:100%"> 
                  <div style="display:inline;text-align: left; float: left;font-size:11px;font-weight:bold;
                          width: 33.33%;
                  ">Original For Buyer</div>
                          
                    <div style=" display:inline;text-align: center; float: left;font-size:11px;font-weight:bold;
                    width: 33.33%;
                      ">Duplicate For Transporter</div>
                          
                        <div style=" display:inline;text-align: right; float: left;font-size:11px;font-weight:bold;
                        width: 33.33%;
                      ">Triplicate for Consignor</div>
        </div>
       
        <div style="width:100%">        
                    <div style="font-size:25px;text-align: center;">`+ firmArray[0]["FIRM"] + `</div>
        </div>
        
        <div style="width:100%"> 
                    <div style="display:inline;text-align: left; float: left;font-size:12px;
                          width: 33.33%;font-weight: bold;
                          ">GSTIN:`+ getValueNotDefine(firmArray[0]["COMPANY_GSTIN"]) + `</div>
                          
                            <div style=" display:inline;text-align: center; float: left;font-size:12px;
                            width: 33.33%;font-weight: bold;
                          ">`+ getValueNotDefine(firmArray[0]["OTHERRMK"]) + `</div>
                          
                            <div style=" display:inline;text-align: right; float: left;font-size:12px;
                            width: 33.33%;font-weight: bold;
                          ">PAN NO.:`+ getValueNotDefine(firmArray[0]["PANNO"]) + `</div>
        </div>
    
        <div style="width:100%"> 
                <div style="text-align: center; font-size:14px;
                  ">`+ getValueNotDefine(firmArray[0]["ADDRESS1"]) + `,` + getValueNotDefine(firmArray[0]["ADDRESS2"]) + `,` + getValueNotDefine(firmArray[0]["CITY1"]) + `</div>
        </div>
       
        <div style="width:100%"> 
              <div style="font-size:23px;text-align: center;">TAX INVOICE</div>
        </div>
      
        <hr class="pdfhr">
              
        <div style="width:100%";>
                  <div style="text-align: left;float: left;width: 50%;font-size:14px;font-weight: bold;">
                  Buyer: `+ partyArray[0]["partyname"] + `</div>
                  
                  <div style="text-align: right;float: right;width: 50%;font-size:14px;font-weight: bold;">
                  BILL NO: ` + getValueNotDefine(BLS[i].billDetails[j].BILL) + `</div>
        </div>   

        <div style="width:100%";>
                  <div style="text-align: left;float: left;width: 50%;font-size:14px;">
                  `+ getValueNotDefine(partyArray[0]["AD1"]) + `</div>
                
                <div style="text-align: right;float: right;width: 50%;font-size:14px;">
                CHALLAN: ` + getValueNotDefine(BLS[i].billDetails[j].BILL) + `
                </div>
       </div>
           
        <div style="width:100%;">
              <div style="text-align: left;float: left;width: 50%;font-size:14px;">-
              `+ getValueNotDefine(partyArray[0]["AD2"]) + `</div>
              <div style="text-align: right;float: right;width: 50%;font-size:14px">
                   DATE: ` + formatDate(BLS[i].billDetails[j].DATE) + `</div>
        </div>

        <div style="width:100%";>     
                    <div style="display:inline;text-align: left; float: left;font-size:14px;
                    width: 33.33%;
                    ">-`+ getValueNotDefine(partyArray[0]["city"]) + `</div>
                    
                      <div style=" display:inline;text-align: center; float: left;font-size:14px;
                      width: 33.33%;
                    ">-`+getValueNotDefine( partyArray[0]["PNO"]) + `</div>
                    <div style=" display:inline;text-align: left; float: left;font-size:14px;
                    width: 33.33%;
                    ">-</div>
        </div>      

        <div style="width:100%">   
                  <div style="display:inline;text-align: left; float: left;font-size:14px;
                width: 33.33%;
                ">GSTIN:`+ getValueNotDefine(partyArray[0]["GST"]) + `</div>
                  <div style=" display:inline;text-align: center; float: left;font-size:14px;
                  width: 33.33%;
                ">Palace of Supply:-` + getValueNotDefine(BLS[i].billDetails[j].STC) + `
                </div>
        </div>

      <hr class="pdfhr">
      `;
              if (BLS[i].billDetails[j].BCODE!=null&& BLS[i].billDetails[j].BCODE!='') {
                var brokerArray = (getPartyDetailsBySendCode(BLS[i].billDetails[j].BCODE)); 
                if(brokerArray.length>0){
                           div +=`
          <div style="width:100%";>
                <div style="display:inline;text-align: left; float: left;font-size:14px;
                width: 50%;
                ">AGENT:` + getValueNotDefine(brokerArray[0]["partyname"]) + `</div>
              
                <div style=" display:inline;text-align: center; float: left;font-size:14px;
                width: 50%;
              ">PHONES-` + getValueNotDefine(brokerArray[0]["PH1"]) + ` ,` + getValueNotDefine(brokerArray[0]["MO"]) + `</div>
          </div>
       
          <div style="width:100%"> 
                      <div style="display:inline;text-align: left; float: left;font-size:14px;
                      width:100%;
                      ">ADDRESS:` + getValueNotDefine(brokerArray[0]["AD1"]) + `,` + brokerArray[0]["AD2"] + `</div>
          </div>`;
        }  } else {
                           div +=`
          <div style="width:100%";>
                      <div style="display:inline;text-align: left; float: left;font-size:14px;
                      width: 50%;
                      ">AGENT:</div>
                    
                      <div style=" display:inline;text-align: center; float: left;font-size:14px;
                      width: 50%;
                    ">PHONES-</div>
          </div>
       
          <div style="width:100%"> 
                    <div style="display:inline;text-align: left; float: left;font-size:14px;
                  width:100%;
                  ">ADDRESS:</div>
          </div>`;
              }
           

           
           div +=`
    
      <hr class="pdfhr">
      
            <div style="width:100%"> 
                    <div style="display:inline;text-align: left; float: left;font-size:14px;
                    width: 40%;
                    ">L.R. NO.:` + getValueNotDefine(BLS[i].billDetails[j].RRNO) + `</div>
                    
                      <div style=" display:inline;text-align: left; float: left;font-size:14px;
                      width: 30%;
                    ">LR DATE:` + getValueNotDefine(formatDate(BLS[i].billDetails[j].RRDET)) + `</div>
                    
                      <div style=" display:inline;text-align: center; float: left;font-size:14px;
                      width: 30%;
                    ">WEIGHT :` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].WGT)) + `</div>
            </div>
                
            <div style="width:100%">     
                        <div style="display:inline;text-align: left; float: left;font-size:14px;
                        width: 40%;
                        ">TRANSPORT:` + getValueNotDefine(BLS[i].billDetails[j].TRNSP) + `</div>
                        
                          <div style=" display:inline;text-align: left; float: left;font-size:14px;
                          width: 30%;
                        ">CASE NO:` + getValueNotDefine(BLS[i].billDetails[j].CSNO) + `</div>
                        
                          <div style=" display:inline;text-align: center; float: left;font-size:14px;
                          width: 30%;
                        ">FREIGHT :` +getValueNotDefine( valuetoFixed(BLS[i].billDetails[j].FRT)) + `</div>
          </div>
        
        <div style="width:100%">     
                <div style="display:inline;text-align: left; float: left;font-size:14px;
                width: 50%;
                ">STATION :` + getValueNotDefine((BLS[i].billDetails[j].PLC)) + `</div>
                
                  <div style=" display:inline;text-align: left; float: left;font-size:14px;
                  width: 50%;
                ">HSN/SAC:</div>
        </div>   
                
        
             <div style="width:100%">            
                        <div style="display:inline;text-align: left; float: left;font-size:14px;font-weight: bold;
                        width: 33.33%;
                        ">Distance(Km):` + getValueNotDefine((BLS[i].billDetails[j].DST)) + `</div>
                        
                          <div style=" display:inline;text-align: left; float: left;font-size:14px;font-weight: bold;
                          width: 33.33%;
                        ">Transposter ID:</div>
                        
                          <div style=" display:inline;text-align: center; float: left;font-size:14px;font-weight: bold;
                          width: 33.33%;
                        ">E-Way Bill no:` + getValueNotDefine((BLS[i].billDetails[j].EWB)) + `</div>
            </div>
                
          
      <hr class="pdfhr">
            <div style="width:100%"> 
                            <div style="display:inline;text-align: left; float: left;font-size:11px;
                          width: 35%;
                          ">SR. PARTICULARS</div>
                            <div style=" display:inline;text-align: left; float: left;font-size:11px;
                            width: 10%;
                          ">PCS</div>
                          <div style=" display:inline;text-align: left; float: left;font-size:11px;
                            width: 10%;
                          ">CUT</div>
                          <div style=" display:inline;text-align: LEFT; float: left;font-size:11px;
                            width: 10%;
                          ">MTR</div>
                          <div style=" display:inline;text-align: LEFT; float: left;font-size:11px;
                            width: 10%;
                          ">RATE</div>
                          <div style=" display:inline;text-align: LEFT; float: left;font-size:11px;
                            width: 10%;
                          ">PER</div>
                          <div style=" display:inline;text-align: right; float: left;font-size:11px;
                            width: 13%;
                          ">AMOUNT</div>
                </div>
           
           <hr class="pdfhr">
                 
    </div>
`;

              div += `<div style="height:35%;">`;
              console.log(BLS[i].billDetails[j].IDE);
DET = DETdata.filter(function(data){
    return data.IDE == BLS[i].billDetails[j].IDE;
})              
              console.log(DET);
              if (DET.length>0) {
                
              
                var billDet = (DET[0].billDetails);
                var sr = 0;                
                for (var k = 0; k < billDet.length; k++){            
                    sr += 1
div +=`
            <div style="display:inline;text-align: left; float: left;font-size:12px;
            width: 35%;
            ">`+sr+`-`+getValueNotDefine(billDet[k].qual)+`</div>
            <div style=" display:inline;text-align: left; float: left;font-size:12px;
            width: 10%;
           ">`+getValueNotDefine(valuetoFixedNo(billDet[k].PCS))+`</div>
           <div style=" display:inline;text-align: left; float: left;font-size:11px;
            width: 10%;
           ">`+getValueNotDefine(valuetoFixed(billDet[k].CUT))+`</div>
           <div style=" display:inline;text-align: LEFT; float: left;font-size:12px;
            width: 10%;
           ">`+getValueNotDefine(valuetoFixed(billDet[k].MTS))+`</div>
           <div style=" display:inline;text-align: LEFT; float: left;font-size:12px;
            width: 10%;
           ">`+getValueNotDefine(valuetoFixed(billDet[k].RATE))+`</div>
            <div style=" display:inline;text-align: LEFT; float: left;font-size:12px;
            width: 10%;
           ">`+ getValueNotDefine(billDet[k].UNIT) +`</div>
           <div style=" display:inline;text-align: right; float: left;font-size:12px;
            width: 13%;
           ">`+getValueNotDefine(valuetoFixed(billDet[k].AMT))+`</div>
           
           `;
              
                }
              }

              div +=`</div>
  <div>
      <hr class="pdfhr">
                    <div style="display:inline;text-align: left; float: left;font-size:12px;
                      width: 100%;font-weight: bold;
                      ">BANK A/C NO.:`+getValueNotDefine(firmArray[0]["ADDRESS3"])+` - IFSC CODE :`+getValueNotDefine(firmArray[0]["ADDRESS4"])+`
                    </div>
              
            <div style="width:100%;">          
                      <div style="display:inline;text-align: left; float: left;font-size:12px;
                      width: 50%;
                      ">REMARK:` + getValueNotDefine((BLS[i].billDetails[j].RMK)) + `
                      </div>
            </div>   

<hr class="pdfhr">

                    <div style="display:inline;text-align: left; float: left;font-size:14px;
                  width: 40%;
                  ">SUB TOTAL</div>
                    <div style=" display:inline;text-align: left; float: left;font-size:14px;
                    width: 20%;
                  ">PCS-` + getValueNotDefine(valuetoFixedNo(BLS[i].billDetails[j].TPCS)) + `</div>
                    <div style=" display:inline;text-align: left; float: left;font-size:14px;
                    width: 28%;
                  ">MTS-` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].TMTS)) + `</div>
                  <div style=" display:inline;text-align: right; float: center;font-size:14px;
                    width: 22%;
                  ">` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].grsamt)) + `</div>
<hr class="pdfhr">
`;

            
           if (BLS[i].billDetails[j].LA1RATE != 0) {    
             div += ` 
                <div style="display:inline;text-align: right; float: left;font-size:14px;
              width:92%;
              ">`+ BLS[i].billDetails[j].LA1RMK + ` -> ` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].grsamt)) + `  X `+BLS[i].billDetails[j].LA1RATE+`% : `+ getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].LA1AMT)) + `</div>
            
           `;
          }
          if(BLS[i].billDetails[j].LA2RATE !=0){
                      
            div +=` 
                  <div style="display:inline;text-align: right; float: left;font-size:14px;
                  width:92%;
                  ">`+BLS[i].billDetails[j].LA2RMK+` -> `+BLS[i].billDetails[j].LA2qty+`  X `+BLS[i].billDetails[j].LA2RATE+` : `+getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].LA2AMT))+`</div>
            
           `;
          }


          if(BLS[i].billDetails[j].LA3RATE !=0){
                      
            div +=`
             <div style="display:inline;text-align: right; float: left;font-size:14px;
              width:92%;
              ">`+BLS[i].billDetails[j].LA3RMK+` -> `+BLS[i].billDetails[j].LA3qty+`  X `+BLS[i].billDetails[j].LA3RATE+` : `+getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].LA3AMT))+`</div>
            
            `;
        }

                  if(BLS[i].billDetails[j].VTAMT != 0)  {
              
                  if(BLS[i].billDetails[j].STC != 24 )  {
     
                div += `
                <div style="width:100%">
                        <div style="display:inline;text-align: right; float: left;font-size:14px;
                        width:92%;
                        ">IGST @ `+BLS[i].billDetails[j].VTRET+`% on Taxable Value  `+getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].grsamt))+` = `+getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].VTAMT))+`</div>
                       
                </div>
                        `;
           
                     }  
                     
                       if(BLS[i].billDetails[j].STC == 24 )  {
     
           div +=`
              <div style="width:100%">
                    <div style="display:inline;text-align: right; float: left;font-size:14px;
                    width:92%;
                    ">CGST @ `+BLS[i].billDetails[j].VTRET+`% on Taxable Value  `+getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].grsamt))+` = `+getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].VTAMT))+`</div>
              
              </div>

           <div style="width:100%">
                <div style="display:inline;text-align: right; float: left;font-size:14px;
                width: 92%;
                ">SGST @ `+BLS[i].billDetails[j].ADVTRET+`% on Taxable Value  `+getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].grsamt))+` = `+getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].ADVTAMT))+`</div>
           
           </div>`;
           
                     }      }
          
        
           
div +=` <hr class="pdfhr">

                <div style="display:inline;text-align: left; float: left;font-size:13px;
                width: 70%;font-weight: bold;
                ">DUE DAYS:`+getValueNotDefine(valuetoFixedNo(partyArray[0]["dhara"]))+`</div>
              
                <div style=" display:inline;text-align: right; font-size:13px;
                width: 30%;font-weight: bold;
              ">GRAND TOTAL :`+getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].fnlamt))+`</div>
           
           <hr class="pdfhr">
           <div style="width:100%;">
                    <div style="display:inline;text-align: left; float: left;font-size:8px;
                    width: 50%;
                    ">TERMS & CONDITIONS:-</div>
                      <div style=" display:inline;text-align: right; float: right; font-size:10px;
                      width: 50%;
                    ">FOR :`+ getValueNotDefine(firmArray[0]["FIRM"]) + `</div>
           </div>
           
                  <div style="display:inline;text-align: left; float: left;font-size:8px;
                  width: 100%;
                  ">1.SUBJECT TO SURAT JURISDICTION.</div>
            
                    <div style="display:inline;text-align: left; float: left;font-size:8px;
                  width: 100%;
                  ">2.GOODS HAVE BEEN SOLD & DESPATCHED AT ENTIRE RISK OF PURCHASER.</div>
             
                  <div style="display:inline;text-align: left; float: left;font-size:8px;
                  width: 100%;
                  ">3.COMPLAINTS, IF ANY REGARDING THIS INVOICE MUST BE INFORMED IN WRITING WITHIN 48 HOURS</div>
             
                    <div style="display:inline;text-align: left; float: left;font-size:8px;
                  width: 33.33%;
                  ">CHECKED BY </div>
                  <div style=" display:inline;text-align: center; float: left;font-size:8px;
                  width: 33.33%;
                ">DELIVERED BY </div>
                  <div style=" display:inline;text-align: right; float: left;font-size:8px;
                  width: 33.33%;
                ">AUTH. SIGNATORY</div>
           </div>
           </div></div>
           `;
	   
            }
        }       
                
      document.body.innerHTML = div;
      // $("#result").append(div)
      $("#loader").removeClass('has-loader'); 
            
    } else {
              document.body.innerHTML="<h1 align='center'>NO DATA FOUND<h1>";	
                $("#loader").removeClass('has-loader');
    }
     } catch (error) {
    document.body.innerHTML = div;
    // alert(error);
    $("#loader").removeClass('has-loader');
  }
}
