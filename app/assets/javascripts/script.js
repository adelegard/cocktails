$(document).ready(function() {
	$(".chzn-select").chosen();

  $('.carousel').carousel({
    interval: 10000
  });

  $("[rel='tooltip']").each(function() {
    addTooltipToElement($(this));
  });

  function addTooltipToElement(elem) {
    elem.tooltip({
      delay: { show: 1000, hide: 50 },
      placement: elem.attr("data-placement") != undefined ? elem.attr("data-placement") : "top"
    });
  }

	$.ajaxSetup({
		'beforeSend': function(xhr) {
			xhr.setRequestHeader('Accept','text/javascript')
		}
	});

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


  $('input.recipe_ac').autocomplete({
    source: function(request, response) {
      var params = getAutoCompleteRecipeParams(request.term);
      $.ajax({
        url: params['url'],
        dataType: "jsonp",
        data: params['data'],
        success: function(data) {
          response(data);
        }
      });
    },
    close: function(event, ui){
    	$(this).closest('form').submit();
    },
    minLength: 2,
    delay: 300
  });

  $('input.ingridients_ac').autocomplete({
    source: function(request, response) {
      var params = getAutoCompleteIngredientsParams(request.term);
      $.ajax({
        url: params['url'],
        dataType: "jsonp",
        data: params['data'],
        success: function(data) {
          response(data);
        }
      });
    },
    minLength: 2,
    delay: 300
  });

  function getAutoCompleteRecipeParams(term) {
    params = {};
    params['url'] = '/search/autocomplete_recipes';
    dataHash = {}
    dataHash.q = term
    params['data'] = dataHash;
    return params;
  }

  function getAutoCompleteIngredientsParams(term) {
    params = {};
    params['url'] = '/search/autocomplete_ingredients';
    dataHash = {}
    dataHash.q = term
    params['data'] = dataHash;
    return params;
  }
});