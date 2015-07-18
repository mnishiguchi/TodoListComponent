@TodoStore = Fluxxor.createStore

  initialize: (todos) ->
    @todos = todos || {}

    @bindActions(TodoConstants.ADD_TODO,    @onAddTodo,
                 TodoConstants.TOGGLE_TODO, @onToggleTodo,
                 TodoConstants.UPDATE_TODO, @onUpdateTodo,
                 TodoConstants.DELETE_TODO, @onDeleteTodo )

  getState: ->
    todos: @todos

  onAddTodo: (payload) ->
    # Update UI
    new_todo = payload.new_todo
    @todos.push(new_todo)
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
