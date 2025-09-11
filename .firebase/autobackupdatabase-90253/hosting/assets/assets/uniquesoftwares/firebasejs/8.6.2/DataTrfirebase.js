firebaseDirpath = 'forUnique' + "/" + atob(ClDb) + "/" + ClDb + "/"+ Currentyear + "/"
function writeDataToFirebaseDatabase(key, Data) {
  path = firebaseDirpath + key;
  firebase.database().ref(path).set(Data).then(function (d) {
    // ReadDataToFirebaseDatabase(key, Data)
  });
}

function ReadDataToFirebaseDatabase(key, Data) {
  path = firebaseDirpath + key;
  firebase.database().ref(path).on('value', (snapshot) => {
    const data = snapshot.val();
    console.log(data);
  }, function (error) {
    console.log("Error: " + error.code);
  });
}