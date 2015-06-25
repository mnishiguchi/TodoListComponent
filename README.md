Todo list component 2
=====================

This is a simple React.js component implemented with Fluxxor on Ruby on Rails application. TodosController's index action prepares initial todo data and renders the index.html.haml, where the React component is initialized with the data passed in from the controller. Despite not being a server-side rendering, this structure eliminates the need to load the component's initial data in a simple way. Also, I find this code readable because I explicitly invoke the React component on a HTML template.

![alt text](https://github.com/mnishiguchi/todolist2_react_fluxxor_rails/blob/master/screenshot.jpg)

[React + Fluxxor on RailsサーバーサイドでFluxの初期化(Japanese)](http://qiita.com/mnishiguchi/items/594178849da209b9c9fd)

## Environment
- OSX Yosemite
- Rails 4.2.1
- ruby 2.2.1

## Relevant Gems
- react-rails
- sprockets-coffee-react
- browserify-rails

## How it works?
#### TodosController's index action prepares data in JSON passes it to the template via @todos instance variable.
`todos_controller.rb`

```
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

```
constants = require('../constants/todo_constants')

TodoStore = Fluxxor.createStore

  initialize: (todos) ->
    @todos = {}

    # Adds initial data if any.
    # Format: { 8: {completed: false, content: "Practice Ruby", id: 8}, ... }
    if todos
      for todo in todos
        @todos[todo.id] = todo

    @bindActions(constants.ADD_TODO,    @onAddTodo,
                 constants.TOGGLE_TODO, @onToggleTodo,
                 constants.UPDATE_TODO, @onUpdateTodo,
                 constants.DELETE_TODO, @onDeleteTodo )

  getState: ->
    todos: @todos
  ...
```
#### Create a method to initialize the React component and its Flux with the data passed in as an argument.
`app.js.cjsx`

```
TodoStore   = require('./stores/todo_store')
TodoActions = require('./actions/todo_actions')
TodoApp     = require('./components/TodoApp')

# Invoked in a Rails template with JSON data passed in.

React._initTodoApp = (options) ->

  # Instantiates the stores
  stores =
    TodoStore: new TodoStore(options["todos"] if options)

  # Actions
  actions = TodoActions

  # Instantiates the flux with the stores and actions
  flux = new Fluxxor.Flux(stores, actions)

  # Logging for the "dispatch" event
  flux.on 'dispatch', (type, payload) ->
    console.log "[Dispatch]", type, payload if console?.log?

  # Rendering the whole component to the mount node
  if (mountNode = document.getElementById("react_todolist"))
    React.render <TodoApp flux={ flux } />, mountNode
```
#### Invoke the initializer method with the data that is passed in from the controller.
`index.html.haml`

```
%h1 Todo List

#react_todolist

:coffee

  $(document).on "page:change", ->
    React._initTodoApp(todos: #{ @todos })
```


## Resources
- [What is React.js?](https://facebook.github.io/react/)
- [What is Flux?](http://fluxxor.com/what-is-flux.html)
