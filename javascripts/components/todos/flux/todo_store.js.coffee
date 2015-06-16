@todolistFlux ||= {}

# Semantic actions

@todolistFlux["actions"] =

  # Creates a new todo to database. Dispatches ADD_TODO on successful Ajax.
  addTodo:    (content) ->
    params = todo:
               content: content
    $.ajax
      method: "POST"
      url:    "/todos/"
      data:   params
    .done (data, textStatus, jqXHR) =>
      new_todo =
        id:        data.id
        content:   data.content
        completed: data.completed
      @dispatch(todolistFlux.constants.ADD_TODO, new_todo: new_todo)
      $.growl.notice title: "", message: "Todo added"
    .fail (jqXHR, textStatus, errorThrown) =>
      $.growl.error title: "Error", message: "Error adding todo"
      console.error textStatus, errorThrown.toString()

  # Saves a new completion status to database. Dispatches TOGGLE_TODO on successful Ajax.
  toggleTodo: (id, completed) ->
    params = todo:
               completed: completed
    $.ajax
      method: "PATCH"
      url:    "/todos/" + id
      data:   params
    .done (data, textStatus, jqXHR) =>
      title = if data.completed then "Completed" else "Not completed"
      @dispatch(todolistFlux.constants.TOGGLE_TODO, id: data.id, completed: data.completed)
      $.growl.notice title: title, message: data.content
    .fail (jqXHR, textStatus, errorThrown) =>
      $.growl.error title: "Error", message: "Error toggleing todo completion"
      console.error textStatus, errorThrown.toString()

  # Saves a new content to database. Dispatches UPDATE_TODO on successful Ajax.
  updateTodo: (id, new_content) ->
    params = todo:
               content: new_content
    $.ajax
      method: "PATCH"
      url:    "/todos/" + id
      data:   params
    .done (data, textStatus, jqXHR) =>
      @dispatch(todolistFlux.constants.UPDATE_TODO, id: data.id, new_content: data.content)
      $.growl.notice title: "", message: "Todo updated"
    .fail (jqXHR, textStatus, errorThrown) =>
      $.growl.error title: "Error", message: "Error updating todo"
      console.error textStatus, errorThrown.toString()

  # Deletes a todo to database. Dispatches DELETE_TODO on successful Ajax.
  deleteTodo: (id) ->
    $.ajax
      method: "DELETE"
      url:    "/todos/" + id
    .done (data, textStatus, jqXHR) =>
      @dispatch(todolistFlux.constants.DELETE_TODO, id: data.id)
      $.growl.notice title: "Deleted", message: data.content
    .fail (jqXHR, textStatus, errorThrown) =>
      $.growl.error title: "Error", message: "Error deleting todos"
      console.error textStatus, errorThrown.toString()
