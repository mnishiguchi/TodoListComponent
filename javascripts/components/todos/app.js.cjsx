TodoStore   = require('./stores/todo_store')
TodoActions = require('./actions/todo_actions')
TodoApp     = require('./components/TodoApp')

# Instantiates the flux with data passed in from Rails.

instantiateFlux = (options) ->

  # Instantiates the stores
  stores =
    TodoStore: new TodoStore(options["todos"])

  # Actions
  actions = TodoActions

  # Instantiates the flux with the stores and actions
  flux = new Fluxxor.Flux(stores, actions)

  # Logging for the "dispatch" event
  flux.on 'dispatch', (type, payload) ->
    console.log "[Dispatch]", type, payload if console?.log?

  return flux

# Invoked in a Rails template with JSON data passed in.

React._initTodoApp = (options) ->

  # Instantiates the flux.
  flux = instantiateFlux(options)

  # Rendering the whole component to the mount node
  if (mountNode = document.getElementById("react_todolist"))
    React.render <TodoApp flux={ flux } />, mountNode
