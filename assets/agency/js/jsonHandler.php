<?php
include('session.php');
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JSON HANDLER</title>
</head>

<body>

</body>

</html>
<script src="jsStoreDatatoIndexeddb.js"></script>
<script src="jsGetObjectByKey.js"></script>
<script>
    var Db = <?php echo "'" . $DSN . "'" ?>;
    var BLS;
    var DET;
    var MST;
    var QUL;
    var FAS;
    jsGetObjectByKey(Db, "BLS", "").then(function(data) {
        BLS = data;
        jsGetObjectByKey(Db, "DET", "").then(function(data) {
            DET = data;
            jsGetObjectByKey(Db, "QUL", "").then(function(data) {
                QUL = data;
                jsGetObjectByKey(Db, "FAS", "").then(function(data) {
                    FAS = data;
                    jsGetObjectByKey(Db, "MST", "").then(function(data) {
                        MST = data;
                        getArray();
                    });
                });
            });
        });
    });

    function getArray() {
        if (MST.length > 0) {
            var MSTarray = [];
            for (var i = 0; i < MST.length; i++) {
                MSTarray.push({
                    code: MST[i].value,
                    BCODE: MST[i].broker,
                    CITY: MST[i].city,
                    ADDRESS: MST[i].label,
                    partydetails: MST[i],
                    BLS: getBLS(MST[i].value),
                    FAS: getFAS(MST[i].value)
                })
            }
            storedatatoIndexdb(Db, "EMP", JSON.stringify(MSTarray))
            console.log(MSTarray);
        }

    }

    function getBLS(code) {
        var BLSarray = BLS.filter(function(data) {
            return data.code == code;
        }).map(function(subdata) {
            return subdata;
        })
        return BLSarray;
    }

    function getFAS(code) {
        var FASarray = FAS.filter(function(data) {
            return data.code == code;
        }).map(function(subdata) {
            return subdata;
        })
        return FASarray;
    }

    function getBILLDET(IDE) {
        var DETarray = DET.filter(function(data) {
            return data.IDE == IDE;
        }).map(function(subdata) {
            return subdata;
        })
        return DETarray;
    }

    function getQUALDET(qual) {
        var Qualdetails = QUL.filter(function(data) {
            return data.value == qual;
        }).map(function(subdata) {
            return subdata;
        })
        return Qualdetails;
    }
</script>