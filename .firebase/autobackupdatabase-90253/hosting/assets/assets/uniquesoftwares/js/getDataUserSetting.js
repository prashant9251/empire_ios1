
var BillDetSetting = getUrlParams(url, "BillDetSetting");

function getDataUserSetting(key) {
  var value = "";
  try {
    BillDetSetting = JSON.parse(BillDetSetting);
    if (BillDetSetting != null && BillDetSetting != "" && BillDetSetting != undefined) {
      if (BillDetSetting.length > 0) {
        value = BillDetSetting[0].BillDetSetting[0][key];
        if (value == undefined && value == null) {
          value = "";
        }
      }
    }
  } catch (error) {

  }
  return value;
}