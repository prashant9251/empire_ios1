var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'js/jsToolTips.js');
document.head.appendChild(my_awesome_script);
var mobileNoChoose = "MO";
var ATYPES = [];
var ReportTypeArray = [];
var ReportTypeArraySearch = [];
var masterData, MainMasterData;
var url = window.location.href;
var BLS_DataArray;
var CITY_ARRAY = [];
var groupData = [];
var MARKETArray = [];
var sundryDebitorsAtype = "1";
var COMPMST = [];
var hasteArray = [];
function cityFilterSet(Array) {
  var CityFind = [];
  var MARKETflag = [];
  for (var i = 0; i < Array.length; i++) {
    if (!CityFind[Array[i].city]) {
      CITY_ARRAY.push({ label: Array[i].city });
      CityFind[Array[i].city] = true;
    }
    if (!MARKETflag[Array[i].M]) {
      MARKETArray.push({ label: Array[i].M, value: Array[i].M });
      MARKETflag[Array[i].M] = true;
    }
  }
  console.log(MARKETArray);
}
function getReportTypeArrayBySERIES(code) {
  return ReportTypeArray.filter(function (d) {
    return d.TYPE == code;
  });
}

function loadAtypeOninit(sundryDebitorsAtype) {
  var v = getATypeArrayByAtype(sundryDebitorsAtype);
  if (v.length > 0) {
    try {
      document.getElementById("ReportATypeName").value = v[0].label;
      document.getElementById("ReportATypeCode").value = v[0].value;
    } catch (error) {

    }
  }
}
function getATypeArrayByAtype(atype_code) {
  return ATYPES.filter(function (d) {
    return d.value == atype_code;
  });
}

var FORM_TYPE = getUrlParams(url, "FORM_TYPE");
FORM_TYPE = FORM_TYPE == null ? "" : FORM_TYPE;

function clearMobileNo() {
  $("#mobileNo").val("");
  $("#partyEmail").val("");
}
function getPartyDetailsBySendCode(ccode) {
  return masterData.filter(function (data) {
    return data.value == ccode;
  });
}

function refreshAutoComplateVal() {
  var sundryDebitorsAtype = $("#ReportATypeCode").val();
  var ReportATypeName = $("#ReportATypeName").val();
  if (ReportATypeName == null || ReportATypeName == "") {
    sundryDebitorsAtype = "";
  }
  if (url.indexOf("PENDINGLR_AJXREPORT") > -1 ||
    url.indexOf("ITEMWISESALE_FRMReport") > -1 ||
    url.indexOf("ALLSALE_FRM") > -1 ||
    url.indexOf("bulkPdfBill") > -1 ||
    (url.indexOf("OUTSTANDING_FRMReport") > -1 && FORM_TYPE.indexOf("PURCHASEOUTSTANDING") < 0)
  ) {
    if (sundryDebitorsAtype == "" || sundryDebitorsAtype == null) {
      sundryDebitorsAtype = "1";
    }
    // && FORM_TYPE.indexOf("PURCHASEOUTSTANDING")<0
    masterData = MainMasterData.filter(function (data) {
      return data.ATYPE == sundryDebitorsAtype;
    });
  } else if (url.indexOf("millstock_FRMReport") > -1) {
    masterData = MainMasterData.filter(function (data) {
      return data.ATYPE == 14;
    });
  } else if (
    url.indexOf("PURCHASEOUTSTANDING_FRMReport") > -1 ||
    url.indexOf("PURCHASE_FRMReport") > -1 ||
    url.indexOf("PURCHASEFINISH_FRMReport") > -1 ||
    (url.indexOf("OUTSTANDING_FRMReport") > -1 && FORM_TYPE.indexOf("PURCHASEOUTSTANDING") > -1)
  ) {

    if (sundryDebitorsAtype == "" || sundryDebitorsAtype == null) {
      sundryDebitorsAtype = "1";
      masterData = MainMasterData.filter(function (data) {
        return data.ATYPE != sundryDebitorsAtype;
      });
      sundryDebitorsAtype = "";
    } else {
      masterData = MainMasterData.filter(function (data) {
        return data.ATYPE == sundryDebitorsAtype;
      });
    }
  }
  loadAtypeOninit(sundryDebitorsAtype);//loading Atype on change Series
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
  $("#broker").focus(function () {
    clearMobileNo();
  });
  $("#partyname").focus(function () {
    clearMobileNo();
  });
  jsGetObjectByKey(DSN, "COMPMST", "").then(function (COMPMST) {
    this.COMPMST = COMPMST;

    COMPMST = COMPMST.sort(function (a, b) {
      a.label = a.FIRM;
      if (a.CNO > b.CNO) { return -1; }
      if (a.CNO < b.CNO) { return 1; }
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
        option.text = element.CNO + "- " + element.FIRM;
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
      <h2 onclick="syncDatabyFlutter();">No database Found</h2>
      <h2 onclick="syncDatabyFlutter();">Step follow kare</h2>
      <h1 onclick="syncDatabyFlutter();"> dubara se Current year or Last year sync kare </h1>
      <h1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <button  onclick="syncDatabyFlutter();">Sync Now</button></h1>
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
      if (FIX_FIRM != null && FIX_FIRM != "" && FIX_FIRM != undefined) {
        // alert(FIX_FIRM);
        try {
          $('#FIRM').css('display', "none");
          document.getElementById("FIRM").value = getFirmDetailsByCno(FIX_FIRM)[0].FIRM;
        } catch (error) { }
      } else if (MCNO_SELECT != null && MCNO_SELECT != "" && MCNO_SELECT != undefined) {
        try {
          document.getElementById("FIRM").value = getFirmDetailsByFirm(MCNO_SELECT)[0].FIRM;
        } catch (error) { }

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
      console.log("======================err_firm_select_defult================" + err);
    }

    $("#FIRM").change(function () {
      var val = $("#FIRM").val();
      localStorage.setItem(DSN + "MCNO_SELECT", val)
    });

    jsGetObjectByKey(DSN, "MST", "").then(function (data) {

      masterData = data;
      MainMasterData = data;
      cityFilterSet(masterData);
      var brokerArray = data;
      var array = data;
      jsGetObjectByKey(DSN, "SERIES", "").then(function (t) {
        jsGetObjectByKey(DSN, "ATYPE", "").then(function (ATYPE_DATA) {
          this.ATYPES = ATYPE_DATA.map(function (data) {
            return {
              label: data.NAME,
              value: data.ATYPE,
            };
          });
          ReportTypeArray = t.map(function (data) {
            return {
              label: data.SERIES,
              value: data.ST,
              TYPE: data.SERIESCODE,
              DT: data.DT,
            };
          });
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
          } catch (error) { }
          //----------------broker-------------------
          brokerArray = brokerArray.filter(function (d) {
            return d.ATYPE == 12;
          });
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
                    $("#broker").val(ui.item.value);
                    try {
                      $("#mobileNo").val(ui.item[mobileNoChoose]);
                      $("#partyEmail").val(ui.item.EML);
                    } catch (error) { }
                    try {
                      processDataAllType();//for chart
                    } catch (error) {

                    }
                  },
                });
              }
            }
          });

          //----------------------ATYPES
          $("#ReportATypeName").keyup(function (e) {
            if (e.which == 38 || e.which == 40 || e.which == 13) {
              return;
            } else {
              var search = $(this).val();
              //alert(ATYPES);
              if (search != "") {
                $("#ReportATypeName").autocomplete({
                  minLength: 1,
                  source: ATYPES,
                  select: function (event, ui) {
                    event.preventDefault();
                    $(this).val(ui.item.label);
                    try {
                      $("#ReportATypeCode").val(ui.item.value);
                      $("#ReportATypeName").val(ui.item.label);
                      refreshAutoComplateVal();
                    } catch (error) { }
                    try {
                      setData();
                    } catch (error) { }
                  },
                });
              }
            }
          });

          //----------------------MARKET

          $("#MARKET").keyup(function (e) {
            if (e.which == 38 || e.which == 40 || e.which == 13) {
              return;
            } else {
              var MARKET = $(this).val();
              //alert(MARKET);
              if (MARKET != "") {
                console.log("----" + MARKET);
                $("#MARKET").autocomplete({
                  minLength: 1,
                  source: MARKETArray,
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
              // console.log(masterData)
              //alert(partyname);
              if (partyname !== "") {
                if (masterData.length > 0) {
                  $("#partyname").autocomplete({
                    minLength: 1,
                    source: function (request, response) {
                      var term = $.ui.autocomplete.escapeRegex(request.term),
                        startsWithMatcher = new RegExp("^" + term, "i"),
                        startsWith = $.grep(masterData, function (value) {
                          return startsWithMatcher.test(
                            value.value || value.label || value
                          );
                        }),
                        containsMatcher = new RegExp(term, "i"),
                        contains = $.grep(masterData, function (value) {
                          return (
                            $.inArray(value, startsWith) < 0 &&
                            containsMatcher.test(
                              value.value || value.label || value
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
                      console.log(ui.item);
                      try {
                        $("#mobileNo").val(ui.item.MO);
                        $("#partyEmail").val(ui.item.EML);
                      } catch (error) { }

                      try {
                        setData();
                      } catch (error) { }
                      try {
                        processDataAllType();//for chart
                      } catch (error) {

                      }
                      try {
                        hasteArray = [];
                        hasteArray = hasteMainArray.filter(function (d) {
                          return d.AD.toString().toUpperCase().trim() == ui.item.value.toString().toUpperCase().trim();
                        });
                      } catch (error) {

                      }
                      try {
                        loadItemSaleChartTable();//calling Item chart chart function
                      } catch (error) {

                      }
                    },
                  });
                }
              }
            }
          });
          jsGetObjectByKey(DSN, "ACGROUP", "").then(function (groupData) {
            groupData = groupData;
            $("#groupname").keyup(function (e) {
              if (e.which == 38 || e.which == 40 || e.which == 13) {
                return;
              } else {
                var groupname = $(this).val();
                //alert(groupname);
                if (groupname !== "") {
                  if (groupData.length > 0) {
                    console.log("----" + groupname);
                    $("#groupname").autocomplete({
                      minLength: 1,
                      source: function (request, response) {
                        var term = $.ui.autocomplete.escapeRegex(request.term),
                          startsWithMatcher = new RegExp("^" + term, "i"),
                          startsWith = $.grep(groupData, function (value) {
                            return startsWithMatcher.test(
                              value.value || value.label || value
                            );
                          }),
                          containsMatcher = new RegExp(term, "i"),
                          contains = $.grep(groupData, function (value) {
                            return (
                              $.inArray(value, startsWith) < 0 &&
                              containsMatcher.test(
                                value.value || value.label || value
                              )
                            );
                          });

                        response(startsWith.concat(contains));
                      },
                      select: function (event, ui) {
                        event.preventDefault();
                        $(this).val(ui.item.label);
                        $("#groupcode").val(ui.item.value);
                        $("#groupname").val(ui.item.label);
                      },
                    });
                  }
                }
              }
            });
          });
          ReportTypeArraySearch = ReportTypeArray;

          if (url.indexOf("PURCHASEFINISH_FRMReport") > -1) {
            document.getElementById("ReportType").value = "";
            document.getElementById("ReportATypeCode").value = "";
            document.getElementById("ReportSeriesTypeCode").value = "P2";
          } else if (url.indexOf("RETURNGOODS_FRMReport") > -1) {
            var TYPE = "P3";
            var seriesArray = getReportTypeArrayBySERIES(TYPE);
            if (seriesArray.length > 0) {
              document.getElementById("ReportType").value = seriesArray[0].label;
              document.getElementById("ReportATypeCode").value = seriesArray[0].value;
              document.getElementById("ReportSeriesTypeCode").value = TYPE;
            }
          } else if (url.indexOf("PURCHASE_FRMReport") > -1) {
            document.getElementById("ReportType").value = "PURCHASES (ALL)";
            document.getElementById("ReportATypeCode").value = "";
            document.getElementById("ReportSeriesTypeCode").value = "P";
          } else if (url.indexOf("PURCHASEOUTSTANDING_FRMReport") > -1) {
            document.getElementById("ReportType").value = "PURCHASES (ALL)";
            document.getElementById("ReportATypeCode").value = "";
            document.getElementById("ReportSeriesTypeCode").value = "P";
          } else if (url.indexOf("orderFormList_FRM") > -1) {
            document.getElementById("ReportType").value = "PENDING ORDER";
            document.getElementById("ReportATypeCode").value = "";
            document.getElementById("ReportSeriesTypeCode").value = "";
          } else if (url.indexOf("PCORDER_FRMReport") > -1) {
            document.getElementById("ReportType").value = "ORDER";
            document.getElementById("ReportATypeCode").value = "";
            document.getElementById("ReportSeriesTypeCode").value = "";
            ReportTypeArraySearch = ReportTypeArray.filter(function (d) {
              return d.DT.toUpperCase().trim() == "ZSO" || d.DT.toUpperCase().trim() == "ZPO";
            })
          } else if (url.indexOf("JOBWORK_FRMReport") > -1) {
            document.getElementById("ReportType").value = "JOBWORK";
            document.getElementById("ReportATypeCode").value = "";
            document.getElementById("ReportSeriesTypeCode").value = "";
            ReportTypeArraySearch = ReportTypeArray.filter(function (d) {
              return d.DT.toUpperCase().trim() == "DCJW";
            })
          } else if (url.indexOf("TDS_FRMReport") > -1) {
            document.getElementById("ReportType").value = "TDS";
            document.getElementById("ReportATypeCode").value = "";
            document.getElementById("ReportSeriesTypeCode").value = "";
          } else if (url.indexOf("OUTSTANDING_FRMReport") > -1 && FORM_TYPE.indexOf("PURCHASEOUTSTANDING") > -1) {
            var TYPE = "P";
            var seriesArray = getReportTypeArrayBySERIES(TYPE);
            if (seriesArray.length > 0) {
              document.getElementById("ReportType").value = seriesArray[0].label;
              document.getElementById("ReportATypeCode").value =
                seriesArray[0].value;
              document.getElementById("ReportSeriesTypeCode").value = TYPE;
              sundryDebitorsAtype = seriesArray[0].value;
              loadAtypeOninit(sundryDebitorsAtype);
            }
          } else {
            var TypeSearch = getUrlParams(url, "TypeSearch");

            try {
              var TYPE = TypeSearch != null && TypeSearch != "" ? TypeSearch : "S";
              var seriesArray = getReportTypeArrayBySERIES(TYPE);
              if (seriesArray.length > 0) {
                document.getElementById("ReportType").value = seriesArray[0].label;
                document.getElementById("ReportATypeCode").value =
                  seriesArray[0].value;
                document.getElementById("ReportSeriesTypeCode").value = TYPE;
                sundryDebitorsAtype = seriesArray[0].value;
                console.log("--------------" + sundryDebitorsAtype);
                loadAtypeOninit(sundryDebitorsAtype);
              }
            } catch (error) {
              console.log(error);
            }
          }

          $("#ReportType").keyup(function (e) {
            if (e.which == 38 || e.which == 40 || e.which == 13) {
              return;
            } else {
              var ReportType = $(this).val();
              //alert(ReportType);
              if (ReportType !== "") {
                console.log("----" + ReportType);
                $("#ReportType").autocomplete({
                  minLength: 1,
                  source: function (request, response) {
                    var term = $.ui.autocomplete.escapeRegex(request.term),
                      startsWithMatcher = new RegExp("^" + term, "i"),
                      startsWith = $.grep(ReportTypeArraySearch, function (value) {
                        return startsWithMatcher.test(
                          value.label || value.SERIESCODE || value
                        );
                      }),
                      containsMatcher = new RegExp(term, "i"),
                      contains = $.grep(ReportTypeArraySearch, function (value) {
                        return (
                          $.inArray(value, startsWith) < 0 &&
                          containsMatcher.test(
                            value.label || value.SERIESCODE || value
                          )
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
                    sundryDebitorsAtype = ui.item.value;
                    refreshAutoComplateVal();
                  },
                });
              }
            }
          });
          refreshAutoComplateVal();
        });
      });
    });
  });

  $("#city").keyup(function (e) {
    if (e.which == 38 || e.which == 40 || e.which == 13) {
      return;
    } else {
      var city = $(this).val();
      //alert(city);
      if (city != "") {
        console.log("--" + city);
        $("#city").autocomplete({
          minLength: 1,
          source: CITY_ARRAY,
          select: function (event, ui) {
            event.preventDefault();
            $(this).val(ui.item.label);
            $("#city").val(ui.item.label);
            try {
              loadItemSaleChartTable();//calling Item chart chart function
            } catch (error) {

            }
          }
        });
      }
    }
  });

  jsGetObjectByKey(DSN, "HASTE", "").then(function (data) {
    var hasteMainArray = data.map(function (data) {
      return {
        label: data.HS,
        AD: data.AD,
      };
    });
    hasteArray = hasteMainArray;
    $("#haste").keyup(function (e) {
      if (e.which == 38 || e.which == 40 || e.which == 13) {
        return;
      } else {
        var haste = $(this).val();
        //alert(haste);
        if (haste !== "") {
          console.log("----" + haste);
          $("#haste").autocomplete({
            minLength: 1,
            source: hasteArray,
          });
        }
      }
    });
    try {

      var godownArray = hasteMainArray.filter(function (d) {
        return d.AD.toString().toUpperCase().indexOf("GODOWN") > -1;
      });
      $("#godown").keyup(function (e) {
        if (e.which == 38 || e.which == 40 || e.which == 13) {
          return;
        } else {
          var godown = $(this).val();
          //alert(godown);
          if (godown !== "") {
            console.log("----" + godown);
            $("#godown").autocomplete({
              minLength: 1,
              source: godownArray,
            });
          }
        }
      });

    } catch (error) {
      noteError(error);
    }
  });


  jsGetObjectByKey(DSN, "TRANSPORT", "").then(function (t) {
    var transportArray = t;
    $("#transport").keyup(function (e) {
      if (e.which == 38 || e.which == 40 || e.which == 13) {
        return;
      } else {
        var transport = $(this).val();
        //alert(transport);
        if (transport != "") {
          console.log("----" + transport);
          $("#transport").autocomplete({
            minLength: 1,
            source: transportArray,
            select: function (event, ui) {
              event.preventDefault();
              $(this).val(ui.item.label);
              $("#transport").val(ui.item.label);
              $("#transportCode").val(ui.item.value);
            },
          },);
        }
      }
    });
  });
});

function setYearSelection() {
  try {
    var yearSelect = document.getElementById("YEAR");
    if (yearSelect) {
      yearSelect.innerHTML = "";
      var option = document.createElement("option");
      var Currentyeartext = (Currentyear.substring(0, 2)) + "-" + (Currentyear.substring(2, 4));

      option.value = (Currentyear).toString();
      option.text = (Currentyeartext).toString();
      yearSelect.appendChild(option);

      var option = document.createElement("option");
      var lastYear = (Currentyear.substring(0, 2) - 1) + "" + (Currentyear.substring(2, 4) - 1);
      var lastYearText = (Currentyear.substring(0, 2) - 1) + "-" + (Currentyear.substring(2, 4) - 1);
      option.value = (lastYear).toString();
      option.text = (lastYearText).toString();
      yearSelect.appendChild(option);
    }

  } catch (error) {

  }
}

function setDate() {
  if (
    url.indexOf("OUTSTANDING_FRMReport") > -1 ||
    url.indexOf("millstock_FRMReport") > -1 ||
    url.indexOf("bankPassBook_FRMReport") > -1 ||
    url.indexOf("PCSSTOCK_FRMReport") > -1 ||
    url.indexOf("JOBWORK_FRMReport") > -1 ||
    url.indexOf("TDS_FRMReport") > -1
  ) {
  } else {
    currentYearStartdate = "20" + Currentyear.substring(0, 2) + "-04-01";
    dateSetToInput("search_FromDate", currentYearStartdate);

    // var today = new Date();
    // var dd = String(today.getDate()).padStart(2, '0');
    // var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    // var yyyy = today.getFullYear();
    // today = yyyy + '-' + mm + '-' + dd;
    // dateSetToInput("search_ToDate", today);
  }
}
// function ReportTypeArraySearchFilter(){
//   var doc_type = $('#doc_type').val();
//   if(doc_type!=null && doc_type !=""){
//     ReportTypeArraySearch = ReportTypeArray.filter(function(d){
//       return d.DT.toUpperCase().trim()==doc_type;
//     })
//   }else{
//     ReportTypeArraySearch = ReportTypeArray;
//   }
// }
function setSearchToDate(id) {
  try {
    var yearEndDate = "20" + Currentyear.substring(2, 4) + "-03-31";
    var localTimeInMili = getUrlParams(url, "localTimeInMili");
    var todateNew = new Date(parseInt(localTimeInMili));
    var yearEndDateObj = new Date(yearEndDate);
    if (todateNew > yearEndDateObj) {
      todateNew = yearEndDateObj;
    }
    dateSetToInput(id, todateNew.toISOString());
  } catch (error) {

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
function renderAutocompleteSuggestions(input, term) {
  var autocompleteWidget = input.data("ui-autocomplete");
  autocompleteWidget._renderItemData = function (ul, item) {
    var text = item.label || item.value || item;
    var highlightedText = highlight(text, term);
    return $("<li style='border:1px solid black;'>").append(highlightedText).appendTo(ul);
  };
}
function highlight(text, term) {
  var regex = new RegExp(term, "gi");
  return text.replace(regex, function (match) {
    return "<span class='highlight'>" + match + "</span>";
  });
}

if (deviceIsIos == "true") {
  $('head').append('<meta name="viewport"content="width=device-width, initial-scale=.7, maximum-scale=100, user-scalable=no"/>');
}


