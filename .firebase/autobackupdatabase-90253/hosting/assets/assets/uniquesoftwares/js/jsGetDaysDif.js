
function getDaysDif(Date1, Date2) {
    var date1 = new Date(Date1.replace(/-/g, "/"));
    var date2 = new Date(Date2);
    var DiffTime = date2.getTime() - date1.getTime();
    var DiffDays = DiffTime / (1000 * 3600 * 24);
    return parseInt(DiffDays);
}
function getDaysAdd(Date1, DaysTOAdd) {
    var date = new Date(Date1); // Now
    date.setDate(date.getDate() + DaysTOAdd); // Set now + 30 days as the new date
    return (date);
}