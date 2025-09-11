
key = ["PBLS", "BILLREC", "ACGROUP", "BLS", "COMM", "ATYPE", "CITY", "OUTSTANDING", "LEDGER", "SERIES", "COMPMST", "QUL", "MST", "DET", "TIME"];
keyArrayInDatabase = ["ACGROUP", "BILLREC", "PBLS", "COMM", "ATYPE", "ORDER", "CHALTRN", "FINISHSTOCK", "TIME", "HASTE", "CITY", "ITEMWISESALE", "MILL", "OUTSTANDING", "PURCHASE", "LEDGER", "EMP", "FAS", "BLS", "SERIES", "COMPMST", "QUL", "PACKINGSTYLE", "MST", "DET", "settMill", "settOTG"];

var Currentyear = getUrlParams(url, "Currentyear");
var AppLocalStorage = getUrlParams(url, "AppLocalStorage");
var CURRENT_YEAR = Currentyear;
var ClDb = getUrlParams(url, "CLDB");
var clnt = getUrlParams(url, "CLNT");
// console.log(clnt);
Curentyearforlocalstorage = getUrlParams(url, "Curentyearforlocalstorage");
var privateNetworkIp = getUrlParams(url, "privateNetworkIp");
var privateNetWorkSync = getUrlParams(url, "privateNetWorkSync");
var LFolder = getUrlParams(url, "LFolder");
var SyncType = getUrlParams(url, "SyncType");
var CUOTP = getUrlParams(url, "CUOTP");

function noteError(error) {
  $("body").append(
    error +
    "<br>Please Send This Error Msg ScreenShot to <a target='_blank'href='https://wa.me/?text=Error'></a>"
  );
  $("body").append(error.stack);
  $("body").append(error.onLine);
  // console.log(error.onLine);
  $("#loader").removeClass("has-loader");
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
        // console.log(database.objectStoreNames.contains(key));
        storage.get(key).addEventListener("success", function (event) {
          // var result = this.result;
          storage.put(JSON.parse(value), key);
          // console.log(key, JSON.parse(value));
          // alert(JSON.stringify(value));
          if (Db.indexOf(Curentyearforlocalstorage) > -1) {
            if (key == 'SERIES') {
              localStorage.setItem(key, (value));
            }
            if (key == 'COMPMST') {
              localStorage.setItem(key, (value));
            }
            if (key == 'TIME') {
              localStorage.setItem(key, (value));
            }

            if (key == 'BLS') {
              try {
                saleTotalCalculat(JSON.parse(value));
              } catch (error) {

              }
            }
            if (key == 'OUTSTANDING') {
              try {
                OutstandingTotalCalculat(JSON.parse(value));
              } catch (error) {

              }
            }
          }
          if (IosPlateForm == "true") {
            // console.log(IosPlateForm);
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
  return promise.then(function (result) {
    return result;
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
        `        <tr >        <td>` +
        sr +
        `-</td>
        <td><input style="margin:15px;"  type="checkbox" 
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
        `/>&nbsp</td>
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
  // console.log(modelDiv);
  $("body").append(modelDiv);
  // showhideUnhide();
}
function showhideUnhide() {
  try {
    var modal = document.getElementById("viewSettings");
    modal.style.display = "block";
  } catch (error) { }
}

function hide() {
  try {
    if (CurrentPageSett.length > 0) {
      for (var j = 0; j < CurrentPageSett.length; j++) {
        // console.log(CurrentPageSett[j].key);
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
  jsGetObjectByKey(DSN, "settOTG", "").then(function (data) {
    settings = data;
    CurrentPageSett = settings[filename];
    tempSettings = document.querySelectorAll("*[class]");
    // console.log(tempSettings);
    for (var i = 0; i < tempSettings.length; i++) {
      if (
        tempSettings[i].className.indexOf("hide") > -1 &&
        tempSettings[i].className.indexOf("hideAbleTr") < 0 &&
        tempSettings[i].className.indexOf("unhideAbleTr") < 0
      ) {
        // console.log(tempSettings[i].nodeName)
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
        if (display == "none") {
          obj.view = false;
        } else {
          obj.view = true;
        }
        if (!SettingByClassFlag[key]) {
          SettingByClass.push(obj);
          SettingByClassFlag[key] = true;
        }
      }
    }
    // console.table(SettingByClass)
    if (settings[filename] == undefined || settings[filename] == null) {
      CurrentPageSett = SettingByClass;
      settings[filename] = CurrentPageSett;
      // console.log(CurrentPageSett);

      // console.log(settings[filename], settings);
      storedatatoIndexdb(DSN, "settOTG", JSON.stringify(settings)).then(
        function (data) { }
      );
    }
    // storedatatoIndexdb(DSN, "settOTG", JSON.stringify([])).then(function (data) {
    // })
    openSettingForm(SettingByClass);
    hide();
    createTempFlutterPdf();
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

// console.log(SyncType);
// console.log("--ONLINE--" + navigator.onLine);
var Enavigator = navigator.onLine;

function getObjectFromIndexDb(Db, key, subKey) {
  return new Promise(function (resolve, reject) {
    var idb_request;
    var data;
    idb_request = window.indexedDB.open(Db, 1);
    idb_request.addEventListener("error", function (event) {
      alert("Could not open Indexed DB due to error: " + this.errorCode);
      reject("Could not open Indexed DB due to error: " + this.errorCode);
    });
    idb_request.addEventListener("success", function (event) {
      var database = this.result;
      var storage = database.transaction(key, "readwrite").objectStore(key);
      // console.log(database.objectStoreNames.contains(key));
      storage.get(key).addEventListener("success", function (event) {
        var result = this.result;
        if (key == "settOTG") {
          try {
            if (result.length == 0) {
              result = {};
            } else if (result[0].cod != undefined) {
              if (result[0].cod == "WVR") {
                result = {};
              }
            }
          } catch (error) { }
          storedatatoIndexdb(DSN, key, JSON.stringify(result)).then(function (
            data
          ) { });
        }
        if (key == "EMP") {
          if (result.length == 0) {
            result = {};
            storedatatoIndexdb(DSN, key, JSON.stringify(result)).then(function (
              data
            ) { });
          }
        }
        resolve(result);
      });
    });
  });
}

function jsGetObjectByKey(Db, key, subKey) {
  var newPromise = new Promise(function (resolve, reject) {
    createDatabase(Db, keyArrayInDatabase).then(function (d) {
      var idb_request;
      var data;
      var result;
      var resultInJson = [];

      if (IosPlateForm == "true") {

        try {

          window.flutter_inappwebview.callHandler("GetFromLocal", Db + key).then(
            function (result) {
              // var Jsonresult = JSON.parse(result);
              // console.log("-=-=-=-=-=-=-="+result)
              resolve(result);
            },
            function (err) {
              var Jsonresult = JSON.parse(err);
              reject(Jsonresult);
            }
          );
        } catch (error) {

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
    // console.log(result, key);
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
    if (key == "EMP") {
      if (result.length == 0) {
        result = {};
        storedatatoIndexdb(DSN, key, JSON.stringify(result)).then(function (data) {
        })
      }
    }
    return result
  })
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
    // console.log(userRequest);
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
          // console.log(data);
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
}

function hideselectBoxReport() {
  try {
    $(".selectBoxReport").css("display", "none");
    $(".pdfBtnHide").css("display", "");

    document.getElementById("footer").style.display = "none";
  } catch (error) { }
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
    var database, idb_request;
    if (!("indexedDB" in window)) {
      alert("Error This browser doesn't support IndexedDB");
      return;
    }
    var initializeMaster = {
      value: "",
      label: "",
      partyname: "",
      city: "",
      broker: "",
      ATYPE: "",
    };
    var temparrayMillSetting = [
      {
        nm: "WEAVER",
        cod: "WVR",
        val: "0",
      }
    ];
    idb_request = window.indexedDB.open(Db, 1);

    idb_request.addEventListener("error", function (event) {
      alert(
        "Error Could not open " +
        Db +
        " databases due to error: " +
        this.errorCode
      );
      reject(false);
    });

    idb_request.addEventListener("upgradeneeded", function (event) {
      for (var i = 0; i < key.length; i++) {
        var storage = this.result.createObjectStore(key[i], {
          autoIncrement: true,
        });
        if (key[i] == "ORDER" || key[i] == "JOBWORK") {
          initializeMaster = [];
        } else if (key[i] == "settMill") {
          initializeMaster = temparrayMillSetting;
        } else {
          initializeMaster = [];
        }
        storage.add(initializeMaster, key[i]);
        // console.log(initializeMaster);
        document.cookie =
          key[i] +
          "_CREATETIME=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
      }
      resolve(true);
      // alert("Creating a new database!");
      // document.location.href = "./SYNCFIRM.php";
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
    Android.dialNo(mo);
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



//----tempPdfCreate
function createTempFlutterPdf() {
  try {
    window.flutter_inappwebview.callHandler("createTempFlutterPdf", "").then(function (result) {
      // alert(text);
      resolve(key);
    },
      function (err) {
        reject(key);
      }
    );
  } catch (error) {
    // alert(error);
  }
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

//----CreateOrderFormHtmlToPdf
function CreateOrderFormHtmlToPdf(div) {
  try {
    window.flutter_inappwebview.callHandler("CreateOrderFormHtmlToPdf", div).then(function (result) {
      // alert(text);
      resolve(key);
    },
      function (err) {
        reject(key);
      }
    );
  } catch (error) {
    // alert(error);
  }
}



function topToBottom(){
  window.scrollTo(0, document.body.scrollHeight);
}

function bottomToTop(){
  window.scrollTo(0, 0);
}




//---top to bottom & bottom to top system
  // Show/hide sticky buttons on scroll
  
  var topbottomBtn=`
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
  document.addEventListener('scroll', function() {
    var scrollPosition = window.scrollY;
    var stickyButtons = document.querySelector('.stickybuttonsTopBottom');
    if (scrollPosition > 100) { // Adjust the value as needed
      stickyButtons.style.display = 'flex';
      stickyButtons.style.opacity = 1;
      // Set a timeout to hide the buttons after 2 seconds
      setTimeout(function() {
        stickyButtons.style.opacity = 0;
        stickyButtons.style.display = 'none';
      }, 2000);
    } else {
      stickyButtons.style.opacity = 0;
      stickyButtons.style.display = 'none';
    }
  });
  $(document).ready(function () {
    var stickyButtons = document.querySelector('.stickybuttonsTopBottom');
    setTimeout(function () {
      stickyButtons.style.opacity = 0;
      stickyButtons.style.display = 'none';
    }, 2000);
  });
//---top to bottom & bottom to top system





if(clnt!="100"){
  console.log = console.warn = console.error = function() {};
}