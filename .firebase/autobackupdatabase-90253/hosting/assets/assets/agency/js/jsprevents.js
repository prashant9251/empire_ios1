$(document).keydown(function (event) {
    console.log(event.keyCode);
    if (event.keyCode == 123) { // Prevent F12
        return false;
    } else if (event.ctrlKey && event.shiftKey && event.keyCode == 73) { // Prevent Ctrl+Shift+I        
        return false;
    } else if (event.ctrlKey && (event.keyCode== 85)) {
        // alert('Sorry, This Functionality Has Been Disabled!');
        //disable key press porcessing
        return false;
    }
});
$(document).on("contextmenu", function (e) {          
    e.preventDefault();
});

