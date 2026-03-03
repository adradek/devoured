$(document).on('turbolinks:load', function() {
  var $compilation_inclusion_title = $("#compilation_inclusion_title");
  var $compilation_inclusion_reading_id = $("#compilation_inclusion_reading_id");

  $(".add-to-compilation-modal-launcher").on('click', function() {
    // console.log("id:", $(this).attr("data-reading-id"));
    // console.log("caption:", $(this).attr("data-title"));
    $compilation_inclusion_title.val($(this).attr("data-title"));
    $compilation_inclusion_reading_id.val($(this).attr("data-reading-id"));
  });
});
