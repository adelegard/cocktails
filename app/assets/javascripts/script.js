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

  $("select.chzn-select.ingridients_ac").ajaxChosen({
      method: 'GET',
      url: '/search/autocomplete_ingredients',
      dataType: 'json',
      jsonTermKey: 'q'
  }, function (data) {
      var terms = {};
      $.each(data, function (i, val) {
          terms[i] = val;
      });
      return terms;
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