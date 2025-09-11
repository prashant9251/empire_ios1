function hideLogoImg() {
    var logoImg = document.getElementById('logoImg');
    logoImg.hidden = true;
}
function getFirmDetArray(FIRM) {
    return COMPMST.filter(function (d) {
        return d.FIRM == FIRM;
    })
}
function getPartyDetArray(partycode) {
    return masterData.filter(function (d) {
        return d.partyname == partycode;
    })
}
var ReportType = getUrlParams(url, "ReportType")
ReportType = ReportType == null ? "" : ReportType;

function makeOrderPdf(Id, IDE, orderData, orderDet, share) {
    console.log((orderDet));
    RMK = "";
    if (orderData.length == 0) {
        orderData.push(orderDet);
    }
    if (Id != null && Id != "" && Id != undefined) {
        getOrderData = orderData.filter(function (d) {
            return d.OrderID == Id;
        })
    }
    console.log(getOrderData);
    var div = ``;

    if (getOrderData.length > 0) {
        for (j = 0; j < getOrderData.length; j++) {
            var getFirmDet = getFirmDetArray(getOrderData[j].FIRM);
            console.log(getOrderData[j].partyname);
            var getPartyDet = getPartyDetArray(getOrderData[j].partyname);
            if (getFirmDet.length > 0) {
                FIRMNAME = getFirmDet[0].FIRM;
                AD1 = getValueNotDefine(getFirmDet[0].ADDRESS1);
                AD2 = getValueNotDefine(getFirmDet[0].ADDRESS2);
                AD3 = getValueNotDefine(getFirmDet[0].ADDRESS3);
                AD4 = getValueNotDefine(getFirmDet[0].ADDRESS4);
                gstNo = getValueNotDefine(getFirmDet[0].COMPANY_GSTIN);
                getOrderData[j].maincompanyObj=getFirmDet[0];
            }
            var PAD1 = "";
            var PAD2 = "";
            var PAD3 = "";
            var PAD4 = "";
            var PGSTIN = "";
            var PNO = "";
            if (getPartyDet.length > 0) {
                PAD1 = getValueNotDefine(getPartyDet[0].AD1);
                PAD2 = getValueNotDefine(getPartyDet[0].AD2);
                PAD3 = getValueNotDefine(getPartyDet[0].AD3);
                PAD4 = getValueNotDefine(getPartyDet[0].AD4);
                PGSTIN = getValueNotDefine(getPartyDet[0].GST);
                PNO = getValueNotDefine(getPartyDet[0].PNO);
                getOrderData[j].partyObj=getPartyDet[0];

            }
            getOrderData[j].IDE=IDE;
            
            div += `<div style="height: 95%;" id="orderFormPdfFormate">
    <div class="firmDet">
        <div style="width: 100%;display: inline;">
            <div class="form-row">
                <div class="col form-group">

                    <div style="padding-left: 10px;" id="firm">
                        <h4 style="color:#cc9e08;font-weight: 700;">`+ FIRMNAME + `</h4>
                        <h6 style="color: #2e2508;">`+ AD1 + `</h6>
                        <h6 style="color: #2e2508;">`+ AD2 + `</h6>
                        <h6 style="color: #2e2508;">GST:`+ gstNo + `</h6>
                    </div>

                </div>

                <div class="col form-group" style="margin-right: 0;padding-right: 20px;" align="right">
                    <img src="http://aashaimpex.com/logos/`+ clnt + `.jpeg" id="logoImg" onerror="hideLogoImg();"width="200" height="100" alt="">
                </div>
            </div>

        </div>
        <div  class="form-group"><h5 align="center">`+getValueNotDefine(getOrderData[j].entryType)+`</h5></div>
        <hr style="height: 12px;background-color:#cc9e08;margin-bottom: 0%;">
        <div align="center" style=" background-color: rgb(197, 194, 194);height: 50px;margin-top: 0%;">
            <div class="form-row">
                <div class="col form-group" style="text-align: left;padding-top: 15px;padding-left: 10px;">
                    <h6>`+getValueNotDefine(getOrderData[j].entryType)+` NO: `+ getValueNotDefine(IDE) + `</h6>
                </div>
                <div class="col form-group" style="text-align: right;padding-top: 15px;padding-right: 10px;">
                    <h6>DATE:`+ formatDate((getOrderData[j].BK_DATE)) + `</h6>
                </div>
            </div>
        </div>

        <div style="padding: 10px;">
            <div class="form-row">
                <div class="col form-group">
                    <div id="orderFormPartyDet">
                        <h6><b>M/S</b></h6>
                        <h6> `+ getValueNotDefine(getOrderData[j].partyname) + `</h6>
                        <h6> `+ PAD1 + `</h6>
                        <h6>`+ PAD2 + `,` + getValueNotDefine(getOrderData[j].city) + `,` + PNO + `</h6>
                        <h6>GSTIN :  `+ getValueNotDefine(getOrderData[j].GSTIN) + `</h6>
                    </div>
                </div>
                <div class="col form-group">
                    <div>
                        <h6>BROKER : `+ getValueNotDefine(getOrderData[j].broker) + `</h6>
                        <h6>HASTE : `+ getValueNotDefine(getOrderData[j].haste) + `</h6>
                        <h6>TRANSPORT : `+ getValueNotDefine(getOrderData[j].BK_TRANSPORT) + `</h6>
                        <h6>BOOKING STATION : `+ getValueNotDefine(getOrderData[j].BK_STATION) + `</h6>
                    </div>
                </div>
            </div>
            <hr style="height: 12px;background-color:#cc9e08;margin-top: 0%;">
            
            <table class="" style="width:100%;" >
            <thead>
            <tr  style="margin: 0;height: 30px;color: #2e2508;font-weight: bold;width:100%;">
                <th>
                    
                        <h6>SR.-ITEM</h6>
                    
                </th>
                <th>
                    
                        <h6>PACKING STYLE</h6>
                    
                </th>
                <th>
                    
                        <h6>RATE</h6>
                    
                </th>
                <th>
                    
                        <h6>QUANTITY/MTS</h6>
                    
                </th>
                <th>
                    
                        <h6>RMK</h6>
                    
                </th>
            </tr>
            </thead>
           
                `;
            var billDetails = getOrderData[j].billDetails;
            if (billDetails.length > 0) {
                sr = 0;
                subtotal = 0;
                for (i = 0; i < billDetails.length; i++) {
                    sr += 1;
                    subtotal += parseInt(billDetails[i].qty);
                    div += `<tr  style="margin: 0;height: 20px;width:100%;">
                    <td>
                        
                            <h6>`+ sr + `-`+ billDetails[i].qualname + `</h6>
                        
                    </td>
                    <td>
                        
                            <h6>`+ billDetails[i].pack + `</h6>
                        
                    </td>
                    <td>
                        
                            <h6>`+ getValueNotDefine(billDetails[i].rate) + `</h6>
                        
                    </td>
                    <td>
                        
                            <h6>`+ getValueNotDefine(billDetails[i].qty) + `</h6>
                        
                    </td>
                    <td>
                        
                            <h6>`+ getValueNotDefine(billDetails[i].productRemark) + `</h6>
                        
                    </td>
                </tr>`;
                }

            }

            div += `
            <tr>
            <td colspan="6">
            
            <hr style="">
            </td>
            </tr>
            <tr  style="padding: 5px;">
                <td>
                    
                        <h6>SUB TOTAL</h6>
                    
                </td>
                <td>
                    
                        
                    
                </td>
                <td>
                    
                        
                    
                </td>
                <td>
                    
                        <h6>`+ subtotal + `</h6>
                    
                </td>
                <td>
                    
                        
                    
                </td>
            </tr>
           
            </table>
            <hr style="height: 12px;background-color:#cc9e08;margin-top: 0%;">

            <div class="form-row" style="padding: 5px;">
                <div class="col form-group">
                    <h6>REMARK</h6>
                    <textarea style="width: 80%;height: 100%;"> `+ getValueNotDefine(getOrderData[j].RMK) + ` </textarea>
                </div>
                <div class="col form-group">
                <hr style="height: 12px;background-color:#cc9e08;margin-top: 0%;">

                    <div style="width: 100%;display:inline;">
                        <div style="width: 50%;float:left;text-align: left;">
                            <h6>TOTAL :`+ subtotal + `</h6>
                        </div>
                        <div style="width: 50%;float:right;text-align: right;">
                            <h6>FOR : <b><u>`+ FIRMNAME + `</u></b> </h6>
                        </div>
                    </div>
                </div>
            </div>

            <div style="width: 100%;display:inline;margin-top:5px;">
                <div style="width: 33%;float:left;text-align: left;">
                     <h6>CHECKED BY `+ getValueNotDefine(getOrderData[j].confirmedBy) + `</h6>
                </div>
                <div style="width: 33%;float:left;text-align: center;">
                   <h6>ORDERED BY</h6>
               </div>
               <div style="width: 33%;float:right;text-align: right;">
                  <h6>AUTH. SIGNATORY</h6>
              </div>
            </div>
        </div>
    </div>
    <div class="partyDet">

    </div>
    <div class="productDet">

    </div>
    <div class="total">

    </div>
</div>`;

            $('#orderFormResult').html(div);
            if (share == "share") {
                document.title = getValueNotDefine(getOrderData[j].entryType)+` NO: `+ getValueNotDefine(IDE) ;
                var r = confirm("Do you want to share Order Form PDF");
                if (r) {
                    $('#result').addClass("ShareBillPdf");
                    $('#tblHead').addClass("ShareBillPdf");
                    $('#footerbottom').addClass("ShareBillPdf");
                    CreateOrderFormHtmlToPdf(getOrderData[j]);
                    var timeIntervel = setInterval(function () {
                        $('#result').removeClass("ShareBillPdf");
                        $('#tblHead').removeClass("ShareBillPdf");
                        $('#footerbottom').removeClass("ShareBillPdf");
                        $('#orderFormPdfFormate').css("display", "none");
                        document.title = ReportType + " REPORT";
                        clearInterval(timeIntervel);
                    }, 3500);
                } else {
                    $('#result').removeClass("ShareBillPdf");
                    $('#tblHead').removeClass("ShareBillPdf");
                    $('#footerbottom').removeClass("ShareBillPdf");
                    $('#orderFormPdfFormate').css("display", "none");
                    document.title = ReportType + " REPORT";                    
                    if (typeof clearPartyVal == "function") {
                        clearPartyVal();
                    }
                    CreateOrderFormHtmlToPdf(getOrderData[j]);
                }


            }
            qualAdd = false;



        }
    }

}
