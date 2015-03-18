//= require openseadragon/jquery

(function($) {
  function initOpenSeadragon() {
    $('picture[data-openseadragon]').openseadragon();
  }

  $(document).on('page:load', initOpenSeadragon);
  $(document).ready(initOpenSeadragon);
})(jQuery);