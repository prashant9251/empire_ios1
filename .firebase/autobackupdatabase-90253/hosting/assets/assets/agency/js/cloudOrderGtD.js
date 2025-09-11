var ServerLocation = getUrlParams(url, "ServerLocation");
var http = getUrlParams(url, "http");
var FILE_NAME = getUrlParams(url, "FILE_NAME");

function cloudGtD(key, value) {
    return promise = new Promise(function (resolve, reject) {
        DSN;
        Currentyear;
        clnt = atob(DSN.replace(Currentyear, ""));
        ClDb = DSN.replace(Currentyear, "");
        postData = value;
        newDate= new Date();
        var URLKEY=http+ServerLocation+"/CLIENT/DATA/" + clnt + "/" + ClDb + "/" + FILE_NAME + "/access.php?tm=" + newDate;
        var timeoutSecond = 20;

        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {

                data = JSON.parse(this.responseText);
                if ((data).length > 0) {
                        resolve(data);
                } else {
                }
            }
        }
        xhttp.open("POST", URLKEY, true);
        xhttp.onerror = function () {
            reject("reject");
        }
        xhttp.timeout = 1000 * timeoutSecond; // Set timeout to 4 seconds (4000 milliseconds)
        xhttp.ontimeout = function () {
            reject("reject");
        }
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("Musertoken=" + ClDb + "&key=" + key);

    });
}