var masterData;
var ReportTypeArray;
var url = window.location.href;
var acgroupData;
var partynameAcgroupData;
var ccdAcgroupData;
function clearMobileNo() {
    $('#mobileNo').val('')
}

var MFIRM = [];
var MCNO = getUrlParams(url, "MCNO");
var MCNO_SELECT = localStorage.getItem(DSN + "MCNO_SELECT");
function getFirmDetailsByFirm(MCNO_SELECT) {
    return NMFIRM = COMPMST.filter(function (data) {
        return data.FIRM.trim() == MCNO_SELECT.trim();
    })
}

function getFirmDetailsByCno(CNO) {
    return NMFIRM = COMPMST.filter(function (data) {
        return data.CNO.trim() == CNO.trim();
    })
}

$(document).ready(function () {
    setDate();
    $("#partyname").focus(function () {
        clearMobileNo();
    });
    $("#ccd").focus(function () {
        clearMobileNo();
    });
    jsGetObjectByKey(DSN, "COMPMST", "").then(function (COMPMST) {
        this.COMPMST = COMPMST;
        COMPMST = COMPMST.sort(function (a, b) {
            a.label = a.FIRM;
            if (a.FIRM > b.FIRM) { return -1; }
            if (a.FIRM < b.FIRM) { return 1; }
            return 0;
        });

        if (MCNO != null && MCNO != "" && MCNO != undefined) {
            MFIRM = COMPMST.filter(function (data) {
                return data.CNO.trim() == MCNO.trim();
            });
        }
        var xfirm = document.getElementById("FIRM");
        if (COMPMST.length > 0) {
            COMPMST.forEach(function (element, index) {
                var option = document.createElement("option");
                option.value = element.FIRM;
                option.text = element.FIRM;
                try {
                    xfirm.add(option, xfirm[0]);
                } catch (error) {

                }
                //  alert(element.FIRM);
            });
        } else {
            $('body').html(`
            <div>
            <img src="./../syncAgain.jpeg" height="500"/>
            <h2 onclick="syncDatabyFlutter();"> follow this step</h2>
            <h1 onclick="syncDatabyFlutter();"> Please sync again </h1>
            </div>      
            `);
        }

        var option = document.createElement("option");
        option.value = "";
        option.text = "ALL";
        try {
            xfirm.add(option, xfirm[0]);

        } catch (error) {

        }
        try {
            setData();
        } catch (error) {

        }

        var FIX_FIRM = AllUrlString["FIX_FIRM"];
        try {
            if (FIX_FIRM != null && FIX_FIRM != "") {
                // alert(FIX_FIRM);
                try {
                    $('#FIRM').css('display', "none");
                    document.getElementById("FIRM").value = getFirmDetailsByCno(FIX_FIRM)[0].FIRM;
                } catch (error) { }
            } else if (MCNO_SELECT != null) {
                document.getElementById("FIRM").value = getFirmDetailsByFirm(MCNO_SELECT)[0].FIRM;
                // alert(getFirmDetailsByFirm(MCNO_SELECT)[0].FIRM);
            } else if (MCNO != "" && MCNO != null && MCNO != undefined) {
                if (MFIRM.length > 0) {
                    document.getElementById("FIRM").value = MFIRM[0].FIRM;
                }
            } else {
                document.getElementById("FIRM").value = "";
            }
        } catch (err) {
            try {
                document.getElementById("FIRM").value = "";
            } catch (error) {
            }
            //console.log("======================err_firm_select_defult================"+err);
        }


        $("#FIRM").change(function () {

            var val = $("#FIRM").val();
            localStorage.setItem(DSN + "MCNO_SELECT", val)
        });
        jsGetObjectByKey(DSN, "ACGROUP", "").then(function (data) {
            acgroupData = data;
            //console.log(acgroupData)
            partynameAcgroupData = acgroupData.filter(function (d) {
                return d.ATYPE == 1;
            })
            ccdAcgroupData = acgroupData.filter(function (d) {
                return d.ATYPE == 2;
            })
            jsGetObjectByKey(DSN, "MST", "").then(function (data) {
                masterData = data;
                ccdmasterData = data;
                if (url.indexOf('ALLSALE_FRMReport') > -1 || url.indexOf('DDREG_FRMReport') > -1 || url.indexOf('COMM_FRMReport') > -1 || (url.indexOf('OUTSTANDING_FRMReport') > -1 && url.indexOf('PURCHASEOUTSTANDING_FRMReport') < 0)) {
                    masterData = masterData.filter(function (data) {
                        return data.ATYPE == 1;
                    })
                    ccdmasterData = ccdmasterData.filter(function (data) {
                        return data.ATYPE == 2;
                    })
                } else if (url.indexOf('PURCHASEOUTSTANDING_FRMReport') > -1 || url.indexOf('PURCHASE_FRMReport') > -1 || url.indexOf('PURCHASEFINISH_FRMReport') > -1) {
                    masterData = masterData.filter(function (data) {
                        return data.ATYPE != 1;
                    })
                    ccdmasterData = ccdmasterData.filter(function (data) {
                        return data.ATYPE == 2;
                    })
                }
                var brokerArray = data;
                var array = data;
                var unique = [];
                var distinct = [];
                try {

                    for (let i = 0; i < array.length; i++) {
                        if (!unique[array[i].PTGD]) {
                            distinct.push(array[i].PTGD);
                            unique[array[i].PTGD] = 1;
                            if (array[i].PTGD != null) {
                                getoption(array[i].PTGD, array[i].PTGD, "GRD");
                                document.getElementById("GRD").value = "GRADE";
                            }

                        }
                    }
                    getoption("GRADE", "", "GRD");

                } catch (error) {

                }
                //----------------broker-------------------
                //// console.log(brokerArray);

                brokerArray = brokerArray.filter(function (data) {
                    return data.ATYPE == 12;
                })
                //// console.log(brokerArray);
                $("#broker").keyup(function (e) {
                    if (e.which == 38 || e.which == 40 || e.which == 13) {
                        return;
                    } else {
                        var broker = $(this).val();
                        //alert(broker);
                        if (broker != "") {
                            //console.log("----" + broker);
                            $("#broker").autocomplete({
                                minLength: 1,
                                source: brokerArray,
                                select: function (event, ui) {
                                    event.preventDefault();
                                    $("#broker").val(ui.item.partyname);
                                    $("#brokercode").val(ui.item.value);
                                },
                            });
                        }
                    }
                });
                //----------------------
                $("#partyname").keyup(function (e) {
                    if (e.which == 38 || e.which == 40 || e.which == 13) {
                        return;
                    } else {
                        var partyname = $(this).val();
                        //alert(partyname);
                        if (partyname !== "") {
                            if (masterData.length > 0) {
                                //console.log("----" + partyname);
                                $("#partyname").autocomplete({
                                    minLength: 1,
                                    source: function (request, response) {
                                        var term = $.ui.autocomplete.escapeRegex(
                                            request.term
                                        ),
                                            startsWithMatcher = new RegExp("^" + term, "i"),
                                            startsWith = $.grep(masterData, function (
                                                value
                                            ) {
                                                return startsWithMatcher.test(
                                                    value.label || value.partyname || value
                                                );
                                            }),
                                            containsMatcher = new RegExp(term, "i"),
                                            contains = $.grep(masterData, function (value) {
                                                return (
                                                    $.inArray(value, startsWith) < 0 &&
                                                    containsMatcher.test(
                                                        value.label || value.partyname || value
                                                    )
                                                );
                                            });

                                        response(startsWith.concat(contains));
                                    },
                                    select: function (event, ui) {
                                        event.preventDefault();
                                        $(this).val(ui.item.label);
                                        $("#partycode").val(
                                            ui.item.value.replace(/(\r\n|\n|\r)/gm, "")
                                        );
                                        $("#partyname").val(
                                            ui.item.partyname.replace(/(\r\n|\n|\r)/gm, "")
                                        );
                                        try {
                                            $("#mobileNo").val(ui.item.MO);
                                        } catch (error) {

                                        }
                                    },
                                });
                            }
                        }
                    }
                });
                //----------------------
                $("#partynamegrp").keyup(function (e) {
                    if (e.which == 38 || e.which == 40 || e.which == 13) {
                        return;
                    } else {
                        var partynamegrp = $(this).val();
                        //alert(partynamegrp);
                        if (partynamegrp !== "") {
                            if (partynameAcgroupData.length > 0) {
                                //console.log("----" + partynamegrp);
                                $("#partynamegrp").autocomplete({
                                    minLength: 1,
                                    source: function (request, response) {
                                        var term = $.ui.autocomplete.escapeRegex(
                                            request.term
                                        ),
                                            startsWithMatcher = new RegExp("^" + term, "i"),
                                            startsWith = $.grep(partynameAcgroupData, function (
                                                value
                                            ) {
                                                return startsWithMatcher.test(
                                                    value.label || value.partyname || value
                                                );
                                            }),
                                            containsMatcher = new RegExp(term, "i"),
                                            contains = $.grep(partynameAcgroupData, function (value) {
                                                return (
                                                    $.inArray(value, startsWith) < 0 &&
                                                    containsMatcher.test(
                                                        value.label || value.partyname || value
                                                    )
                                                );
                                            });

                                        response(startsWith.concat(contains));
                                    },
                                    select: function (event, ui) {
                                        event.preventDefault();
                                        $(this).val(ui.item.label);
                                        $("#partycodegrp").val(ui.item.value);
                                        $("#partynamegrp").val(ui.item.partyname);
                                        try {
                                            $("#mobileNo").val(ui.item.MO);
                                        } catch (error) {

                                        }
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
                                //console.log("----" + ccd);
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
                                        $("#ccdcode").val(ui.item.value);
                                        try {
                                            $("#mobileNo").val(ui.item.MO);
                                        } catch (error) {

                                        }
                                    },
                                });
                            }
                        }
                    }
                });

                $("#ccdgrp").keyup(function (e) {
                    if (e.which == 38 || e.which == 40 || e.which == 13) {
                        return;
                    } else {
                        var ccdgrp = $(this).val();
                        //alert(ccdgrp);
                        if (ccdgrp !== "") {
                            if (ccdAcgroupData.length > 0) {
                                //console.log("----" + ccdgrp);
                                $("#ccdgrp").autocomplete({
                                    minLength: 1,
                                    source: function (request, response) {
                                        var term = $.ui.autocomplete.escapeRegex(
                                            request.term
                                        ),
                                            startsWithMatcher = new RegExp("^" + term, "i"),
                                            startsWith = $.grep(ccdAcgroupData, function (
                                                value
                                            ) {
                                                return startsWithMatcher.test(
                                                    value.label || value.ccd || value
                                                );
                                            }),
                                            containsMatcher = new RegExp(term, "i"),
                                            contains = $.grep(ccdAcgroupData, function (value) {
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
                                        $("#ccdgrp").val(ui.item.partyname);
                                        $("#ccdcodegrp").val(ui.item.value);
                                        try {
                                            $("#mobileNo").val(ui.item.MO);
                                        } catch (error) {

                                        }
                                    },
                                });
                            }
                        }
                    }
                });
            })
        })
    })

    var cityArray
    jsGetObjectByKey(DSN, "CITY", "").then(function (data) {
        cityArray = data.map(function (data) {
            return {
                label: data.CT
            }
        });

        $("#city").keyup(function (e) {
            if (e.which == 38 || e.which == 40 || e.which == 13) {
                return;
            } else {
                var city = $(this).val();
                //alert(city);
                if (city != "") {
                    //console.log("--" + city);
                    $("#city").autocomplete({
                        minLength: 1,
                        source: cityArray
                    });
                }
            }
        });
    });




    jsGetObjectByKey(DSN, "HASTE", "").then(function (data) {
        var hasteArray = data.map(function (data) {
            return {
                label: data.HS
            }
        });
        $("#haste").keyup(function (e) {
            if (e.which == 38 || e.which == 40 || e.which == 13) {
                return;
            } else {
                var haste = $(this).val();
                //alert(haste);
                if (haste !== "") {
                    //console.log("----" + haste);
                    $("#haste").autocomplete({
                        minLength: 1,
                        source: hasteArray
                    });
                }
            }
        });
    });

    jsGetObjectByKey(DSN, "SERIES", "").then(function (data) {
        ReportTypeArray = data.map(function (data) {
            return {
                label: data.SERIES,
                value: data.ST,
                TYPE: data.SERIESCODE,
                DT: data.DT
            }
        });

        if (url.indexOf('PURCHASEFINISH_FRMReport') > -1) {
            document.getElementById('ReportType').value = ""
            document.getElementById('ReportATypeCode').value = ""
            document.getElementById('ReportSeriesTypeCode').value = "P"
        } else if (url.indexOf('RETURNGOODS_FRMReport') > -1) {
            document.getElementById('ReportType').value = ""
            document.getElementById('ReportATypeCode').value = "1"
            document.getElementById('ReportSeriesTypeCode').value = "P"
            document.getElementById('ReportDOC_TYPECode').value = "CN"
        } else if (url.indexOf('PURCHASE_FRMReport') > -1) {
            var TYPE = "P1"
            var seriesArray = getReportTypeArrayBySERIES(TYPE);
            document.getElementById('ReportType').value = seriesArray[0].label
            document.getElementById('ReportATypeCode').value = seriesArray[0].value
            document.getElementById('ReportSeriesTypeCode').value = TYPE
        } else if (url.indexOf('PURCHASEOUTSTANDING_FRMReport') > -1) {
            var TYPE = "P1"
            var seriesArray = getReportTypeArrayBySERIES(TYPE);
            document.getElementById('ReportType').value = seriesArray[0].label
            document.getElementById('ReportATypeCode').value = seriesArray[0].value
            document.getElementById('ReportSeriesTypeCode').value = TYPE
            //console.log(seriesArray)
        } else if (url.indexOf('COMM_FRMReport') > -1) {
            document.getElementById('ReportType').value = "COMMISSION PENDING"
            document.getElementById('ReportATypeCode').value = "2"
            document.getElementById('ReportSeriesTypeCode').value = ""
        } else if (url.indexOf('DDREG_FRMReport') > -1) {
            document.getElementById('ReportType').value = "DD REGISTER"
            document.getElementById('ReportATypeCode').value = "2"
            document.getElementById('ReportSeriesTypeCode').value = ""
        } else if (url.indexOf('OUTSTANDING_FRMReport') > -1) {
            try {
                var TYPE = "S1"
                var seriesArray = getReportTypeArrayBySERIES(TYPE);
                document.getElementById('ReportType').value = "";
                document.getElementById('ReportATypeCode').value = seriesArray[0].value
                document.getElementById('ReportSeriesTypeCode').value = TYPE
            } catch (error) {

            }
        } else {
            try {
                var TYPE = "S1"
                var seriesArray = getReportTypeArrayBySERIES(TYPE);
                document.getElementById('ReportType').value = seriesArray[0].label
                document.getElementById('ReportATypeCode').value = seriesArray[0].value
                document.getElementById('ReportSeriesTypeCode').value = TYPE
            } catch (error) {

            }
        }
        $("#ReportType").keyup(function (e) {
            if (e.which == 38 || e.which == 40 || e.which == 13) {
                return;
            } else {
                var ReportType = $(this).val();
                //alert(ReportType);
                if (ReportType !== "") {
                    //console.log("----" + ReportType);
                    $("#ReportType").autocomplete({
                        minLength: 1,
                        source: function (request, response) {
                            var term = $.ui.autocomplete.escapeRegex(request.term),
                                startsWithMatcher = new RegExp("^" + term, "i"),
                                startsWith = $.grep(ReportTypeArray, function (value) {
                                    return startsWithMatcher.test(value.label || value.SERIESCODE || value);
                                }),
                                containsMatcher = new RegExp(term, "i"),
                                contains = $.grep(ReportTypeArray, function (value) {
                                    return ($.inArray(value, startsWith) < 0 && containsMatcher.test(value.label || value.SERIESCODE || value)
                                    );
                                });

                            response(startsWith.concat(contains));
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).val(ui.item.label);
                            $("#ReportType").val(ui.item.label);
                            $("#ReportATypeCode").val(ui.item.value);
                            $("#ReportSeriesTypeCode").val(ui.item.TYPE);
                            $("#ReportDOC_TYPECode").val(ui.item.DT);
                            //console.log(ui.item.label, ui.item.value, ui.item.TYPE, ui.item.DT);
                        },
                    });
                }
            }
        });
    });



});

function getReportTypeArrayBySERIES(code) {
    return ReportTypeArray.filter(function (d) {
        return d.TYPE == code;
    })
}


function setDate() {
    if (
        url.indexOf("OUTSTANDING_FRMReport") > -1 ||
        url.indexOf("bankPassBook_FRMReport") > -1 ||
        url.indexOf("PURCHASEOUTSTANDING_FRMReport") > -1 ||
        url.indexOf("COMM_FRMReport") > -1 ||
        url.indexOf("PCORDER_FRMReport") > -1
    ) {
    } else {
        currentYearStartdate = "20" + Currentyear.substring(0, 2) + "-04-01";
        dateSetToInput("search_FromDate", currentYearStartdate);
    }
}
function dateSetToInput(Id, inputDate) {
    var date = new Date(inputDate);
    var day = date.getDate();
    var month = date.getMonth() + 1;
    var year = date.getFullYear();
    if (month < 10) month = "0" + month;
    if (day < 10) day = "0" + day;
    var today = year + "-" + month + "-" + day;
    try {
        document.getElementById(Id).value = today;
    } catch (error) {

    }
}

if (IosPlateForm == "true") {
    $('head').append('<meta name="viewport"content="width=device-width, initial-scale=.7, maximum-scale=100, user-scalable=no"/>');
}