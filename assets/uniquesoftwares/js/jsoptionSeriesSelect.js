var series=[];
function SelectTypeOptions(onId, SelectSeries) {
  jsGetObjectByKey(DSN, "SERIES", "").then(function (data) {
    series = data;
    series=series.sort(function(a,b){
      if(a.SERIES > b.SERIES) { return -1; }
    if(a.SERIES <b.SERIES) { return 1; }
    return 0;
    })
    var xfirm = document.getElementById(onId);
    if (series.length > 0) {
      series.forEach(function(element, index) {
        var option = document.createElement("option");
        option.value = element.SERIESCODE;
        option.text = element.SERIES;
        xfirm.add(option, xfirm[0]);
        //  alert(element.FIRM);
      });
      
    }
    SelectSeries(onId);
  })
} 
function SelectSeries(onId) {
  try {
    
  var FIND_BILL_TYPE = getUrlParams(url, "MTYPE");
    var MSERIES = series.filter(function (data) {
      // console.log(data.SERIESCODE);
      return data.SERIESCODE == FIND_BILL_TYPE; 
    });
    if(MSERIES.length>0){
      document.getElementById(onId).value = MSERIES[0]['SERIESCODE'];   
    }
  } catch (error) {
  }
}


