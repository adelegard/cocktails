$(function() {

  $('#photo_modal .thumb').click(function(e) {
    $('#photo_modal .thumb').removeClass("active");
    $(this).addClass("active");

    $('#main_img').attr('src',$(this).attr('src').replace('tiny','medium'));
  });
  $('#photo_modal .close').click(function() {
    $("#photo_modal").modal('hide');
  });

  $('#photo_modal').on('show', function(){
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
  })
  $('#photo_modal').on('hide', function(){
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