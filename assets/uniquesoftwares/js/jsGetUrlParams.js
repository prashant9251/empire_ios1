
var cssFile = document.createElement('link');
cssFile.type = 'image/png';
cssFile.rel = 'shortcut icon';
cssFile.href = "favicon.ico";  // or path for file {themes('/styles/mobile.css')}
document.head.appendChild(cssFile); // appe
var acceptVarList={
    "DatabaseSource":true,
    "MCNO":true,
    "MTYPE":true,
    "Currentyear":true,
    "CrntYearStartdate":true,
    "login_user":true,
    "SHOPNAME":true,
    "DEVICEID":true,
    "mobileNo":true,
    "email":true,
    "OTP":true,
    "SyncType":true,
    "LFolder":true,
    "CLNT":true,
    "CLDB":true,
    "ServerLocation":true,
    "http":true,
    "IosPlateForm":true,
    "userGstin":true,
    "requestFrom":true,
    "FIX_FIRM":true,
    "Curentyearforlocalstorage":true,
    "privateNetworkIp":true,
    "privateNetWorkSync":true,
    "privateNetWorkSync":true,
    
};
// function getUrlParams(url_string, key) {
//     var url = new URL(url_string);
//     var c = url.searchParams.get(key);
//     // console.log(key, c);
//     if(c!=null && c!="" && c!=undefined){
//         if(acceptVarList[key]==true){
//             setCookie(key,c,1);
//             console.log("cookies set--",key,"-",c);
//         }
//     }
//     if (c == null || c == "" || c == undefined) {
//         if(acceptVarList[key]==true){
//             c = getCookie(key);
//             console.log("cookies get--",key,"-",c);
//         }
//     }
//     return c;
// }


function getUrlParams(url_string, key) {
    var url = new URL(url_string);
    var c = url.searchParams.get(key);
    // console.log(key, c);
    // localStorage.setItem(key,c);
    return c;
}

var url = window.location.href;

var IosPlateForm =getUrlParams(url, "IosPlateForm")
var deviceIsIos = getUrlParams(url, "deviceIsIos")
var privateNetworkIp = getUrlParams(url, "privateNetworkIp")
var LFolder = getUrlParams(url, "LFolder")
var privateNetworkIp = getUrlParams(url, "privateNetworkIp")
var privateNetworkIp = getUrlParams(url, "privateNetworkIp")
var CurrentyearSelected=getUrlParams(url,"Currentyear");//user in chart.html

var SYNCBLS = [];
var SYNCOUTSTANDING = [];
var SYNCACGROUP = [];
var SYNCMST = [];



function getAllUrlPrms() {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;
    var obj = {};
    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');
        obj[sParameterName[0]] = decodeURIComponent(sParameterName[1]);
    }
    return obj;
};


var domain = window.location.hostname;
var AllUrlString = getAllUrlPrms();
function setCookie(name, value, expirationDays) {
    var expirationDate = new Date();
    expirationDate.setDate(expirationDate.getDate() + expirationDays);
    var cookieValue = encodeURIComponent(name) + "=" + encodeURIComponent(value) + ";expires=" + expirationDate.toUTCString() + ";path=/";
       
    if (domain) {
        cookieValue += ";domain=" + domain;
    }
    document.cookie = cookieValue;
}
// Function to get a specific cookie value by key (name)
function getCookie(key) {
    const cookieString = document.cookie;
    const cookiesArray = cookieString.split("; ");

    for (const cookie of cookiesArray) {
        const [name, value] = cookie.split("=");
        const decodedName = decodeURIComponent(name.trim());
        if (decodedName === key) {
            return decodeURIComponent(value);
        }
    }

    // Return null if the cookie with the specified key is not found
    return null;
}

function saveToLocal(evt, key) {
    var value = evt.value;
    // alert(key);
    localStorage.setItem(key, value);
}

function readToLocal(key) {
    var val = localStorage.getItem(key);
    if (val == null || val == undefined) {
        val = "";
    }
    return val;
}




var ORDER_FORM_ENABLE=getUrlParams(url, "ORDER_FORM_ENABLE");
var AppLocalStorage=getUrlParams(url, "AppLocalStorage");