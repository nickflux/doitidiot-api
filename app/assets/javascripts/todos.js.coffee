jQuery ->
  if $('#new_todo').length
    new Todo()
  
    
class Todo
  constructor: ->
    @getExistingTodos()
    @getPendingTodos()
    @index()
    $('#new_todo input[type=submit]').click(@create)
    $('#todos').on("click", '.edit_todo', @edit)
    $('#todos').on("click", '.destroy_todo', @destroy)
    $('#todos').on("click", '.complete_todo', @complete)
    $('#todos').on("click", '.update_todo', @update)
  
  applyRedacts: =>    
    # trigger applyBlacklists in Redacts
    $('#todos').trigger("apply_blacklists")
  
  getTodoId: (element) =>
    element.closest('li').attr('id').replace(/todo_/, "")
    
  getWhatToDo: (element) =>
    element.closest('li').data("what-to-do")
    
  isLocal: (todo_id) =>
    if (todo_id.match("ls-"))
      true
    else
      false
      
  getExistingTodo: (todo_id) =>
    todos = $.grep @existingTodos, (to, i) -> 
      to._id == todo_id
    return todos[0]
    
  getExistingTodoIndex: (todo) =>
    index = $.inArray todo, @existingTodos
    return index
  
  getExistingTodos: =>
    if !localStorage["existingTodos"]
      localStorage["existingTodos"] = JSON.stringify([]);
    @existingTodos = $.parseJSON localStorage["existingTodos"]
    # send these todos to the server
    @sendExisting()
    
  addExistingTodo: (todo_id, todo) =>
    todo._id = todo_id
    @existingTodos.push(todo)
    localStorage["existingTodos"] = JSON.stringify(@existingTodos)
    return todo
    
  updateExistingTodos: (todo_id, todo_updates) =>
    todo                          = @getExistingTodo(todo_id)
    # if this todo does not exist in our local Existing Todos storage
    # create it
    if !todo
      todo  = @addExistingTodo(todo_id, todo_updates)
    else
      # or update it
      todo_index                    = @getExistingTodoIndex(todo)
      for own key, value of todo_updates
        todo[key] = value      
      @existingTodos[todo_index]    = todo
      localStorage["existingTodos"] = JSON.stringify(@existingTodos)
    return todo
      
  getPendingTodo: (todo_id) =>
    todos = $.grep @pendingTodos, (to, i) -> 
      to._id == todo_id
    return todos[0]
    
  getPendingTodoIndex: (todo) =>
    index = $.inArray todo, @pendingTodos
    return index
  
  getPendingTodos: =>
    if !localStorage["pendingTodos"]
      localStorage["pendingTodos"] = JSON.stringify([]);
    @pendingTodos = $.parseJSON localStorage["pendingTodos"]
    # send these todos to the server
    @sendPending()
    
  addPendingTodo: (todo) =>
    todo_id             = new Date().getTime()
    todo['_id']         = "ls-" + todo_id
    todo['anger_level'] = 1
    @pendingTodos.push(todo)
    localStorage["pendingTodos"] = JSON.stringify(@pendingTodos)
    return todo
  
  updatePendingTodos: (todo_id, todo_updates) =>
    todo                          = @getPendingTodo(todo_id)
    todo_index                    = @getPendingTodoIndex(todo)
    for own key, value of todo_updates
      todo[key] = value      
    @pendingTodos[todo_index]     = todo
    localStorage["pendingTodos"]  = JSON.stringify(@pendingTodos)
    return todo
  
  todoInLi: (todo) =>
    $('#todos').append('<li id="todo_'+todo._id+'" class="row-fluid anger_level'+todo.anger_level+'" data-what-to-do="'+todo.what_to_do+'">' + Mustache.to_html($('#todo_template').html(), todo) + '</li>')
  
  index: =>
    self  = this
    $.retrieveJSON "/todos.json", (todos, status, data) ->
      $('#todos').empty()
      # go through todos and merge with existing offline todo updates
      $(todos).each (i, todo) ->
        if self.getExistingTodo(todo._id)
          todos[i]  = $.extend(todo, self.getExistingTodo(todo._id))
      # now add new offline todos
      all_todos = $.grep todos.concat(self.pendingTodos), (todo, i) -> 
        !todo.complete && !todo.deleted
      # sort the todos
      all_todos.sort (a,b) ->
        ((a.ordinal > b.ordinal) ? -1 : ((a.ordinal < b.ordinal) ? 1 : 0));
      $(all_todos).each (i, todo) ->
        self.todoInLi(todo)
      # enable sorting
      # self.sort() - do we care?
      self.applyRedacts()
      
  sort: =>
    self  = this
    $("#todos").sortable
      axis: 'y'
      handle: '.handle'
      update: ->
        $('#todos li').each (i, todo_elm) ->
          todo_id = self.getTodoId($(todo_elm).find('span:first-child'))
          todo_updates  = 
            ordinal: i + 1
          if self.isLocal(todo_id)
            self.updatePendingTodos(todo_id, todo_updates)
          else
            self.updateExistingTodos(todo_id, todo_updates)
    $("#todos").disableSelection()
  
  show: (todo) =>
    $('#new_todo input[type=text]').val("")
    @todoInLi(todo)
    @applyRedacts()
     
  create: =>
    todo  = {what_to_do: $('#new_todo input[type=text]').val()}
    todo  = @addPendingTodo(todo)
    @show(todo)
    false
  
  edit: (e) =>
    todo_elm      = $(e.target)
    list_item     = todo_elm.closest('li')
    todo          =
      what_to_do: @getWhatToDo(todo_elm),
      _id: @getTodoId(todo_elm)
    $(list_item).html(Mustache.to_html($('#edit_todo_template').html(), todo))
  
  update: (e) =>
    todo_elm          = $(e.target)
    list_item         = todo_elm.closest('li')
    todo_id           = @getTodoId(todo_elm)
    what_to_do_value  = list_item.find('input').val()
    todo              =
      what_to_do: what_to_do_value,
      _id: todo_id
    todo_updates  = 
        what_to_do: what_to_do_value
    if @isLocal(todo_id)
      @updatePendingTodos(todo_id, todo_updates)
    else
      @updateExistingTodos(todo_id, todo_updates)
    $(list_item).html(Mustache.to_html($('#todo_template').html(), todo))
    $(list_item).data("what-to-do", what_to_do_value)
    @applyRedacts()
    false
          
  destroy: (e) =>
    todo_elm      = $(e.target)
    todo_id       = @getTodoId(todo_elm)
    list_item     = todo_elm.closest('li')
    todo_updates  = 
        deleted: true
    if @isLocal(todo_id)
      @updatePendingTodos(todo_id, todo_updates)
    else
      @updateExistingTodos(todo_id, todo_updates)
    $(list_item).remove()
      
  complete: (e) =>
    todo_elm      = $(e.target)
    todo_id       = @getTodoId(todo_elm)
    list_item     = todo_elm.closest('li')
    todo_updates  = 
        complete: true
    if @isLocal(todo_id)
      @updatePendingTodos(todo_id, todo_updates)
    else
      @updateExistingTodos(todo_id, todo_updates)
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
            
  sendExisting: =>
    sendExistingMethod = @sendExisting
    if (window.navigator.onLine)
      existingTodos = $.parseJSON localStorage["existingTodos"]
      if (existingTodos.length > 0)
        todo            = existingTodos[0]
        update_todo_url = '/todos/'+todo._id
        $.ajax
          type: 'PUT',
          url: update_todo_url
          data: {todo: todo}
          dataType: 'json',
          success: ->
            existingTodos.shift()
            localStorage["existingTodos"] = JSON.stringify existingTodos
            setTimeout(sendExistingMethod, 100)
            
  
        