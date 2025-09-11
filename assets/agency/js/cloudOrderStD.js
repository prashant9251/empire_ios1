var ServerLocation = getUrlParams(url, "ServerLocation");
var http = getUrlParams(url, "http");
var FILE_NAME = getUrlParams(url, "FILE_NAME");

function cloudStD(key, value) {
    return promise = new Promise(function (resolve, reject) {
        DSN;
        Currentyear;
        clnt = atob(DSN.replace(Currentyear, ""));
        Cldb = DSN.replace(Currentyear, "");
        postData = value;
        try {
            window.flutter_inappwebview.callHandler("saveOrderToFirestore",  JSON.parse(postData)).then(function (result) {
                    // alert(text);
                    resolve(key);
                },
                function (err) {
                    reject(key);
                }
                );
            } catch (error) {
            alert(error);
            }
    });
}



function cloudStDkeyVal(OrderId,key,value,filename,productId,count) {
    if(count!=undefined && count!=null && count!="" && count ==1){
        productId="";//for complete order
    }
    return promise = new Promise(function (resolve, reject) {
        DSN;
        Currentyear;
        clnt = atob(DSN.replace(Currentyear, ""));
        Cldb = DSN.replace(Currentyear, "");
        postData = value;
        domain=ServerLocation;
        var URLKEY = domain+"/ORDER/updateDataToSJson.php";
        var timeoutSecond = 10;

        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                data = this.responseText;
                // alert("UPDATED");
                if(key=="dispatch" && value =="Y" ){
                    alert("Updated successfully")
                }
                resolve(data);
                getCloudData();
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
        xhttp.send("secpt=" + encodeURIComponent("Li8uLi9DTElFTlQvREFUQS8=") + "&ftype=json&productId="+productId+"&filename="+filename+"&OrderID="+OrderId+"&value=" + value + "&key=" + key + "&Clnt=" + clnt + "&Cldb=" + encodeURIComponent(Cldb) + "&year=" + Currentyear + "&postData=" + encodeURIComponent(postData));

    });
}


function cloudIndDkeyVal(OrderId,key,value,filename,productId) {
    return promise = new Promise(function (resolve, reject) {
        DSN;
        Currentyear;
        clnt = atob(DSN.replace(Currentyear, ""));
        Cldb = DSN.replace(Currentyear, "");
        postData = value;
        domain=ServerLocation;
        var URLKEY = domain+"/ORDER/insertSubDataToSJson.php";
        var timeoutSecond = 10;

        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                data = this.responseText;
                // alert("UPDATED");
                resolve(data);
                getCloudData();
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
        xhttp.send("secpt=" + encodeURIComponent("Li8uLi9DTElFTlQvREFUQS8=") + "&ftype=json&productId="+productId+"&filename="+filename+"&OrderID="+OrderId+"&value=" + value + "&key=" + key + "&Clnt=" + clnt + "&Cldb=" + encodeURIComponent(Cldb) + "&year=" + Currentyear + "&postData=" + encodeURIComponent(postData));

    });
}