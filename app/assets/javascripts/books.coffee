$(document).on 'turbolinks:load', ->
  $('button#swap').click ->
    $start  = $('input#start')
    $finish = $('input#finish')
    buffer = $start.val()
    $start.val($finish.val())
    $finish.val(buffer)
    false;
