var EMP;
function getEMPdata(cno, partycode, broker, city, fromdate, todate) {
  return jsGetObjectByKey(DSN, "EMP", "").then(function (data) {
        EMP = data;
       return getBILLData(cno, partycode, broker, city, fromdate, todate);
    });

}

function getBILLData(cno, partycode, bcode, city, fromdate, todate) {
    var BLS = EMP;   
    if (cno != '') {
        BLS = getBLSfilter(BLS, "CNO", cno);
    }
    if (partycode != '') {
        BLS = getBLSfilter(BLS, "code", partycode);
    }
    if (bcode != '') {
        BLS = getBLSfilter(BLS, "BCODE", bcode);
    }
    if (city != '') {
        BLS = getBLSfilter(BLS, "CITY", city);
    }
    if (fromdate != '') {
        BLS = BLS.filter(function (data) {
            return data.BLS.some((BLS) => new Date(BLS.DATE) >= new Date(fromdate));
        }).map(function (subdata) {
            return {
                ADDRESS: subdata.ADDRESS,
                code: subdata.code,
                CITY: subdata.CITY,
                BCODE: subdata.BCODE,
                BLS: subdata.BLS.filter(function (d) {
                    return new Date(d.DATE) >= new Date(fromdate);
                }),
                FAS: subdata.FAS.filter(function (d) {
                    return new Date(d.DATE) >= new Date(fromdate);
                })
            }
        })
    }
    if (todate != '') {
        BLS = BLS.filter(function (data) {
            return data.BLS.some((BLS) => new Date(BLS.DATE) <=new Date(todate));
        }).map(function (subdata) {
            return {
                ADDRESS: subdata.ADDRESS,
                code: subdata.code,
                CITY: subdata.CITY,
                BCODE: subdata.BCODE,
                BLS: subdata.BLS.filter(function (d) {
                    return new Date(d.DATE) <= new Date(todate);
                }),
                FAS: subdata.FAS.filter(function (d) {
                    return new Date(d.DATE) <= new Date(todate);
                })
            }
        })
    }
    // console.log("---------", BLS);
    return BLS;
}


function getBLSfilter(array, onfilter, value) {    
   var BLS = array.filter(function (data) {
        return data.BLS.some((BLS) => BLS[onfilter] == value);
    }).map(function (subdata) {
        return {
            ADDRESS: subdata.ADDRESS,
            code: subdata.code,
            CITY: subdata.CITY,
            BCODE: subdata.BCODE,
            BLS: subdata.BLS.filter(function (d) {
                return d[onfilter] == value
            }),
            FAS: subdata.FAS.filter(function (d) {
                return  d[onfilter] == value
            })
        }
    })
    return BLS;
}