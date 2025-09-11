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
    // $('body').append("Call :8469190530");
  }
})


function retrieve(productname) {
    var ArrayImg = [];
    ImgName = productname;
  firebase.database().ref('Images/' + clnt + "/" + ImgName).on('value', function (snapshot) {
    var Array = snapshot.val();
    var div = '';
    for (key in Array) {
      console.log(Array[key].Link);
      var id = key.trim();
      id = id.replaceAll(" ", "")
      div += `<div style="float: left;"><input type="checkbox"class="checkbox" id="txt_` + id + `">
        <img src="`+ Array[key].Link + `"id="` + id + `" class="img" onclick="select('` + id + `');">
        
        </div>`;
      ArrayImg.push(Array[key].Link);
    }
    CallAndroidShowActivity(ArrayImg);
  })
  
}


function CallAndroidShowActivity(ArrayImg){
  if (ArrayImg.length > 0) {
    console.log(ArrayImg)
    Android.callShowActivityImageByUrlArray(JSON.stringify(ArrayImg));
  } else {
    alert("No Image Found");
  }
}