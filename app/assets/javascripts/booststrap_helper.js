$(function() {
  $('.carousel').carousel({
    interval: 10000
  });

  $("[rel='tooltip']").each(function() {
    addTooltipToElement($(this));
  });

  function addTooltipToElement(elem) {
    elem.tooltip({
      delay: { show: 500 },
      placement: typeof(elem.attr("data-placement")) !== 'undefined' ? elem.attr("data-placement") : "top"
    });
  }
});