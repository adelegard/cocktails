$(document).ready(function() {
  $('#cabinet_ingredient_search').keydown(function(e) {
  	if (e.which == 13) {
	  	var val = $(this).val();
		addToLiquorCabinet(val, function() {
			var row = "<tr><td><i class='icon-remove'></i><div class='lc_ingredient dib'>" + val + "</div></td></tr>";
			$("#my_ingredients tbody").append(row);
		});
  	}
  });

  $('#add_cabinet_ingredient').click(function() {
  	var val = $("#cabinet_ingredient_search").val();
	addToLiquorCabinet(val, function() {
		var row = "<tr><td><i class='icon-remove'></i><div class='lc_ingredient dib'>" + val + "</div></td></tr>";
		$("#my_ingredients tbody").append(row);
	});
  });

  function canAddToLiquorCabinet(val) {
  	if (val === "") return false;
  	if (checkLiquorCabinet(val) === false) return true;
  	return false;
  }

  function checkLiquorCabinet(val) {
  	var returnVal = false;
	$("#my_ingredients tbody tr td .lc_ingredient").each(function() {
		if (this.innerHTML === val) {
			returnVal = true;
			return returnVal;
		}
	});
	return returnVal;
  }

  function addToLiquorCabinet(val, callback) {
	if (canAddToLiquorCabinet(val) === false) return;
	$.ajax({
	  url: '/cabinet/add',
	  data: {q: val},
	  success: function(data) {
	  	if (callback != undefined) callback();
	  }
	});
  }

  $(document).on("click", "#my_ingredients tbody tr td .icon-remove", function(e) {
	var therow = $(e.currentTarget).closest("tr");
  	var val = therow.find(".lc_ingredient").html();
  	removeFromLiquorCabinet(val, function() {
  		$(therow).empty().remove();
  	});
  });

  function removeFromLiquorCabinet(val, callback) {
	$.ajax({
	  url: '/cabinet/remove',
	  data: {q: val},
	  success: function(data) {
	  	if (callback != undefined) callback();
	  }
	});
  }

  // Recipe functions
  $("ul.recipe_ingredients .full_ingredient").click(function() {
  	var li_ingredient = $(this).closest("li.ingredient");
  	var val = li_ingredient.find(".the_ingredient").html();
  	if (li_ingredient.hasClass("in_liquor_cabinet")) {
	  	removeFromLiquorCabinet(val);
  	} else {
		addToLiquorCabinet(val);
  	}
	li_ingredient.toggleClass("in_liquor_cabinet");
	li_ingredient.toggleClass("not_in_liquor_cabinet");
	li_ingredient.find("i").toggleClass("icon-remove");
	li_ingredient.find("i").toggleClass("icon-ok");
  });
});