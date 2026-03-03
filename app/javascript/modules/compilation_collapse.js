$(document).on('turbolinks:load', function() {
  $("tr.compilation").on('click', function(){
    var $components = $("tr[data-part-of='" + $(this).attr('data-compilation-id') + "']");

    if ($components.hasClass("show")) {
      // $components.addClass("in");
      $components.removeClass("show");
    } else {
      $components.addClass("show");
      // $components.removeClass("in");
    };

  });
});
