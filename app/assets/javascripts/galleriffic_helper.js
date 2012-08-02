if (typeof(Cocktails) === 'undefined') {
  Cocktails = {};
}

if (typeof(Cocktails.GallerifficHelper) === 'undefined') {
  Cocktails.GallerifficHelper = {
    _init: function() {
      // We only want these styles applied when javascript is enabled
      $('div.navigation').css({
        'width': '350px',
        'float': 'left'
      });
      $('div.content').css('display', 'block');
      // Initially set opacity on thumbs and add
      // additional styling for hover effect on thumbs
      var onMouseOutOpacity = 0.75;
      $('#thumbs ul.thumbs li').opacityrollover({
        mouseOutOpacity: onMouseOutOpacity,
        mouseOverOpacity: 1.0,
        fadeSpeed: 'fast',
        exemptionSelector: '.selected'
      });

      if ($("#thumbs")[0]) {
        // Initialize Advanced Galleriffic Gallery
        var gallery = $('#thumbs').galleriffic({
          delay: 3000, // in milliseconds
          numThumbs: 10, // The number of thumbnails to show page
          preloadAhead: 40, // Set to -1 to preload all images
          enableTopPager: true,
          enableBottomPager: false,
          maxPagesToShow: 7, // The maximum number of pages to display in either the top or bottom pager
          imageContainerSel: '#slideshow', // The CSS selector for the element within which the main slideshow image should be rendered
          controlsContainerSel: '#controls', // The CSS selector for the element within which the slideshow controls should be rendered
          captionContainerSel: '#caption', // The CSS selector for the element within which the captions should be rendered
          loadingContainerSel: '#loading', // The CSS selector for the element within which should be shown when an image is loading
          renderSSControls: true, // Specifies whether the slideshow's Play and Pause links should be rendered
          renderNavControls: true, // Specifies whether the slideshow's Next and Previous links should be rendered
          playLinkText: 'Play',
          pauseLinkText: 'Pause',
          prevLinkText: 'Previous',
          nextLinkText: 'Next',
          nextPageLinkText: 'Next &rsaquo;',
          prevPageLinkText: '&lsaquo; Prev',
          enableHistory: false, // Specifies whether the url's hash and the browser's history cache should update when the current slideshow image changes
          enableKeyboardNavigation: true, // Specifies whether keyboard navigation is enabled
          autoStart: false, // Specifies whether the slideshow should be playing or paused when the page first loads
          syncTransitions: false, // Specifies whether the out and in transitions occur simultaneously or distinctly
          defaultTransitionDuration: 1000, // If using the default transitions, specifies the duration of the transitions
          onSlideChange: function(prevIndex, nextIndex) { // accepts a delegate like such: function(prevIndex, nextIndex) { ... }
            // 'this' refers to the gallery, which is an extension of $('#thumbs')
            this.find('ul.thumbs').children().eq(prevIndex).fadeTo('fast', onMouseOutOpacity).end().eq(nextIndex).fadeTo('fast', 1.0);
          },
          onPageTransitionOut: undefined,
          onPageTransitionIn: undefined,
          onTransitionOut: undefined, // accepts a delegate like such: function(slide, caption, isSync, callback) { ... }
          onTransitionIn: function(slide, caption, isSync) { // accepts a delegate like such: function(slide, caption, isSync) { ... }
            var the_caption = caption.children().first();
            var ident = caption.find("input.disqus_identifier").val();
            var url = caption.find("input.disqus_url").val();

            slide.fadeTo('slow', 1.0);
            Cocktails.DisqusHelper.load_disqus(the_caption, ident, url, function() {
              caption.fadeTo('fast', 1.0);
            });
          },
          onImageAdded: undefined, // accepts a delegate like such: function(imageData, $li) { ... }
          onImageRemoved: undefined // accepts a delegate like such: function(imageData, $li) { ... }
        });
      }
    }
  }
}