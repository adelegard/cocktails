$(function() {

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
        $(".raty_star_not_rated").hide();
        $(".raty_star_rated").show();
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

  $("ul.recipe_ingredients .full_ingredient").click(function() {
  	var li_ingredient = $(this).closest("li.ingredient");
  	var val = li_ingredient.find(".the_ingredient").html();
  	var new_title;
  	if (li_ingredient.hasClass("in_liquor_cabinet")) {
	  	removeFromLiquorCabinet(val);
	  	new_title = "Click to Add to Liquor Cabinet";
  	} else {
  		addToLiquorCabinet(val);
  		new_title = "Click to Remove from Liquor Cabinet";
  	}
  	$(this).attr("title", new_title);
  	addTooltipToElement($(this));
  	li_ingredient.toggleClass("in_liquor_cabinet");
  	li_ingredient.toggleClass("not_in_liquor_cabinet");
  	li_ingredient.find("i").toggleClass("icon-remove");
  	li_ingredient.find("i").toggleClass("icon-ok");
  });

});