# ==> Constants

TodoConstants =
  ADD_TODO:    'ADD_TODO'
  TOGGLE_TODO: 'TOGGLE_TODO'
  UPDATE_TODO: 'UPDATE_TODO'
  DELETE_TODO: 'DELETE_TODO'
@Components.TodoConstants = TodoConstants


# ==> Store

@Components.TodoStore = Fluxxor.createStore

  initialize: (todos=[]) ->
    @todos = todos

    @bindActions(TodoConstants.ADD_TODO,    @onAddTodo,
                 TodoConstants.TOGGLE_TODO, @onToggleTodo,
                 TodoConstants.UPDATE_TODO, @onUpdateTodo,
                 TodoConstants.DELETE_TODO, @onDeleteTodo )

  getState: ->
    todos: @todos

  onAddTodo: (payload) ->
    # Update UI
    new_todo = payload.new_todo
    @todos.unshift(new_todo)
    @emit('change')

  onToggleTodo: (payload) ->
    # Update UI
    index = @todos.indexOf(payload.todo)
    @todos[index].completed = payload.completed
    @emit('change')

  onUpdateTodo: (payload) ->
    # Update UI
    index = @todos.indexOf(payload.todo)
    @todos[index].content = payload.new_content
    @emit('change')

  onDeleteTodo: (payload) ->
    # Update UI
    index = @todos.indexOf(payload.todo)
    @todos.splice(index, 1)  # Deletes the todo.
    @emit('change')


# ==> Actions

@Components.TodoActions =

  # Creates a new todo to database.
  # Waits for data because we need a new id generated by database.
  # Dispatches ADD_TODO on successful Ajax.
  addTodo:    (content) ->
    return if not isOnline()
    $.ajax
      method: "POST"
      url:    "/todos/"
      data:   todo:
                content: content
    .done (data, textStatus, XHR) =>
      new_todo =
        id:        data.id
        content:   data.content
        completed: data.completed
      @dispatch(TodoConstants.ADD_TODO, new_todo: new_todo)
      $.growl.notice title: "Todo added", message: data.content
    .fail (XHR, textStatus, errorThrown) =>
      if error_messages = JSON.parse(XHR.responseText)
        for k, v of error_messages
          $.growl.error title: "#{ capitalize(k) } #{v}", message: ""
      else
        $.growl.error title: "Error adding todo", message: "#{errorThrown}"
      console.error("#{textStatus}: #{errorThrown}")

  # Saves a new completion status to database.
  toggleTodo: (todo, completed) ->
    return if not isOnline()
    @dispatch(TodoConstants.TOGGLE_TODO, todo: todo, completed: completed)
    $.ajax
      method: "PATCH"
      url:    "/todos/" + todo.id
      data:   todo:
                completed: completed
    .done (data, textStatus, XHR) =>
      title = if data.completed then "Completed" else "Not completed"
      $.growl.notice title: title, message: data.content
    .fail (XHR, textStatus, errorThrown) =>
      if error_messages = JSON.parse(XHR.responseText)
        for k, v of error_messages
          $.growl.error title: "#{ capitalize(k) } #{v}", message: ""
      else
        $.growl.error title: "Error toggling todo", message: "#{errorThrown}"
      console.error("#{textStatus}: #{errorThrown}")

  # Saves a new content to database.
  updateTodo: (todo, new_content) ->
    return if not isOnline()
    @dispatch(TodoConstants.UPDATE_TODO, todo: todo, new_content: new_content)
    $.ajax
      method: "PATCH"
      url:    "/todos/" + todo.id
      data:   todo:
                content: new_content
    .done (data, textStatus, XHR) =>
      $.growl.notice title: "Todo updated", message: ""
    .fail (XHR, textStatus, errorThrown) =>
      if error_messages = JSON.parse(XHR.responseText)
        for k, v of error_messages
          $.growl.error title: "#{ capitalize(k) } #{v}", message: ""
      else
        $.growl.error title: "Error updating todo", message: "#{errorThrown}"
      console.error("#{textStatus}: #{errorThrown}")

  # Deletes a todo to database.
  deleteTodo: (todo) ->
    return if not isOnline()
    @dispatch(TodoConstants.DELETE_TODO, todo: todo)
    $.ajax
      method: "DELETE"
      url:    "/todos/" + todo.id
    .done (data, textStatus, XHR) =>
      $.growl.notice title: "Deleted", message: data.content
    .fail (XHR, textStatus, errorThrown) =>
      if error_messages = JSON.parse(XHR.responseText)
        for k, v of error_messages
          $.growl.error title: "#{ capitalize(k) } #{v}", message: ""
      else
        $.growl.error title: "Error deleting todo", message: "#{errorThrown}"
      console.error("#{textStatus}: #{errorThrown}")


# ==> Utils

isOnline = ->
  return true if navigator.onLine
  $.growl.error(title: "Offline", message: "")
  false

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)
