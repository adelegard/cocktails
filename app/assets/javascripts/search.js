if (typeof(Cocktails) === 'undefined') {
  Cocktails = {};
}

if (typeof(Cocktails.Search) === 'undefined') {
  Cocktails.Search = {
    _initialized: false,

    _sidebar_ingredients_form: "#sidebar_indgredients_form",

    _init: function() {
      if(!this._initialized) {

        /* recipe autocomplete */
        $('input.recipe_ac').autocomplete({
          source: function(request, response) {
            var params = Cocktails.Search._getAutoCompleteParams(request.term, '/search/autocomplete_recipes');
            $.ajax({
              url: params['url'],
              dataType: "jsonp",
              data: params['data'],
              success: function(data) {
                response(data);
              }
            });
          },
          close: function(event, ui){
            $(this).closest('form').submit();
          },
          minLength: 2,
          delay: 300
        });
        /* ingredient autocomplete */
        $(document).on("focus", "input.ingredients_ac:not(.ui-autocomplete-input)", function (e) {
          $(this).autocomplete({
            source: function(request, response) {
              var params = Cocktails.Search._getAutoCompleteParams(request.term, '/search/autocomplete_ingredients_titles');
              $.ajax({
                url: params['url'],
                dataType: "jsonp",
                data: params['data'],
                success: function(data) {
                  response(data);
                }
              });
            },
            minLength: 2,
            delay: 300
          });
        });

        /* sidebar searching */

        /* set sidebar search checkboxes based on cookied values */
        var search_cookies = new cookieList("search_ingredient").items();
        for (var i=0; i < search_cookies.length; i++) {
          Cocktails.Search.addSidebarIngredient(search_cookies[i]);
        }

        $('li.checked_ingredient span').each(function() {
          var search_cookies = new cookieList("search_ingredient").items();
          var val = $(this).text();
          if($.inArray(val, search_cookies) > -1) {
            $(this).prev('input').attr('checked', true);
          }
        });

        $("li.spirit_reset a").click(function() {
          $.cookie("spirit", null, { expires: 7, path: '/' });
        });

        $("li.spirit a").click(function() {
          $.cookie("spirit", $(this).text(), { expires: 7, path: '/' });
        });

        $('.sidebar-nav.search a.reset').click(function() {
          var search_cookies = new cookieList("search_ingredient");
          search_cookies.clear();

          $(this).siblings("li").find("input[type='checkbox']").attr("checked", false);
          var the_form = $(Cocktails.Search._sidebar_ingredients_form);
          the_form.find("input[type='hidden']").remove();
          the_form.submit();
        });

        $(document).on('change', '.sidebar-nav.search li.checked_ingredient input:checkbox', function(e) {
          var the_form = $(Cocktails.Search._sidebar_ingredients_form);
          var the_checkbox = $(e.target);
          var val = the_checkbox.next("span").html();
          var cookie_list = new cookieList("search_ingredient");
          if(the_checkbox.is(":checked")) {
            cookie_list.add(val);
            var new_input = the_form.prev("input[type='hidden']").first().clone();
            new_input.val(val);
            the_form.append(new_input);
          } else {
            cookie_list.remove(val);
            the_form.find("input[value='"+val+"']").remove();
          }
          the_form.submit();
        });

        $('.sidebar-nav.search input.add_ingredient').keydown(function(e) {
          if (e.keyCode !== 13) return; //enter
          var val = $(this).val();
          if (!Cocktails.Search.addSidebarIngredient(val)) return false;

          var cookie_list = new cookieList("search_ingredient");
          cookie_list.add(val);

          $(Cocktails.Search._sidebar_ingredients_form).submit();
        });

        this._initialized = true;
      }
    },
    _getAutoCompleteParams: function(term, url) {
      params = {};
      params['url'] = url;
      dataHash = {};
      dataHash.q = term;
      params['data'] = dataHash;
      return params;
    },

    addSidebarIngredient: function(val) {
      if (!Cocktails.Search.canAddToIngredientSidebar(val)) return false;
      Cocktails.Search.addSidebarIngredientCheckbox(val);
      Cocktails.Search.addSidebarIngredientToForm(val);
      return true;
    },
    addSidebarIngredientCheckbox: function(val) {
      var new_li = $("li.checked_ingredient").first().clone();
      new_li.find("span").html(val);
      new_li.find("input:checkbox").attr("checked", true);
      $("ul.spirits").append(new_li);
    },
    addSidebarIngredientToForm: function(val) {
      var the_form = $(Cocktails.Search._sidebar_ingredients_form);
      var new_input = the_form.prev("input[type='hidden']").first().clone();
      new_input.val(val);
      the_form.append(new_input);
    },
    canAddToIngredientSidebar: function(val) {
      if (val === "") return false;
      if (Cocktails.Search.checkSidebar(val) === false) return true;
      return false;
    },
    checkSidebar: function(val) {
      return $('li.checked_ingredient span:contains("' + val + '")').length > 0;
    }

  };
}

$(function() {
  Cocktails.Search._init();
});
