//= require openseadragon

(function($) {
  var __osd_counter = 0;
  function generateOsdId() {
    __osd_counter++;
    
    return "Openseadragon" + __osd_counter;
  }

  function initOpenSeadragon() {
    $('picture[data-openseadragon]').each(function() {
      var $picture = $(this);
      
      if (typeof $picture.attr('id') === "undefined") {
        $picture.attr('id', generateOsdId());
      }

      var collectionOptions = $picture.data('openseadragon');
      
      var sources = $picture.find('source[media="openseadragon"]');

      var tilesources = $.map(sources, function(e) {
        if ($(e).data('openseadragon')) {
          return $(e).data('openseadragon');
        } else {
          return $(e).attr('src');
        }
      });
      
      $picture.css("display", "block");
      $picture.css("height", "500px");

      $picture.data('osdViewer', OpenSeadragon(
        $.extend({ id: $picture.attr('id') }, collectionOptions, { tileSources: tilesources })
      ));
    });
  };

  window.onload = initOpenSeadragon;
  document.addEventListener("page:load", initOpenSeadragon);
})(jQuery);