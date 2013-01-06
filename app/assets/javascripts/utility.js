if (typeof(Cocktails) === 'undefined') {
  Cocktails = {};
}

if (typeof(Cocktails.Utility) === 'undefined') {
  Cocktails.Utility = {
    _initialized: false,
    _ajaxChosenIngredientParams: {
      method: 'GET',
      url: '/search/autocomplete_ingredients',
      dataType: 'json',
      jsonTermKey: 'q'
    },
    _ajaxChosenIngredientSelector: "select.chzn-select.ingredients_ac",

    _init: function() {
      if(!this._initialized) {

        String.prototype.endsWith = function(suffix) {
            return this.indexOf(suffix, this.length - suffix.length) !== -1;
        };

        $.ajaxSetup({
          'beforeSend': function(xhr) {
            xhr.setRequestHeader('Accept','text/javascript');
          }
        });

        this.setupAjaxChosenIngredients();

        this._initialized = true;
      }
    },
    setupAjaxChosenIngredients: function() {
      Cocktails.Utility._setupAjaxChosen(Cocktails.Utility._ajaxChosenIngredientSelector,
                                         Cocktails.Utility._ajaxChosenIngredientParams);
    },
    _ajaxChosenSuccessCallback: function(data) {
      var terms = {};
      $.each(data, function (i, val) {
          terms[i] = val;
      });
      return terms;
    },
    _setupAjaxChosen: function(selector, params) {
      $(selector).ajaxChosen(params, Cocktails.Utility._ajaxChosenSuccessCallback);
    }

  };
}

$(function() {
  Cocktails.Utility._init();
});