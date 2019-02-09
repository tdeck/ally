// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


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
      // ['insertImage'],
      ['unorderedList', 'orderedList'],
      ['horizontalRule'],
      ['removeformat'],
      ['viewHTML'],
      ['fullscreen'],
    ],
    resetCss: true
  });
});
