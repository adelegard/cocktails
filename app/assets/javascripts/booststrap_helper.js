$(function() {
  $('.carousel').carousel({
    interval: 10000
  });

  $("[rel='tooltip']").each(function() {
    addTooltipToElement($(this));
  });

  function addTooltipToElement(elem) {
    elem.tooltip({
      delay: { show: 1000, hide: 50 },
      placement: typeof(elem.attr("data-placement")) !== 'undefined' ? elem.attr("data-placement") : "top"
    });
  }
});