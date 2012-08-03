if (typeof(Cocktails) === 'undefined') {
  Cocktails = {};
}

if (typeof(Cocktails.RatyHelper) === 'undefined') {
  Cocktails.RatyHelper = {
    _init: function() {
      /* raty "star" plugin http://www.wbotelhos.com/raty/ */
      /* large stars */
      $('.raty_star_not_rated').raty(this.getRatyStarOptions({isRated: false, smallStars: false}));
      $('.raty_star_rated').raty(this.getRatyStarOptions({isRated: true, smallStars: false}));

      /* small stars */
      $('.raty_small_star_not_rated').raty(this.getRatyStarOptions({isRated: false, smallStars: true}));
      $('.raty_small_star_rated').raty(this.getRatyStarOptions({isRated: true, smallStars: true}));

      /* show and hide the two different elements on mouseenter/leave */
      $('.stars').bind("mouseenter", function() {
        $(this).find('.raty_star_not_rated').hide();
        $(this).find('.raty_star_rated').show();
      }).bind("mouseleave", function() {
        $(this).find('.raty_star_not_rated').show();
        $(this).find('.raty_star_rated').hide();
      });
    },

    getRatyStarOptions: function(attr) {
      var size = attr.smallStars ? 18 : 30;
      var read_only = attr.smallStars ? true : false;
      var starOffImg = attr.smallStars ? 'stars_sm_single_off.gif' : 'stars_lg_single_off.gif';
      var starHalfImg = attr.smallStars ? 'stars_sm_half.gif' : 'stars_lg_half.gif';
      var starOnImg = attr.smallStars ? 'stars_sm_single.gif' : 'stars_lg_single.gif';
      if (typeof attr.isRated !== 'undefined' && attr.isRated) {
        starHalfImg = attr.smallStars ? 'stars_sm_half_orange.gif' : 'stars_lg_half_orange.gif';
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
            Cocktails.RatyHelper.rateRecipe($("#recipe_id").val(), score);
          }
        }
      };
    },

    rateRecipe: function(recipe_id, rating) {
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
          count = parseInt(count, 10);
          count = count+1;
          $("#recipe_rating_count_num").html(count);
          $(".recipe_rating_count").effect("highlight", {}, 3000);
        }
      });
    }


  };
}