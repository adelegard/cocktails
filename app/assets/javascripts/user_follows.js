$(function() {

    $('.follow, .unfollow').click(function(e) {
        var self = $(e.target);
        var href = self.attr("data-href");
        $.ajax({
        url: href,
        success: function(){
            if (self.hasClass("unfollow")) {
                self.prev(".follow").addClass("dib").show();
            } else {
                self.next(".unfollow").addClass("dib").show();
            }
            self.hide();
        }
        });
    });

});