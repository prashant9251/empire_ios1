var Data;
var firebaseConnection;
var FirebaseInitialize = false;
Data = JSON.parse(localStorage.getItem("TIME"));
// console.log(Data);
if (Data == null || Data == "" || Data == undefined) {
    try {
        Data = JSON.parse(Android.readfromAndroidTxt(DSN + "TIME"));
    } catch (error) {

    }
    Data = JSON.parse(Data)
}
console.log((Data));
firebaseConnection = (Data[0].firebase);
console.log(firebaseConnection);
if (firebaseConnection != null && firebaseConnection != "" && firebaseConnection != undefined) {
    FirebaseInitialize = true;
    console.log((firebaseConnection))
    var firebaseConfig = firebaseConnection;
    // Initialize Firebase
    try {
        firebase.initializeApp(firebaseConfig);
    } catch (error) {
        console.log(error);
        document.getElementById('error').innerHTML = error;
    }
} else {
    try {
        document.getElementById("error").innerHTML = "No Server Connected"
    } catch (error) {

    }
}

