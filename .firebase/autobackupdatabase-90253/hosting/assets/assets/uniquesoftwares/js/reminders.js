var REMINDER;
var EMP;
jsGetObjectByKey(DSN, "FAS", "").then(function (data) {
    EMP = data;
    if (EMP.REMINDER == undefined) {
        EMP = {}
        EMP["REMINDER"] = [];
    }
    REMINDER = EMP["REMINDER"];
});

function setTodaysDueListReminder(partycode, id) {
    var DateTime = new Date($("#dateTime_" + id).val());
    // DateTimeInMili = DateTime.getTime();
    try {
        // console.log(partycode, id, DateTime.getTime());
        var partyArray = getPartyDetailsBySendCode(partycode);
        var UID = partyArray[0].UID == undefined || partyArray[0].UID == null || partyArray[0].UID == "" ? 0 : partyArray[0].UID;
        // console.log(UID,partyArray);
        Android.setNotificationForAndroid("toDaysDueList", "Reminder for " + partycode, "Today's Due List ", DateTime.getTime(), "&partyname=" + encodeURIComponent(partycode) + "&partycode=" + encodeURIComponent(partycode), UID);
    } catch (error) {

    }
    var obj = {};
    obj.partycode = partycode;
    obj.DateTime = DateTime;
    obj.id = id;
    var PartyFound = false;
    if (REMINDER.length > 0) {
        for (var i = 0; i < REMINDER.length; i++) {
            if (REMINDER[i].partycode == partycode) {
                console.log(REMINDER[i].partycode)
                REMINDER[i].DateTime == DateTime;
                REMINDER[i].id = id;
                PartyFound = true;
            }
        }
    }
    if (!PartyFound) {
        REMINDER.push(obj);
    }
    // console.table(REMINDER);
    console.log(EMP);
    storedatatoIndexdb(DSN, "FAS", JSON.stringify(EMP)).then(function (data) {
    })
}
function getReminders(partycode) {
    return REMINDER.filter(function (d) {
        return d.partycode == partycode;
    })
}
