$(document).ready(function() {
	$(".chzn-select").chosen();

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
		  url: e.target.href,
		  success: function(){
		  	$(e.currentTarget).closest(".favorite-links").find(".favorite-container").show();
			$(e.currentTarget).closest(".favorite-links").find(".unfavorite-container").hide();
		  }
		});
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

  function getAutoCompleteIngredientsParams(term) {
    params = {};
    params['url'] = '/search/autocomplete_ingredients';
    dataHash = {}
    dataHash.q = term
    params['data'] = dataHash;
    return params;
  }
});