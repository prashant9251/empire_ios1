var url = window.location.href;

var MCNO = getUrlParams(url, "MCNO");
var MTYPE = getUrlParams(url, "MTYPE");
var DSN = getUrlParams(url, "DatabaseSource");
var Currentyear = getUrlParams(url, "Currentyear");
var privateNetworkIp = getUrlParams(url, "privateNetworkIp");
var privateNetWorkSync = getUrlParams(url, "privateNetWorkSync");
var LFolder = getUrlParams(url, "LFolder");
var SyncType = getUrlParams(url, "SyncType");
var Crntyear = Currentyear;
var ClDb = DSN.replace(Currentyear, "");
var Clnt = atob(ClDb);
console.log(ClDb);