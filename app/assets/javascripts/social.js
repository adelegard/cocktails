$(function() {
    $(".socialicons li a").on("click", function() {
        $(".modal").modal("hide");
    });
    $(".socialicons li a.facebook").on("click", function() {
        var url = $('#comments.tab-pane .disqus_url').val();
        var img_url = $('.base_url').val();
        img_url = img_url + $('#drink_thumb a img').attr("src");

        var recipe_title = $('.recipe_title').text();
        fb_postToFeed(url, img_url, recipe_title);
    });
    $(".socialicons li a.gpluslight").on("click", function() {
        window.open($(this).attr("data-href"),'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');
        return false;
    });
    $(".socialicons li a.delicious").on("click", function() {
        window.open('http://www.delicious.com/save?v=5&noui&jump=close&url='
            +encodeURIComponent(location.href)
            +'&title='
            +encodeURIComponent(document.title), 'delicious','toolbar=no,width=550,height=550');
        return false;
    });
    $(".socialicons li a.pinterest").on("click", function() {
        window.open($(this).attr("data-href"),'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=300,width=600');
        return false;
    });
});