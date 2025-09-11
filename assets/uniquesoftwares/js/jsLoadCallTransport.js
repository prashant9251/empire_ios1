
var MData;
var MDataLength = 300;
function loadCall(transport) {
     if (transport.length > 0) {
        console.log(qualPACK)
        MData = QualData.filter(function (qdata) {
            return ((qdata.label).toUpperCase()).indexOf(transport.toUpperCase()) > -1;
        });
    } else {
        MData = QualData;
    }
    // try {
    lengthLimit = 100;
    if (MData.length > 500) {
        lengthLimit = 500;
    } else {
        lengthLimit = MData.length;
    }
    if (lengthLimit > 0) {
        var tr = '';
        tr += `    <thead > <tr style="color:black;">
        <th style=" border:1px solid black;text-align:center;">TRANSPORT</th>
       <th style=" border:1px solid black;text-align:center;">GSTIN</th> 
        </tr> 
        </thead>
        `;
        for (var i = 0; i < lengthLimit; i++) {
            var shareText = "";
            shareText += "TRANSPORT:-" + MData[i].label + "\n";
            shareText += "GSTIN:-" + MData[i].value + "\n";
      
            tr += `    <tr>
            <th >`+MData[i]["label"]+`</th>
           <th style="color:darkblue;text-decoration-line: underline;" onclick="shareTextToFlutterApp('`+encodeURIComponent(shareText)+`')">`+MData[i]["value"]+`</th> 
            </tr> 
            `; 
        }

        $('#result').html(tr);
        $("#loader").removeClass('has-loader');
    } else {
        $('#result').html('<h1>No Data Found</h1>');

    }
    // } catch (error) {
    //     // alert(error);
    // }


}

function hideBox1(hideableClass) {
    var checkBox = document.getElementById(hideableClass);
    if (checkBox.checked == true) {
        $("." + hideableClass).removeClass("hideTr");
        $("." + hideableClass).addClass("displayTr");
    } else {
        $("." + hideableClass).removeClass("displayTr");
        $("." + hideableClass).addClass("hideTr");
    }
}
function hideBox2(hideableClass) {
    var checkBox = document.getElementById(hideableClass);
    if (checkBox.checked == true) {
        $("." + hideableClass).removeClass("hideTr");
        $("." + hideableClass).addClass("displayTr");
    } else {
        $("." + hideableClass).removeClass("displayTr");
        $("." + hideableClass).addClass("hideTr");
    }
}
function hideBox3(hideableClass) {
    var checkBox = document.getElementById(hideableClass);
    if (checkBox.checked == true) {
        $("." + hideableClass).removeClass("hideTr");
        $("." + hideableClass).addClass("displayTr");
    } else {
        $("." + hideableClass).removeClass("displayTr");
        $("." + hideableClass).addClass("hideTr");
    }
}