function jsconnectionDatabase(Db,key, value) {
    var database, idb_request;
    idb_request = window.indexedDB.open(Db, 1);

    idb_request.addEventListener("error", function (event) {
        alert("Could not open Indexed DB due to error: " + this.errorCode);
    });   

    idb_request.addEventListener("success", function (event) {
        database = this.result;
        var storage = database.transaction(key, "readwrite").objectStore(key);
        // console.log(database.objectStoreNames.contains(key));
        storage.get(key).addEventListener("success", function (event) {
            var result = this.result;
            value = value.concat(result);
            console.log(key + "-" + result.length);
            // alert(JSON.parse(this.result));
            storage.put(value, key);
            console.log(value);
            // alert(JSON.stringify(value));
        });

        // alert("Successfully opened database!");
    });
}
