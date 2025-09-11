
function getPartyListBySendcityCode(city, Db) {
    if (city != "" || city != null) {
        var partylist = [];
        var cityValFAS = "";
        if (masterData.length > 0) {
            cityValFAS += " AND (";
            var x = 0;
            for (var i = 0; i < masterData.length; i++) {
                if (masterData[i].city == city) {
                    x += 1;
                    partylist.push({
                        value: masterData[i].value,
                        partyname: masterData[i].partyname,
                        city: masterData[i].city,
                        broker: masterData[i].broker,
                    });

                    if (x == 1) {
                        cityValFAS +=
                            "(" +
                            Db +
                            "FAS.code='" +
                            masterData[i].value +
                            "')";
                    } else {
                        cityValFAS +=
                            " OR (" +
                            Db +
                            "FAS.code='" +
                            masterData[i].value +
                            "')";
                    }
                }
            }
            cityValFAS += ")";
        }
        console.log(cityValFAS);

        document.cookie = "cityValFAS=" + cityValFAS;
        localStorage.setItem("cityPartyList", JSON.stringify(partylist));
        return partylist;
    }
}
