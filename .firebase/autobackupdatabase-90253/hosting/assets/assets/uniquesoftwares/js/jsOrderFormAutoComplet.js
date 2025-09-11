var masterData;
var entryType = $('#entryType').val();
var MasterSearchData;
var hasteData = [];
var cityData = [];
var BK_STATIONData = [];
var TRANSPORTData = [];
function ChangeEntryType() {
    entryType = $('#entryType').val();
    if (entryType == "WORK-CHALLAN") {
        MasterSearchData = masterData.filter(function (d) {
            return d.ATYPE != 1;
        })
    } else {
        MasterSearchData = masterData.filter(function (d) {
            return d.ATYPE == 1;
        })
    }
}

jsGetObjectByKey(DSN, "MST", "").then(function (data) {

    masterData = data;
    brokerArray = masterData.filter(function (data) {
        return data.ATYPE == 12;
    })
    $("#broker").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
            return;
        } else {
            var broker = $(this).val();
            //alert(broker);
            if (broker != "") {
                console.log("----" + broker);
                $("#broker").autocomplete({
                    minLength: 1,
                    source: brokerArray,
                    select: function (event, ui) {
                        event.preventDefault();
                        $("#broker").val(ui.item.partyname);
                    },
                });
            }
        }
    });
    var flagCity = [];
    var flagBookingStation = [];
    MasterSearchData = masterData.filter(function (d) {
        if (!flagCity[d.city]) {
            var obj = {}
            obj.value = d.city;
            obj.label = d.city;
            cityData.push(obj);
            flagCity[d.city] = true;
        }
        if (!flagBookingStation[d.ST]) {
            var obj = {}
            obj.value = d.ST;
            obj.label = d.ST;
            BK_STATIONData.push(obj);
            flagBookingStation[d.ST] = true;
        }
        return d.ATYPE == 1;
    })
    console.log(BK_STATIONData);
    $("#BK_STATION").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
            return;
        } else {
            var BK_STATION = $(this).val();
            //alert(BK_STATION);
            if (BK_STATION !== "") {
                if (BK_STATIONData.length > 0) {
                    console.log(BK_STATIONData);
                    $("#BK_STATION").autocomplete({
                        minLength: 1,
                        source: function (request, response) {
                            var term = $.ui.autocomplete.escapeRegex(
                                request.term
                            ),
                                startsWithMatcher = new RegExp("^" + term, "i"),
                                startsWith = $.grep(BK_STATIONData, function (
                                    value
                                ) {
                                    return startsWithMatcher.test(
                                        value.label || value.value || value
                                    );
                                }),
                                containsMatcher = new RegExp(term, "i"),
                                contains = $.grep(BK_STATIONData, function (value) {
                                    return (
                                        $.inArray(value, startsWith) < 0 &&
                                        containsMatcher.test(
                                            value.label || value.value || value
                                        )
                                    );
                                });

                            response(startsWith.concat(contains));
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).val(ui.item.label);
                        },
                    });
                }
            }
        }
    });
    $("#city").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
            return;
        } else {
            var city = $(this).val();
            //alert(city);
            if (city !== "") {
                if (cityData.length > 0) {
                    console.log(cityData);
                    $("#city").autocomplete({
                        minLength: 1,
                        source: function (request, response) {
                            var term = $.ui.autocomplete.escapeRegex(
                                request.term
                            ),
                                startsWithMatcher = new RegExp("^" + term, "i"),
                                startsWith = $.grep(cityData, function (
                                    value
                                ) {
                                    return startsWithMatcher.test(
                                        value.label || value.value || value
                                    );
                                }),
                                containsMatcher = new RegExp(term, "i"),
                                contains = $.grep(cityData, function (value) {
                                    return (
                                        $.inArray(value, startsWith) < 0 &&
                                        containsMatcher.test(
                                            value.label || value.value || value
                                        )
                                    );
                                });

                            response(startsWith.concat(contains));
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).val(ui.item.label);
                        },
                    });
                }
            }
        }
    });
    $("#partyname").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
            return;
        } else {
            var partyname = $(this).val();
            //alert(partyname);
            if (partyname !== "") {
                if (MasterSearchData.length > 0) {
                    $("#partyname").autocomplete({
                        minLength: 1,
                        source: function (request, response) {
                            var term = $.ui.autocomplete.escapeRegex(
                                request.term
                            ),
                                startsWithMatcher = new RegExp("^" + term, "i"),
                                startsWith = $.grep(MasterSearchData, function (
                                    value
                                ) {
                                    return startsWithMatcher.test(
                                        value.partyname || value.label || value
                                    );
                                }),
                                containsMatcher = new RegExp(term, "i"),
                                contains = $.grep(MasterSearchData, function (value) {
                                    return (
                                        $.inArray(value, startsWith) < 0 &&
                                        containsMatcher.test(
                                            value.partyname || value.label || value
                                        )
                                    );
                                });

                            response(startsWith.concat(contains));
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).val(ui.item.label);
                            $("#partycode").val(ui.item.value);
                            $("#partyname").val(ui.item.partyname);
                            $("#GSTIN").val(ui.item.GST);
                            $("#city").val(ui.item.city);
                            $("#BK_STATION").val(ui.item.ST);
                            $("#broker").val(ui.item.broker);
                            $("#haste").val("");
                            $("#BK_TRANSPORT").val(ui.item.TRSPT);
                            $("#RMK").val(" DHARA :  " + getValueNotDefine(ui.item.dhara) + "    OR   " + getValueNotDefine(ui.item.CRD));

                        },
                    });
                }
            }
        }
    });

})
jsGetObjectByKey(DSN, "HASTE", "").then(function (HASTE) {
    hasteData = HASTE.map(function (d) {
        return { value: d.HS, label: d.HS+","+getValueNotDefine(d.ST), ST: d.ST, TRANSPORT: d.TR, AD: d.AD }
    });
    console.log(hasteData)
    $("#haste").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
            return;
        } else {
            var haste = $(this).val();
            //alert(haste);
            if (haste !== "") {
                if (hasteData.length > 0) {
                    $("#haste").autocomplete({
                        minLength: 1,
                        source: function (request, response) {
                            var term = $.ui.autocomplete.escapeRegex(
                                request.term
                            ),
                                startsWithMatcher = new RegExp("^" + term, "i"),
                                startsWith = $.grep(hasteData, function (
                                    value
                                ) {
                                    return startsWithMatcher.test(
                                        value.label || value.value || value
                                    );
                                }),
                                containsMatcher = new RegExp(term, "i"),
                                contains = $.grep(hasteData, function (value) {
                                    return (
                                        $.inArray(value, startsWith) < 0 &&
                                        containsMatcher.test(
                                            value.label || value.value || value
                                        )
                                    );
                                });

                            response(startsWith.concat(contains));
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).val(ui.item.label);
                            $("#haste").val(ui.item.value);
                            $("#BK_STATION").val(getValueNotDefine(ui.item.ST));
                            $("#BK_TRANSPORT").val(getValueNotDefine(ui.item.TRANSPORT));
                        },
                    });
                }
            }
        }
    });
})
jsGetObjectByKey(DSN, "TRANSPORT", "").then(function (TRANSPORT) {
    TRANSPORTData = TRANSPORT.map(function (d) {
        return { value: d.label, label: d.label }
    });
    console.log(TRANSPORTData)
    $("#BK_TRANSPORT").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
            return;
        } else {
            var BK_TRANSPORT = $(this).val();
            //alert(BK_TRANSPORT);
            if (BK_TRANSPORT !== "") {
                if (TRANSPORTData.length > 0) {
                    $("#BK_TRANSPORT").autocomplete({
                        minLength: 1,
                        source: function (request, response) {
                            var term = $.ui.autocomplete.escapeRegex(
                                request.term
                            ),
                                startsWithMatcher = new RegExp("^" + term, "i"),
                                startsWith = $.grep(TRANSPORTData, function (
                                    value
                                ) {
                                    return startsWithMatcher.test(
                                        value.label || value.value || value
                                    );
                                }),
                                containsMatcher = new RegExp(term, "i"),
                                contains = $.grep(TRANSPORTData, function (value) {
                                    return (
                                        $.inArray(value, startsWith) < 0 &&
                                        containsMatcher.test(
                                            value.label || value.value || value
                                        )
                                    );
                                });

                            response(startsWith.concat(contains));
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).val(ui.item.label);
                            $("#BK_TRANSPORT").val(ui.item.value);
                        },
                    });
                }
            }
        }
    });
})
jsGetObjectByKey(DSN, "QUL", "").then(function (data) {
    QULData = data;
    QULData=QULData.filter(function(d){
        var stockMsg=getValueNotDefine(d["FS"])!="" ? " (STOCK : "+d["FS"]+")":"";
        d["label"]=d["label"] +stockMsg;
        return true;
    })
    $("#qualname").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
            return;
        } else {
            var qual = $(this).val();
            //alert(qual);
            if (qual !== "") {
                if (QULData.length > 0) {
                    console.log("----" + qual);
                    $("#qualname").autocomplete({
                        minLength: 1,
                        source: function (request, response) {
                            var term = $.ui.autocomplete.escapeRegex(
                                request.term
                            ),
                                startsWithMatcher = new RegExp("^" + term, "i"),
                                startsWith = $.grep(QULData, function (
                                    value
                                ) {
                                    return startsWithMatcher.test(
                                        value.label || value.value || value
                                    );
                                }),
                                containsMatcher = new RegExp(term, "i"),
                                contains = $.grep(QULData, function (value) {
                                    return (
                                        $.inArray(value, startsWith) < 0 &&
                                        containsMatcher.test(
                                            value.label || value.value || value
                                        )
                                    );
                                });

                            response(startsWith.concat(contains));
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).val(ui.item.label);
                            $("#qualcode").val(ui.item.value);
                            $("#qualname").val(ui.item.value);
                            var S1 = parseInt(ui.item.S1) == 0 ? "" : parseInt(ui.item.S1);
                            $("#rate").val(S1);
                            document.getElementById('qty').focus();
                        },
                    });
                }
            }

        }
    });
})

var ARR_RMK = JSON.parse(localStorage.getItem("ARR_RMK"));
ARR_RMK = ARR_RMK == null ? ARR_RMK = [] : ARR_RMK;
$("#RMK").keyup(function (e) {
    if (e.which == 38 || e.which == 40 || e.which == 13) {
        return;
    } else {
        var RMK = $(this).val();
        //alert(RMK);
        if (RMK != "") {
            $("#RMK").autocomplete({
                minLength: 1,
                source: ARR_RMK,
                select: function (event, ui) {
                    event.preventDefault();
                    $("#RMK").val(ui.item.label);
                },
            });
        }
    }
});
