// var my_awesome_script = document.createElement('script');
// my_awesome_script.setAttribute('src', './../jsPDF.js');
// document.head.appendChild(my_awesome_script);
var my_awesome_script = document.createElement('script');
my_awesome_script.setAttribute('src', 'https://unpkg.com/xlsx/dist/xlsx.full.min.js');
document.head.appendChild(my_awesome_script);
var kIsWeb = getUrlParams(url, "kIsWeb");
var excelJson = [];


var isAppReady = false;

try {
  window.addEventListener("flutterInAppWebViewPlatformReady", function (event) {
    isAppReady = true;
  });
} catch (error) {
}

function checkAppReady() {
  return kIsWeb.indexOf("true") > -1 || IosPlateForm == false ? true : isAppReady;
}


key = ["JOBCARD", "BILLREC", "GREY_ORDER", "TDS", "JOBWORK", "ATYPE", "CHALTRN", "FINISHSTOCK", "TIME", "TRANSPORT", "HASTE", "CITY", "ITEMWISESALE", "ACGROUP", "MILL", "OUTSTANDING", "LEDGER", "SERIES", "COMPMST", "QUL", "MST", "DET", "BLS",];
keyArrayInDatabase = ["JOBCARD", "PCORDER", "ACGROUP", "ATYPE", "JOBWORK", "BILLREC", "GREY_ORDER", "TDS", "ORDER", "CHALTRN", "FINISHSTOCK", "TIME", "TRANSPORT", "HASTE", "CITY", "ITEMWISESALE", "MILL", "OUTSTANDING", "PURCHASE", "LEDGER", "EMP", "FAS", "BLS", "SERIES", "COMPMST", "QUL", "PACKINGSTYLE", "MST", "DET", "settMill", "settOTG",];

var Currentyear = getUrlParams(url, "Currentyear");
var AppLocalStorage = getUrlParams(url, "AppLocalStorage") ?? "";
var CURRENT_YEAR = Currentyear;
var ClDb = getUrlParams(url, "CLDB");
var clnt = getUrlParams(url, "CLNT");
Curentyearforlocalstorage = getUrlParams(url, "Curentyearforlocalstorage");
var privateNetworkIp = getUrlParams(url, "privateNetworkIp");
var privateNetWorkSync = getUrlParams(url, "privateNetWorkSync");
var LFolder = getUrlParams(url, "LFolder");
var SyncType = getUrlParams(url, "SyncType");
var CUOTP = getUrlParams(url, "CUOTP");
var SHOPNAME = getUrlParams(url, "SHOPNAME");

function noteError(error) {
  $("body").append(
    error +
    "<br id='hideError'>Please Send This Error Msg ScreenShot to <a target='_blank'href='https://wa.me/?text=Error'></a>"
  );
  $("body").append(error.stack);
  $("body").append(error.onLine);
  $("#loader").removeClass("has-loader");
}



function downloadExcel() {
  var fileName = "";
  if (url.indexOf("OUTSTANDING_AJXREPORT.html") > -1) {
    fileName = "Outstanding Report";
    excelJson = getOutstandingExcelJson();
  } else if (url.indexOf("ALLSALE_AJXREPORT.html") > -1) {
    fileName = "BLS Report";
    excelJson = getBlsExcelJson();
  } else if (url.indexOf("PURCHASE_AJXREPORT.html") > -1) {
    fileName = "Purchase Report";
    excelJson = getPBlsExcelJson();
  } else if (url.indexOf("master.html") > -1) {
    fileName = "Master Report";
    excelJson = getMasterExcelJson();
  } else if (url.indexOf("LEDGER_AJXREPORT.html") > -1) {
    fileName = "Ledger Report";
    excelJson = getLEDGERExcelJson();
  } else if (url.indexOf("millstock_AJXREPORT.html") > -1) {
    fileName = "Mill Stock Report";
    excelJson = getMillStockExcelJson();
  }
  try {
    if (!excelJson || excelJson.length === 0) {
      alert("No data available to download.");
      return;
    }

    // Convert JSON to Worksheet
    const worksheet = XLSX.utils.json_to_sheet(excelJson);

    // Create a Workbook
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");

    // Convert to ArrayBuffer
    const excelBinary = XLSX.write(workbook, { bookType: "xlsx", type: "array" });
    const excelBlob = new Blob([excelBinary], { type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" });

    // Convert Blob to Base64
    const reader = new FileReader();
    reader.readAsDataURL(excelBlob);
    reader.onloadend = function () {
      const base64data = reader.result; // Base64 Data URL
      Android.downloadExcel(base64data, fileName);
    };

  } catch (error) {
    alert("Error downloading Excel: " + error.message);
  }
}


function stringHashCode(str) {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = (hash * 31 + str.charCodeAt(i)) | 0;
  }
  return hash;
}


function indexDbSave(Db, key, value) {
  return new Promise(function (resolve, reject) {
    var idb_request = window.indexedDB.open(Db, 1);

    idb_request.addEventListener("error", function (event) {
      console.log(
        "Could not open Indexed DB due to error: " +
        this.errorCode +
        " in " +
        key
      );
      reject("reject" + key);
    });

    idb_request.addEventListener("success", function (event) {
      var database = this.result;
      var transaction = database.transaction(key, "readwrite");

      transaction.onerror = function (event) {
        console.log("Transaction error:", event.target.error);
        reject("reject" + key);
      };

      var objectStore;
      if (!database.objectStoreNames.contains(key)) {
        objectStore = database.createObjectStore(key, { keyPath: 'id', autoIncrement: true });
      } else {
        objectStore = transaction.objectStore(key);
      }
      objectStore.put(JSON.parse(value)).addEventListener("success", function (event) {
        console.log(key);
        resolve(key);
      });
    });
  });
}


var Curentyearforlocalstorage;

function storedatatoIndexdb(Db, key, value) {
  return promise = new Promise(function (resolve, reject) {
    createDatabase(Db, keyArrayInDatabase).then(function (d) {
      var d = new Date();
      d.setTime(d.getTime() + (360 * 24 * 60 * 60 * 1000));
      var expires = "expires=" + d.toUTCString();


      var database, idb_request;

      idb_request = window.indexedDB.open(Db, 1);

      idb_request.addEventListener("error", function (event) {
        console.log("Could not open Indexed DB due to error: " + this.errorCode + " in " + key);
        reject("reject" + key);
      });

      idb_request.addEventListener("success", function (event) {
        database = this.result;
        var storage = database.transaction(key, "readwrite").objectStore(key);
        storage.get(key).addEventListener("success", function (event) {
          // var result = this.result;
          storage.put(JSON.parse(value), key);
          // alert(JSON.stringify(value));

          if (IosPlateForm == "true") {
            try {
              window.flutter_inappwebview.callHandler("SaveToLocal", Db + key, value).then(function (result) {
                resolve(key);
              },
                function (err) {
                  reject(key);
                }
              );
            } catch (error) { }
          } else {
            indexDbSave(Db, key, value).then(
              function (d) {
                resolve(key);
              },
              function (error) {
                reject(error);
              }
            );
          }
        });

        // alert("Successfully opened database!");
      });

    });
  });
}


//-----hide/unhide

var filename = url.substring(url.lastIndexOf("/") + 1);
toIndex = filename.indexOf(".html");
filename = filename.substring(0, toIndex);
var CurrentPageSett;
var tempSettings = [
  { view: true, key: "TYPE", id: "TYPE", Caption: "TYPE", cal: "" },
  { view: true, key: "FRM", id: "FRM", Caption: "FIRM", cal: "" },
  { view: true, key: "GROUP", id: "GROUP", Caption: "GROUP", cal: "" },
];

function viewVal(key) {
  return CurrentPageSett.filter(function (d) {
    return d.key == key;
  });
}

function closeViewSettings() {
  document.getElementById("viewSettings").style.display = "none";
}
function openSettingForm(sett) {
  var modelDiv = `<div id="viewSettings"style="overflow: auto;" class="modal">
                <div class="modal-content">
                <div class="modal-header baseColorApp">
                    <div style="display:flex;width:100%;">
                        <div style="width:50%">
                        <h2 id="mdlPartyName" style="margin-top: 0;">View Setting</h2>
                        <h5 style="color:red;">If do any changes regenerate report please</h5>
                        </div>
                        <div style="width:50%">
                        <span class="close" onclick="closeViewSettings();">&times;</span>
                        </div>
                    </div>
                    
                    
                </div>
                <div class="modal-body" align="center">
                <table style="padding:5px; font-size: 25px;"align="center">`;

  if (sett.length > 0) {
    var sr = 0;
    modelDiv += `
        <tr>
        <th>SR</th>
        <th>FIELD</th>
        <th></th>
        </tr>`;
    for (var i = 0; i < sett.length; i++) {
      var check = "";
      var savedSetting = viewVal(sett[i].key);
      if (savedSetting.length > 0) {
        if (savedSetting[0].view) {
          check = "checked";
        }
      } else {
        if (sett[i].view) {
          check = "checked";
        }
      }
      sr = i + 1;
      modelDiv +=
        ` <tr > <td>` + sr + `-&nbsp;</td>

        <td><input style="margin:15px;" type="checkbox" 
        onchange="settingSave('` +
        sett[i].id +
        `','` +
        sett[i].key +
        `','` +
        sett[i].Caption +
        `',this);
        "key="` +
        sett[i].key +
        `" Caption="` +
        sett[i].Caption +
        `" 
        id="` +
        sett[i].key +
        `" ` +
        check +
        `/>&nbsp
        </td>
        
        <td>` +
        sett[i].nodeName +
        `</td>
        </tr>  
         `;
    }
  } else {
    modelDiv += `
        <tr>
        <th>No Hide/Unhide Settings Available for this Module</th>
        </tr>`;
  }
  modelDiv += `
            </table>
            </div>
            <div class="modal-footer baseColorApp">
            <h3 onclick="closeViewSettings();">Close</h3>
            </div>
            </div>
            </div>`;
  $("body").append(modelDiv);
  // showhideUnhide();
}
function showhideUnhide() {
  try {
    var modal = document.getElementById("viewSettings");
    modal.style.display = "block";
  } catch (error) { }
}
function localStorageSave(id) {
  var val = $('#' + id).val();
  localStorage.setItem(id, val);
}

function hide() {
  try {
    if (CurrentPageSett.length > 0) {
      for (var j = 0; j < CurrentPageSett.length; j++) {
        if (CurrentPageSett[j].view) {
          $(".hide" + CurrentPageSett[j].key).css("display", "");
        } else {
          $(".hide" + CurrentPageSett[j].key).css("display", "none");
        }
      }
    }
  } catch (error) { }
}

var SettingByClass = [];
var SettingByClassFlag = [];
function hideList() {
  return new Promise(function (resolve, reject) {
    jsGetObjectByKey(DSN, "settOTG", "").then(function (data) {
      settings = data;
      CurrentPageSett = settings[filename];
      tempSettings = document.querySelectorAll("*[class]");
      for (var i = 0; i < tempSettings.length; i++) {
        if (
          tempSettings[i].className.indexOf("hide") > -1 &&
          tempSettings[i].className.indexOf("hideAbleTr") < 0 &&
          tempSettings[i].className.indexOf("unhideAbleTr") < 0
        ) {
          var obj = {};
          var key = tempSettings[i].className.replace("hide", "");
          if (key.indexOf(" ") > -1) {
            key = key.substring(0, key.indexOf(" "));
          }
          obj.key = key;
          obj.id = key;
          var className = tempSettings[i].className;
          if (className.indexOf(" ") > -1) {
            className = className.substring(0, className.indexOf(" "));
          }
          obj.class = className;
          obj.Caption = "";
          obj.nodeName = tempSettings[i].outerText;
          var display = tempSettings[i].style.display;
          obj.view = display !== "none";
          if (!SettingByClassFlag[key]) {
            SettingByClass.push(obj);
            SettingByClassFlag[key] = true;
          }
        }
      }
      if (settings[filename] == undefined || settings[filename] == null) {
        CurrentPageSett = SettingByClass;
        settings[filename] = CurrentPageSett;
        storedatatoIndexdb(DSN, "settOTG", JSON.stringify(settings)).then(
          function (data) { }
        );
      }
      openSettingForm(SettingByClass);
      hide();
      createTempFlutterPdf();
      resolve();
    }).catch(function (error) {
      reject(error);
    });
  });
}

function settingSave(id, key, caption, ele) {
  var found = false;
  for (var i = 0; i < CurrentPageSett.length; i++) {
    if (CurrentPageSett[i]["id"] == id) {
      CurrentPageSett[i]["key"] = key;
      CurrentPageSett[i]["Caption"] = caption;
      CurrentPageSett[i]["view"] = ele.checked;
      found = true;
    }
  }
  if (!found) {
    var obj = {};
    obj["id"] = id;
    obj["key"] = key;
    obj["Caption"] = caption;
    obj["view"] = ele.checked;
    CurrentPageSett.push(obj);
  }
  // console.table(CurrentPageSett);
  settings[filename] = CurrentPageSett;
  storedatatoIndexdb(DSN, "settOTG", JSON.stringify(settings)).then(function (
    data
  ) { });
  hide();
}

//-----hide/unhide

//-------userRequest
var userRequest = {};
userRequest.Musertoken = ClDb;
userRequest.clnt = clnt;
userRequest.CURRENT_YEAR = CURRENT_YEAR;
userRequest.CUOTP = CUOTP;
userRequest.mobileno_user = getUrlParams(url, "mobileno_user");
userRequest.emailadd = getUrlParams(url, "emailadd");
userRequest.DEVICEID = getUrlParams(url, "DEVICEID");
//-------userRequest

var Enavigator = navigator.onLine;

function getObjectFromIndexDbWeb(Db, key, subKey) {
  var databaseName = (Db + key).toLowerCase();
  var boxName = 'box';
  var keyName = (Db + key);
  return new Promise(function (resolve, reject) {
    var idb_request;
    idb_request = window.indexedDB.open(databaseName, 1);

    idb_request.addEventListener("error", function (event) {
      alert("Could not open Indexed DB due to error: " + event.target.errorCode);
      reject("Could not open Indexed DB due to error: " + event.target.errorCode);
    });

    idb_request.addEventListener("success", function (event) {
      var database = event.target.result;
      var transaction = database.transaction([boxName], "readwrite");
      var storage = transaction.objectStore(boxName);

      var request = storage.get(keyName);

      request.addEventListener("success", function (event) {
        var result = event.target.result;
        arrayBuffer = result;
        if (arrayBuffer) {
          let uint8Array = new Uint8Array(arrayBuffer);
          let textDecoder = new TextDecoder('utf-8');
          // let jsonString = textDecoder.decode(uint8Array);

          // console.log(jsonString);
          // let jsonObject = JSON.parse(jsonString);

          // result = (jsonObject);
        } else {
          result = {};
        }
        // Perform any data manipulation as needed

        resolve(result);
      });

      request.addEventListener("error", function (event) {
        alert("Error while retrieving data:", event.target.error);
        reject("Error while retrieving data: " + event.target.error);
      });
    });

    idb_request.addEventListener("upgradeneeded", function (event) {
      // Handle database version upgrade if needed
    });
  });
}


function getObjectFromIndexDb(Db, key, subKey) {
  return new Promise(function (resolve, reject) {
    var idb_request;
    idb_request = window.indexedDB.open(Db, 1);

    idb_request.addEventListener("error", function (event) {
      alert("Could not open Indexed DB due to error: " + event.target.errorCode);
      reject("Could not open Indexed DB due to error: " + event.target.errorCode);
    });

    idb_request.addEventListener("success", function (event) {
      var database = event.target.result;
      var transaction = database.transaction([key], "readonly");
      var storage = transaction.objectStore(key);

      var request = storage.get(key);

      request.addEventListener("success", function (event) {
        var result = event.target.result;
        if (kIsWeb.indexOf("true") > -1) {
          arrayBuffer = result;
          if (arrayBuffer) {
            let uint8Array = new Uint8Array(arrayBuffer);
            let jsonString = new TextDecoder().decode(uint8Array);
            let jsonObject = JSON.parse(jsonString);

            result = (jsonObject);
          } else {
            result = {};
          }
        }
        // Perform any data manipulation as needed
        if (key === "settOTG") {
          try {
            if (result === undefined || (result.cod && result.cod === "WVR")) {
              result = {};
            }
          } catch (error) {
            alert("Error while manipulating data:", error);
          }
        } else if (key === "EMP") {
          if (!result || result.length === 0) {
            result = {};
          }
        }
        resolve(result);
      });

      request.addEventListener("error", function (event) {
        alert("Error while retrieving data:", event.target.error);
        reject("Error while retrieving data: " + event.target.error);
      });
    });

    idb_request.addEventListener("upgradeneeded", function (event) {
      // Handle database version upgrade if needed
    });
  });
}


// function getObjectFromIndexDb(Db, key, subKey) {
//   return new Promise(function (resolve, reject) {
//     var idb_request;
//     idb_request = window.indexedDB.open(Db, 1);

//     idb_request.addEventListener("error", function (event) {
//       alert("Could not open Indexed DB due to error: " + event.target.errorCode);
//       reject("Could not open Indexed DB due to error: " + event.target.errorCode);
//     });

//     idb_request.addEventListener("success", function (event) {
//       var database = event.target.result;
//       var transaction = database.transaction([key], "readonly");
//       var storage = transaction.objectStore(key);

//       var request = storage.get(subKey);

//       request.addEventListener("success", function (event) {
//         var result = event.target.result;

//         // Perform any data manipulation as needed
//         if (key === "settOTG") {
//           try {
//             if (result === undefined || (result.cod && result.cod === "WVR")) {
//               result = {};
//             }
//           } catch (error) {
//             console.error("Error while manipulating data:", error);
//           }
//         } else if (key === "EMP") {
//           if (!result || result.length === 0) {
//             result = {};
//           }
//         }
//         resolve(result);
//       });

//       request.addEventListener("error", function (event) {
//         console.error("Error while retrieving data:", event.target.error);
//         reject("Error while retrieving data: " + event.target.error);
//       });
//     });

//     idb_request.addEventListener("upgradeneeded", function (event) {
//       // Handle database version upgrade if needed
//     });
//   });
// }
function getObjectFromLive(Db, key, subKey) {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    const apiUrl = "http://192.168.29.93:8098//TRADING/uniqLive/" + key + ".php?"; // Replace with your actual API endpoint
    xhr.open("POST", apiUrl, true);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          const responseJson = JSON.parse(xhr.responseText);
          alert(xhr.responseText);
          resolve(responseJson);
        } else {
          reject(new Error(`HTTP error! Status: {xhr.status}`));
        }
      }
    };

    var AllUrlString = getAllUrlPrms();
    const requestBody = JSON.stringify(AllUrlString);
    xhr.send(requestBody);
  });
}

function jsGetObjectByKey(Db, key, subKey) {
  var newPromise = new Promise(function (resolve, reject) {
    createDatabase(Db, keyArrayInDatabase).then(function (d) {
      var idb_request;
      var data;
      var result;
      var resultInJson = [];
      if (AppLocalStorage.toString().toUpperCase() != "INDEXDB") {
        getObjectFromLive(Db, key, subKey).then(
          function (d) {
            resultInJson = d;
            resolve(resultInJson);
          },
          function (error) {
            reject(error);
          }
        );
      } else if (IosPlateForm == "true") {
        try {
          window.flutter_inappwebview.callHandler("GetFromLocal", Db + key).then(
            function (result) {
              // var Jsonresult = JSON.parse(result);
              resolve(result);
            },
            function (err) {
              var Jsonresult = JSON.parse(err);
              reject(Jsonresult);
            }
          );
        } catch (error) {
          console.log(error);
        }
      } else if (kIsWeb.indexOf("true") > -1) {
        try {
          window.flutter_inappwebview.callHandler("GetFromLocal", Db + key).then(
            function (result) {
              // var Jsonresult = JSON.parse(result);
              resolve(result);
            },
            function (err) {
              var Jsonresult = JSON.parse(err);
              reject(Jsonresult);
            }
          );
        } catch (error) {
          console.log(error);
        }

      } else {
        getObjectFromIndexDb(Db, key, subKey).then(
          function (d) {
            resultInJson = d;
            resolve(resultInJson);
          },
          function (error) {
            reject(error);
          }
        );
      }
    }, function (error) {
      console.log(error);
      // reject(error);
    });
  });
  return newPromise.then(function (result) {
    if (key == "settOTG") {
      try {
        if (result.length == 0) {
          result = {};
        } else if (result[0].cod != undefined) {
          if (result[0].cod == "WVR") {
            result = {};
          }
        }
      } catch (error) {

      }
      storedatatoIndexdb(DSN, key, JSON.stringify(result)).then(function (data) { });
    }
    return result
  })
}


function getBoxData(Db, key, subKey) {
  return new Promise(function (resolve, reject) {
    try {

      window.flutter_inappwebview.callHandler("getBoxData", Db, key)
        .then(function (result) {
          resolve(result);
        })
        .catch(function (err) {
          // Handle error
          // var JsonResult = JSON.parse(err);
          reject([]);
        });
    } catch (error) {
      resolve([]);
    }
  });
}
var newDate = new Date();
function getDataFromServer(key) {
  return new Promise(function (resolve, reject) {
    userRequest.key = key;
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
      if (this.readyState == 4 && this.status == 200) {
        d = this.responseText;
        resolve(d);
      }
    };
    var URLKEY = "http://aashaimpex.com/oprate/EMPIRE TRADING/" + key + ".php";
    xhttp.open("POST", URLKEY, true);
    xhttp.onerror = function () { };
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send(JSON.stringify(userRequest));
  });
}

// getliveData()
firebaseDirpath =
  "forUnique" + "/" + atob(ClDb) + "/" + ClDb + "/" + Currentyear + "/";
function getliveData(key, Data) {
  path = firebaseDirpath + key;
  return new Promise(function (resolve, reject) {
    firebase
      .database()
      .ref(path)
      .on(
        "value",
        (snapshot) => {
          const data = snapshot.val();
          resolve(data);
        },
        function (error) {
          reject("Error: " + error.code);
        }
      );
  });
}

function selectBoxReport() {
  try {
    $(".selectBoxReport").css("display", "");
    $(".pdfBtnHide").css("display", "none");

    document.getElementById("footer").style.display = "";
  } catch (error) { }

  try {
    rightDrawerAdd();
  } catch (error) {

  }
}

function hideselectBoxReport() {
  try {
    $(".selectBoxReport").css("display", "none");
    $(".pdfBtnHide").css("display", "");

    document.getElementById("footer").style.display = "none";
  } catch (error) {
    alert(error);
  }
  try {
    document.getElementById("rightDrawer").style.display = "none";
  } catch (error) {

  }
}

//---------------call save system

function getContactDetails(mobileNo) {
  mobileNo = mobileNo.toString();
  try {
    var contactDetils = getPartyDetailsByMobileNo(mobileNo);
    if (contactDetils.length > 0) {
      var displayname = getValueNotDefine(contactDetils[0].partyname);
      var email = getValueNotDefine(contactDetils[0].EML);
      var mobileNo = getValueNotDefine(contactDetils[0].MO);
      var city = getValueNotDefine(contactDetils[0].city);
      var ph1 = getValueNotDefine(contactDetils[0].PH1);
      var ph2 = getValueNotDefine(contactDetils[0].PH2);
      var company = getValueNotDefine(contactDetils[0].partyname);
      var jobTitle = "BUSINESS";
      displayname += " ," + city;
      Android.SaveContact(
        displayname,
        mobileNo,
        ph1,
        ph2,
        email,
        company,
        jobTitle
      );
    } else {
      Android.SaveContact("", mobileNo, "", "", "", "", "");
    }
  } catch (error) { }
}

function getPartyDetailsByMobileNo(mobileNoSearch) {
  try {
    var retVal = masterData.filter(function (data) {
      return (
        data.MO == mobileNoSearch ||
        data.PH1 == mobileNoSearch ||
        data.PH2 == mobileNoSearch
      );
    });
  } catch (error) {
    retVal = [];
  }
  return retVal;
}

//---------------call save system

function getValueNotDefine(value) {
  var Rvalue;
  if (value == "undefined" || value == null) {
    Rvalue = "";
  } else {
    Rvalue = value;
  }
  return Rvalue;
}

function createDatabase(Db, key) {
  return new Promise(function (resolve, reject) {
    var idb_request;

    if (!("indexedDB" in window)) {
      alert("Error: This browser doesn't support IndexedDB");
      reject("IndexedDB not supported");
      return;
    }

    idb_request = window.indexedDB.open(Db, 1);

    idb_request.addEventListener("error", function (event) {
      var errorMessage = "Error: Could not open " + Db + " database due to error: ";
      if (this.error && this.error.message) {
        errorMessage += this.error.message;
      } else {
        errorMessage += "unknown error";
      }
      alert(errorMessage);
      reject(errorMessage);
    });

    idb_request.addEventListener("upgradeneeded", function (event) {
      for (var i = 0; i < key.length; i++) {
        var storage = this.result.createObjectStore(key[i], {
          autoIncrement: true,
        });

        var initializeMaster;
        if (key[i] == "ORDER" || key[i] == "JOBWORK") {
          initializeMaster = [];
        } else if (key[i] == "settMill") {
          initializeMaster = [];
        } else {
          initializeMaster = [];
        }
        storage.add(initializeMaster, key[i]);
        document.cookie =
          key[i] +
          "_CREATETIME=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
      }
    });
    idb_request.addEventListener("success", function (event) {
      resolve(true);
    });
  });
}


function dialNo(mo) {
  if (IosPlateForm == "true") {
    try {
      window.flutter_inappwebview.callHandler("dialNo", mo).then(function (result) {
        // alert(text);
        // resolve(key);
      },
        function (err) {
          // reject(key);
        }
      );
    } catch (error) { }
  } else {
    try {
      Android.dialNo(mo);

    } catch (error) {

    }
  }
}


function getSharedprefVal(key) {
  return new Promise(function (resolve, reject) {
    if (IosPlateForm == "true") {
      try {
        window.flutter_inappwebview.callHandler("getSharedprefVal", key).then(function (result) {
          // alert(text);
          resolve(key);
        },
          function (err) {
            // reject(key);
            reject("");
          }
        );
      } catch (error) { }
    } else {
      try {
        Android.getSharedprefVal(key);
      } catch (error) {
        // alert(error);
      }
    }
  });
}


function saveSharedprefVal(key, val) {
  if (IosPlateForm == "true") {
    try {
      window.flutter_inappwebview.callHandler("saveSharedprefVal", key, val).then(function (result) {
        // alert(text);
        // resolve(key);
      },
        function (err) {
          // reject(key);
        }
      );
    } catch (error) { }
  } else {
    try {
      Android.saveSharedprefVal(key, val);
    } catch (error) {
      // alert(error);
    }
  }
}


//----shareTextFultter
function shareTextToFlutterApp(text, mo) {
  if (IosPlateForm == "true") {
    try {
      window.flutter_inappwebview.callHandler("shareText", text, mo).then(function (result) {
        // alert(text);
        // resolve(key);
      },
        function (err) {
          // reject(key);
        }
      );
    } catch (error) { }
  } else {
    try {
      Android.shareText(text, mo);
    } catch (error) {

    }
  }
}

//----getHiveMainBoxValByKey
function getHiveMainBoxValByKey(key) {
  try {
    window.flutter_inappwebview.callHandler("getHiveMainBoxValByKey", key).then(function (result) {
      // alert(text);
      // resolve(key);
      return result;
    },
      function (err) {
        // reject(key);
        return null;
      }
    );
  } catch (error) {
    return null;
  }
}

//----setHiveMainBoxValByKey
function setHiveMainBoxValByKey(key, val) {
  try {
    window.flutter_inappwebview.callHandler("setHiveMainBoxValByKey", key, val).then(function (result) {
      // alert(text);
      // resolve(key);
    },
      function (err) {
        // reject(key);
      }
    );
  } catch (error) { }
}

//----dialCallFultter

//----getExtraProductImageFileFultter
function getExtraProductImageFile(list) {
  try {
    window.flutter_inappwebview.callHandler("getExtraProductImageFile", list).then(function (result) {
      // alert(text);
      // resolve(key);
    },
      function (err) {
        // reject(key);
      }
    );
  } catch (error) { }
}


function getCurrentUser() {
  var newPromise = new Promise(function (resolve, reject) {
    window.flutter_inappwebview.callHandler("getCurrentUserFromFlutter").then(
      function (result) {
        var Jsonresult = (result);
        resolve(Jsonresult);
      },
      function (err) {
        var Jsonresult = (err);
        reject(Jsonresult);
      }
    );
  });
  return newPromise;
}


function getLastUpdatedDate() {
  var newPromise = new Promise(function (resolve, reject) {
    window.flutter_inappwebview.callHandler("getLastUpdatedDate").then(
      function (result) {
        var Jsonresult = (result);
        alert(Jsonresult);
        resolve(Jsonresult);
      },
      function (err) {
        var Jsonresult = (err);
        reject(Jsonresult);
      }
    );
  });
  return newPromise;
}

function showtoast(msg) {
  try {
    window.flutter_inappwebview.callHandler("showtoast", msg).then(function (result) { },
      function (err) {
      }
    );
  } catch (error) {
    // alert(error);
  }
}


function getUpiLink() {
  var newPromise = new Promise(function (resolve, reject) {
    getCurrentUser().then(function (d) {
      var upi = d["upi"];
      resolve(upi);
    },
      function (err) {
        resolve("{}");
      })
  })
  return newPromise;
}


//----tempPdfCreate
function createTempFlutterPdf() {
  try {
    window.flutter_inappwebview.callHandler("createTempFlutterPdf", "").then(function (result) {
      // alert(text);
      // resolve(key);
    },
      function (err) {
        // reject(key);
      }
    );
  } catch (error) {
    // alert(error);
  }
}

//----openComplainRegistration
function openComplainRegistration() {
  try {
    window.flutter_inappwebview.callHandler("openComplainRegistration", "").then(function (result) {
      // alert(text);
      // resolve(key);
    },
      function (err) {
        // reject(key);
      }
    );
  } catch (error) {
    // alert(error);
  }
}

//----CreateOrderFormHtmlToPdf
function CreateOrderFormHtmlToPdf(div) {
  try {
    window.flutter_inappwebview.callHandler("CreateOrderFormHtmlToPdf", div).then(function (result) {
      // alert(text);
      // resolve(key);
    },
      function (err) {
        // reject(key);
      }
    );
  } catch (error) {
    // alert(error);
  }
}


//----CreateOrderFormHtmlToPdf
function bulkPdfStartCreateShare(list) {
  if (IosPlateForm == "true") {
    try {
      window.flutter_inappwebview.callHandler("bulkPdfStartCreateShare", list).then(function (result) {
        // resolve(key);
      },
        function (err) {
          // reject(key);
        }
      );
    } catch (error) {
      // alert(error);
    }
  } else {
    try {
      Android.bulkPdfStartCreateShare(JSON.stringify(list));
      alert("Please go back and wait for pdf creation");
      Android.closeWebView();
    } catch (error) {

    }
  }
}
//----CreateOrderFormHtmlToPdf
function directPdfCreateOnLoad() {
  try {
    window.flutter_inappwebview.callHandler("directPdfCreateOnLoad", "").then(function (result) {
    },
      function (err) {
        alert(err);
      }
    );
  } catch (error) {
    console.log(error.stack);
  }
}
//----viewImageByLink
function viewImageByLink(url) {
  try {
    window.flutter_inappwebview.callHandler("viewImageByLink", url).then(function (result) {
      // alert(text);
    },
      function (err) {
      }
    );
  } catch (error) {
    // alert(error);
  }
}
//----viewImageByLink
function sendShareTextToApp(msg, MO) {
  if (IosPlateForm == "true") {
    try {
      window.flutter_inappwebview.callHandler("sendShareTextToApp", msg, MO).then(function (result) {
        // alert(text);
        // resolve(key);
      },
        function (err) {
          // reject(key);
        }
      );
    } catch (error) {
      // alert(error);
    }
  } else {
    try {
      Android.sendShareTextToApp(msg, MO)
    } catch (error) {

    }
  }
}
//----syncDatabyFlutter
function syncDatabyFlutter() {
  try {
    window.flutter_inappwebview.callHandler("syncDatabyFlutter", "").then(function (result) {
      // alert(text);
      // resolve(key);
    },
      function (err) {
        // reject(key);
      }
    );
  } catch (error) {
    // alert(error);
  }
}



function createPdf() {
  var doc = new jsPDF();
  var html = document.querySelector('body');
  doc.fromHTML(html, 15, 15, { width: 170 },
    function () {
      var blob = doc.output('blob');
      var reader = new FileReader();
      reader.readAsDataURL(blob);
      reader.onloadend = function () {
        var base64data = reader.result;
        console.log(base64data);
        try {
          window.flutter_inappwebview.callHandler("pdfConvertFromApp", base64data).then(function (result) {
            // alert(text);
          },
            function (err) {
            }
          );
        } catch (error) { }
      }

    });
  //  doc.save("output.pdf");
}
function makePdfStart() {
  var html = document.querySelector('body');
  var opt = {
    margin: 0,
    filename: 'myfile.pdf',
    image: { type: 'jpeg', quality: 1 },
    html2canvas: { scale: 2 },
    jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
  };
  html2pdf()
    .set(opt)
    .from(html)
    .save();
}


function exportTableToExcel(tableId, filename) {
  var table = document.getElementById(tableId);
  var rows = table.getElementsByTagName("tr");
  var data = [];

  for (var i = 0; i < rows.length; i++) {
    var row = rows[i];
    var rowData = [];
    var cells = row.getElementsByTagName("td");

    for (var j = 0; j < cells.length; j++) {
      rowData.push(cells[j].innerText);
    }

    data.push(rowData);
  }

  var workbook = XLSX.utils.book_new();
  var worksheet = XLSX.utils.aoa_to_sheet(data);
  XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet 1");
  var excelBuffer = XLSX.write(workbook, { bookType: "xlsx", type: "array" });
  var blob = new Blob([excelBuffer], { type: "application/octet-stream" });
  var link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = filename;
  link.click();
}

function getMimeType(fileName) {
  const extension = fileName.split('.').pop().toLowerCase();
  return extension;
}


//---top to bottom & bottom to top system
// Show/hide sticky buttons on scroll

var topbottomBtn = `
  <div style="position: fixed;
      bottom: 20px;
      left: 20px;
      display: flex;
      flex-direction: column;
      gap: 10px;
      z-index: 1000;" class="stickybuttonsTopBottom displayNone" >
    <button style=" background-color: #4CAF50;
      color: white;
      border: none;
      padding: 10px;
      text-align: center;
      text-decoration: none;
      display: inline-block;
      font-size: 16px;
      cursor: pointer;
      border-radius: 5px;" onclick="window.scrollTo({ top: 0, behavior: 'smooth' });">Go to Top</button>
    <button style=" background-color: #4CAF50;
      color: white;
      border: none;
      padding: 10px;
      text-align: center;
      text-decoration: none;
      display: inline-block;
      font-size: 16px;
      cursor: pointer;
      border-radius: 5px;"  onclick="window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });">Go to Bottom</button>
  </div>`;
$('body').append(topbottomBtn);
document.addEventListener('scroll', function () {
  var scrollPosition = window.scrollY;
  var stickyButtons = document.querySelector('.stickybuttonsTopBottom');
  if (scrollPosition > 100) { // Adjust the value as needed
    stickyButtons.style.display = 'flex';
    stickyButtons.style.opacity = 1;
    // Set a timeout to hide the buttons after 2 seconds
    setTimeout(function () {
      stickyButtons.style.opacity = 0;
      stickyButtons.style.display = 'none';
    }, 2000);
  } else {
    try {
      stickyButtons.style.opacity = 0;
      stickyButtons.style.display = 'none';
    } catch (error) {

    }
  }
});

$(document).ready(function () {
  try {
    var stickyButtons = document.querySelector('.stickybuttonsTopBottom');
    setTimeout(function () {
      try {
        stickyButtons.style.opacity = 0;
        stickyButtons.style.display = 'none';

      } catch (error) {

      }
    }, 1000);
  } catch (error) {

  }
});
//---top to bottom & bottom to top system


function getHtmlFromWebview() {
  var div = "";
  const tables = document.getElementsByTagName("table");
  for (let i = 0; i < tables.length; i++) {
    div += (tables[i].outerHTML);
  }
  // alert(div);
  return div;
}
if (clnt != "111") {
}