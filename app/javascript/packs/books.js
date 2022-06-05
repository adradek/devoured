$(document).on('turbolinks:load', function(){
  $('button#swap').click(function(){
    let $start  = $('input#start')
    let $finish = $('input#finish')
    let buffer = $start.val()
    $start.val($finish.val())
    $finish.val(buffer)
    return false;
  });
});
