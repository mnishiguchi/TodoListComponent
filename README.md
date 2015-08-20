#Todo list component with Fluxxor

- A simple React.js component implemented with Fluxxor on Ruby on Rails application.
- A controller prepares initial todo data.
- The component is invoked inside a view template with the data passed in.

[日本語](http://qiita.com/mnishiguchi/items/594178849da209b9c9fd)

---

![alt text](https://github.com/mnishiguchi/todolist2_react_fluxxor_rails/blob/master/Screenshot.png)

---

## Requirements
- Ruby 2.2.1
- Rails 4.2.1
- React.js
- Fluxxor
- Bootstrap3

## How it works?

#### Prepares data in JSON and put it into an instance variable.

```rb
class TodosController < ApplicationController
  #...

  # Initializes the todo app with initial JSON data.
  def index
    @todos = current_user.todos.select(:id, :content, :completed, :created_at).to_json
  end

  #...
```

#### Set up TodoStore's `initialize` method so that it can accept initial data.

```coffee
@TodoStore = Fluxxor.createStore

  initialize: (todos=[]) ->
    @todos = todos
  ...
```

#### Create a method to initialize the component and its Flux with the data.

```coffee
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
```

#### Invoke the component inside the view template passing in data.

```haml
%h1 Todo List

/ MountNode
#todo_component

:coffee
  jQuery ->
    new Components.initTodoApp("todo_component", todos: #{ Todo.getInitialData })
```


## Resources
- [What is React.js?](https://facebook.github.io/react/)
- [What is Flux?](http://fluxxor.com/what-is-flux.html)
