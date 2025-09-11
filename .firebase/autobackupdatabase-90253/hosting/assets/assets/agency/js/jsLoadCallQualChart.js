
var MData;
var MDataLength = 300;
function loadCall(qualname) {
    if (qualType != "" && qualname.length > 0) {
        MData = QualData.filter(function (qdata) {
            return ((qdata.QT)) != null;
        });
        MData = MData.filter(function (qdata) {
            return ((qdata.QT).toUpperCase()).indexOf(qualType.toUpperCase()) > -1;
        });
        MData = MData.filter(function (qdata) {
            return ((qdata.label).toUpperCase()).indexOf(qualname.toUpperCase()) > -1;
        });
    } else if (qualType.length > 0) {
        MData = QualData.filter(function (qdata) {
            return ((qdata.QT)) != null;
        });
        MData = MData.filter(function (qdata) {
            return ((qdata.QT).toUpperCase()).indexOf(qualType.toUpperCase()) > -1;
        });
    } else if (qualname.length > 0) {
        MData = QualData.filter(function (qdata) {
            return ((qdata.label).toUpperCase()).indexOf(qualname.toUpperCase()) > -1;
        });
    } else {
        MData = QualData;
    }
    // try {

    if (MData.length > 0) {
        var tr = '';
        tr += `    <thead > <tr style="background-color: #588c7e;!important;color:black">
        <th>Quality</th>
        <th>Rate1</th>
        <th>Rate2</th>
        <th>Rate3</th>
        <th>Fabrics</th> 
        <th>Pack</th>
        </tr> 
        </thead>
        `;
        for (var i = 0; i < MData.length; i++) {
            var productname = getValueNotDefine(MData[i].label);
            var S1 = getValueNotDefineNo(MData[i].S1);
            var S2 = getValueNotDefineNo(MData[i].S2);
            var S3 = getValueNotDefineNo(MData[i].S3);
            var shareText = "PRODUCT NAME :-" + productname + "\n";

            tr += `    <tr style="background-color: white;!important;color:black;">
        <td class="QualtableSetting" >`+ productname + `</td>
        <td class="Rate1Hideable QualtableSetting"><a target="_blank"onclick="shareTextToFlutterApp('`+ encodeURIComponent(shareText + "PRICE :-" + S1 + "/-") + `');"><button>` + S1 + `</button></a></td>
        <td class="Rate2Hideable QualtableSetting"><a target="_blank"onclick="shareTextToFlutterApp('`+ encodeURIComponent(shareText + "PRICE :-" + S2 + "/-") + `');"><button>` + S2 + `</button></a></td>
        <td class="Rate3Hideable QualtableSetting"><a target="_blank"onclick="shareTextToFlutterApp('`+ encodeURIComponent(shareText + "PRICE :-" + S3 + "/-") + `');"><button>` + S3 + `</button></a></td>
        <td class="QualtableSetting">`+ getValueNotDefine(MData[i].BQ) + `</td>
        <td class="QualtableSetting">`+ getValueNotDefine(MData[i].PCK) + `</td>
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