    
    function openBillDetails(IDE,rowContent){
        var billDet=jsgetArrayProductdetailsbyIDE(IDE);
        console.log(billDet)
        var tr='';
        if(billDet[0].length>0){
            tr +=`<table class="productDetails"><thead>
                <tr>
                <th>QUAL</th>
                <th>PCS</th>
                <th>PACK</th>
                <th>UNIT</th>
                <th>CUT</th>
                <th>RATE</th>
                <th>MTS</th>
                <th>AMT</th>
                </tr>
                </thead>`;       
                for(j=0;j<billDet[0].length;j++){
                    tr +=`<tr>
                <th>`+billDet[0][j]['qual']+`</th>
                <th>`+billDet[0][j]['PCS']+`</th>
                <th>`+billDet[0][j]['PCK']+`</th>
                <th>`+billDet[0][j]['UNIT']+`</th>
                <th>`+billDet[0][j]['CUT']+`</th>
                <th>`+billDet[0][j]['RATE']+`</th>
                <th>`+billDet[0][j]['MTS']+`</th>
                <th>`+billDet[0][j]['AMT']+`</th>
                </tr>`;
                }
                var currentDataTble = document.getElementsByClassName("productDetails");
                for(var i=0;i<currentDataTble.length;i++ ){
                    console.log(currentDataTble[i]);
                    if(currentDataTble[i] != undefined && currentDataTble[i] != null){
                        var parentRows = currentDataTble[i].parentElement;
                        parentRows.parentNode.removeChild(parentRows);
                        //parentRows.style.display="none";
                    }
                }  

                var mainDatTable = document.getElementById("result");
                rowContent = rowContent.parentElement.parentElement;
                var rowNbr = rowContent.rowIndex;
                var row = mainDatTable.insertRow(rowNbr+1);
                var cell1 = row.insertCell(0);
                cell1.setAttribute('colspan',6);
                cell1.innerHTML = tr;
        }
    }