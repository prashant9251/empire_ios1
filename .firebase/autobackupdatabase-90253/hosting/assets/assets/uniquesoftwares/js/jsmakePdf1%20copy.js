
var url = window.location.href;
var BLS;
var DET;
var DETdata;
var div = '';

function loadBillPdfCall() {
  $("#loader").addClass('has-loader');


  if (IDE != '' && IDE != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => billDetails['IDE'].toUpperCase() == IDE.toUpperCase());
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return ((billDetails['IDE'].toUpperCase() == IDE.toUpperCase()));
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


  // console.log(IDE, Data);

  if (partycode != '' && partycode != null) {
    partycode = partycode
    Data = Data.filter(function (d) {
      return d.code.trim().toUpperCase() == partycode.trim().toUpperCase();
    })
  }

   console.log(IDE, Data);

  if (this.broker != '' && this.broker != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => billDetails['BCODE'] === this.broker);
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return (billDetails['BCODE'] === this.broker);
        })
      }
    })
  }
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
  if (fromdate != '' && fromdate != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => new Date(billDetails.DATE).setHours(0, 0, 0, 0) >= new Date(fromdate).setHours(0, 0, 0, 0));
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return new Date(billDetails.DATE).setHours(0, 0, 0, 0) >= new Date(fromdate).setHours(0, 0, 0, 0);
        })
      }
    })
  }
  // console.log(fromdate, Data);

  if (todate != '' && todate != null) {
    Data = Data.filter(function (data) {
      return data.billDetails.some((billDetails) => new Date(billDetails.DATE).setHours(24, 0, 0, 0) <= new Date(todate).setHours(24, 0, 0, 0));
    }).map(function (subdata) {
      return {
        code: subdata.code,
        billDetails: subdata.billDetails.filter(function (billDetails) {
          return new Date(billDetails.DATE).setHours(24, 0, 0, 0) <= new Date(todate).setHours(24, 0, 0, 0);
        })
      }
    })
  }
  // console.log(todate, Data);
  BLS = Data;
  // console.log(BLS);


  if (BLS.length > 0) {

    for (var i = 0; i < BLS.length; i++) {

      for (var j = 0; j < BLS[i].billDetails.length; j++) {
        partyArray = getPartyDetailsBySendCode(BLS[i].code);
        // console.log("partyArray", partyArray);
        firmArray = getFirmDetailsBySendCode(BLS[i].billDetails[j].CNO);
        // console.log("FIRM", firmArray);
        var titleBill = BLS[0].billDetails[0].BILL;
        titleBill = titleBill.replace("\/", "-");
        document.title = "BILL NO- " + titleBill;
        var OtherRmk = (firmArray[0]["OTHERRMK"]);
        if (OtherRmk == '' || OtherRmk == null) {
          OtherRmk = (firmArray[0]["EMAIL"]);
          if (OtherRmk == '' || OtherRmk == null) {
            OtherRmk = '-';
          }
        }
        Clnt = DSN.replace(Currentyear, "");
        console.log(DSN, Clnt);
        Clnt = atob(Clnt);
        var logoBll = getDataUserSetting("logoBll");
        var logoBillStyle = "background-image: url('http://aashaimpex.com/logos/" + Clnt + ".jpeg";
        if (logoBll == 0) {
          logoBillStyle = "background-image:none;";
        }

        div += `
  <div class="page" style="
  background-size: 300px 100px;
  background-position-x: center;
  background-position-y: 82%;
  background-repeat: no-repeat;`+ logoBillStyle + `">

  
    <div class="">
        <div style="width:100%"> 
                  <div style="display:inline; text-align: right;float: left;width: 60%;font-size:12px;">
                  !!Shree Ganeshay Namaha!!</div>
                  
                  <div style=" display:inline;text-align: right; float: left;width: 40%;font-size:12px;">
                Phone:`+ getValueNotDefine(firmArray[0]["PHONE1"]) + `,` + getValueNotDefine(firmArray[0]["MOBILE"]) + `</div>
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
                    <div style="font-size:26px;text-align:center;font-weight:700;">`+ firmArray[0]["FIRM"] + `</div>
        </div>
        
        <div style="width:100%"> 
                    <div style="display:inline;text-align: left; float: left;font-size:12px;
                          width: 25%;font-weight: bold;
                          ">GSTIN:`+ getValueNotDefine(firmArray[0]["COMPANY_GSTIN"]) + `</div>
                          
                            <div style=" display:inline;text-align: center; float: left;font-size:12px;
                            width: 50%;font-weight: bold;
                          ">`+ getValueNotDefine(OtherRmk) + `</div>
                          
                            <div style=" display:inline;text-align: right; float: left;font-size:12px;
                            width: 25%;font-weight: bold;
                          ">PAN NO.:`+ getValueNotDefine(firmArray[0]["PANNO"]) + `</div>
        </div>
    
        <div style="width:100%"> 
                <div style="text-align: center; font-size:14px;
                  ">`+ getValueNotDefine(firmArray[0]["ADDRESS1"]) + `,` + getValueNotDefine(firmArray[0]["ADDRESS2"]) + `,` + getValueNotDefine(firmArray[0]["CITY1"]) + `</div>
        </div>
       `;

        var Series = (BLS[i].billDetails[j].SERIES);
        var Type = (BLS[i].billDetails[j].TYPE);
        // console.log(Series, Type);
        if (((Series).toUpperCase()).indexOf('SALE') > -1 && ((Type).toUpperCase()).indexOf('S') > -1 && ((Series).toUpperCase()).indexOf('RETURN') < 0) {
          var BillType = "TAX INVOICE";
        } else {
          var BillType = Series;
        }
        div += `
        <div style="width:100%"> 
              <div style="font-size:23px;text-align: center;">`+ BillType + `</div>
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
                  -`+ getValueNotDefine(partyArray[0]["AD1"]) + `</div>
                
                <div style="text-align: right;float: right;width: 50%;font-size:14px;">
                CHALLAN: ` + getValueNotDefine(BLS[i].billDetails[j].BILL) + `
                </div>
       </div>
           
        <div style="width:100%;">
              <div style="text-align: left;float: left;width: 50%;font-size:14px;">
              -`+ getValueNotDefine(partyArray[0]["AD2"]) + `</div>
              <div style="text-align: right;float: right;width: 50%;font-size:14px">
                   DATE: ` + formatDate(BLS[i].billDetails[j].DATE) + `</div>
        </div>

        <div style="width:100%";>     
                    <div style="display:inline;text-align: left; float: left;font-size:14px;
                    width: 33.33%;
                    "> - `+ getValueNotDefine(partyArray[0]["city"]) + `</div>
                    
                      <div style=" display:inline;text-align: center; float: left;font-size:14px;
                      width: 33.33%;
                    "> -`+ getValueNotDefine(partyArray[0]["PNO"]) + `</div>
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

      <hr class="pdfhr">`;



        div += `
      <div style="width:100%";>
      <div style="display:inline;text-align: left; float: left;font-size:14px;
      width: 100%;
      ">Consignee:` + getValueNotDefine(BLS[i].billDetails[j].haste) + `</div>
      </div>
      <div style="width:100%"> 
                  <div style="display:inline;text-align: left; float: left;font-size:14px;
                  width:100%;
                  ">GSTIN:</div>
      </div>

      <hr class="pdfhr">
      `;
        if (BLS[i].billDetails[j].BCODE != null && BLS[i].billDetails[j].BCODE != '') {
          var brokerArray = (getPartyDetailsBySendCode(BLS[i].billDetails[j].BCODE));
          if (brokerArray.length > 0) {
            div += `
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
                      ">ADDRESS:` + getValueNotDefine(brokerArray[0]["AD1"]) + `,` + getValueNotDefine(brokerArray[0]["AD2"]) + `</div>
          </div>`;
          }
        } else {
          div += `
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



        div += `
    
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
                        ">FREIGHT :` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].FRT)) + `</div>
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
      </div>
      <div class="bottomBorder"  class="table-responsive"style="width: 100%;height: 37%; display: flex;font-size: 10px;font-weight: 900;">
       <div style=" display: flex;width: 100%;">
            <table class="table"  style="font-size:12px;width: 100%;text-align:left;">
                <tr style="width:100%;">
                          <th>SR. PARTICULARS</th>
                          <th class="hcategory" >CATEGORY</th>
                          <th >HSN</th>
                          <th >PCS</th>
                          <th class="hCut">CUT</th>
                          <th class="hMts">MTR</th>
                          <th class="hNetMts" >NET MTS.</th>
                          <th class="hLessFold" >FOLD.<br>LESS.</th>
                          <th >RATE</th>
                          <th >PER</th>
                          <th>AMOUNT</th>
                </tr>   
`;


        if (YearChange != '' && YearChange != null) {
          DET = DETdata.filter(function (data) {
            return data.CNO == BLS[i].billDetails[j].CNO &&
              data.TYPE.toUpperCase() == BLS[i].billDetails[j].TYPE.toUpperCase() &&
              data.VNO == VNO;
          })
        } else {
          DET = DETdata.filter(function (data) {
            return data.CNO == BLS[i].billDetails[j].CNO &&
              data.TYPE.toUpperCase() == BLS[i].billDetails[j].TYPE.toUpperCase() &&
              data.VNO == (BLS[i].billDetails[j].VNO);
          })
        }

        // console.log(DET);
        if (DET.length > 0) {
          div += ``;

          var billDet = (DET[0].billDetails);
          var sr = 0;
          billDet = billDet.sort(function (a, b) {
            return a.SRNO > b.SRNO ? -1 : 1;
          })
          for (var k = 0; k < billDet.length; k++) {
            sr += 1
            var CTGRY = billDet[k].CTGRY == null || billDet[k].CTGRY == "" ? "" : billDet[k].CTGRY;
            var LESS_FOLD = 0;
            var NET_MTS = 0;
            if (billDet[k].LF != "" && billDet[k].LF != null && billDet[k].LF != undefined) {
              var MTS = parseFloat(billDet[k].MTS)
              var lessMts = (MTS * parseFloat(billDet[k].LF)) / 100;
              NET_MTS = MTS - lessMts;
            }
            div += `
        <tr >   
           <td >`+ sr + `-` + getValueNotDefine(billDet[k].qual) + `</td>
           <td class="hcategory" >`+ CTGRY + `</td>
           <td >`+ ((billDet[k].hsn)) + `</td>
           <td >`+ getValueNotDefine(valuetoFixedNo(billDet[k].PCS)) + `</td>
           <td class="hCut">`+ getValueNotDefine(valuetoFixed(billDet[k].CUT)) + `</td>
           <td class="hMts" >`+ getValueNotDefine(valuetoFixed(billDet[k].MTS)) + `</td>
           <td class="hNetMts" >`+ NET_MTS + `</td>
           <td class="hLessFold">`+ getValueNotDefine(valuetoFixed(LESS_FOLD)) + `</td>
           <td >`+ getValueNotDefine(valuetoFixed(billDet[k].RATE)) + `</td>
           <td >`+ getValueNotDefine(billDet[k].UNIT) + `</td>
           <td>`+ getValueNotDefine(valuetoFixed(billDet[k].AMT)) + `</td>
        </tr>
           `;

            if (billDet[k].DET != undefined && billDet[k].DET != null && billDet[k].DET != "") {
              div += `
                  <tr >   
                    <td 
                    width: 100%;
                    ">` + `-` + getValueNotDefine(billDet[k].DET) + `</td>
                  </tr>
                   `;
            }

          }
        }
          div += ` </table>`;
          var grossAmt = (getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].grsamt)));
        div += `</div></div>
  <div>
      <hr class="pdfhr">
                    <div style="display:inline;text-align: left; float: left;font-size:12px;
                      width: 100%;font-weight: bold;
                      ">BANK A/C NO.:`+ getValueNotDefine(firmArray[0]["ADDRESS3"]) + ` - IFSC CODE :` + getValueNotDefine(firmArray[0]["ADDRESS4"]) + `
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
                    <div class="hMts" style=" display:inline;text-align: left; float: left;font-size:14px;
                    width: 28%;
                  ">MTS-` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].TMTS)) + `</div>
                  <div style=" display:inline;text-align: right; float: center;font-size:14px;
                    width: 22%;
                  ">` + grossAmt + `</div>
<hr class="pdfhr">
`;
        var taxablevalue = parseFloat(grossAmt);

        if (BLS[i].billDetails[j].LA1RATE != 0) {
          div += ` 
                <div style="display:inline;text-align: right; float: left;font-size:14px;
              width:92%;
              ">`+ getValueNotDefine(BLS[i].billDetails[j].LA1RMK) + ` -> ` + grossAmt + `  X ` + getValueNotDefine(BLS[i].billDetails[j].LA1RATE) + `% : ` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].LA1AMT)) + `</div>
            
           `;
          taxablevalue = taxablevalue + parseFloat(getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].LA1AMT)));
        }
        if (BLS[i].billDetails[j].LA2RATE != 0) {

          div += ` 
                  <div style="display:inline;text-align: right; float: left;font-size:14px;
                  width:92%;
                  ">`+ getValueNotDefine(BLS[i].billDetails[j].LA2RMK) + ` -> ` + getValueNotDefine(BLS[i].billDetails[j].LA2qty) + `  X ` + getValueNotDefine(BLS[i].billDetails[j].LA2RATE) + ` : ` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].LA2AMT)) + `</div>
            
           `;
          taxablevalue = taxablevalue + parseFloat(getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].LA2AMT)));
        }


        if (BLS[i].billDetails[j].LA3RATE != 0) {

          div += `
             <div style="display:inline;text-align: right; float: left;font-size:14px;
              width:92%;
              ">`+ getValueNotDefine(BLS[i].billDetails[j].LA3RMK) + ` -> ` + getValueNotDefine(BLS[i].billDetails[j].LA3qty) + `  X ` + getValueNotDefine(BLS[i].billDetails[j].LA3RATE) + ` : ` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].LA3AMT)) + `</div>
            
            `;
          taxablevalue = taxablevalue + parseFloat(getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].LA3AMT)));
        }

        if ((BLS[i].billDetails[j].VTAMT) != null && (BLS[i].billDetails[j].VTAMT) != "" && parseInt(BLS[i].billDetails[j].VTAMT) != 0) {

          var stateCode = parseInt(firmArray[0].COMPANY_GSTIN.substring(0, 2));
          if (parseInt(BLS[i].billDetails[j].STC) != (stateCode)) {

            div += `
                <div style="width:100%">
                        <div style="display:inline;text-align: right; float: left;font-size:14px;
                        width:92%;
                        ">IGST @ `+ getValueNotDefine(BLS[i].billDetails[j].VTRET) + `% on Taxable Value  ` + valuetoFixed(getValueNotDefine(taxablevalue)) + ` = ` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].VTAMT)) + `</div>
                       
                </div>
                        `;
          }
          if (parseInt(BLS[i].billDetails[j].STC) == (stateCode)) {
            div += `
              <div style="width:100%">
                    <div style="display:inline;text-align: right; float: left;font-size:14px;
                    width:92%;
                    ">CGST @ `+ getValueNotDefine(BLS[i].billDetails[j].VTRET) + `% on Taxable Value  ` + grossAmt + ` = ` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].VTAMT)) + `</div>
              
              </div>

           <div style="width:100%">
                <div style="display:inline;text-align: right; float: left;font-size:14px;
                width: 92%;
                ">SGST @ `+ getValueNotDefine(BLS[i].billDetails[j].ADVTRET) + `% on Taxable Value  ` + grossAmt + ` = ` + getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].ADVTAMT)) + `</div>
           
           </div>`;
          }
        }



        div += ` <hr class="pdfhr">

                <div style="display:inline;text-align: left; float: left;font-size:13px;
                width: 70%;font-weight: bold;
                ">DUE DAYS FROM BILL DATE:`+ getValueNotDefine(getDaysDif(BLS[i].billDetails[j].DATE, new Date())) + `</div>
              
                <div style=" display:inline;text-align: right; font-size:13px;
                width: 30%;font-weight: bold;
              ">GRAND TOTAL :`+ getValueNotDefine(valuetoFixed(BLS[i].billDetails[j].BAMT)) + `</div>
           
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

    var BillDetSetting = getUrlParams(url, "BillDetSetting");

    try {
      if (BillDetSetting != null && BillDetSetting != "" && BillDetSetting != undefined && BillDetSetting.length > 0) {
        BillDetSetting = JSON.parse(BillDetSetting);
        var hCut = BillDetSetting[0].BillDetSetting[0].hCut;
        var hcategory = BillDetSetting[0].BillDetSetting[0].hcategory;
        var hMts = BillDetSetting[0].BillDetSetting[0].hMts;
        var hNetMts = BillDetSetting[0].BillDetSetting[0].hNetMts;
        var hLessFold = BillDetSetting[0].BillDetSetting[0].hLessFold;
        if (hCut == 0 && hCut != null && hCut != undefined) {
          $('.hCut').css("display", "none");
        }
        if (hMts == 0 && hMts != null && hMts != undefined) {
          $('.hMts').css("display", "none");
        }
        if (hcategory == 1 && hcategory != null && hcategory != undefined) {
          $('.hcategory').css("display", "inline");
        }

        if (hNetMts == 1 && hNetMts != null && hNetMts != undefined) {
          $('.hNetMts').css("display", "inline");
        }
        if (hLessFold == 1 && hLessFold != null && hLessFold != undefined) {
          $('.hLessFold').css("display", "inline");
        }
      }
    } catch (error) {

    }

  } else {
    document.body.innerHTML = "<h1 align='center'>NO DATA FOUND<h1>";
    $("#loader").removeClass('has-loader');
  }

  try { } catch (error) {
    document.body.innerHTML = div;
    // alert(error);
    $("#loader").removeClass('has-loader');
  }
}
