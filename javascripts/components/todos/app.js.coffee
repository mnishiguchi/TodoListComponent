# Invoked in a Rails template with JSON data passed in.
# Initializes the todolist component with the provided options.

@initTodoList = (options) ->

  # Instantiates the flux.

  flux = todolistFlux["init"](options)
  constants = todolistFlux["constants"]

  # The main React component (<TodoList/>)

  @TodoList = React.createClass
    mixins: [ Fluxxor.FluxMixin(React),
              Fluxxor.StoreWatchMixin("TodoStore") ]

    getInitialState: ->
      newTodoText: ""

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
      todos_wrapper = @getStateFromFlux().todos
      if confirm("Clear all the completed items?")
        for id, todo of todos_wrapper
          @getFlux().actions.deleteTodo(id) if todo.completed

    handleSelectTodoNav: (e) ->
      # TODO

    render: ->

      ButtonGroup = ReactBootstrap.ButtonGroup
      Button = ReactBootstrap.Button
      Input  = ReactBootstrap.Input

      add_button =
        <Button type="submit"
                bsStyle="primary">
                Add Todo</Button>

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
          <ButtonGroup onSelect={ @handleSelectTodoNav }>
            <Button eventKey={1}>All</Button>
            <Button eventKey={2}>Active</Button>
            <Button eventKey={3}>Completed</Button>
          </ButtonGroup>
          <Button onClick={ @handleClearCompleted } className="pull-right">Clear completed</Button>
        </nav>

      createTodoItems = (todos) ->
        for id, todo of todos
          <Todo todo={ todo } key={ id } />

      <div id="todolist_wrapper">
        { add_form }
        { navigation }
        <div id="todo_items_wrapper">
          { createTodoItems(@state.todos) }
        </div>
      </div>

  # Rendering the whole component to the mount node

  if (mountNode = document.getElementById("react_todolist"))
    React.render <TodoList flux={ flux } />, mountNode
