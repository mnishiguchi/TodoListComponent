# Invoked in a Rails template with JSON data passed in.

class @Components.initTodoApp
  constructor: (mountNode, options={}) ->

    todoData =  if options.hasOwnProperty("todos") then options["todos"] else []

    # Instantiating the stores.
    stores =
      TodoStore: new Components.TodoStore(todoData)

    # Actions
    actions = Components.TodoActions

    # Instantiating the flux with the stores and actions.
    flux = new Fluxxor.Flux(stores, actions)

    # Logging for the "dispatch" event.
    flux.on 'dispatch', (type, payload) ->
      console.log "[Dispatch]", type, payload if console?.log?

    # Rendering the whole component to the mount node.
    app = React.createElement Components.TodoApp, {flux: flux}
    React.render(app, document.getElementById(mountNode))
