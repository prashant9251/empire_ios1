
var MData;
var MDataLength = 300;
function loadCall(qualname) {
    MData = QualData;
    lengthLimit = document.getElementById('lengthLimit').value;
    if (qualType != "" && qualPACK != null && qualname.length > 0) {
        console.log(qualType, qualPACK, qualname)
        MData = MData.filter(function (qdata) {
            return ((qdata.QT)) != null;
        });
        MData = MData.filter(function (qdata) {
            return ((qdata.QT).toUpperCase()).indexOf(qualType.toUpperCase()) > -1;
        });
        MData = MData.filter(function (qdata) {
            return ((qdata.label).toUpperCase()).indexOf(qualname.toUpperCase()) > -1;
        });
        MData = MData.filter(function (qdata) {
            return ((qdata.PCK).toUpperCase()).indexOf(qualPACK.toUpperCase()) > -1;
        });
    } else if (qualType.length > 0 && qualPACK.length > 0) {
        console.log(qualType, qualPACK)
        MData = QualData.filter(function (qdata) {
            return ((qdata.QT)) != null && ((qdata.PCK)) != null;
        });
        MData = MData.filter(function (qdata) {
            return ((qdata.QT).toUpperCase()).indexOf(qualType.toUpperCase()) > -1 && ((qdata.PCK).toUpperCase()).indexOf(qualPACK.toUpperCase()) > -1;
        });
    } else if (qualType.length > 0) {
        console.log(qualType)
        MData = QualData.filter(function (qdata) {
            return ((qdata.QT)) != null;
        });
        MData = MData.filter(function (qdata) {
            return ((qdata.QT).toUpperCase()).indexOf(qualType.toUpperCase()) > -1;
        });
    } else if (qualPACK.length > 0) {
        console.log(qualPACK)
        MData = QualData.filter(function (qdata) {
            return ((qdata.PCK)) != null;
        });
        MData = MData.filter(function (qdata) {
            return ((qdata.PCK).toUpperCase()).indexOf(qualPACK.toUpperCase()) > -1;
        });
    } else if (qualname.length > 0) {
        console.log(qualPACK)
        MData = QualData.filter(function (qdata) {
            return ((qdata.label).toUpperCase()).indexOf(qualname.toUpperCase()) > -1;
        });
    } else {
        MData = QualData;
    }
    
    if(isBaseQual!=null && isBaseQual !=""){
        MData = MData.filter(function(d){
            return d.IB.toString().toUpperCase().trim()==isBaseQual;
        })
     }
    // try {
   

    console.log(lengthLimit);

    if (qualOrderBy != null && qualOrderBy !== "") {
        MData = MData.sort(function(a, b) {
            var aRate = parseFloat(getValueNotDefineNo(a[qualOrderBy]));
            var bRate = parseFloat(getValueNotDefineNo(b[qualOrderBy]));
            if(qualOrderByOption=="ASC"){
                if (aRate < bRate) {
                    return -1;
                } else if (aRate > bRate) {
                    return 1;
                } else {
                    return 0;
                }
            }else if(qualOrderByOption=="DESC"){
                if (aRate > bRate) {
                    return -1;
                } else if (aRate < bRate) {
                    return 1;
                } else {
                    return 0;
                }
            }
        });
        MData=MData.filter(function(d){
            var aRate = parseFloat(getValueNotDefineNo(d[qualOrderBy]));
            return aRate > 0;
        });
    }

    if (MData.length > lengthLimit) {
        lengthLimit = lengthLimit;
    } else {
        lengthLimit = MData.length;
    }
    if (lengthLimit > 0) {
        var tr = '';
        tr += `    <thead > <tr style="color:black;">
        <th style=" border:1px solid black;">Quality</th>
        <th style=" border:1px solid black;" class="Rate1Hideable">Rate<input class="hideTr"type="checkbox" id="Rate1Hideable"onchange="hideBox1('Rate1Hideable');" value="Y"  checked></th>
        <th style=" border:1px solid black;" class="Rate2Hideable">Rate<input class="hideTr"type="checkbox" id="Rate2Hideable"onchange="hideBox2('Rate2Hideable');" value="Y"  checked></th>
        <th style=" border:1px solid black;" class="Rate3Hideable">Rate<input class="hideTr"type="checkbox" id="Rate3Hideable"onchange="hideBox3('Rate3Hideable');" value="Y"  checked></th>
        <th style=" border:1px solid black;">Fabrics</th> 
        <th style=" border:1px solid black;">Pack</th>
        <th style=" border:1px solid black;">MAIN SCREEN</th>
        <th style=" border:1px solid black;">CATEGORY</th>
        <th style=" border:1px solid black;">IS BASE QUAL</th>
        <th style=" border:1px solid black;">STOCK</th>
        </tr> 
        </thead>
        `;
        for (var i = 0; i < lengthLimit; i++) {
            var productname = getValueNotDefine(MData[i].label);
            var S1 = getValueNotDefineNo(MData[i].S1);
            var S2 = getValueNotDefineNo(MData[i].S2);
            var S3 = getValueNotDefineNo(MData[i].S3);
            var shareText = "PRODUCT NAME :-" + productname + "\n";
            var URLKEY = "retrieveImg.html?&ntab=NTAB&folder=" + encodeURIComponent(productname) + '&Musertoken=' + encodeURIComponent(CLDb) + '&clnt=' + encodeURIComponent(clnt) + '&api=';
            var UploadLink = "uploadImg.html?&ntab=NTAB&folder=" + encodeURIComponent(productname) + '&Musertoken=' + encodeURIComponent(CLDb) + '&clnt=' + encodeURIComponent(clnt) + '&api=';
            tr += `    <tr style="">
        <td class="QualtableSetting" onclick="costingOpen('`+productname+`');" style=" color: darkblue;text-decoration-line: underline;">`+ productname + ` </td>
        <td class="Rate1Hideable QualtableSetting"><a target="_blank"onclick="shareTextToFlutterApp('`+ encodeURIComponent(shareText + "PRICE :-" + S1 + "/-") + `');"><button>` + S1 + `</button></a></td>
        <td class="Rate2Hideable QualtableSetting"><a target="_blank"onclick="shareTextToFlutterApp('`+ encodeURIComponent(shareText + "PRICE :-" + S2 + "/-") + `');"><button>` + S2 + `</button></a></td>
        <td class="Rate3Hideable QualtableSetting"><a target="_blank"onclick="shareTextToFlutterApp('`+ encodeURIComponent(shareText + "PRICE :-" + S3 + "/-") + `');"><button>` + S3 + `</button></a></td>
        <td class="QualtableSetting">`+ getValueNotDefine(MData[i].BQ) + `</td>
        <td class="QualtableSetting">`+ getValueNotDefine(MData[i].PCK) + `</td>
        <td class="QualtableSetting" >`+ getValueNotDefine(MData[i].MS) + `</td>
        <td class="QualtableSetting" >`+ getValueNotDefine(MData[i].CT) + `</td>
        <td class="QualtableSetting" >`+ getValueNotDefine(MData[i].IB) + `</td>
        <td class="QualtableSetting" >`+ getValueNotDefine(MData[i].FS) + `</td>
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