# <TodoItem />

TodoItem = React.createClass
  mixins: [Fluxxor.FluxMixin(React)]

  getInitialState: ->
    savedValue: @props.todo.content
    value:      @props.todo.content
    completed:  @props.todo.completed
    changed:    false
    updated:    false

  handleToggleCompleted: (e) ->
    e.preventDefault()
    id = @props.todo.id
    toggled_completion = not @state.completed
    @getFlux().actions.toggleTodo(id, toggled_completion)
    @setState(completed: toggled_completion)

  handleChange: ->
    input = @refs.input.getValue()
    if input is @state.savedValue
      @setState(value: input, changed: false, updated: false)
    else
      @setState(value: input, changed: true, updated: false)

  handleUpdate: (e) ->
    e.preventDefault()
    input = @refs.input.getValue()
    @getFlux().actions.updateTodo(@props.todo.id, input)
    @setState(changed: false, updated: true, savedValue: input)

  handleCancelChange: (e) ->
    e.preventDefault()
    @setState(value: @state.savedValue, changed: false)

  render: ->

    Button = ReactBootstrap.Button
    Input  = ReactBootstrap.Input

    isChecked = if @state.completed then "fa fa-check-square-o" else "fa fa-square-o"

    checkbox =
      <i className={ isChecked } onClick={ @handleToggleCompleted }></i>

    update_button =
      <div>
        <a onClick={ @handleUpdate }>Update</a>
        &nbsp; | &nbsp;
        <a onClick={ @handleCancelChange }>Cancel</a>
      </div>

    type = if @state.changed
             'warning'
           else if @state.updated
             'success'

    <form ref={ "todo_item_" + @props.todo.id } >
      <Input type='text'
             onChange={ @handleChange }
             ref='input'
             value={ @state.value }
             addonBefore={ checkbox }
             addonAfter={ update_button if @state.changed }
             bsStyle={ type } />
    </form>

module.exports = TodoItem
