$(document).ready(function() {
	$("a.showFullPageView").click(function() {
		$("#fullPageView").fadeIn("slow");
	});

	$("#fullPageView a.close_circle").click(function() {
		$("#fullPageView").fadeOut("slow");
	});
});