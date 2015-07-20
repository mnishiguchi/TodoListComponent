R = React.DOM

@TodoItem = React.createClass
  mixins: [Fluxxor.FluxMixin(React)]

  getInitialState: ->
    value:      @props.todo.content
    completed:  @props.todo.completed
    changed:    false
    updated:    false

  handleToggleCompleted: (e) ->
    e.preventDefault()
    @getFlux().actions.toggleTodo(@props.todo, not @state.completed)
    @setState(completed: not @state.completed)

  handleChange: (e) ->
    input = e.target.value
    if input is @props.todo.content
      @setState(value: input, changed: false, updated: false)
    else
      @setState(value: input, changed: true, updated: false)

  handleUpdate: (e) ->
    e.preventDefault()
    input = React.findDOMNode(@refs.input).value
    @getFlux().actions.updateTodo(@props.todo, input)
    @setState(changed: false, updated: true)

  handleCancelChange: (e) ->
    e.preventDefault()
    originalContent = @props.todo.content
    @setState(value: originalContent, changed: false)

  checkBox: ->
    R.div
      className: "input-group-addon"
      R.i
        className: if @state.completed then "fa fa-check-square-o" else "fa fa-square-o"
        onClick: @handleToggleCompleted

  field: ->
    R.input
      className: "form-control"
      type:      "text"
      style:     { fontSize: "1.5em" }
      ref:       'input'
      value:     @state.value
      onChange:  @handleChange

  fieldColor: ->
    if @state.changed
      'has-warning'
    else if @state.updated
      'has-success'

  updateButton: ->
    R.div
      className: "input-group-addon"
      R.div null,
        R.a
          onClick: @handleUpdate
          "Update"
        R.div
          "\u0020|\u0020"
        R.a
          onClick: @handleCancelChange
          "Cancel"

  render: ->
    R.form
      className: "form-horizontal"
      R.div
        className: "form-group #{@fieldColor()}"
        R.div
          className: "input-group"
          @checkBox()
          @field()
          @updateButton() if @state.changed
