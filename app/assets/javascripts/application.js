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
//= require jquery3
//= require jquery_ujs
//= require activestorage
//= require turbolinks
//= require_tree .

// Set up picnic CSS image upload widget
document.addEventListener("turbolinks:load", function() {
  [].forEach.call(document.querySelectorAll('.dropimage'), function(img){
    img.onchange = function(e){
      var inputfile = this, reader = new FileReader();
      reader.onloadend = function(){
        inputfile.style['background-image'] = 'url('+reader.result+')';
      }
      reader.readAsDataURL(e.target.files[0]);
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

// Set up Trumbowyg WYSIWYG editor
document.addEventListener('turbolinks:load', function() {
  $('.richtext').trumbowyg({
    // I have to vendor this file because CloudFlare's CDN refuses to set broad
    // CORS headers that would permit the SVG file to be loaded on localhost.
    svgPath: '/trumbowyg.svg',
    btns: [
      ['undo', 'redo'], // Only supported in Blink browsers
      ['formatting'],
      ['strong', 'em', 'del'],
      ['link'],
      ['image'],
      ['unorderedList', 'orderedList'],
      ['horizontalRule'],
      ['removeformat'],
      ['viewHTML'],
      ['fullscreen'],
    ],
    btnsDef: {
      // I think the "Upload" image is confusing and not what someone would
      // likely click; this is the best I can do without a lot of effort.
      // Leaving the URL option in (called 'Insert Image") will probably be
      // confusing also as the text implies it'll be the best choice but
      // in most cases will not be.
      image: {
        dropdown: ['upload'],
        ico: 'insertImage'
      }
    },
    resetCss: true,
    minimalLinks: true, // Don't show title and target fields
    removeformatPasted: true,

    plugins: {
      upload: {
        serverPath: '/image_uploads',
        fileFieldName: 'image',
        urlPropertyName: 'url',
        //imageWidthModalEdit: true,
      }
    }
  });
});
