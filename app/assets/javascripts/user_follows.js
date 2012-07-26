$(function() {

    $('.follow, .unfollow').click(function(e) {
        var self = $(e.target);
        var href = self.attr("data-href");
        $.ajax({
        url: href,
        success: function(){
            if (self.hasClass("unfollow")) {
                self.prev(".follow").show();
            } else {
                self.next(".unfollow").show();
            }
            self.hide();
        }
        });
    });

});