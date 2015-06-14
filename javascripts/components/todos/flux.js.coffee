# Initializes the Flux

Fluxxor.initTodosFlux = (options) ->

  # Constants (Action types)

  constants =
    ADD_TODO:    'ADD_TODO'
    TOGGLE_TODO: 'TOGGLE_TODO'
    UPDATE_TODO: 'UPDATE_TODO'
    DELETE_TODO: 'DELETE_TODO'

  # Stores

  TodoStore = Fluxxor.createStore
    initialize: ->
      @todos = {}
      if options.hasOwnProperty("todos")
        for todo in options["todos"]
          @todos[todo.id] = todo

      @bindActions(constants.ADD_TODO,    @onAddTodo,
                   constants.TOGGLE_TODO, @onToggleTodo,
                   constants.UPDATE_TODO, @onUpdateTodo,
                   constants.DELETE_TODO, @onDeleteTodo)

    getState: ->
      todos: @todos

    onAddTodo: (payload) ->
      params = todo:
                 content: payload.content
      $.ajax
        method: "POST"
        url: "/todos/"
        data: params
      .done (data, textStatus, jqXHR) =>
        todo =
          id:        data.id
          content:   data.content
          completed: data.completed
        @todos[data.id] = todo
        @emit('change')
        $.growl.notice title: "", message: "Todo added"
      .fail (jqXHR, textStatus, errorThrown) =>
        $.growl.error title: "Error", message: "Error adding todo"
        console.error textStatus, errorThrown.toString()

    onToggleTodo: (payload) ->
      params = todo:
                 completed: payload.completed
      $.ajax
        method: "PATCH"
        url: "/todos/" + payload.id
        data: params
      .done (data, textStatus, jqXHR) =>
        title = if params.todo.completed then "Completed" else "Not completed"
        todo =
          id:        data.id
          content:   data.content
          completed: data.completed
        @todos[data.id] = todo
        @emit('change')
        $.growl.notice title: title, message: data.content
      .fail (jqXHR, textStatus, errorThrown) =>
        $.growl.error title: "Error", message: "Error toggleing todo completion"
        console.error textStatus, errorThrown.toString()

    onUpdateTodo: (payload) ->
      params = todo:
                 content: payload.new_content
      $.ajax
        method: "PATCH"
        url: "/todos/" + payload.id
        data: params
      .done (data, textStatus, jqXHR) =>
        todo =
          id:        data.id
          content:   data.content
          completed: data.completed
        @todos[data.id] = todo
        @emit('change')
        $.growl.notice title: "", message: "Todo updated"
      .fail (jqXHR, textStatus, errorThrown) =>
        $.growl.error title: "Error", message: "Error updating todo"
        console.error textStatus, errorThrown.toString()

    onDeleteTodo: (payload) ->
      id = payload.id
      $.ajax
        method: "DELETE"
        url: "/todos/" + id
      .done (data, textStatus, jqXHR) =>
        message = @todos[id].content
        delete @todos[id]
        @emit('change')
        $.growl.notice title: "Deleted", message: message
      .fail (jqXHR, textStatus, errorThrown) =>
        $.growl.error title: "Error", message: "Error deleting todos"
        console.error textStatus, errorThrown.toString()

  # Registering our semantic actions

  actions =

    addTodo:    (content) ->
      @dispatch(constants.ADD_TODO, content: content)

    toggleTodo: (id, completed) ->
      @dispatch(constants.TOGGLE_TODO, id: id, completed: completed)

    updateTodo: (id, new_content) ->
      @dispatch(constants.UPDATE_TODO, id: id, new_content: new_content)

    deleteTodo: (id) ->
      @dispatch(constants.DELETE_TODO, id: id)

  # Instantiating our stores

  stores =
    TodoStore: new TodoStore

  # Creating a Flux instance with our stores and actions that are defined above

  flux = new Fluxxor.Flux(stores, actions)

  # Logging upon the "dispatch" event

  flux.on 'dispatch', (type, payload) ->
    console.log "[Dispatch]", type, payload if console?.log?

  return flux
