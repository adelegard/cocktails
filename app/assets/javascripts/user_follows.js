$(function() {

    $('.follow').click(function(e) {
        var self = $(e.target);
        $.ajax({
            url: "/user/" + self.attr("data-id") + "/follow",
            type: "POST",
            success: function(){
                var followers = $('.stats .followers');
                var num_followers = parseInt(followers.text(), 10);
                self.next(".unfollow").addClass("dib").show();
                num_followers = num_followers + 1;
                followers.text(num_followers);
                self.hide();
            }
        });
    });

    $('.unfollow').click(function(e) {
        var self = $(e.target);
        $.ajax({
            url: "/user/" + self.attr("data-id") + "/unfollow",
            type: "DELETE",
            success: function(){
                var followers = $('.stats .followers');
                var num_followers = parseInt(followers.text(), 10);
                self.prev(".follow").addClass("dib").show();
                num_followers = num_followers - 1;
                followers.text(num_followers);
                self.hide();
            }
        });
    });

});