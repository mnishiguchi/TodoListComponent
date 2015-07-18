#Todo list component with Fluxxor

- a simple React.js component implemented with Fluxxor on Ruby on Rails application.
- TodosController's index action prepares initial todo data and renders the index.html.haml, where the React component is initialized with the data passed in.

![alt text](https://github.com/mnishiguchi/todolist2_react_fluxxor_rails/blob/master/screenshot.png)

[日本語](http://qiita.com/mnishiguchi/items/594178849da209b9c9fd)

## Environment
- ruby 2.2.1
- Rails 4.2.1

## Dependencies
- react-rails
- Fluxxor

## How it works?
#### TodosController's index action prepares data in JSON passes it to the template via @todos instance variable.
`todos_controller.rb`

```rb
class TodosController < ApplicationController
  ...

  # Initializes the todo app with initial JSON data.
  def index
    @todos = current_user.todos.select(:id, :content, :completed, :created_at).to_json
  end

  ...

  private

    def todo_params
      params.require(:todo).permit(:content, :completed)
    end
end
```

#### Set up the TodoStore's initialize method so that it can accept initial data.
`todo_store.js.coffee`

```coffee
@TodoStore = Fluxxor.createStore

  initialize: (todos) ->
    @todos = todos || {}  # Store the data
  ...
```

#### Create a method to initialize the React component and its Flux with the data passed in as an argument.
`app.js.coffee`

```coffee
window.initializeTodoApp = (mountNode, options) ->

  # Instantiating the stores.
  stores =
    TodoStore: new TodoStore(options["todos"] if options)

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
```

#### Invoke the initializer method inside the view template with data.
`index.html.haml`

```haml
%h1 Todo List

  / MountNode
  #todo_component

:coffee

  $(document).ready ->
    window.initializeTodoApp("todo_component", todos: #{ @todos })
```


## Resources
- [What is React.js?](https://facebook.github.io/react/)
- [What is Flux?](http://fluxxor.com/what-is-flux.html)
