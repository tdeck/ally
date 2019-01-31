// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


window.addEventListener('load', function () {
  // I have to vendor this file because CloudFlare's CDN refuses to set broad CORS headers
  // that would permit the SVG file to be loaded on localhost.
  $.trumbowyg.svgPath = '/trumbowyg.svg';

  $('.richtext').trumbowyg({
    btns: [
      ['viewHTML'],
      ['undo', 'redo'], // Only supported in Blink browsers
      ['formatting'],
      ['strong', 'em', 'del'],
      ['link'],
      // ['insertImage'],
      ['unorderedList', 'orderedList'],
      ['horizontalRule'],
      ['removeformat'],
      ['fullscreen'],
    ],
    resetCss: true
  });
}, false);
