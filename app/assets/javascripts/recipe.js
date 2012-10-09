if (typeof(Cocktails) === 'undefined') {
  Cocktails = {};
}

if (typeof(Cocktails.Recipe) === 'undefined') {
  Cocktails.Recipe = {
    _initialized: false,

    _init: function() {
      if(!this._initialized) {

        Cocktails.GallerifficHelper._init();
        Cocktails.RatyHelper._init();

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

        // private note
        $(".set_private_note").on("click", this._show_private_note_dialog);
        $(".note_container .note").on("click", this._show_private_note_dialog);
        $(".note_container form.delete_note .delete").on("click", this._submit_private_note_form);

        // favoriting
        $(document).on("click", ".favorite", this._recipe_favorite);
        $(document).on("click", ".unfavorite", this._recipe_unfavorite);

        // social buttons
        $(document).on("click", ".btn-group.share > a", this._share_btn_clicked);
        $(document).on("click", ".btn-group.like > a, .btn-group.save > a", this._social_btn_clicked);

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
        if (e.which == 37) { /* left arrow */
          var active_thumb = $(".thumbs .thumb.active");
          if (active_thumb.prev(".thumb").length === 1) {
            active_thumb.removeClass("active").prev(".thumb").addClass("active").trigger("click");
          }
        } else if (e.which == 39) { /* right arrow */
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
      $('img.main_img').attr('src',$(e.target).attr('src').replace('icon','large'));
    },
    _close_modal: function(e) {
      $(e.target).closest('.modal').modal('hide');
    },

    /* Full page view */
    _show_fullpage_view: function() {
      $("#fullPageView").fadeIn("slow");
    },
    _hide_fullpage_view: function() {
      $("#fullPageView").fadeOut("slow");
    },

    /* Private Recipe Note */
    _show_private_note_dialog: function() {
      $('.recipe_note_dialog').modal();
    },

    _submit_private_note_form: function() {
      $(this).closest("form").submit();
    },

    /* Favoriting */
    _recipe_favorite: function(e) {
      e.preventDefault();
      var fav = $(e.currentTarget);
      $.ajax({
        url: fav.attr("href"),
        success: function(){
          fav.closest(".favorite-links").find(".favorite-container").hide();
          fav.closest(".favorite-links").find(".unfavorite-container").show();
        }
      });
    },
    _recipe_unfavorite: function(e) {
      e.preventDefault();
      var fav = $(e.currentTarget);
      $.ajax({
        url: fav.attr("href"),
        success: function(){
          fav.closest(".favorite-links").find(".favorite-container").show();
          fav.closest(".favorite-links").find(".unfavorite-container").hide();
        }
      });
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