
function loadCall(data) {
    Data = data;
    if (FIRM != null && FIRM != "" && FIRM != undefined) {
        Data = Data.filter(function (d) {
            return d.FIRM == FIRM;
        })
    }
    if (partyname != null && partyname != "" && partyname != undefined) {
        Data = Data.filter(function (d) {
            return d.partyname == partyname;
        })
    }
    if (CITY != null && CITY != "" && CITY != undefined) {
        Data = Data.filter(function (d) {
            return d.city == CITY;
        })
    }
    if (ccd != null && ccd != "" && ccd != undefined) {
        Data = Data.filter(function (d) {
            return d.ccd == ccd;
        })
    }
    if (fromdate != null && fromdate != "" && fromdate != undefined) {
        Data = Data.filter(function (d) {
            return new Date(d.BK_DATE).setHours(0, 0, 0, 0) >= new Date(fromdate).setHours(0, 0, 0, 0);
        })
    }
    if (todate != null && todate != "" && todate != undefined) {
        Data = Data.filter(function (d) {
            return new Date(d.BK_DATE).setHours(24, 0, 0, 0) <= new Date(todate).setHours(24, 0, 0, 0);
        })
    }

    if (qualname != '' && qualname != null) {
        Data = Data.filter(function (data) {
            return data.billDetails.some((billDetails) => billDetails['qualname'] === qualname);
        }).map(function (subdata) {
            return {
                code: subdata.code,
                BK_DATE: subdata.BK_DATE,
                BK_STATION: subdata.BK_STATION,
                BK_TRANSPORT: subdata.BK_TRANSPORT,
                FIRM: subdata.FIRM,
                GSTIN: subdata.GSTIN,
                OrderID: subdata.OrderID,
                RMK: subdata.RMK,
                ccd: subdata.ccd,
                city: subdata.city,
                ccdAdd: subdata.ccdAdd,
                partyname: subdata.partyname,
                dispatch: subdata.dispatch,
                confirmedBy: subdata.confirmedBy,
                billDetails: subdata.billDetails.filter(function (billDetails) {
                    return (billDetails['qualname'] === qualname);
                })
            }
        })
    }

    if (dispatchCondition != '' && dispatchCondition != null) {
        Data = Data.filter(function (data) {
            return data.billDetails.some((billDetails) => billDetails['dispatch'] == dispatchCondition);
        }).map(function (subdata) {
            return {
                code: subdata.code,
                BK_DATE: subdata.BK_DATE,
                BK_STATION: subdata.BK_STATION,
                BK_TRANSPORT: subdata.BK_TRANSPORT,
                FIRM: subdata.FIRM,
                GSTIN: subdata.GSTIN,
                OrderID: subdata.OrderID,
                RMK: subdata.RMK,
                ccd: subdata.ccd,
                city: subdata.city,
                ccdAdd: subdata.ccdAdd,
                partyname: subdata.partyname,
                dispatch: subdata.dispatch,
                confirmedBy: subdata.confirmedBy,
                billDetails: subdata.billDetails.filter(function (billDetails) {
                    return (billDetails['dispatch'] == dispatchCondition);
                })
            }
        })
    }

    console.log(Data);
    tr = '<tbody>';
    if (Data.length > 0) {
        tr += `<tr style="font-weight:500;background-color:#588c7e;color:white;"align="center">
        <th></th>
        <th>ORDER NO.</th>
        <th>CUSTOMER</th>
        <th>CITY</th>
        <th>SUPPLIER</th>
        <th>BOOKING ST.</th>
        <th>TRANSPORT</th>
        <th>RMK</th>
        <th colspan="2"></th>
        </tr>`;
        var sr = 0;
        var grandtotal = 0;
        var grandtotalDispatched = 0;
        var grandtotalpending = 0;
        for (var i = 0; i < Data.length; i++) {
            if (Data[i].dispatch == "Y") {
                btn = `<a><button  onclick="cloudStDkeyVal('` + Data[i].OrderID + `','dispatch','N','ORDER','');">RESTORE</button></a>`;
            } else if (Data[i].dispatch == "N") {
                btn = `<a><button  onclick="cloudStDkeyVal('` + Data[i].OrderID + `','dispatch','Y','ORDER','');">COMPLETE</button></a>`;
            } else {
                btn = `<a><button  onclick="cloudStDkeyVal('` + Data[i].OrderID + `','dispatch','Y','ORDER','');">COMPLETE</button></a>`;
            }
            sr += 1;
            tr += `<tr class="order` + Data[i].OrderID + ` hint"style="font-weight:700;"align="center">
            <td>`+ btn + `</td>
            <td>`+ Data[i].OrderID + `</td>
            <td>`+ Data[i].partyname + `</td>
            <td>`+ Data[i].city + `</td>
            <td>`+ Data[i].ccd + `</td>
            <td>`+ Data[i].BK_STATION + ` </td>
            <td>`+ Data[i].BK_TRANSPORT + `</td>
            <td>`+ Data[i].RMK + `</td>
            <td colspan="3"></td>
            </tr>`;

            var billdetails = Data[i].billDetails;

            var qSr = 0;
            if (billdetails.length > 0) {
                tr += `<tr class="order` + Data[i].OrderID + ` hint"style=""align="center">
                <td></td>
                <td colspan="1"><button onclick="makepdf('`+ Data[i].OrderID + `', '` + Data[i].OrderID + `','share');"style="font-size:20px;"><a>&#10148;</a></button></td>
                <td class="trOrd">SR</td>
                <td class="trOrd">PRODUCT</td>
                <td class="trOrd">QUANTITY</td>
                <td class="trOrd"colspan="1">DISPATCHED</td>
                <td class="trOrd"colspan="1">PENDING</td>
                <td class="trOrd">TYPE</td>
                <td class="trOrd">PACK</td>
                <td class="trOrd">PRICE</td>
                <td class="trOrd"colspan="1">DISPATCH</td>
                </tr>`;
                var subtotal = 0;
                var subtotalDispatched = 0;
                var subtotalpending = 0
                count = 0;
                for (var j = 0; j < billdetails.length; j++) {
                    console.log(billdetails[j].dispatched);
                    dispatched = (billdetails[j].dispatched)
                    dispatched = (dispatched == undefined && dispatched == null ? 0 : dispatched);
                    pending = parseInt(billdetails[j].qty) - parseInt(dispatched);
                    pending = pending < 0 ? 0 : pending;
                    qSr += 1;
                    subtotal += parseInt(billdetails[j].qty);
                    subtotalDispatched += parseInt(dispatched);
                    subtotalpending += parseInt(pending);
                    count = billdetails.length;
                    console.log(Data[i].OrderID, count);
                    FeditQty = `'` + Data[i].OrderID + `','` + billdetails[j].ID + `','` + pending + `','` + billdetails[j].qualname + `'`;
                    tr += `<tr class="order` + Data[i].OrderID + ` hint" style="font-weight:500;color:#588c7e;"align="center">
                    <td colspan="1"><button style="font-size:20px;" onclick="editQty(`+ FeditQty + `);">&#9998;</button></td>
                    <td>
                    <button style="font-size:20px;background-color: #588c7e;color:white;" onclick="cloudStDkeyVal('`+ Data[i].OrderID + `','dispatch','Y','ORDER','` + billdetails[j].ID + `','` + count + `');">&#10004;</button></td>
                    <td onclick="editQty(`+ FeditQty + `);">` + billdetails[j].ID + `</td>
                    <td onclick="editQty(`+ FeditQty + `);">` + billdetails[j].qualname + `</td>
                    <td onclick="editQty(`+ FeditQty + `);">` + billdetails[j].qty + `</td>
                    <td onclick="editQty(`+ FeditQty + `);">` + dispatched + `</td>
                    <td onclick="editQty(`+ FeditQty + `);">` + pending + `</td>
                    <td onclick="editQty(`+ FeditQty + `);">` + billdetails[j].ptype + `</td>
                    <td onclick="editQty(`+ FeditQty + `);">` + billdetails[j].pack + ` </td>
                    <td onclick="editQty(`+ FeditQty + `);">` + billdetails[j].rate + `</td>
                    <td onclick="editQty(`+ FeditQty + `);" colspan="1">` + billdetails[j].dispatch + `</td>
                    </tr>`;
                }
                tr += `<tr  class="order` + Data[i].OrderID + ` hint" class="tfootcard"style="background-color:#3e3b3b26;color:#1b5d4b;text-align: center;" align="center">
                <td colspan="4">SUB TOTAL</td>
                <td>`+ subtotal + `</td>
                <td>`+ subtotalDispatched + `</td>                
                <td>`+ subtotalpending + `</td>                
                <td colspan="6"></td>
                </tr>`;
                grandtotal += subtotal;
                grandtotalDispatched += subtotalDispatched;
                grandtotalpending += subtotalpending;
            }

        }
        tr += `<tr  class="tfootcard"style="background-color:#3e3b3b26;color:#1b5d4b;text-align: center;" align="center">
            <td colspan="4">GRAND TOTAL</td>
            <td>`+ grandtotal + `</td>
            <td>`+ grandtotalDispatched + `</td>
            <td>`+ grandtotalpending + `</td>
            <td colspan="6"></td>
            </tr>`;
        document.title = "ORDER LIST";
        $('#result').html(tr);
        $("#loader").removeClass('has-loader');
    } else {
        $('#result').html('<h1 align="center">No Order Found</h1>');
        $("#loader").removeClass('has-loader');
    }
}


function editQty(DispatchOrderID, productId, pendingQty, qualName) {
    qty = prompt((" Enter dispatched quantity for ").toUpperCase() + qualName.toUpperCase());
    if (qty != null && qty != "") {
        finalQty = parseInt(pendingQty - qty);
        if ((finalQty) < 0) {
            var res = confirm(`Only ` + pendingQty + ` order remaining, do you still want to proceed  ?`);
            if (res == true) {
                finalQty = 0;
                cloudIndDkeyVal(DispatchOrderID, 'qty', qty, 'ORDER', productId).then(function (data) {
                    cloudStDkeyVal(DispatchOrderID, 'dispatch', 'Y', 'ORDER', productId).then(function (data) {
                        // alert("UPDATED");
                        console.log((data));
                        getCloudData();
                    })
                }, function (error) {
                    msg = "Please check internet connection & try again";
                    alert(msg);
                    // $('#result').html('<h6 align="center">'+msg+'</h6>');
                    $("#loader").removeClass('has-loader');
                })
            }
        } else {
            cloudIndDkeyVal(DispatchOrderID, 'qty', qty, 'ORDER', productId).then(function (data) {
                alert("Updated successfully");
                console.log((data));
                getCloudData();
            }, function (error) {
                msg = "PLEASE CHECK INTERNET CONNECTION & TRY AGAIN";
                alert(msg);
                // $('#result').html('<h6 align="center">'+msg+'</h6>');
                $("#loader").removeClass('has-loader');
            })
        }

    }
}


function makepdf(DispatchOrderID, IDE, share) {
    DataForDispatch = DataForDispatchArray.filter(function (d) {
        return d.OrderID == DispatchOrderID;
    })

    makeOrderPdf(DispatchOrderID, IDE, DataForDispatch, "", share);
}
