$(function() {
    $(document).on("click", ".socialicons li a", function() {
        $(".modal").modal("hide");
    });
    $(document).on("click", ".socialicons li a.facebook", function() {
        var url = $(this).attr("data-url");
        var title = $(this).attr("data-title");
        var img_url = $(this).attr("data-photo-url");
        fb_postToFeed(url, img_url, title);
    });
    $(document).on("click", ".socialicons li a.gpluslight", function() {
        window.open($(this).attr("data-href"),'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');
        return false;
    });
    $(document).on("click", ".socialicons li a.delicious", function() {
        window.open('http://www.delicious.com/save?v=5&noui&jump=close&url='+
            encodeURIComponent(location.href)+
            '&title='+
            encodeURIComponent(document.title), 'delicious','toolbar=no,width=550,height=550');
        return false;
    });
    $(document).on("click", ".socialicons li a.pinterest", function() {
        window.open($(this).attr("data-href"),'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=300,width=600');
        return false;
    });
});
var add_pinterest_btn = function(iframe_selector, insert_before_selector, page_url, photo_url, description) {
    $(iframe_selector).remove();
    $(insert_before_selector).before("<a class='pin-it-button' count-layout='none' href='http://pinterest.com/pin/create/button/?url="+
        page_url + "&media=" + photo_url + "&description=" + description + "'>" +
        "<img border = '0' src = '//assets.pinterest.com/images/PinExt.png' title = 'Pin It'/></a>");
};