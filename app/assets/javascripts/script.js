/* this file is kind of the dumping ground for general js */

$(function() {

  $(".chzn-select").chosen();
  $('#new_recipe_directions').NobleCount('.characters_remaining:first', {max_chars:2000, on_negative: 'go_red'});
  $('#new_recipe_inspiration').NobleCount('.characters_remaining:last', {max_chars:2000, on_negative: 'go_red'});

  $.expander.defaults.slicePoint = 180;
  $.expander.defaults.expandSpeed = 100;
  $.expander.defaults.expandText = '+';
  $.expander.defaults.expandPrefix = '';
  $.expander.defaults.userCollapseText = '-';
  $('.expandable.header_details').expander({
    onSlice: function() {
      // change from display 'none' to 'block' so the onSlice method
      // doesn't make the overflowing element make the page jump
      // HOWEVER, for some reason this isn't working on the recipe show page
      $(this).css('display', 'block');
    },
    beforeExpand: function() {
      $(this).addClass('expanded');
    },
    afterExpand: function() {
      $('html').on('click', function() {
        //invoke the 'read-less' click to collapse the content
        $('.read-less a').trigger('click');
      });
      $(document).on('keydown', function(e) {
        if (e.keyCode === 27) { // escape key
           $('.read-less a').trigger('click');
         }
      });
      $('.expandable.expanded').on('click', function(e) {
        e.stopPropagation();
      });
    },
    onCollapse: function() {
      $(this).removeClass('expanded');
      $('html').off('click');
      $(document).off('keydown');// This kills all keydown's. Not ideal.
      $('.expandable.expanded').off('click');
    }
  });
  $('.expandable.ingredient_list').expander({
    onSlice: function(e) {
      // change from display 'none' to 'block' so the onSlice method
      // doesn't make the overflowing element make the page jump
      // HOWEVER, for some reason this isn't working on the recipe show page
      $(this).css('visibility', 'visible');
    }
  });

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
});