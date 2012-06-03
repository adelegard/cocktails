$(function() {
	$(".chzn-select").chosen();
  $('#new_recipe_directions').NobleCount('#characters_remaining', 
                                {max_chars:2000, on_negative: 'go_red'});


  /* set sidebar search checkboxes based on cookied values */
  var cookie_str = "checkbox [cookie] values: ";
  var search_cookies = new cookieList("search_ingredient").items();
  for (var i=0; i < search_cookies.length; i++) {
    var contains = $('li.checked_ingredient span:contains("' + search_cookies[i] + '")').length > 0;
    if (!contains) {
      addSidebarIngredient(search_cookies[i]);
    }
    cookie_str = cookie_str + search_cookies[i] + ", ";
  }
  $('span.ing_cookie_span').html(cookie_str);


  /* I'm not totally sure if this stuff should be stored in cookies...*/
  var cookie_str = "spirit [cookie] value: ";
  var spirit_cookie = $.cookie("spirit");
  var the_spirit = $('li.spirit a:contains("' + spirit_cookie + '")').first();
  if (!the_spirit.closest("li.spirit").hasClass("active")) {
    the_spirit.closest("li.spirit").addClass("active");
  }
  cookie_str += spirit_cookie;
  $('span.spirit_cookie_span').html(cookie_str);

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

  $('input.ingridients_ac').autocomplete({
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

  $(document).on('.sidebar-nav.search li.checked_ingredient input[type="checkbox"]').change(function(e) {
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
    if (!canAddToIngredientSidebar(val)) return false;

    var cookie_list = new cookieList("search_ingredient");
    cookie_list.add(val);

    addSidebarIngredient(val);
    $("#sidebar_indgredients_form").submit();
  });

  function addSidebarIngredient(val) {
    addSidebarIngredientCheckbox(val);
    addSidebarIngredientToForm(val);
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
    var returnVal = false;
    $(".sidebar-nav.search ul li span").each(function() {
      if (this.innerHTML === val) {
        returnVal = true;
        return returnVal;
      }
    });
    return returnVal;
  }

  $(document).on("click", ".new_recipe_ingredient_add", function() {
    var new_ingredient = $(".new_recipe_ingredient").first().clone();
    var num = $(".the_ingredients .ingredient").length;

    setNewIngredientName("input", new_ingredient, num);
    setNewIngredientName("select.amt", new_ingredient, num);
    //setNewIngredientName("select.ingridients_ac", new_ingredient, num);

    new_ingredient.removeClass("dn new_recipe_ingredient");
    new_ingredient.find("select").addClass("chzn-select");
    new_ingredient.appendTo(".the_ingredients");
    $(".chzn-select").chosen();
    setupAjaxChosen();
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
    $("select.chzn-select.ingridients_ac").ajaxChosen(ajaxChosenParams, 
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