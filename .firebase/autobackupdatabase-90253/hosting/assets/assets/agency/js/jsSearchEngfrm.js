$(document).ready(function() {
    onload(Crntyear);
  YearChange();
  lastUpdatedDate();
    $('#searchEng').keyup(function(e) {
      if (e.which == 38 || e.which == 40 || e.which == 13) {
        return;
      } else {
        var searchEng = $(this).val();
        //alert(searchEng);
        if (searchEng !== '') {
          if (masterData.length >0) {
            console.log("----" + searchEng);
            $("#searchEng").autocomplete({
              minLength: 1,
              source: function(request, response) {
                var term = $.ui.autocomplete.escapeRegex(request.term),
                  startsWithMatcher = new RegExp("^" + term, "i"),
                  startsWith = $.grep(masterData, function(value) {
                    return startsWithMatcher.test(value.partyname || value.label || value);
                  }),
                  containsMatcher = new RegExp(term, "i"),
                  contains = $.grep(masterData, function(value) {
                    return $.inArray(value, startsWith) < 0 &&
                      containsMatcher.test(value.partyname || value.label || value);
                  });

                response(startsWith.concat(contains));
              },
              select: function(event, ui) {
                event.preventDefault();
                $(this).val(ui.item.label);
                $("#searchEng").val(ui.item.value);
                $("#partycode").val(ui.item.value);
                $('#ATYPE').val(ui.item.ATYPE);
                $('#fulladdress').val(ui.item.label);
                $('#broker').val(ui.item.broker);
                $('#MOBILE').val(ui.item.MOBILE);
                SEARCHENG();
                $("#logocontainer").css("display", "none");
                return;
              }
            });
          }
        }
      }



    });
});
  
  
function SEARCHENG() {

    var VNO = $('#searchEng').val();
    if (Number.isInteger(VNO) == true) {
      VNO = $('#searchEng').val();
    } else {
      var partyname = $('#searchEng').val();
    }
    var year = $('#selectyear').val();
    var fulladdress = $('#fulladdress').val();
 
    var partycode = $('#partycode').val();
    var ATYPE = $('#ATYPE').val();
    var broker = $('#broker').val();
    var MOBILE = $('#MOBILE').val();
    if (ATYPE == 1) {
      $('#searchEngResult').html('<div class="container"> <div class="col-md-8"><p style="color:white;">' + fulladdress + ',' + MOBILE + '</p><a class="form-control" target="_blank" href="OUTSTANDING_AJXREPORT.php?ntab=NTAB&partycode=' + encodeURIComponent(partycode) + '&partyname=' + encodeURIComponent(partyname) + '&year=' + year + '">OUTSTANDING </a><br><a class="form-control" target="_blank" href="ALLSALE_AJXREPORT.php?ntab=NTAB&partycode=' + encodeURIComponent(partycode) + '&partyname=' + encodeURIComponent(partyname) + '">ALLSALE  </a><br><a class="form-control" target="_blank" href="LEDGER_AJXREPORT.php?ntab=NTAB&partycode=' + encodeURIComponent(partycode) + '&partyname=' + encodeURIComponent(partyname) + '&year=' + year + '">LEDGER   </a><br><a class="form-control" target="_blank" href="ITEMWISESALE_AJXREPORT.php?ntab=NTAB&partycode=' + encodeURIComponent(partycode) + '&partyname=' + encodeURIComponent(partyname) + '">ALL QUALITYS WISE SALE </a><br><a class="form-control" target="_blank" href="ALLSALE_AJXREPORT.php?ntab=NTAB&partycode=' + encodeURIComponent(partycode) + '&partyname=' + encodeURIComponent(partyname) + '&productDet=Y&year=' + year + '">BILL WISE ITEM SALE  </a></div><br>');
      $('#searchEngResult').append('<div class="container"> <div class="col-md-8"><p style="color:white;">EXTRA SUGGESTION</p><a class="form-control" target="_blank" href="OUTSTANDING_AJXREPORT.php?ntab=NTAB&broker=' + encodeURIComponent(broker) + '&year=' + year + '">OUTSTANDING OF ' + broker + ' </a><br><a class="form-control" target="_blank" href="ALLSALE_AJXREPORT.php?ntab=NTAB&broker=' + encodeURIComponent(broker) + '">ALLSALE OF ' + broker + '  </a><br></div>');

    }
    if (ATYPE == 12) {
      $('#searchEngResult').html('<div class="container"> <div class="col-md-8"><p style="color:white;">' + fulladdress + '</p><a class="form-control" target="_blank" href="OUTSTANDING_AJXREPORT.php?ntab=NTAB&broker=' + encodeURIComponent(partcode) + '&year=' + year + '">OUTSTANDING OF ' + partyname + ' </a><br><a class="form-control" target="_blank" href="ALLSALE_AJXREPORT.php?ntab=NTAB&broker=' + encodeURIComponent(partyname) + '">ALLSALE OF ' + partyname + '  </a><br></div>');
    }
    if (ATYPE == 101) {
      $('#searchEngResult').html('<div class="container"> <div class="col-md-8"><p style="color:white;">' + fulladdress + '</p><a class="form-control" target="_blank" href="findBill.php?ntab=NTAB&VNO=">OPEN FIND BILL</a><br></div>');
    }
    if (ATYPE == 102) {
      $('#searchEngResult').html('<div class="container"> <div class="col-md-8"><p style="color:white;">' + fulladdress + '</p><a class="form-control" target="_blank" href="millstock_FRMReport.php?ntab=NTAB&VNO=">OPEN MILL STOCK </a><br></div>');
    }
    if (ATYPE == 103) {
      $('#searchEngResult').html('<div class="container"> <div class="col-md-8"><p style="color:white;">' + fulladdress + '</p><a class="form-control" target="_blank" href="LEDGER_FRMReport.php?ntab=NTAB&VNO=">OPEN LEDGER</a><br></div>');
    }
    if (ATYPE == 14) {
      $('#searchEngResult').html('<div class="container"> <div class="col-md-8"><p style="color:white;">' + fulladdress + '</p><a class="form-control" target="_blank" href="millstock_AJXREPORT.php?ntab=NTAB&partycode=' + encodeURIComponent(partycode) + '&partyname=' + encodeURIComponent(partyname) + '&year=' + year + '">MILL STOCK OF ' + partyname + ' </a><br></div>');
    }
    if (VNO > 0) {
      $('#searchEngResult').html('<div class="container"> <div class="col-md-8"><br><a class="form-control" target="_blank" href="findBill.php?ntab=NTAB&VNO=' + encodeURIComponent(VNO) + '">OPEN BILL NO-' + VNO + '</a><br></div>');
    }

    $("#logocontainer").css("display", "none");
    // alert(ATYPE);
  }

  function formatDate(date) {
    if (date != '' && date != null) {        
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();
        hours = d.getHours();
      mint = d.getMinutes();
      var time = hours + " : "+mint;
    if (month.length < 2) 
        month = '0' + month; 
    if (day.length < 2) 
            day = '0' + day;       

    return [day, month, year,time].join('/');
    } else {
        return '';
}
}

  