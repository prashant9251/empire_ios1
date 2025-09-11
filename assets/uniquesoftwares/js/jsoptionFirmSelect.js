var COMPMST = [];
var MFIRM;
function SelectFirmOptions(IdFirmOptions) {
//     var COMPMST = [];
//     jsGetObjectByKey(DSN, "COMPMST", "").then(function (data) {
//         COMPMST=data;
//         console.log(COMPMST);
//         var MFIRM = COMPMST.filter(function (data) {
//             return data.CNO == MCNO;
//         })

//         var xfirm = document.getElementById(IdFirmOptions);
//         if (COMPMST.length > 0) {
//             COMPMST.forEach(function (element, index) {
//                 var option = document.createElement("option");
//                 option.value = element.FIRM;
//                 option.text = element.FIRM;
//                 xfirm.add(option, xfirm[0]);
//                 //  alert(element.FIRM);
//             });

//         }

//         var option = document.createElement("option");
//         option.value = "";
//         option.text = "ALL";
//         xfirm.add(option, xfirm[0]);
//         if (MCNO != "" && MCNO != null && MCNO != undefined) {
//             document.getElementById(IdFirmOptions).value = MFIRM[0].FIRM;
//         } else {
//             document.getElementById(IdFirmOptions).value = "";
//         }
//         try {
//             setData();        
//         } catch (error) {
            
//         }
//     });
}
function getoption(text, value, onID) {
    var xMill = document.getElementById(onID);
    if (xMill != undefined) {
        var option = document.createElement("option");
        option.value = value;
        option.text = text;
        xMill.add(option, xMill[0]);
    }
}


function setValueInId(onId, localStorageValueName, defultValue) {
    var val = localStorage.getItem(localStorageValueName);
    if (val != "" && val != null) {
        document.getElementById(onId).value = val;
    } else {
        document.getElementById(onId).value = defultValue;
    }
}

function CheckBoxOption(onId, localStorageValueName) {
    var val = localStorage.getItem(localStorageValueName);
    if (val == "Y") {
        document.getElementById(onId).checked = true;
    }
}

function setValueToLocalStorage(name, val) {
    localStorage.setItem(name, val);
}
function localSave(onName) {
    var val = document.getElementById(onName).value;
    if (onName == "productDet") {
        var checkBox = document.getElementById(onName);
        if (checkBox.checked == true) {
            setValueToLocalStorage("SL_" + onName, "Y")
        } else {
            setValueToLocalStorage("SL_" + onName, "N")
        }

    } else if (onName == "pack") {
        var QualDataArr = QualPackingArr.filter(function (d) {
            return d.value == val;
        });
        if (QualDataArr.length > 0) {
            var rate = document.getElementById("rate").value;
            var packingRate = QualDataArr[0].S1;
            packingRate = packingRate == "" || packingRate == null ? 0 : packingRate;
            rate = rate == "" || rate == null ? 0 : rate;
            console.log(QualDataArr, packingRate, rate)
            totalRate = parseFloat(rate) + parseFloat(packingRate);
            if (totalRate != 0) {
                $('#rate').val(totalRate);
            }
        }
        setValueToLocalStorage("SL_" + onName, val)
    } else {
        setValueToLocalStorage("SL_" + onName, val)
        console.log(val);
    }
}

function localsaveInArray(onName) {
    var val = document.getElementById(onName).value;
    var arr = JSON.parse(localStorage.getItem("ARR_" + onName));
    if (arr != null && val != null && val != "" && val != undefined) {
        if (arr.length > 0) {
            arr = arr;
            for (var i = 0; i < arr.length; i++) {
                if (arr[i].label.toUpperCase() != val.toUpperCase()) {
                    var obj = {};
                    obj.label = val
                    console.log(obj);
                    arr.push(obj);
                }
                break;
            }
        } else {
            arr = [];
            var obj = {};
            obj.label = val
            arr.push(obj);
        }
    } else {
        arr = [];
        var obj = {};
        obj.label = val
        arr.push(obj);
    }

    localStorage.setItem("ARR_" + onName, JSON.stringify(arr));
    return arr;
}


