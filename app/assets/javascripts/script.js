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
			$(e.currentTarget).removeClass("favorite");
			$(e.currentTarget).addClass("no-favorite");
		  }
		});
	});
	$(document).on("click", ".no-favorite", function(e) {
		e.preventDefault();
		var href = $(e.currentTarget).attr("href");
		$.ajax({
		  url: e.target.href,
		  success: function(){
			$(e.currentTarget).removeClass("no-favorite");
			$(e.currentTarget).addClass("favorite");
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

  $('#cabinet_ingredient_search').keydown(function(e) {
  	if (e.which == 13) {
  		addToLiquorCabinetForm($(this).val());
  	}
  });

  $('#add_cabinet_ingredient').click(function(e) {
	addToLiquorCabinetForm($(this).val());
  });

  function addToLiquorCabinetForm(val) {
	var exists = $('table#my_ingredients input[name="ingredients[\''+ val +'\']"]:hidden').length;
	if (exists > 0) return;

	var input = "<input type=\"hidden\" name=\"ingredients['"+ val +"']\"/>";
	var row = "<tr><td>" + input + val + "</td></tr>";
	$("#my_ingredients tbody").append(row);  	
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