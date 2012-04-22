$(document).ready(function() {

  $("ul.recipe_ingredients .full_ingredient").click(function() {
  	var li_ingredient = $(this).closest("li.ingredient");
  	var val = li_ingredient.find(".the_ingredient").html();
  	var new_title;
  	if (li_ingredient.hasClass("in_liquor_cabinet")) {
	  	removeFromLiquorCabinet(val);
	  	new_title = "Click to Add to Liquor Cabinet";
  	} else {
  		test();
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