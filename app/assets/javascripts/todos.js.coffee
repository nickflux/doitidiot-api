jQuery ->
  if $('#new_todo').length
    new Todo()
  # get the Todos from local storage if offline
  if !localStorage["pendingTodos"]
    localStorage["pendingTodos"] = JSON.stringify([]);
  $.retrieveJSON "/todos.json", (todos, status, data) ->
    $('#todos').empty()
    pendingTodos  = $.parseJSON localStorage["pendingTodos"]
    all_todos     = todos.concat(pendingTodos)
    $(all_todos).each (i, todo) ->
      $('#todos').append('<li id="todo_'+todo._id+'">' + Mustache.to_html($('#todo_template').html(), todo) + '</li>')
      
  $("#todos").sortable
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($(this).data('sort-url'), $(this).sortable('serialize'))
  $("#todos").disableSelection()
    
class Todo
  constructor: ->
    $('#new_todo input[type=submit]').click(@create)
    $('#todos').on("click", '.edit_todo', @edit)
    $('#todos').on("click", '.destroy_todo', @destroy)
    $('#todos').on("click", '.complete_todo', @complete)
    $('#todos').on("click", '.update_todo', @update)
    @sendPending()
  
  show: (todo) =>
    $('#new_todo input[type=text]').val("")
    $('#todos').append('<li id="todo_'+todo._id+'">' + Mustache.to_html($('#todo_template').html(), todo) + '</li>')
     
  create: =>
    pendingTodos  = $.parseJSON localStorage["pendingTodos"]
    todo          = {what_to_do: $('#new_todo input[type=text]').val()}
    pendingTodos.push(todo)
    localStorage["pendingTodos"] = JSON.stringify(pendingTodos)
    @show(todo)
    false
  
  edit: ->
    edit_todo_url  = $(this).data('url')
    list_item      = $(this).closest('li')
    $.ajax
      type: 'GET',
      url: edit_todo_url,
      dataType: 'json',
      success: (todo) ->
        $(list_item).html(Mustache.to_html($('#edit_todo_template').html(), todo))
  
  update: ->
    update_todo_url   = $(this).data('url')
    list_item         = $(this).closest('li')
    what_to_do_value  = list_item.find('input').val()
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
    list_item         = $(this).closest('li')
    $.ajax
      type: 'DELETE',
      url: destroy_todo_url,
      dataType: 'json',
      success: ->
        $(list_item).remove()
        
  complete: ->
    update_todo_url   = $(this).data('url')
    list_item         = $(this).closest('li')
    $.ajax
      type: 'PUT',
      url: update_todo_url,
      data: { todo: {complete: true}},
      dataType: 'json',
      success: ->
        $(list_item).remove()
       
  sendPending: =>
    sendPendingMethod = @sendPending
    if (window.navigator.onLine)
      pendingTodos = $.parseJSON localStorage["pendingTodos"]
      if (pendingTodos.length > 0)
        create_todo_url = $('#new_todo input[type=submit]').data('url')
        todo            = pendingTodos[0]
        $.ajax
          type: 'POST'
          url: create_todo_url
          data: {todo: todo}
          dataType: 'json',
          success: ->
            pendingTodos.shift()
            localStorage["pendingTodos"] = JSON.stringify pendingTodos
            setTimeout(sendPendingMethod, 100)
            
  
        