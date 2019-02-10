// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//
//= require rails-ujs
//= require jquery3
//= require activestorage
//= require turbolinks
//= require_tree .

document.addEventListener("DOMContentLoaded", function() {
  [].forEach.call(document.querySelectorAll('.dropimage'), function(img){
    img.onchange = function(e){
      var inputfile = this, reader = new FileReader();
      reader.onloadend = function(){
        inputfile.style['background-image'] = 'url('+reader.result+')';
      }
      reader.readAsDataURL(e.target.files[0]);
      console.log("FIle after upload:", e.target.files[0]);
    }
  });

  // If the image was populated on page load (happens when someone hits back
  // to a form they already filled out), then we need to send a synthetic
  // event to cause it to be displayed by the code above
  [].forEach.call(document.querySelectorAll('.dropimage input'), function(input){
    if (input.files.length > 0) {
      input.dispatchEvent(new Event('change', {bubbles: true}));
    }
  });
});
