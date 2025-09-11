
function getPartyListBySendBrokerCityCode(broker, city, Db) {
    if ((broker != "" || broker != null) && (city != "" || city != null)) {
        var partylist = [];
        var brokerCityValFAS = "";
        if (masterData.length > 0) {
            brokerCityValFAS += " AND (";
            var x = 0;
            for (var i = 0; i < masterData.length; i++) {
                if (
                    masterData[i].broker == broker &&
                    masterData[i].city == city
                ) {
                    x += 1;
                    partylist.push({
                        value: masterData[i].value,
                        partyname: masterData[i].partyname,
                        city: masterData[i].city,
                        broker: masterData[i].broker,
                    });

                    if (x == 1) {
                        brokerCityValFAS +=
                            "(" +
                            Db +
                            "FAS.code='" +
                            masterData[i].value +
                            "')";
                    } else {
                        brokerCityValFAS +=
                            " OR (" +
                            Db +
                            "FAS.code='" +
                            masterData[i].value +
                            "')";
                    }
                }
            }
            brokerCityValFAS += ")";
        }
        // console.log(brokerCityValFAS);

        document.cookie = "brokerCityValFAS=" + brokerCityValFAS;
        localStorage.setItem("BrokerPartyList", JSON.stringify(partylist));
        return partylist;
    }
}
