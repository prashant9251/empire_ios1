// jsGetObjectByKey(DSN, "settOTG", "").then(function (data) {
//     setting = data;
//     openSettingForm(setting);
// });

// function openSettingForm(sett) {
//     var modelDiv = `<div id="myModal" class="modal">
//                 <div class="modal-content">
//                 <div class="modal-header">
//                     <h2 id="mdlPartyName">Report View Setting</h2>
//                     <span class="close" onclick="document.getElementById('myModal').style.display = 'none'">&times;</span>
//                 </div>
//                 <div class="modal-body" align="center">
//                 <table style="padding:5px;">`;
//     if (sett.length > 0) {
//         for (var i = 0; i < sett.length; i++) {
//             var check = '';
//             if (sett[i].val == 1) {
//                 var check = "checked";
//             }
//             modelDiv += `
//         <tr style="height:30px;padding:20px;">
//         <td>` + sett[i].nm + `</td><td><input data="` + sett[i].nm + `" title="` + sett[i].cod + `"type="checkbox"value="1" name="` + sett[i].cod + `" ` + check + `/>&nbsp</td>
//         </tr>  
//          `;
//         }
//     }
//     modelDiv += `
//             </table>
//             </div>
//             <div class="modal-footer" align="center">
//                 <h5 onclick="saveSetting();">SUBMIT</h5>
//             </div>
//             </div>
//             </div>`;


//     $('body').append(modelDiv);
//     var modal = document.getElementById("myModal");
//     modal.style.display = "block";
// }


// function saveSetting() {
//     var CheckArr = new Array();
//     $('input[type=checkbox]').each(function () {
//         var val
//         if ($(this).is(':checked')) {
//             val = 1;
//         } else {
//             val = 0;
//         }
//         CheckArr.push({ nm: $(this).attr('data'), cod: $(this).attr('title'), val: val });
//     });
//     // init(CheckArr);
//     console.log(CheckArr);
//     openSettingForm(CheckArr);
//     storedatatoIndexdb(DSN, "settMill", JSON.stringify(CheckArr));
//     document.getElementById('myModal').style.display = 'none'
// }