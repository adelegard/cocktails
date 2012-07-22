//Initialize disqus global vars
var disqus_shortname = 'bombcocktails';
var disqus_identifier; //made of post id &nbsp; guid
var disqus_url; //post permalink
var disqus_developer = 1; // developer mode is on

$(function() {

  function loadDisqus(source, identifier, url, callback) {
    $('#disqus_thread').remove();
    jQuery('<div id="disqus_thread"></div>').insertBefore(source);

    if (window.DISQUS) {
      //if Disqus exists, call it's reset method with new parameters
      DISQUS.reset({
        reload: true,
        config: function () {
          this.page.identifier = identifier;
          this.page.url = url;
          if (typeof(callback) !== 'undefined') callback();
        }
      });
    } else {
      disqus_identifier = identifier; //set the identifier argument
      disqus_url = url; //set the permalink argument

      //append the Disqus embed script to HTML
      var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
      dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
      jQuery('head').append(dsq);

      if (typeof(callback) !== 'undefined') callback();
    }
  }

  // We only want these styles applied when javascript is enabled
  $('div.navigation').css({'width' : '350px', 'float' : 'left'});
  $('div.content').css('display', 'block');
  // Initially set opacity on thumbs and add
  // additional styling for hover effect on thumbs
  var onMouseOutOpacity = 0.75;
  $('#thumbs ul.thumbs li').opacityrollover({
    mouseOutOpacity:   onMouseOutOpacity,
    mouseOverOpacity:  1.0,
    fadeSpeed:         'fast',
    exemptionSelector: '.selected'
  });

  if ($("#thumbs")[0]) {
  // Initialize Advanced Galleriffic Gallery
  var gallery = $('#thumbs').galleriffic({
      delay:                     3000, // in milliseconds
      numThumbs:                 10, // The number of thumbnails to show page
      preloadAhead:              40, // Set to -1 to preload all images
      enableTopPager:            true,
      enableBottomPager:         false,
      maxPagesToShow:            7,  // The maximum number of pages to display in either the top or bottom pager
      imageContainerSel:         '#slideshow', // The CSS selector for the element within which the main slideshow image should be rendered
      controlsContainerSel:      '#controls', // The CSS selector for the element within which the slideshow controls should be rendered
      captionContainerSel:       '#caption', // The CSS selector for the element within which the captions should be rendered
      loadingContainerSel:       '#loading', // The CSS selector for the element within which should be shown when an image is loading
      renderSSControls:          true, // Specifies whether the slideshow's Play and Pause links should be rendered
      renderNavControls:         true, // Specifies whether the slideshow's Next and Previous links should be rendered
      playLinkText:              'Play',
      pauseLinkText:             'Pause',
      prevLinkText:              'Previous',
      nextLinkText:              'Next',
      nextPageLinkText:          'Next &rsaquo;',
      prevPageLinkText:          '&lsaquo; Prev',
      enableHistory:             false, // Specifies whether the url's hash and the browser's history cache should update when the current slideshow image changes
      enableKeyboardNavigation:  true, // Specifies whether keyboard navigation is enabled
      autoStart:                 false, // Specifies whether the slideshow should be playing or paused when the page first loads
      syncTransitions:           false, // Specifies whether the out and in transitions occur simultaneously or distinctly
      defaultTransitionDuration: 1000, // If using the default transitions, specifies the duration of the transitions

      onSlideChange:             function(prevIndex, nextIndex) { // accepts a delegate like such: function(prevIndex, nextIndex) { ... }
        // 'this' refers to the gallery, which is an extension of $('#thumbs')
        this.find('ul.thumbs').children()
                .eq(prevIndex).fadeTo('fast', onMouseOutOpacity).end()
                .eq(nextIndex).fadeTo('fast', 1.0);
      },
      onPageTransitionOut:      undefined,
      onPageTransitionIn:       undefined,
      onTransitionOut:          undefined, // accepts a delegate like such: function(slide, caption, isSync, callback) { ... }
      onTransitionIn:            function(slide, caption, isSync) { // accepts a delegate like such: function(slide, caption, isSync) { ... }
        //caption.children().first().prepend('<div id="disqus_thread"></div>');
        var the_caption = caption.children().first();
        var ident = caption.find("input.disqus_identifier").val();
        var url = caption.find("input.disqus_url").val();
        
        slide.fadeTo('slow', 1.0);
        loadDisqus(the_caption, ident, url, function() {
          caption.fadeTo('fast', 1.0);
        });
      },
      onImageAdded:              undefined, // accepts a delegate like such: function(imageData, $li) { ... }
      onImageRemoved:            undefined  // accepts a delegate like such: function(imageData, $li) { ... }
  }); 
  }

  $('li.comments_tab').click(function() {
    if ($('#comments.tab-pane #disqus_thread').length !== 0) return;
    loadDisqus($('#comments.tab-pane .disqus_identifier'), 
      $('#comments.tab-pane .disqus_identifier').val(), 
      $('#comments.tab-pane .disqus_url').val());
  });
  $('li.photos_tab').click(function() {
    if ($('#photos.tab-pane #disqus_thread').length !== 0) return;
    loadDisqus($('#photos.tab-pane #caption .disqus_identifier'), 
      $('#photos.tab-pane #caption .disqus_identifier').val(), 
      $('#photos.tab-pane #caption .disqus_url').val());
  });

  $('#photos_modal .thumb').click(function(e) {
    $('#photos_modal .thumb').removeClass("active");
    $(this).addClass("active");

    $('#main_img').attr('src',$(this).attr('src').replace('tiny','medium'));
  });
  $('img.icon').click(function(e) {
    $("#photo_modal").modal('show');
    $('img.main_img').attr('src',$(this).attr('src').replace('icon','large'));
  });


  $('.modal .close').click(function(e) {
    $(this).closest('.modal').modal('hide');
  });

  $('#photos_modal').on('show', function(){
    $(document).on("keyup.photo_key", function(e) {
      if (e.which == 37) { /* left arrow */
        var active_thumb = $(".thumbs .thumb.active");
        if (active_thumb.prev(".thumb").length === 1) {
          active_thumb.removeClass("active").prev(".thumb").addClass("active").trigger("click");
        }
      } else if (e.which == 39) { /* right arrow */
        var active_thumb = $(".thumbs .thumb.active");
        if (active_thumb.next(".thumb").length === 1) {
          active_thumb.removeClass("active").next(".thumb").addClass("active").trigger("click");
        }
      }
    });
  });
  $('#photos_modal').on('hide', function(){
    $(document).off("keyup.photo_key");
  });


  /* raty "star" plugin http://www.wbotelhos.com/raty/ */
  /* large stars */
  $('.raty_star_not_rated').raty(getRatyStarOptions({isRated: false, smallStars: false}));
  $('.raty_star_rated').raty(getRatyStarOptions({isRated: true, smallStars: false}));

  /* small stars */
  $('.raty_small_star_not_rated').raty(getRatyStarOptions({isRated: false, smallStars: true}));
  $('.raty_small_star_rated').raty(getRatyStarOptions({isRated: true, smallStars: true}));

  function getRatyStarOptions(attr) {
    var size = attr.smallStars ? 18 : 30;
    var read_only = attr.smallStars ? true : false;
    var starOffImg = attr.smallStars ? 'stars_sm_single_off.gif' : 'stars_lg_single_off.gif';
    var starHalfImg = attr.smallStars ? 'stars_sm_half.gif' : 'stars_lg_half.gif'
    var starOnImg = attr.smallStars ? 'stars_sm_single.gif' : 'stars_lg_single.gif';
    if (typeof attr.isRated !== 'undefined' && attr.isRated) {
      starHalfImg = attr.smallStars ? 'stars_sm_half_orange.gif' : 'stars_lg_half_orange.gif'
      starOnImg = attr.smallStars ? 'stars_sm_single_orange.gif' : 'stars_lg_single_orange.gif';
    }
    return {
      size:      size,
      half:      true,
      readOnly:  read_only,
      starOff:   starOffImg,
      starHalf:  starHalfImg,
      starOn:    starOnImg,
      path:      "/assets/raty",
      hintList:  ['Terrible', 'Not Great', 'Ok', 'Good', 'Amazing'],
      start: function() {
        return $(this).attr('data-rating');
      },
      click: function(score, evt) {
        // Don't let them rate the small ones!
        if (!attr.smallStars) {
          rateRecipe($("#recipe_id").val(), score);
        }
      }
    }
  }

  jQuery('.stars').bind("mouseenter", function() {
    jQuery(this).find('.raty_star_not_rated').hide();
    jQuery(this).find('.raty_star_rated').show();
  }).bind("mouseleave", function() {
    jQuery(this).find('.raty_star_not_rated').show();
    jQuery(this).find('.raty_star_rated').hide();
  });

  function rateRecipe(recipe_id, rating) {
    $.ajax({
      type: "POST",
      url: '/recipes/rate',
      data: {recipe_id: recipe_id,
             rating: rating},
      success: function(data) {
        $(".stars").unbind("mouseenter");
        $(".stars").unbind("mouseleave");

        $("#rating_thanks").show();
        $("#rating_thanks").effect("highlight", {}, 3000);
        var is_rated = $("#recipe_is_rated");
        if (is_rated.val() === "true") {
          return false;
        }

        is_rated.val("true");
        $(".raty_star_not_rated").hide();
        $(".raty_star_rated").show();
        var count = $("#recipe_rating_count_num").html();
        count = parseInt(count);
        count = count+1;
        $("#recipe_rating_count_num").html(count);
        $(".recipe_rating_count").effect("highlight", {}, 3000);
      }
    });
  }

  $("a.showFullPageView").click(function() {
    $("#fullPageView").fadeIn("slow");
  });

  $("#fullPageView a.close_circle").click(function() {
    $("#fullPageView").fadeOut("slow");
  });

  $(document).on("click", ".favorite", function(e) {
    e.preventDefault();
    var href = $(e.currentTarget).attr("href");
    $.ajax({
      url: href,
      success: function(){
        $(e.currentTarget).closest(".favorite-links").find(".favorite-container").hide();
        $(e.currentTarget).closest(".favorite-links").find(".unfavorite-container").show();
      }
    });
  });
  $(document).on("click", ".unfavorite", function(e) {
    e.preventDefault();
    var href = $(e.currentTarget).attr("href");
    $.ajax({
      url: href,
      success: function(){
        $(e.currentTarget).closest(".favorite-links").find(".favorite-container").show();
        $(e.currentTarget).closest(".favorite-links").find(".unfavorite-container").hide();
      }
    });
  });

  $(document).on("click", ".btn-group.share > a", function(e) {
    socialBtnClicked(e, true);
  });
  $(document).on("click", ".btn-group.like > a, .btn-group.save > a", function(e) {
    socialBtnClicked(e);
  });

  function socialBtnClicked(e, share_clicked) {
    var btn_grp = $(e.target).closest(".btn-group");
    var num_liked_btn = btn_grp.find("a:nth-child(2)");
    var num = parseInt(num_liked_btn.text(),10);
    if (btn_grp.find("a:nth-child(1)").hasClass("disabled")) {
      num_liked_btn.text(num-1);
    } else {
      num_liked_btn.text(num+1);
    }
    if (typeof(share_clicked) === 'undefined') btn_grp.find("a").toggleClass("disabled");

    $.ajax({
      url: $(e.currentTarget).attr("data-href")
    });
  }

  $(document).on({
      mouseenter: function () {
        $(this).find("input:checkbox").attr("checked", true);
      },

      mouseleave: function () {
        var vote_btn = $(this);
        if (!vote_btn.hasClass("voted")) vote_btn.find("input:checkbox").removeAttr("checked");
      }
  }, ".vote_container .vote_button:not(.voted)");

  $(".vote_container .vote_button").click(function() {
    var vote_btn = $(this);
    vote_btn.closest(".vote_container").find(".vote_button").removeClass("voted");
    vote_btn.closest(".vote_container").find("input:checkbox").removeAttr("checked");
    vote_btn.find("input:checkbox").attr("checked", true);
    vote_btn.addClass("voted");
    return false;
  });

});