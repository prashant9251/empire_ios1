function deleteDatabase(databaseName){
    
    var req = window.indexedDB.deleteDatabase(databaseName);
    req.onsuccess = function () {
        console.log("Deleted database successfully");
    };
    req.onerror = function () {
        console.log("Couldn't delete database");
    };
    req.onblocked = function () {
        console.log("Couldn't delete database due to the operation being blocked");
        };
    }