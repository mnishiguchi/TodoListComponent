class TodosController < ApplicationController

  before_action :authenticate_user! # all actions

  # The todo list page. Provides the todo list component with JSON data.
  def index
    @todos = current_user.todos.select(:id, :content, :completed).to_json
  end

  # Creates a new todo item via Ajax.
  def create
    @todo = current_user.todos.create!(todo_params)
    render json: @todo
  end

  # Updates a todo item via Ajax.
  def update
    @todo = Todo.find(params[:id])
    @todo.update_attributes(todo_params)
    render json: @todo
  end

  # Destroys a todo item specified by id via Ajax.
  def destroy
    Todo.find(params[:id]).destroy
    render nothing: true, status:  200
  end

  private

    def todo_params
      params.require(:todo).permit(:content, :completed)
    end
end
