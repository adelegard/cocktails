$(function() {

	$(".chzn-select").chosen();
  $('#new_recipe_directions').NobleCount('.characters_remaining:first', 
                                {max_chars:2000, on_negative: 'go_red'});
  $('#new_recipe_inspiration').NobleCount('.characters_remaining:last', 
                                {max_chars:2000, on_negative: 'go_red'});

  $('img.avatar_tiny').each(function() {
    var email_addr = $(this).attr("data-email");
    if (typeof(email_addr) !== 'undefined') {
      $(this).attr('src', Gravtastic(email_addr, {size: 22}));
    }
  });
  $('img.avatar_small').each(function() {
    var email_addr = $(this).attr("data-email");
    if (typeof(email_addr) !== 'undefined') {
      $(this).attr('src', Gravtastic(email_addr, {size: 35}));
    }
  });
  $('img.avatar_medium').each(function() {
    var email_addr = $(this).attr("data-email");
    if (typeof(email_addr) !== 'undefined') {
      $(this).attr('src', Gravtastic(email_addr, {size: 125}));
    }
  });
  $('img.avatar_large').each(function() {
    var email_addr = $(this).attr("data-email");
    if (typeof(email_addr) !== 'undefined') {
      $(this).attr('src', Gravtastic(email_addr, {size: 150}));
    }
  });

  /* set sidebar search checkboxes based on cookied values */
  var cookie_str = "checkbox [cookie] values: ";
  var search_cookies = new cookieList("search_ingredient").items();
  for (var i=0; i < search_cookies.length; i++) {
    addSidebarIngredient(search_cookies[i]);
    cookie_str = cookie_str + search_cookies[i] + ", ";
  }
  $('span.ing_cookie_span').html(cookie_str);

  $('li.checked_ingredient span').each(function() {
    var search_cookies = new cookieList("search_ingredient").items();
    var val = $(this).text();
    if($.inArray(val, search_cookies) > -1) {
      $(this).prev('input').attr('checked', true);
    }
  });

  var ajaxChosenParams = {
    method: 'GET',
    url: '/search/autocomplete_ingredients',
    dataType: 'json',
    jsonTermKey: 'q'
  };

  var ajaxChosenSuccessCallback = function(data) {
    var terms = {};
    $.each(data, function (i, val) {
        terms[i] = val;
    });
    return terms;
  };

  setupAjaxChosen();

	$.ajaxSetup({
		'beforeSend': function(xhr) {
			xhr.setRequestHeader('Accept','text/javascript')
		}
	});

  $('input.recipe_ac').autocomplete({
    source: function(request, response) {
      var params = getAutoCompleteRecipeParams(request.term);
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

  $(document).on("focus", "input.ingredients_ac:not(.ui-autocomplete-input)", function (e) {
    $(this).autocomplete({
      source: function(request, response) {
        var params = getAutoCompleteIngredientsParams(request.term);
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
    var the_form = $("#sidebar_indgredients_form");
    the_form.find("input[type='hidden']").remove();
    the_form.submit();
  });

  $(document).on('change', '.sidebar-nav.search li.checked_ingredient input:checkbox', function(e) {
    var the_form = $("#sidebar_indgredients_form");
    var the_checkbox = $(e.target);
    var val = the_checkbox.next("span").html();
    if(the_checkbox.is(":checked")) {

      var cookie_list = new cookieList("search_ingredient");
      cookie_list.add(val);

      var new_input = the_form.prev("input[type='hidden']").first().clone();
      new_input.val(val);
      the_form.append(new_input);
    } else {
      var cookie_list = new cookieList("search_ingredient");
      cookie_list.remove(val);
      the_form.find("input[value='"+val+"']").remove();
    }
    the_form.submit();
  });

  $('.sidebar-nav.search input.add_ingredient').keydown(function(e) {
    if (e.which !== 13) return; //enter
    var val = $(this).val();
    if (!addSidebarIngredient(val)) return false;

    var cookie_list = new cookieList("search_ingredient");
    cookie_list.add(val);

    $("#sidebar_indgredients_form").submit();
  });

  function addSidebarIngredient(val) {
    if (!canAddToIngredientSidebar(val)) return false;
    addSidebarIngredientCheckbox(val);
    addSidebarIngredientToForm(val);
    return true;
  }

  function addSidebarIngredientCheckbox(val) {
    var new_li = $("li.checked_ingredient").first().clone();
    new_li.find("span").html(val);
    new_li.find("input:checkbox").attr("checked", true);
    $("ul.spirits").append(new_li);
  }
  function addSidebarIngredientToForm(val) {
    var the_form = $("#sidebar_indgredients_form");
    var new_input = the_form.prev("input[type='hidden']").first().clone();
    new_input.val(val);
    the_form.append(new_input);
  }

  function canAddToIngredientSidebar(val) {
    if (val === "") return false;
    if (checkSidebar(val) === false) return true;
    return false;
  }

  function checkSidebar(val) {
    return $('li.checked_ingredient span:contains("' + val + '")').length > 0;
  }

  $(document).on("click", ".new_recipe_ingredient_add", function() {
    var new_ingredient = $(".new_recipe_ingredient").first().clone();
    var num = $(".the_ingredients .ingredient").length;

    setNewIngredientName("input.val", new_ingredient, num);
    setNewIngredientName("select.amt", new_ingredient, num);
    setNewIngredientName("input.ingredients_ac", new_ingredient, num);

    new_ingredient.removeClass("dn new_recipe_ingredient");
    new_ingredient.find("select").addClass("chzn-select");
    new_ingredient.appendTo(".the_ingredients");
    $(".chzn-select").chosen();
    setupAjaxChosen();
    new_ingredient.find("input.val").focus();
    return false;
  });

  function setNewIngredientName(selector, new_ingredient, num) {
    var the_title = new_ingredient.find(selector);
    var input_name = the_title.attr("name");
    input_name = input_name.replace("0", num);
    the_title.attr("name", input_name);
  }

  $(document).on("click", ".remove_new_ingredient", function() {
    var ingredients = $(".the_ingredients .ingredient");
    if (ingredients.length <= 1) return false;
    $(this).closest(".ingredient").remove();
  });

  function setupAjaxChosen() {
    $("select.chzn-select.ingredients_ac").ajaxChosen(ajaxChosenParams, 
                                                      ajaxChosenSuccessCallback);
  }

  function getAutoCompleteRecipeParams(term) {
    params = {};
    params['url'] = '/search/autocomplete_recipes';
    dataHash = {}
    dataHash.q = term
    params['data'] = dataHash;
    return params;
  }

  function getAutoCompleteIngredientsParams(term) {
    params = {};
    params['url'] = '/search/autocomplete_ingredients_titles';
    dataHash = {}
    dataHash.q = term
    params['data'] = dataHash;
    return params;
  }
});