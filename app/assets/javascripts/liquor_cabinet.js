$(function() {

  function addIngredientSuccessCallback(val) {
      var temp_row = $("#my_ingredients tbody tr:first").clone();
      temp_row.find(".lc_ingredient .the_ingredient").html(val);
      temp_row.find("a.see_other").attr("href", "/search?spirit=" + val);
      $("#my_ingredients tbody").append(temp_row);
  }

  $('#cabinet_ingredient_search').keydown(function(e) {
    if (e.which !== 13) return;
    var val = $(this).val();
    if (canAddToLiquorCabinet(val) === false) return;
    addToLiquorCabinet(val, addIngredientSuccessCallback(val));
  });

  $('#add_cabinet_ingredient').click(function() {
    var val = $("#cabinet_ingredient_search").val();
    if (canAddToLiquorCabinet(val) === false) return;
    addToLiquorCabinet(val, addIngredientSuccessCallback(val));
  });

  $(".recipe_ingredients .toggle_in_lc").click(function() {
    var val = $(this).prev("input").val();
    var li_ingredient = $(this).closest("li.ingredient");
    var new_msg;
    if (li_ingredient.hasClass("in_liquor_cabinet")) {
        removeFromLiquorCabinet(val);
        new_msg = $("input.lc_add_message").val();
    } else {
        addToLiquorCabinet(val);
        new_msg = $("input.lc_remove_message").val();
    }
    $(this).text(new_msg);
    li_ingredient.toggleClass("in_liquor_cabinet not_in_liquor_cabinet");
    li_ingredient.prev("i").toggleClass("icon-remove icon-ok");
  });

  function canAddToLiquorCabinet(val) {
  	if (val === "") return false;
  	if (checkLiquorCabinet(val) === false) return true;
  	return false;
  }

  function checkLiquorCabinet(val) {
  	var returnVal = false;
  	$("#my_ingredients tbody tr td .lc_ingredient .the_ingredient").each(function() {
  		if (this.innerHTML === val) {
  			returnVal = true;
  			return returnVal;
  		}
  	});
  	return returnVal;
  }

  function addToLiquorCabinet(val, callback) {
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
    var val = therow.find(".lc_ingredient .the_ingredient").html();
  	removeFromLiquorCabinet(val, function() {
      therow.fadeOut('fast', function() {
        $(therow).empty().remove();
      });
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
});