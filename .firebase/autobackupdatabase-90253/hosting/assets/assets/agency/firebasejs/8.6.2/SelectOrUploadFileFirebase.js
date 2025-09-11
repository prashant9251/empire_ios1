document.getElementById('select').onclick = function (e) {
    var input = document.createElement('input');
    input.type = 'file';
  
    input.onchange = e => {
      files = e.target.files;
      reader = new FileReader();
      reader.onload = function () {
        document.getElementById('myimg').src = reader.result;
      }
      reader.readAsDataURL(files[0]);
    }
  
    input.click();
  }


  document.getElementById('upload').onclick = function () {
    RendowmImagName = files[0].name;
    RendowmImagName = RendowmImagName.replace(".", "");
    console.log(files[0]);
    ImgName = document.getElementById('productname').innerHTML;
    var uploadTask = firebase.storage().ref('Images/' + clnt + "/" + ImgName + "/" + RendowmImagName + ".jpeg").put(files[0]);
  
    // progress upload
    uploadTask.on('state_changed', function (snapshot) {
      var progress = parseInt(snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      document.getElementById('upProgress').innerHTML = 'Upload ' + progress + '%';
      progressBar(progress);
    },
      // onerror
      function (e) {
        alert('error in saving the image');
      },
      // link update to database
      function () {
        uploadTask.snapshot.ref.getDownloadURL().then(function (url) {
          ImgUrl = url;
          firebase.database().ref('Images/' + clnt + "/" + ImgName + "/" + RendowmImagName).set({
            Name: RendowmImagName,
            Link: ImgUrl
          });
          alert('Image Uploaded successfully');
        })
      });
  }
  