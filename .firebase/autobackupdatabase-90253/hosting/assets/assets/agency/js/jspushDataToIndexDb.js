var Curentyearforlocalstorage;
function storePushdatatoIndexdb(Db, key, value) {
    var promise = new Promise(function (resolve, reject) {
        var database, idb_request;
        idb_request = window.indexedDB.open(Db, 1);
        idb_request.addEventListener("error", function (event) {
            alert("Could not open Indexed DB due to error: " + this.errorCode + " in " + key);
            reject("reject" + key);
        });

        idb_request.addEventListener("success", function (event) {
            database = this.result;
            var storage = database.transaction(key, "readwrite").objectStore(key);
            // console.log(database.objectStoreNames.contains(key));
            storage.get(key).addEventListener("success", function (event) {
                // var result = this.result;
                console.log(value.OrderID);
                storage.add(JSON.parse(value),key);
                // console.log(key, JSON.parse(value));
                // alert(JSON.stringify(value));
                resolve(key);
            });

            // alert("Successfully opened database!");
        });

    });

    return promise.then(function (result) {
        return result
    })
}
