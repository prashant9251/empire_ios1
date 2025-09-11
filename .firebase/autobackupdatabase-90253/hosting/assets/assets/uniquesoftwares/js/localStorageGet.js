var url = window.location.href;

var MCNO = getUrlParams(url,"MCNO");
var MTYPE = getUrlParams(url,"MTYPE");
var DSN = getUrlParams(url,"DatabaseSource");
var Currentyear = getUrlParams(url,"Currentyear");
var http = getUrlParams(url, "http");
var ServerLocation = getUrlParams(url, "ServerLocation");
var Crntyear=Currentyear;
var ClDb = getUrlParams(url, "CLDB");
var Clnt=getUrlParams(url, "CLNT");
// console.log(ClDb);
CrntYearStartdate= "20" + Currentyear.substring(0, 2) + "-04-01";