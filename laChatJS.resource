(function($w,$d,undefined){
    if(/iPad|iPhone|iPod/.test(navigator.userAgent) && !$w.MSStream) {

        // moves the input text up so it's visible on load of the page
        $d.getElementsByTagName("html")[0].style.height = ($w.screen.availHeight - 88) + "px";
    } else {
        // shows standard save button in non IOS devices
        $d.getElementById('liveAgentSaveButton').style.display = 'block';
    }
})(window, document);