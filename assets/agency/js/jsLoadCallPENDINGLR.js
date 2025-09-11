function loadCall(Data){       

  
    if (cno != '' && cno != null) {
        Data = Data.filter(function(data) {
          return data.billDetails.some((billDetails) => billDetails['CNO'] === cno);
        }).map(function(subdata) {
        return {
          code: subdata.code,
          billDetails: subdata.billDetails.filter(function(billDetails) {
            return (billDetails['CNO'] === cno);
          })
        }
      })
      }
      //  console.log("BLS",Data);
      if (partycode != '' && partycode != null) {
        Data = Data.filter(function(data) {
          return data.code == partycode;
        })
      }
      //  console.log("BLS",Data);
      if (this.broker != '' && this.broker != null) {
        Data = Data.filter(function(data) {
          return data.billDetails.some((billDetails) => billDetails['BCODE'] === this.broker);
        }).map(function(subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function(billDetails) {
              return (billDetails['BCODE'] === this.broker);
            })
          }
        })
      }
      //  console.log("BLS",Data);
      if (CITY != '' && CITY != null) {
        Data = Data.filter(function(data) {
          return data.billDetails.some((billDetails) => billDetails['CITY'] == this.CITY);
        }).map(function(subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function(billDetails) {
              return (billDetails['CITY'] == this.CITY);
            })
          }
        })
      }
      //  console.log("BLS",Data);
      if (haste != '' && haste != null) {
        Data = Data.filter(function(data) {
          return data.billDetails.some((billDetails) => billDetails['haste'] === haste);
        }).map(function(subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function(billDetails) {
              return (billDetails['haste'] === haste);
            })
          }
        })
      }
      //  console.log("BLS",Data);
      if (fromdate !== '' && fromdate !== null) {
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
      //  console.log("BLS",Data);
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

      if (GRD != '' && GRD != null && GRD != undefined) {
        Data = Data.filter(function (data) {
          return data.billDetails.some((billDetails) => billDetails['GRD'] === GRD);
        }).map(function (subdata) {
          return {
            code: subdata.code,
            billDetails: subdata.billDetails.filter(function (billDetails) {
              return (billDetails['GRD'] === GRD);
            })
          }
        })
      }
    console.log("BLS",Data);
    
    if(Data.length>0){
                var grandparcelcount=0;
                var grandTotalfinalAmt=0;

                try{
                  
            for(i=0;i<Data.length;i++){
              var ccode = getPartyDetailsBySendCode(Data[i].code);
              console.table(Data[i].code+"-",ccode);
                var pcode = getValueNotDefine(ccode[0].partyname);
                var city = getValueNotDefine(ccode[0].city);
                var broker = getValueNotDefine(ccode[0].broker);
                var label = getValueNotDefine(ccode[0].label);
              tr += `<tr class="trPartyHead" onclick="trOnClick('` + Data[i].code + `','` + city + `','` + broker +`');"
                >
                          <th colspan="10" class="trPartyHead" >` + label + `</th>                                    
                        </tr>`;
                          
                if(Data[i].billDetails.length>0){
                    tr +=  `<tr>
                        <th>PDF</th>
                        <th>TRANSPORT</th>
                        <th>L/R NO</th>
                        <th>BILL</th>
                        <th>DATE</th>
                        <th>FIRM</th>
                        <th>BILL AMT</th>
                        </tr>`;
                        var parcelcount=0;
                        var totalFinalAmt=0;
                    for (j = 0; j < Data[i].billDetails.length; j++){
                        parcelcount += 1;
                    totalFinalAmt +=parseFloat(Data[i].billDetails[j].fnlamt);                   
                    var GST = parseFloat(Data[i].billDetails[j].VTAMT)+parseFloat(Data[i].billDetails[j].ADVTAMT);
                    var FdataUrl = getFullDataLinkByCnoTypeVnoFirm(Data[i].billDetails[j].CNO, Data[i].billDetails[j].TYPE, Data[i].billDetails[j].VNO, getFirmDetailsBySendCode(Data[i].billDetails[j].CNO)[0].FIRM, Data[i].billDetails[j].IDE);
                      tr +=  `<tr class="hideAbleTr">
                        <th><a href="`+FdataUrl.replace("fData", "Billpdf")+`" target="_blank"><button>PDF</button><a></th>
                        <th>`+(Data[i].billDetails[j].TRNSP)+`</th>
                        <th>`+getValueNotDefine(Data[i].billDetails[j].RRNO)+`</th>
                        <th><a target="_blank"href="`+FdataUrl+`"><button>`+Data[i].billDetails[j].BILL+`</button></a></th>
                        <th>`+formatDate(Data[i].billDetails[j].DATE)+`</th>
                        <th>`+Data[i].billDetails[j].FRM+`</th>
                        <th>`+valuetoFixed(Data[i].billDetails[j].fnlamt)+`</th>
                        </tr>`; 
                }   
                }     
                grandparcelcount +=parcelcount;
                grandTotalfinalAmt +=totalFinalAmt;
                tr +=  `<tr class="tfootcard">
                        <th colspan="4"> PARCEL `+parcelcount+`</th>
                        <th colspan="2"></th>
                        <th>`+valuetoFixed(totalFinalAmt)+`</th>
                        </tr>`;        
            }
            tr +=  `
            <tr class="tfootcard">
                    <th colspan="4">TOTAL PARCEL `+grandparcelcount+`</th>
                    <th colspan="2"></th>
                    <th>`+valuetoFixed(grandTotalfinalAmt)+`</th>
                    </tr>`; 

            $('#result').html(tr);
            $("#loader").removeClass('has-loader');
              var hideAbleTr = getUrlParams(url, "hideAbleTr");
                  if (hideAbleTr == "true" ) {
                    $('.hideAbleTr').css("display", "none");
                  }
                }catch(e){
                  alert(e);
            $('#result').html(tr);
            $("#loader").removeClass('has-loader');
                  }
        }else{
        $('#result').html('<h1>No Data Found</h1>');
        $("#loader").removeClass('has-loader');
            
        }

    }

    var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src','jsPopUpModelParty.js');
document.head.appendChild(my_awesome_script);  
