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
});