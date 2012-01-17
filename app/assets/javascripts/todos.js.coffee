jQuery ->
  if $('#new_todo').length
    new Todo()
    
class Todo
  constructor: ->
    $('#new_todo input[type=submit]').click(@create)
  
  show: (todo) =>
     $('#new_todo input[type=text]').val("")
     $('#todos').append(Mustache.to_html($('#todo_template').html(), todo))
  
  create: =>
    create_todo_url = $('#new_todo input[type=submit]').data('url')
    $.ajax
      type: 'POST',
      url: create_todo_url,
      data: $("#new_todo").serialize(),
      dataType: 'json',
      success: @show
      
    
    
    false