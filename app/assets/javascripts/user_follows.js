$(function() {

    $('.follow, .unfollow').click(function(e) {
        var self = $(e.target);
        var href = self.attr("data-href");
        $.ajax({
        url: href,
        success: function(){
            var followers = $('.stats .followers');
            var num_followers = parseInt(followers.text());
            if (self.hasClass("unfollow")) {
                self.prev(".follow").addClass("dib").show();
                num_followers = num_followers - 1;
                followers.text(num_followers);
            } else {
                self.next(".unfollow").addClass("dib").show();
                num_followers = num_followers + 1;
                followers.text(num_followers);
            }
            self.hide();
        }
        });
    });

});