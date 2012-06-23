$(function() {
  // validate signup form on keyup and submit
  $("form#new_user").validate({
    rules: {
      'user[email]': {
        required: true,
        minlength: 5,
        email: true
      },
      'user[password]': {
        required: true,
        minlength: 4
      },
      'user[password_confirmation]': {
        required: true,
        minlength: 4,
        equalTo: "#user_password"
      }
    },
    messages: {
      'user[email]': {
        required: "Enter a valid email address",
        email: 'is an invalid email address',
        minlength: jQuery.format("Must be at least {0} characters")
      },
      'user[password]': {
        required: "Enter a password",
        minlength: jQuery.format("Must be at least {0} characters")
      },
      'user[password_confirmation]': {
        required: "Repeat your password",
        equalTo: "Must be equal to the above password"
      }
    },
    errorClass: "help-inline",
    errorElement: "span",
    highlight:function(element, errorClass, validClass) {
      $(element).parents('.control-group').removeClass('success').addClass('error');
    },
    unhighlight: function(element, errorClass, validClass) {
      $(element).parents('.control-group').removeClass('error').addClass('success');
    }
  });

  $.validator.addClassRules({
    recipe_title: {
      required: true,
      minlength: 3
    },
    ing_val: {
      required: true,
      number: true
    },
    add_ingredient: {
      required: true,
      minlength: 2
    },
    new_recipe_directions: {
      required: true,
      minlength: 5
    }
  });

  // validate signup form on keyup and submit
  $("form#new_recipe").validate({
    errorClass: "help-inline",
    errorElement: "span",
    highlight:function(element, errorClass, validClass) {
      $(element).parents('.control-group').removeClass('success').addClass('error');
    },
    unhighlight: function(element, errorClass, validClass) {
      $(element).parents('.control-group').removeClass('error');
    }
  });
});