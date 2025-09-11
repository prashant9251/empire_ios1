
function createDatabase(Db, key) {
    return new Promise(function (resolve, reject) {

        var database, idb_request;
        if (!('indexedDB' in window)) {
            alert('Error This browser doesn\'t support IndexedDB');
            return;
        }
        var initializeMaster = {
            value: "",
            label: "",
            partyname: "",
            city: "",
            broker: "",
            ATYPE: "",
        };
        idb_request = window.indexedDB.open(Db, 1);

        idb_request.addEventListener("error", function (event) {
            alert(
                "Error Could not open " +
                Db +
                " databases due to error: " +
                this.errorCode
            );
            reject(false);
        });

        idb_request.addEventListener("upgradeneeded", function (event) {
            for (var i = 0; i < key.length; i++) {
                var storage = this.result.createObjectStore(key[i], {
                    autoIncrement: true,
                });
                if (key[i] == "ORDER") {
                    initializeMaster = [];
                }
                storage.add(initializeMaster, key[i]);
                console.log(initializeMaster);
                document.cookie =
                    key[i] +
                    "_CREATETIME=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
            }
            resolve(true);
            alert("Creating a new database!");
            // document.location.href = "./SYNCFIRM.php";
        });
        idb_request.addEventListener("success", function (event) {
            resolve(true);
        });
    });
}
