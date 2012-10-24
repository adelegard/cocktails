if (typeof(Cocktails) === 'undefined') {
  Cocktails = {};
}

if (typeof(Cocktails.LC) === 'undefined') {
  Cocktails.LC = {
    _initialized: false,

    _init: function() {
      if(!this._initialized) {
        $('.cabinet_ingredient_search').on("keydown", this.add_ingredient_via_enterkey);
        $('.add_cabinet_ingredient').on("click", this.add_ingredient_via_click);
        $(".recipe_ingredients .toggle_in_lc").on("click", this.toggle_ingredient);
        $(document).on("click", "table.liquor_cabinet_ingredients tbody tr td .icon-remove", this.remove_ingredient_via_x);

        // Ingredient Detail page
        $(".btn_container .btn.cabinet").on("click", this.detail_page_toggle_ingredient);

        this._initialized = true;
      }
    },

    add_ingredient_via_enterkey: function(e) {
      if (e.keyCode !== 13) return;
      var val = $(e.target).val();
      if (Cocktails.LC._can_add(val) === false) return;
      Cocktails.LC._add_ingredient_via_name(val, Cocktails.LC._add_ingredient_callback(val));
    },

    add_ingredient_via_click: function(e) {
      var val = $(".cabinet_ingredient_search").val();
      if (Cocktails.LC._can_add(val) === false) return;
      Cocktails.LC._add_ingredient_via_name(val, Cocktails.LC._add_ingredient_callback(val));
    },

    toggle_ingredient: function(e) {
      var val = $(e.target).prev("input").val();
      var li_ingredient = $(e.target).closest("li.ingredient");
      var new_msg;
      if (li_ingredient.hasClass("in_liquor_cabinet")) {
          Cocktails.LC._remove_ingredient_via_name(val);
          new_msg = $("input.lc_add_message").val();
      } else {
          Cocktails.LC._add_ingredient_via_name(val);
          new_msg = $("input.lc_remove_message").val();
      }
      $(e.target).text(new_msg);
      li_ingredient.toggleClass("in_liquor_cabinet not_in_liquor_cabinet");
      li_ingredient.prev("i").toggleClass("icon-remove icon-ok");
    },

    remove_ingredient_via_x: function(e) {
      var therow = $(e.currentTarget).closest("tr");
      var val = therow.find(".lc_ingredient .the_ingredient").html();
      Cocktails.LC._remove_ingredient_via_name(val, function() {
        therow.fadeOut('fast', function() {
          $(therow).empty().remove();
          if ($("table.liquor_cabinet_ingredients .lc_ingredient").length == 1) { //1 b/c there is always a hidden one for copying
            $(".view_makeable_recipes").attr("disabled", true);
          }
        });
      });
    },

    detail_page_toggle_ingredient: function(e) {
      var btn = $(e.target);
      var ingredient_id = btn.attr("data-id");
      var cabinets = $('.stats .cabinets');
      var num_cabinets = parseInt(cabinets.text(), 10);
      if (btn.hasClass("add")) {
        Cocktails.LC._add_ingredient_via_id(ingredient_id);
        $(".btn_container .remove").addClass("dib").show();
        num_cabinets = num_cabinets + 1;
      } else {
        Cocktails.LC._remove_ingredient_via_id(ingredient_id);
        $(".btn_container .add").addClass("dib").show();
        num_cabinets = num_cabinets - 1;
      }
      cabinets.text(num_cabinets);
      btn.hide();
    },

    _add_ingredient_via_name: function(val, callback) {
      $.ajax({
        url: '/cabinet/add',
        type: 'POST',
        data: {q: val},
        success: function(data) {
          if (typeof(callback) !== 'undefined') callback();
        }
      });
    },
    _remove_ingredient_via_name: function(val, callback) {
      $.ajax({
        url: '/cabinet/remove',
        type: 'DELETE',
        data: {q: val},
        success: function(data) {
          if (typeof(callback) !== 'undefined') callback();
        }
      });
    },

    _add_ingredient_via_id: function(ingredient_id, callback) {
      $.ajax({
        url: '/cabinet/' + ingredient_id + '/add_by_id',
        type: 'POST',
        success: function(data) {
          if (typeof(callback) !== 'undefined') callback();
        }
      });
    },
    _remove_ingredient_via_id: function(ingredient_id, callback) {
      $.ajax({
        url: '/cabinet/' + ingredient_id + '/remove_by_id',
        type: 'DELETE',
        success: function(data) {
          if (typeof(callback) !== 'undefined') callback();
        }
      });
    },

    _add_ingredient_callback: function(val) {
      var temp_row = $("table.liquor_cabinet_ingredients tbody tr:first").clone();
      temp_row.find(".lc_ingredient .the_ingredient").html(val);
      temp_row.find("a.see_other").attr("href", "/search?spirit=" + val);
      temp_row.removeClass("dn");
      $("table.liquor_cabinet_ingredients tbody").append(temp_row);
      $(".view_makeable_recipes").removeAttr("disabled");
    },

    _can_add: function(val) {
      if (val === "") return false;
      if (Cocktails.LC._in_cabinet(val) === false) return true;
      return false;
    },

    _in_cabinet: function(val) {
      var returnVal = false;
      $("table.liquor_cabinet_ingredients tbody tr td .lc_ingredient .the_ingredient").each(function() {
        if (this.innerHTML === val) {
          returnVal = true;
          return returnVal;
        }
      });
      return returnVal;
    }
  };
}

$(function() {
  Cocktails.LC._init();
});