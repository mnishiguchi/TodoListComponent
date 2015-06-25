Todo list component 2
=====================

This is a simple React.js component implemented with Fluxxor for Ruby on Rails application.

![alt text](https://github.com/mnishiguchi/todolist2_react_fluxxor_rails/blob/master/screenshot.jpg)

[React + Fluxxor on RailsサーバーサイドでFluxの初期化(Japanese)](http://qiita.com/mnishiguchi/items/594178849da209b9c9fd)

## 概要
React + FluxxorのコンポーネントにRailsのhtmlテンプレート上にてJSONデータを渡してから、レンダリングする。サーバサイドレンダリングではない。

## 目的
レンダリングの前に初期のデータを準備しておくことにより、初期の読み込みをなくす。

## 環境
OSX Yosemite
Rails 4.2.1
ruby 2.2.1

## 関連Gem
react-rails
sprockets-coffee-react
browserify-rails

## コントローラ（#index）でJSONデータを準備し、＠変数に格納。

```rb:todos_controller.rb
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

## Storeがデータを受け取れるようにinitializeメソッドをセットアップ

```coffeescript:todo_store.js.coffee
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
## ReactコンポーネントとFluxを受け取ったデータを用い初期化するメソッドを準備。

```coffeescript:app.js.cjsx
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
## htmlテンプレート上で初期化メソッドにデータを渡し、呼ぶ。

```haml:index.html.haml
%h1 Todo List

#react_todolist

:coffee

  $(document).on "page:change", ->
    React._initTodoApp(todos: #{ @todos })
```

以上


## Resources
- [What is React.js?](https://facebook.github.io/react/)
- [What is Flux?](http://fluxxor.com/what-is-flux.html)
