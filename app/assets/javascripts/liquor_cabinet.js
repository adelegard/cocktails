$(document).ready(function() {
  $('#cabinet_ingredient_search').keydown(function(e) {
  	if (e.which == 13) {
	  	var val = $(this).val();
	  	var inCabinet = checkLiquorCabinet(val);
	  	if (inCabinet === false) {
			addToLiquorCabinet(val);
	  	}
  	}
  });

  $('#add_cabinet_ingredient').click(function() {
  	var val = $("#cabinet_ingredient_search").val();
  	var inCabinet = checkLiquorCabinet(val);
  	if (inCabinet === false) {
		addToLiquorCabinet(val);
  	}
  });

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

  function addToLiquorCabinet(val) {
	$.ajax({
	  url: '/cabinet/add',
	  data: {q: val},
	  success: function(data) {
		var row = "<tr><td><i class='icon-remove'></i><div class='lc_ingredient dib'>" + val + "</div></td></tr>";
		$("#my_ingredients tbody").append(row);  
	  }
	});
  }

  $(document).on("click", "#my_ingredients tbody tr td .icon-remove", function(e) {
	var therow = $(e.currentTarget).closest("tr");
  	var val = therow.find(".lc_ingredient").html();
  	removeFromLiquorCabinet(val, therow);
  });

  function removeFromLiquorCabinet(val, therow) {
	$.ajax({
	  url: '/cabinet/remove',
	  data: {q: val},
	  success: function(data) {
	  	$(therow).empty().remove();
	  }
	});
  }
});