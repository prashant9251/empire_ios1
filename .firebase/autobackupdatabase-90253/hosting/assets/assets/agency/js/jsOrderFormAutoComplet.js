var masterData=[];
jsGetObjectByKey(DSN, "MST", "").then(function (data) {

    masterData = data;
    ccdmasterData = data.filter(function (data) {
        return data.ATYPE == 2;
    })

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

    MasterSearchData = masterData.filter(function (d) {
        return d.ATYPE == 1;
    })
    $("#partyname").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
            return;
        } else {
            var partyname = $(this).val();
            //alert(partyname);
            if (partyname !== "") {
                if (MasterSearchData.length > 0) {
                    console.log("----" + partyname);
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
                        },
                    });
                }
            }
        }
    });
    $("#ccd").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
            return;
        } else {
            var ccd = $(this).val();
            //alert(ccd);
            if (ccd !== "") {
                if (ccdmasterData.length > 0) {
                    console.log("----" + ccd);
                    $("#ccd").autocomplete({
                        minLength: 1,
                        source: function (request, response) {
                            var term = $.ui.autocomplete.escapeRegex(
                                request.term
                            ),
                                startsWithMatcher = new RegExp("^" + term, "i"),
                                startsWith = $.grep(ccdmasterData, function (
                                    value
                                ) {
                                    return startsWithMatcher.test(
                                        value.label || value.ccd || value
                                    );
                                }),
                                containsMatcher = new RegExp(term, "i"),
                                contains = $.grep(ccdmasterData, function (value) {
                                    return (
                                        $.inArray(value, startsWith) < 0 &&
                                        containsMatcher.test(
                                            value.label || value.ccd || value
                                        )
                                    );
                                });

                            response(startsWith.concat(contains));
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).val(ui.item.label);
                            $("#ccd").val(ui.item.partyname);
                            var AD1 = ui.item.AD1 == null ? "" : ui.item.AD1;
                            var AD2 = ui.item.AD2 == null ? "" : ui.item.AD2;
                            var city = ui.item.city == null ? "" : ui.item.city;
                            var Add = AD1 + "," + AD2 + "," + city;
                            $("#ccdAdd").val(Add);
                        },
                    });
                }
            }
        }
    });
})

jsGetObjectByKey(DSN, "QUL", "").then(function (data) {
    QULData = data;

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
                            $("#qualname").val(ui.item.label);
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
