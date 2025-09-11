function noteError(error) {
    $("body").append(error + "<br>Please Send This Error Msg ScreenShot to <a target='_blank'href='https://wa.me/918469190530?text=Error'>8469190530</a>")

    $("body").append(error.stack)
    $("body").append(error.onLine)
    $("#loader").removeClass('has-loader');
}



var Curentyearforlocalstorage;
function storedatatoIndexdb(Db, key, value) {
    var promise = new Promise(function (resolve, reject) {
        var d = new Date();
        d.setTime(d.getTime() + (360 * 24 * 60 * 60 * 1000));
        var expires = "expires=" + d.toUTCString();

        if (Db.indexOf(Curentyearforlocalstorage) > -1) {
            if (key == 'SERIES') {
                localStorage.setItem(key, (value));
            }
            if (key == 'COMPMST') {
                localStorage.setItem(key, (value));
            }
            if (key == 'TIME') {
                localStorage.setItem(key, (value));
                try {
                    Android.SaveToAndroidTxt(DSN + key, JSON.stringify(value));
                } catch (error) {

                }
            }
        }
      

    });

    return promise.then(function (result) {
        return result
    })
}

//-----hide/unhide


var filename = url.substring(url.lastIndexOf('/') + 1);
toIndex = filename.indexOf(".html");
filename = filename.substring(0, toIndex);
var CurrentPageSett
var tempSettings = [{ "view": true, "key": "TYPE", "id": "TYPE", "Caption": "TYPE", "cal": "" },
{ "view": true, "key": "FRM", "id": "FRM", "Caption": "FIRM", "cal": "" },
{ "view": true, "key": "GROUP", "id": "GROUP", "Caption": "GROUP", "cal": "" }];

function viewVal(key) {
    return CurrentPageSett.filter(function (d) {
        return d.key == key;
    })
}

function openSettingForm(sett) {
    var modelDiv = `<div id="popUpModelSettings"style="overflow: auto;" class="modal">
                <div class="modal-content">
                <div class="modal-header baseColorApp">
                    <div style="display:flex;width:100%;">
                        <div style="width:50%">
                        <h2 id="mdlPartyName" style="margin-top: 0;">View Setting</h2>
                        </div>
                        <div style="width:50%">
                        <span class="close" onclick="document.getElementById('popUpModelSettings').style.display = 'none'">&times;</span>
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
            var check = '';
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
            sr = i + 1
            modelDiv += `
        <tr >
        <td>` + sr + `-</td>
        <td>` + sett[i].nodeName + `</td>
        <td><input type="checkbox" 
        onchange="settingSave('` + sett[i].id + `','` + sett[i].key + `','` + sett[i].Caption + `',this);
        "key="` + sett[i].key + `" Caption="` + sett[i].Caption + `" 
        id="` + sett[i].key + `" ` + check + `/>&nbsp</td>
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
            <div class="modal-footer baseColorApp" align="center">
            </div>
            </div>
            </div>`;


    $('body').append(modelDiv);
    // showhideUnhide();

}
function showhideUnhide() {
    try {
        var modal = document.getElementById("popUpModelSettings");
        modal.style.display = "block";
    } catch (error) {

    }
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
    } catch (error) {

    }
}

var SettingByClass = []; var SettingByClassFlag = [];
function hideList() {
    jsGetObjectByKey(DSN, "settOTG", "").then(function (data) {
        settings = data
        CurrentPageSett = settings[filename];
        tempSettings = document.querySelectorAll('*[class]');
        // console.log(tempSettings);
        for (var i = 0; i < tempSettings.length; i++) {
            if (tempSettings[i].className.indexOf('hide') > -1 && tempSettings[i].className.indexOf('hideAbleTr') < 0 && tempSettings[i].className.indexOf('unhideAbleTr') < 0) {
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
            // console.log(settings[filename], settings);
            storedatatoIndexdb(DSN, "settOTG", JSON.stringify(settings)).then(function (data) {
            })
        }
        // storedatatoIndexdb(DSN, "settOTG", JSON.stringify([])).then(function (data) {
        // })
        openSettingForm(SettingByClass)
        hide();
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
    console.table(CurrentPageSett)
    settings[filename] = CurrentPageSett;
    storedatatoIndexdb(DSN, "settOTG", JSON.stringify(settings)).then(function (data) {
    })
    hide();
}



//-----hide/unhide

var Currentyear = getUrlParams(url, "Currentyear");
var CURRENT_YEAR = Currentyear;
// var ClDb = DSN.replace(Currentyear, "");
var clnt = atob(ClDb);
console.log(clnt);
Curentyearforlocalstorage = '2122'
var privateNetworkIp = getUrlParams(url, "privateNetworkIp");
var privateNetWorkSync = getUrlParams(url, "privateNetWorkSync");
var LFolder = getUrlParams(url, "LFolder");
var SyncType = getUrlParams(url, "SyncType");

var CUOTP = getUrlParams(url, "CUOTP");

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


console.log(SyncType)
console.log("--ONLINE--" + navigator.onLine);
var Enavigator = navigator.onLine;
function jsGetObjectByKey(Db, key, subKey) {
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
            var storage = database
                .transaction(key, "readwrite")
                .objectStore(key);
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
                if (SyncType == "LIVE") {
                    // console.log(SyncType);
                    getDataFromServer(key).then(function (liveData) {
                        if (liveData.length > 0) {
                            // console.log(SyncType, liveData)
                            resolve(liveData);
                            // storedatatoIndexdb(DSN, key, JSON.stringify(liveData)).then(function (data) {
                            // }, function (error) {
                            // });
                        }
                    }).catch(function (err) {
                        console.log(key, err);
                        resolve(result);
                    })
                } else {
                    resolve(result);
                }
            });
        });
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
        }
        var URLKEY = "http://aashaimpex.com/oprate/EMPIRE TRADING/" + key + ".php";
        xhttp.open("POST", URLKEY, true);
        xhttp.onerror = function () { }
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send(JSON.stringify(userRequest));
        // console.log(userRequest);
    })
}

















// getliveData()
firebaseDirpath = 'forUnique' + "/" + atob(ClDb) + "/" + ClDb + "/" + Currentyear + "/"
function getliveData(key, Data) {
    path = firebaseDirpath + key;
    return new Promise(function (resolve, reject) {
        firebase.database().ref(path).on('value', (snapshot) => {
            const data = snapshot.val();
            // console.log(data);
            resolve(data);
        }, function (error) {
            reject("Error: " + error.code);
        });
    })
}



function selectBoxReport() {
    try {
        $('.selectBoxReport').css("display", "");
        $('.pdfBtnHide').css("display", "none");

        document.getElementById('footer').style.display = "";
    } catch (error) {

    }
}

function hideselectBoxReport() {
    try {
        $('.selectBoxReport').css("display", "none");
        $('.pdfBtnHide').css("display", "");

        document.getElementById('footer').style.display = "none";
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
            Android.SaveContact(displayname, mobileNo, ph1, ph2, email, company, jobTitle);
        } else {
            Android.SaveContact("", mobileNo, "", "", "", "", "");
        }
    } catch (error) {

    }
}

function getPartyDetailsByMobileNo(mobileNoSearch) {
    try {
        var retVal = masterData.filter(function (data) {
            return data.MO == mobileNoSearch || data.PH1 == mobileNoSearch || data.PH2 == mobileNoSearch;
        })
    } catch (error) {
        retVal = [];
    }
    return retVal;
}

//---------------call save system


function getValueNotDefine(value) {
    var Rvalue;
    if (value == 'undefined' || value == null) {
        Rvalue = '';
    } else {
        Rvalue = value
    }
    return Rvalue;
}

