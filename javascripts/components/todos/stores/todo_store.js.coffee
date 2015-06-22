constants = require('../constants/todo_constants')

TodoStore = Fluxxor.createStore

  initialize: (todos) ->
    @todos = {}
    if todos
      for todo in todos
        @todos[todo.id] = todo

    @bindActions(constants.ADD_TODO,    @onAddTodo,
                 constants.TOGGLE_TODO, @onToggleTodo,
                 constants.UPDATE_TODO, @onUpdateTodo,
                 constants.DELETE_TODO, @onDeleteTodo )

  getState: ->
    todos: @todos

  onAddTodo: (payload) ->
    # Update UI
    new_todo = payload.new_todo
    @todos[new_todo.id] = new_todo
    @emit('change')

  onToggleTodo: (payload) ->
    # Update UI
    @todos[payload.id].completed = payload.completed
    @emit('change')

  onUpdateTodo: (payload) ->
    # Update UI
    @todos[payload.id].content = payload.new_content
    @emit('change')

  onDeleteTodo: (payload) ->
    # Update UI
    delete @todos[payload.id]
    @emit('change')

module.exports = TodoStore
