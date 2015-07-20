# Invoked in a Rails template with JSON data passed in.

@initializeTodoApp = (mountNode, options={}) ->

  todoData =  if options.hasOwnProperty("todos") then options["todos"] else []

  # Instantiating the stores.
  stores =
    TodoStore: new TodoStore(todoData)

  # Actions
  actions = TodoActions

  # Instantiating the flux with the stores and actions.
  flux = new Fluxxor.Flux(stores, actions)

  # Logging for the "dispatch" event.
  flux.on 'dispatch', (type, payload) ->
    console.log "[Dispatch]", type, payload if console?.log?

  # Rendering the whole component to the mount node.
  # Checking if mount node exists to suppress error caused by loading irrelevant pages.
  if(m = document.getElementById(mountNode))
    app = React.createElement TodoApp, {flux: flux}
    React.render(app, m)
