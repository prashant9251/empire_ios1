var ImgName, ImgUrl;
var files = [];
var reader;
var Data;
var firebaseConnection;
jsGetObjectByKey(DSN, "TIME", "").then(function (data) {
  Data = data;
  firebaseConnection = (Data[0].firebase);
  if (firebaseConnection != undefined) {
    console.log((firebaseConnection))
    var firebaseConfig = firebaseConnection;
    // Initialize Firebase
    firebase.initializeApp(firebaseConfig);
  } else {
    $('body').append("Call :8469190530");
    alert("Call:8469190530")
  }
})



function progressBar(width) {
  var elem = document.getElementById("myBar");
  width++;
  elem.style.width = width + "%";

}

// upload process
clnt;
