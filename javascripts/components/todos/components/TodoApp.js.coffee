R = React.DOM

@TodoApp = React.createClass
  mixins: [ Fluxxor.FluxMixin(React),
            Fluxxor.StoreWatchMixin("TodoStore") ]

  getInitialState: ->
    newTodoText: ""
    filterMode: "ALL"

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

  # Clears one completed item that is first found.
  handleClearCompleted: (e) ->
    e.preventDefault()
    todos = @getStateFromFlux().todos
    for todo in todos when todo.completed
      if confirm("Clear #{todo.content}?")
        @getFlux().actions.deleteTodo(todo)
        break

  handleSelectFilter: (e) ->
    selectedFilter = e.target.name
    @setState filterMode: selectedFilter

  todoFilter: (todo) ->
    switch @state.filterMode
      when "ALL" then true
      when "ACTIVE" then not todo.completed
      when "DONE" then todo.completed

  addForm: ->
    R.form
      className: "form-horizontal"
      id:       "add_form"
      onSubmit: @handleSubmitForm
      R.div
        className: "form-group"
        R.div
          className: "input-group"
          R.input
            className:   "form-control"
            type:        "text"
            placeholder: "New Todo"
            ref:         'input'
            value:       @state.newTodoText
            onChange:    @handleChangeAddTodoText
          R.div
            className: "input-group-btn"
            R.button
              className: "btn btn-primary"
              type:      "submit"
              "Add"

  filterButtons: ->
    R.ul
      className: "nav nav-tabs"
      id: "filter_buttons"
      R.li
        className: if @state.filterMode is "ALL" then "active" else ""
        R.a
          onClick: @handleSelectFilter
          name: "ALL"
          "All"
      R.li
        className: if @state.filterMode is "ACTIVE" then "active" else ""
        R.a
          onClick: @handleSelectFilter
          name: "ACTIVE"
          "Active"
      R.li
        className: if @state.filterMode is "DONE" then "active" else ""
        R.a
          onClick: @handleSelectFilter
          name: "DONE"
          "Done"
      R.li
        className: "pull-right"
        R.a
          @clearButton()

  clearButton: ->
    R.button
      onClick:   @handleClearCompleted
      className: "pull-right"
      "Clear completed"

  createTodoItems: ->
    todos = @state.todos
    R.div
      id: "todo_items_wrapper"
      for todo in todos when @todoFilter(todo)
        React.createElement TodoItem,
          key:  todo.id
          todo: todo

  render: ->
    R.div
      id: "todolist_wrapper"
      @addForm()
      @filterButtons()
      @createTodoItems()
