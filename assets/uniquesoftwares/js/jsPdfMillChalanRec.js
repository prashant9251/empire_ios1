
var url = window.location.href;
var MILL;
var CHALTRN;
var CHALTRNdata;
var div = '';

function loadBillPdfCall() {
  $("#loader").addClass('has-loader');



  if (CRD != '' && CRD != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => billDetails['CRD'] == CRD);
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return ((billDetails['CRD'] == CRD));
        })
      }
    })
  }
  if (this.cno != '' && this.cno != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => billDetails['CNO'] === this.cno);
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails['CNO'] === this.cno);
        })
      }
    })
  }
  if (partycode != '' && partycode != null) {
    Data = Data.filter(function (data) {
      return data.code == partycode;
    })
  }

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
  if (fromdate != '' && fromdate != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => new Date(billDetails.DATE) >= new Date(fromdate).setHours(0, 0, 0, 0));
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return new Date(billDetails.DATE) >= new Date(fromdate).setHours(0, 0, 0, 0);
        })
      }
    })
  }

  if (todate != '' && todate != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => new Date(billDetails.DATE) <= new Date(todate).setHours(24, 0, 0, 0));
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return new Date(billDetails.DATE) <= new Date(todate).setHours(24, 0, 0, 0);
        })
      }
    })
  }

  MILL = Data;

  try {

    if (MILL.length > 0) {

      for (var i = 0; i < MILL.length; i++) {

        for (var j = 0; j < MILL[i].billDetails.length; j++) {

          var titleBill = MILL[i].billDetails[j].DSPNO;
          titleBill = titleBill.replace("\/", "-");
          document.title = "CHALLAN NO- " + titleBill;
          partyArray = getPartyDetailsBySendCode(MILL[i].code);

          firmArray = getFirmDetailsBySendCode(MILL[i].billDetails[j].CNO);

          div += `
  <div class="page">
    <div class=""style="height:50%;">
   
        <div style="width:100%"> 
                  <div style="display:inline;text-align: left; float: left;font-size:11px;width: 33.33%;">
                  Original For Buyer
                  </div>
                          
                    <div style=" display:inline;text-align: center; float: left;font-size:11px;width: 33.33%;">
                    Duplicate For Transporter
                    </div>
                          
                    <div style=" display:inline;text-align: right; float: left;font-size:11px;width: 33.33%;">
                    Triplicate for Consignor
                    </div>
        </div>
       
        <div style="width:100%">        
                    <div style="font-size:30px;text-align: center;font-weight:bold;">`+ firmArray[0]["FIRM"] + `</div>
        </div>

        <div style="width:100%"> 
            <div style="text-align: center; font-size:14px;
            ">`+ getValueNotDefine(firmArray[0]["ADDRESS1"]) + `,` + getValueNotDefine(firmArray[0]["ADDRESS2"]) + `,` + getValueNotDefine(firmArray[0]["CITY1"]) + `</div>
        </div>
        
        <div style="width:100%" class="halfBold"> 
                    <div style="display:inline;text-align: left; float: left;font-size:12px;
                          width: 25%;
                          ">GSTIN:`+ getValueNotDefine(firmArray[0]["COMPANY_GSTIN"]) + `</div>
                          
                            <div style=" display:inline;text-align: center; float: left;font-size:12px;
                            width: 50%;
                          ">JOB ISSUE DELIVERY CHALLAN(PROCESS)</div>
                          
                            <div style=" display:inline;text-align: right; float: left;font-size:12px;
                            width: 25%;
                          ">PAN NO.:`+ getValueNotDefine(firmArray[0]["PANNO"]) + `</div>
        </div>
    
        <hr class="pdfhr">      
       
              
        <div style="width:100%;"class="halfBold">
                  <div style="text-align: left;float: left;width: 60%;font-size:14px;">
                  TO: `+ partyArray[0]["partyname"] + `</div>
                  
                  <div style="text-align: left;float: right;width: 40%;font-size:14px;">
                 CHALLAN NO.: ` + getValueNotDefine(MILL[i].billDetails[j].DSPNO) + `</div>
        </div>   

        <div style="width:100%";>
                  <div style="text-align: left;float: left;width: 60%;font-size:14px;">
                  `+ getValueNotDefine(partyArray[0]["AD1"]) + `</div>
                
                <div style="text-align: left;float: right;width: 40%;font-size:14px;">
                DATE: ` + formatDate(MILL[i].billDetails[j].DATE) + `
                </div>
       </div>
           
        <div style="width:100%;">
              <div style="text-align: left;float: left;width: 60%;font-size:14px;">-
              `+ getValueNotDefine(partyArray[0]["AD2"]) + `,` + getValueNotDefine(partyArray[0]["city"]) + `</div>
              <div style="text-align: left;float: right;width: 40%;font-size:14px">
              GSTIN:`+ getValueNotDefine(partyArray[0]["GST"]) + `
              </div>
        </div style="width:100%;">

        <hr class="pdfhr">  

         <div>
              <div style="width:100%" class="halfBold">
                <div style="text-align: left;float: left;width:40%;font-size:14px;">
                QUALITY : `+ getValueNotDefine(MILL[i].billDetails[j].QUAL) + `
                </div>
                <div style="text-align: left;float: right;width: 60%;font-size:14px">
               HSN / SAC
                </div>
              </div>

              <div style="width:100%">
                <div style="text-align: center;float: left;width:10%;font-size:14px;">
                SR No 
                </div>
                <div style="text-align: right;float: left;width:10%;font-size:14px;">
                MTS
                </div>
                <div style="text-align: center;float: right;width: 80%;font-size:14px">                      
                 </div>
              </div>
        </div>
        <hr class="pdfhr"> 
        <div style="height:280px;">
        <div style="width:100%;">

          `;
          console.log(MILL[i].billDetails[j].CRD);
          CHALTRNdata = CHALTRNdata.filter(function (Chdata) {
            console.log(Chdata.CRD);
            return Chdata.CRD == MILL[i].billDetails[j].CRD;
          })
          console.log(CHALTRNdata);
          var totalMTS = 0;
          if (CHALTRNdata.length > 0) {
            var billDet = (CHALTRNdata[0].billDetails);
            var sr = 0;
            totalMTS = 0;
            for (var k = 0; k < billDet.length; k++) {
              sr += 1
              totalMTS += parseFloat(billDet[k].DMT);
              purRMK = '-';
              if (sr == 1) {
                purRMK = 'PUR. NO. :' + MILL[i].billDetails[j].VNO;
              }
              if (sr == 2) {
                purRMK = 'PARTY :'+getValueNotDefine(MILL[i].billDetails[j].WVR)
              }
              if (sr == 3) {
                purRMK = 'BILL NO:'+getValueNotDefine(MILL[i].billDetails[j].BLL)
              }
              if (sr == 4) {
                purRMK = 'LR NO: '+getValueNotDefine(MILL[i].billDetails[j].DSG)
              }
              div += ` 
                  <div id="billDet">
                      <div style="width:100%">
                            <div style="text-align: center;float: left;width:10%;font-size:14px;">
                            `+ sr + `
                            </div>
                            <div style="text-align: right;float: left;width:10%;font-size:14px;">
                            `+ getValueNotDefine(valuetoFixed(billDet[k].DMT)) + `
                            </div>
                            <div style="text-align: center;float: right;width: 80%;font-size:14px">
                              `+ getValueNotDefine(valuetoFixed(billDet[k].RMT)) + `
                            </div>
                      </div>
                   <div>`;
            }

          }




          div += `
              </div>
              `;

          
          div +=`
              </div>
          <hr class="pdfhr"> 
            <div style="width:100%" class="halfBold">
              <div style="text-align: left;float: left;width:25%;font-size:14px;">
              TOTAL TAKAS : `+ getValueNotDefine(MILL[i].billDetails[j].WPCS) + ` 
              </div>
              <div style="text-align: left;float: left;width:75%;font-size:14px;">
              TOTAL MTS : `+ getValueNotDefine(valuetoFixed(MILL[i].billDetails[j].WMTS)) + `
              </div>            
            </div><br>


            <hr class="pdfhr"> 

            <div style="width:100%">
              <div style="text-align: left;float: left;width:60%;font-size:14px;">
              RECEIVER' S SIGNATURE
              </div>
              <div class="halfBold" style="text-align: left;float: left;width:40%;font-size:14px;">
              FOR `+ firmArray[0]["FIRM"] + `
              </div>            
            </div>
          
        </div>
            </div> `;




        }
      }

      document.body.innerHTML = div;
      // $("#result").append(div)
      $("#loader").removeClass('has-loader');

    } else {
      document.body.innerHTML = "<h1 align='center'>NO DATA FOUND<h1>";
      $("#loader").removeClass('has-loader');
    }
  } catch (error) {
    document.body.innerHTML = div;
    // alert(error);
    $("#loader").removeClass('has-loader');
  }
}


            // <div style="width:100%">
            //   <div style="text-align: left;float: left;width:50%;font-size:14px;">
            //   CGST @ 2.50% : `+getValueNotDefine(valuetoFixed(MILL[i].billDetails[j].VAM))+` SGST @ 2.50% : `+getValueNotDefine(valuetoFixed(MILL[i].billDetails[j].AVAM))+` 
            //   </div>
            //   <div style="text-align: left;float: left;width:40%;font-size:14px;">
            //   TOTAL VALUE : `+getValueNotDefine(valuetoFixed(MILL[i].billDetails[j].WAMT))+`
            //   </div>            
            // </div>