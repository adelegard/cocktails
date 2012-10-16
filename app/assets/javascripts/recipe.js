if (typeof(Cocktails) === 'undefined') {
  Cocktails = {};
}

if (typeof(Cocktails.Recipe) === 'undefined') {
  Cocktails.Recipe = {
    _initialized: false,

    _init: function() {
      if(!this._initialized) {

        Cocktails.GallerifficHelper._init();

        $('li.comments_tab').on("click", this._load_comments_tab);
        $('li.photos_tab').on("click", this._load_photos_tab);

        // photos modal
        $('#photos_modal').on('show', this._show_photos_modal);
        $('#photos_modal').on('hide', this._hide_photos_modal);
        $('#photos_modal .thumb').on("click", this._load_thumb_fullsize_img);
        $('img.icon').on("click", this._load_icon_fullsize_img);

        // general modal
        $('.modal .close').on("click", this._close_modal);

        // full page view
        $("a.showFullPageView").on("click", this._show_fullpage_view);
        $("#fullPageView a.close_circle").on("click", this._hide_fullpage_view);

        // social button
        $(document).on("click", ".btn-group.share > a", this._share_btn_clicked);

        // favoriting
        $(document).on("click", ".recipe_actions .favorite-button[data-action='favorite']", this._recipe_favorited);
        $(document).on("click", ".recipe_actions .favorite-button[data-action='unfavorite']", this._recipe_unfavorited);
        // like
        $(document).on("click", ".recipe_actions .like-button[data-action='like']", this._recipe_liked);
        $(document).on("click", ".recipe_actions .like-button[data-action='unlike']", this._recipe_unliked);
        // dislike
        $(document).on("click", ".recipe_actions .dislike-button[data-action='dislike']", this._recipe_disliked);
        $(document).on("click", ".recipe_actions .dislike-button[data-action='undislike']", this._recipe_undisliked);
        //share
        $(document).on("click", ".recipe_actions .share-button[data-action='share']", this._recipe_shared);

        // voting widget (not currently doing anything real)
        $(document).on({
            mouseenter: function () {
              $(this).find("input:checkbox").attr("checked", true);
            },
            mouseleave: function () {
              var vote_btn = $(this);
              if (!vote_btn.hasClass("voted")) vote_btn.find("input:checkbox").removeAttr("checked");
            }
        }, ".vote_container .vote_button:not(.voted)");
        $(".vote_container .vote_button").on("click", this._vote_btn_clicked);

        this._initialized = true;
      }
    },

    /* Tab loading (Disqus) */
    _load_comments_tab: function() {
      var tab_pane = $('.comments_tab_content.tab-pane');
      Cocktails.DisqusHelper.load_disqus(tab_pane.find('.disqus_identifier'),
        tab_pane.find('.disqus_identifier').val(),
        tab_pane.find('.disqus_url').val());
    },
    _load_photos_tab: function() {
      var tab_pane_caption = $('.photos_tab_content.tab-pane #caption');
      Cocktails.DisqusHelper.load_disqus(tab_pane_caption.find('.disqus_identifier'),
        tab_pane_caption.find('.disqus_identifier').val(),
        tab_pane_caption.find('.disqus_url').val());
    },

    /* Photos Modal functions */
    _show_photos_modal: function(e) {
      $(document).on("keyup.photo_key", function(e) {
        if (e.keyCode == 37) { /* left arrow */
          var active_thumb = $(".thumbs .thumb.active");
          if (active_thumb.prev(".thumb").length === 1) {
            active_thumb.removeClass("active").prev(".thumb").addClass("active").trigger("click");
          }
        } else if (e.keyCode == 39) { /* right arrow */
          var active_thumb = $(".thumbs .thumb.active");
          if (active_thumb.next(".thumb").length === 1) {
            active_thumb.removeClass("active").next(".thumb").addClass("active").trigger("click");
          }
        }
      });
    },
    _hide_photos_modal: function() {
      $(document).off("keyup.photo_key");
    },
    _load_thumb_fullsize_img: function(e) {
      $('#photos_modal .thumb').removeClass("active");
      $(e.target).addClass("active");
      $('#main_img').attr('src',$(e.target).attr('src').replace('tiny','medium'));
    },
    _load_icon_fullsize_img: function(e) {
      $("#photo_modal").modal('show');
      $('img.main_img').attr('src',$(e.target).attr('src').replace('tiny','large'));
    },
    _close_modal: function(e) {
      $(e.target).closest('.modal').modal('hide');
    },

    /* Full page view */
    _show_fullpage_view: function() {
      $("#fullPageView").fadeIn("slow", function() {
        $(document).on("keyup.esc_fullpage", function(e) {
          if (e.keyCode == 27) { /* esc key */
            Cocktails.Recipe._hide_fullpage_view();
            $(document).off("keyup.esc_fullpage");
          }
        });
      });
    },
    _hide_fullpage_view: function() {
      $("#fullPageView").fadeOut("slow");
    },

    /* Favoriting */
    _recipe_favorited: function(e) {
      e.preventDefault();
      var btn = $(e.currentTarget);
      $.ajax({
        url: "/recipes/" + btn.attr("data-id") + "/favorite",
        type: "POST",
        success: function(){
          btn.addClass('btn-warning');
          btn.attr('data-action', 'unfavorite');
          btn.attr('data-original-title', 'Unfavorite');
          var count = parseInt(btn.children('span.favorite-count').html(), 10);
          btn.children('span.favorite-count').html(count + 1);
        }
      });
    },
    _recipe_unfavorited: function(e) {
      e.preventDefault();
      var btn = $(e.currentTarget);
      $.ajax({
        url: "/recipes/" + btn.attr("data-id") + "/favorite",
        type: "POST",
        success: function(){
          btn.removeClass('btn-warning');
          btn.attr('data-action', 'favorite');
          btn.attr('data-original-title', 'Favorite');
          var count = parseInt(btn.children('span.favorite-count').html(), 10);
          btn.children('span.favorite-count').html(count - 1);
        }
      });
    },

    /* Liking */
    _recipe_liked: function(e) {
      e.preventDefault();
      var btn = $(e.currentTarget);
      $.ajax({
        url: "/recipes/" + btn.attr("data-id") + "/like",
        type: "POST",
        success: function(){
          btn.addClass('btn-success');
          btn.attr('data-action', 'unlike');
          btn.attr('data-original-title', 'Unlike');
          var count = parseInt(btn.children('span.like-count').html(), 10);
          btn.children('span.like-count').html(count + 1);
          btn.siblings(".dislike-button").prop('disabled', true);
        }
      });
    },
    _recipe_unliked: function(e) {
      e.preventDefault();
      var btn = $(e.currentTarget);
      $.ajax({
        url: "/recipes/" + btn.attr("data-id") + "/like",
        type: "POST",
        success: function(){
          btn.removeClass('btn-success');
          btn.attr('data-action', 'like');
          btn.attr('data-original-title', 'Like');
          var count = parseInt(btn.children('span.like-count').html(), 10);
          btn.children('span.like-count').html(count - 1);
          btn.siblings(".dislike-button").prop('disabled', false);
        }
      });
    },


    /* Disliking */
    _recipe_disliked: function(e) {
      e.preventDefault();
      var btn = $(e.currentTarget);
      $.ajax({
        url: "/recipes/" + btn.attr("data-id") + "/dislike",
        type: "POST",
        success: function(){
          btn.addClass('btn-danger');
          btn.attr('data-action', 'undislike');
          btn.attr('data-original-title', 'Undislike');
          var count = parseInt(btn.children('span.dislike-count').html(), 10);
          btn.children('span.dislike-count').html(count + 1);
          btn.siblings(".like-button").prop('disabled', true);
        }
      });
    },
    _recipe_undisliked: function(e) {
      e.preventDefault();
      var btn = $(e.currentTarget);
      $.ajax({
        url: "/recipes/" + btn.attr("data-id") + "/dislike",
        type: "POST",
        success: function(){
          btn.removeClass('btn-danger');
          btn.attr('data-action', 'dislike');
          btn.attr('data-original-title', 'Dislike');
          var count = parseInt(btn.children('span.dislike-count').html(), 10);
          btn.children('span.dislike-count').html(count - 1);
          btn.siblings(".like-button").prop('disabled', false);
        }
      });
    },

    /* Shared */
    _recipe_shared: function(e) {
      e.preventDefault();
      var btn = $(e.currentTarget);
      $.ajax({
        url: "/recipes/" + btn.attr("data-id") + "/share",
        type: "POST",
        success: function(){
          btn.addClass('btn-info');
          var count = parseInt(btn.children('span.shared-count').html(), 10);
          btn.children('span.shared-count').html(count + 1);

          Cocktails.Recipe._open_share_dialog(btn.find(".share_attr .title").val(),
                                              btn.find(".share_attr .url").val(),
                                              btn.find(".share_attr .photo_url").val());
        }
      });
    },

    _open_share_dialog: function(recipe_title, recipe_url, photo_url) {
      var share_dialog = $(".recipe_share.modal.template").clone();
      share_dialog.removeClass("template");
      share_dialog.find(".modal-header h3 small").text(recipe_title);
      share_dialog.find(".modal-body .socialicons li a").each(function() {
        var anchor = $(this);

        // data-href
        var data_href = anchor.attr("data-href");
        if (typeof(data_href) !== 'undefined') {
          data_href = data_href.replace("RECIPE_TITLE", recipe_title)
                               .replace("RECIPE_URL", recipe_url)
                               .replace("PHOTO_URL", photo_url);
          anchor.attr("data-href", data_href);
        }
        // href
        var href = anchor.attr("href");
        if (typeof(href) !== 'undefined') {
          href = href.replace("RECIPE_TITLE", recipe_title)
                     .replace("RECIPE_URL", recipe_url)
                     .replace("PHOTO_URL", photo_url);
          anchor.attr("href", href);
        }
        // data-url
        var data_url = anchor.attr("data-url");
        if (typeof(data_url) !== 'undefined') {
          data_url = data_url.replace("RECIPE_URL", recipe_url);
          anchor.attr("data-url", data_url);
        }
        // data-photo-url
        var data_photo_url = anchor.attr("data-photo-url");
        if (typeof(data_photo_url) !== 'undefined') {
          data_photo_url = data_photo_url.replace("PHOTO_URL", photo_url);
          anchor.attr("data-photo-url", data_photo_url);
        }
        // data-title
        var data_title = anchor.attr("data-title");
        if (typeof(data_title) !== 'undefined') {
          data_title = data_title.replace("RECIPE_TITLE", recipe_title);
          anchor.attr("data-title", data_title);
        }
      });

      $("body").append(share_dialog);
      share_dialog.modal("show");
    },

    /* social buttons */
    _social_btn_clicked: function(e, share_clicked) {
      var btn_grp = $(e.target).closest(".btn-group");
      var num_liked_btn = btn_grp.find("a:nth-child(2)");
      var num = parseInt(num_liked_btn.text(),10);
      if (btn_grp.find("a:nth-child(1)").hasClass("disabled")) {
        num_liked_btn.text(num-1);
      } else {
        num_liked_btn.text(num+1);
      }
      if (typeof(share_clicked) === 'undefined') btn_grp.find("a").toggleClass("disabled");

      $.ajax({
        url: $(e.currentTarget).attr("data-href")
      });
    },
    _share_btn_clicked: function(e) {
      Cocktails.Recipe._social_btn_clicked(e, true);
    },

    /* vote widget (not currently hooked up) */
    _vote_btn_clicked: function() {
      var vote_btn = $(this);
      vote_btn.closest(".vote_container").find(".vote_button").removeClass("voted");
      vote_btn.closest(".vote_container").find("input:checkbox").removeAttr("checked");
      vote_btn.find("input:checkbox").attr("checked", true);
      vote_btn.addClass("voted");
      return false;
    }

  };
}

$(function() {
  Cocktails.Recipe._init();
});