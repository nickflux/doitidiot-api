jQuery ->
  if $('#new_todo').length
    new Todo()
  $("#todos").sortable
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($(this).data('sort-url'), $(this).sortable('serialize'))
  $("#todos").disableSelection()
    
class Todo
  constructor: ->
    $('#new_todo input[type=submit]').click(@create)
    $('.edit_todo').click(@edit)
    $('.destroy_todo').click(@destroy)
    $('.complete_todo').click(@complete)
    $('#todos').on("click", '.update_todo', @update)
  
  show: (todo) =>
     $('#new_todo input[type=text]').val("")
     $('#todos').append('<li id="todo_'+todo._id+'">' + Mustache.to_html($('#todo_template').html(), todo) + '</li>')
     
  
  create: =>
    create_todo_url = $('#new_todo input[type=submit]').data('url')
    $.ajax
      type: 'POST',
      url: create_todo_url,
      data: $("#new_todo").serialize(),
      dataType: 'json',
      success: @show
    false
  
  edit: ->
     edit_todo_url  = $(this).data('url')
     list_item      = $(this).parent()
     $.ajax
      type: 'GET',
      url: edit_todo_url,
      dataType: 'json',
      success: (todo) ->
        $(list_item).html(Mustache.to_html($('#edit_todo_template').html(), todo))
  
  update: ->
    update_todo_url   = $(this).data('url')
    what_to_do_value  = $(this).parent().find('input').val()
    list_item         = $(this).parent()
    $.ajax
      type: 'PUT',
      url: update_todo_url,
      data: { todo: {what_to_do: what_to_do_value}},
      dataType: 'json',
      success: ->
        $.getJSON update_todo_url, (todo) ->
          $(list_item).html(Mustache.to_html($('#todo_template').html(), todo))
          
  destroy: ->
    destroy_todo_url  = $(this).data('url')
    list_item         = $(this).parent()
    $.ajax
      type: 'DELETE',
      url: destroy_todo_url,
      dataType: 'json',
      success: ->
        $(list_item).remove()
        
  complete: ->
    update_todo_url   = $(this).data('url')
    list_item         = $(this).parent()
    $.ajax
      type: 'PUT',
      url: update_todo_url,
      data: { todo: {complete: true}},
      dataType: 'json',
      success: ->
        $(list_item).remove()
        