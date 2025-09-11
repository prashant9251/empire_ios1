
    var url = window.location.href;
    var MCNO = getUrlParams(url, "MCNO");
    var MTYPE = getUrlParams(url, "MTYPE");
    var DSN = getUrlParams(url, "DatabaseSource");
    var Currentyear = getUrlParams(url, "Currentyear");
    var Crntyear=Currentyear;
    var ClDb = DSN.replace(Currentyear, "");
    localStorage.setItem("MCNO", MCNO);
    localStorage.setItem("MTYPE", MTYPE);
    localStorage.setItem("DSN", DSN);
    localStorage.setItem("Currentyear", Currentyear);