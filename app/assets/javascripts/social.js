$(".fb_feed_post").on("click", function() {
    $(".modal").dialog("close");
    fb_postToFeed();
});