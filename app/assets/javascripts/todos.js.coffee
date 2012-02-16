jQuery ->
  if $('#new_todo').length
    new Todo()
  
      
  
    
class Todo
  constructor: ->
    @getPendingTodos()
    @index()
    $('#new_todo input[type=submit]').click(@create)
    $('#todos').on("click", '.edit_todo', @edit)
    $('#todos').on("click", '.destroy_todo', @destroy)
    $('#todos').on("click", '.complete_todo', @complete)
    $('#todos').on("click", '.update_todo', @update)
    #if localStorage["pendingTodos"]
      #@sendPending()
  
  getTodoId: (element) =>
    element.closest('li').attr('id').replace(/todo_/, "")
    
  isLocal: (todo_id) =>
    if (todo_id.match("ls-"))
      true
    else
      false
      
  getLocalTodo: (todo_id) =>
    todos = $.grep @pendingTodos, (to, i) -> 
      to._id == todo_id
    return todos[0]
    
  getLocalTodoIndex: (todo) =>
    index = $.inArray todo, @pendingTodos
    return index
  
  getPendingTodos: =>
    if !localStorage["pendingTodos"]
      localStorage["pendingTodos"] = JSON.stringify([]);
    @pendingTodos = $.parseJSON localStorage["pendingTodos"]
    
  addPendingTodo: (todo) =>
    todo_id     = new Date().getTime()
    todo['_id'] = "ls-" + todo_id
    @pendingTodos.push(todo)
    localStorage["pendingTodos"] = JSON.stringify(@pendingTodos)
    return todo
  
  updatePendingTodos: (todo_id, todo_updates) =>
    todo                          = @getLocalTodo(todo_id)
    todo_index                    = @getLocalTodoIndex(todo)
    for own key, value of todo_updates
      todo[key] = value      
    @pendingTodos[todo_index]     = todo
    console.log(@pendingTodos)
    localStorage["pendingTodos"]  = JSON.stringify(@pendingTodos)
    return todo
  
  todoInLi: (todo) =>
    $('#todos').append('<li id="todo_'+todo._id+'">' + Mustache.to_html($('#todo_template').html(), todo) + '</li>')
  
  index: =>
    self  = this
    $.retrieveJSON "/todos.json", (todos, status, data) ->
      $('#todos').empty()
      all_todos = $.grep todos.concat(self.pendingTodos), (todo, i) -> 
        !todo.complete && !todo.deleted
      $(all_todos).each (i, todo) ->
        self.todoInLi(todo)
      self.sort()
      
  sort: =>
    $("#todos").sortable
      axis: 'y'
      handle: '.handle'
      update: ->
        # update local todos first
        $.post($(this).data('sort-url'), $(this).sortable('serialize'))
    $("#todos").disableSelection()
  
  show: (todo) =>
    $('#new_todo input[type=text]').val("")
    this.todoInLi(todo)
     
  create: =>
    todo  = {what_to_do: $('#new_todo input[type=text]').val()}
    todo  = @addPendingTodo(todo)
    @show(todo)
    false
  
  edit: ->
    # do locally
    edit_todo_url  = $(this).data('url')
    list_item      = $(this).closest('li')
    $.ajax
      type: 'GET',
      url: edit_todo_url,
      dataType: 'json',
      success: (todo) ->
        $(list_item).html(Mustache.to_html($('#edit_todo_template').html(), todo))
  
  update: ->
    # do locally
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
          
  destroy: =>
    # do locally
    destroy_todo_url  = $(this).data('url')
    list_item         = $(this).closest('li')
    $.ajax
      type: 'DELETE',
      url: destroy_todo_url,
      dataType: 'json',
      success: ->
        $(list_item).remove()
      
  complete: (e) =>
    todo_elm  = $(e.target)
    todo_id   = @getTodoId(todo_elm)
    list_item = todo_elm.closest('li')
    
    if @isLocal(todo_id)
      todo_updates  = 
        complete: true
      @updatePendingTodos(todo_id, todo_updates)
      $(list_item).remove()
    else
      # TODO: what if we are offline?
      update_todo_url   = todo_elm.data('url')
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
            
  
        