
var cssFile = document.createElement('link');
cssFile.type = 'image/png';
cssFile.rel = 'shortcut icon';
cssFile.href = "favicon.ico";  // or path for file {themes('/styles/mobile.css')}
document.head.appendChild(cssFile); // appe



function getUrlParams(url_string, key) {
    var url = new URL(url_string);
    var c = url.searchParams.get(key);
    // console.log(key, c);
    // localStorage.setItem(key,c);
    return c;
}

var url = window.location.href;

var IosPlateForm=getUrlParams(url,"IosPlateForm")

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


var AllUrlString = getAllUrlPrms();

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




