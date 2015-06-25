TodoItem       = require('./TodoItem')

# <TodoApp /> The controller component

TodoApp = React.createClass
  mixins: [ Fluxxor.FluxMixin(React),
            Fluxxor.StoreWatchMixin("TodoStore") ]

  getInitialState: ->
    newTodoText: ""
    filterMode: 1

  getStateFromFlux: ->
    flux = @getFlux()
    flux.store('TodoStore').getState()

  handleChangeAddTodoText: (e) ->
    @setState(newTodoText: e.target.value)

  handleSubmitForm: (e) ->
    e.preventDefault()
    if @state.newTodoText.trim()
      @getFlux().actions.addTodo(@state.newTodoText)
      @setState(newTodoText: "")

  handleClearCompleted: (e) ->
    e.preventDefault()
    if confirm("Clear all the completed items?")
      for id, todo of @getStateFromFlux().todos
        @getFlux().actions.deleteTodo(id) if todo.completed

  handleSelectFilter: (selectedKey) ->
    switch selectedKey
      when 1 then @setState(filterMode: 1)
      when 2 then @setState(filterMode: 2)
      when 3 then @setState(filterMode: 3)

  todoFilter: (todo) ->
    switch @state.filterMode
      when 1 then true
      when 2
        if todo.completed then false else true
      when 3
        if todo.completed then true else false

  render: ->

    # Bootstrap components
    Nav         = ReactBootstrap.Nav
    NavItem     = ReactBootstrap.NavItem
    ButtonGroup = ReactBootstrap.ButtonGroup
    Button      = ReactBootstrap.Button
    Input       = ReactBootstrap.Input

    add_button =
      <Button type="submit" bsStyle="primary">Add Todo</Button>

    add_form =
      <form onSubmit={ @handleSubmitForm } id="add_form">
        <Input type='text'
               onChange={ @handleChangeAddTodoText }
               placeholder="New Todo"
               ref='input'
               value={ @state.newTodoText }
               buttonAfter={ add_button } />
      </form>

    navigation =
      <nav id="todo_navbar" >
        <Button onClick={ @handleClearCompleted } className="pull-right">Clear completed</Button>
        <Nav bsStyle='pills' activeKey={ @state.filterMode } onSelect={ @handleSelectFilter }>
          <NavItem eventKey={1}>All</NavItem>
          <NavItem eventKey={2}>Active</NavItem>
          <NavItem eventKey={3}>Completed</NavItem>
        </Nav>
      </nav>

    createTodoItems = (todos) =>
      for id, todo of todos when @todoFilter(todo)
        <TodoItem key={ id } todo={ todo } />

    <div id="todolist_wrapper">
      { add_form }
      { navigation }
      <div id="todo_items_wrapper">
        { createTodoItems(@state.todos) }
      </div>
    </div>

module.exports = TodoApp
