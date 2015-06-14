# Invoked in a Rails template with JSON data passed in.
# Initializes the todolist component with the provided options.

@initTodoList = (options) ->

  flux = Fluxxor.initTodosFlux(options)

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

      Button = ReactBootstrap.Button
      Input  = ReactBootstrap.Input

      add_button =
        <Button type="submit"
                bsStyle="primary">
                Add Todo</Button>

      add_form =
        <form onSubmit={ @handleSubmitForm }>
          <Input type='text'
                 onChange={ @handleChangeAddTodoText }
                 placeholder="New Todo"
                 ref='input'
                 value={ @state.newTodoText }
                 buttonAfter={ add_button } />
        </form>

      Navbar  = ReactBootstrap.Navbar
      Nav     = ReactBootstrap.Nav
      NavItem = ReactBootstrap.NavItem
      ButtonToolbar = ReactBootstrap.ButtonToolbar
      ButtonGroup = ReactBootstrap.ButtonGroup
      Button = ReactBootstrap.Button

      navigation =
        <nav className="todo_navbar" >
          <ButtonGroup onSelect={ @handleSelectTodoNav }>
            <Button eventKey={1}>All</Button>
            <Button eventKey={2}>Active</Button>
            <Button eventKey={3}>Completed</Button>
          </ButtonGroup>
          <Button onClick={ @handleClearCompleted } className="pull-right">Clear completed</Button>
        </nav>

      todos = for id, todo of @state.todos
                <Todo todo={ todo }
                      key={ id }
                      flux={ flux } />

      <div id="todolist_wrapper">
        { add_form }
        { navigation }
        <section className="todos">
          { todos }
        </section>
      </div>

  # Rendering the whole component to the mount node

  if (mountNode = document.getElementById("react_todolist"))
    React.render <TodoList flux={ flux } />, mountNode
