$(document).on('turbolinks:load', function() {
  $("tr.compilation").on('click', function(){
    var $components = $("tr[data-part-of='" + $(this).attr('data-compilation-id') + "']");

    if ($components.hasClass("out")) {
      $components.addClass("in");
      $components.removeClass("out");
    } else {
      $components.addClass("out");
      $components.removeClass("in");
    };
  });
});
