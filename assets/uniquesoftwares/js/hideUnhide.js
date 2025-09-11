
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
    var modelDiv = `<div id="popUpModelSettings" style="overflow: auto;"class="modal">
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
    settings[filename] = CurrentPageSett;
    storedatatoIndexdb(DSN, "settOTG", JSON.stringify(settings)).then(function (data) {
    })
    hide();
}


