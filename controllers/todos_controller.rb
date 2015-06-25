class TodosController < ApplicationController

  before_action :authenticate_user! # all actions

  # Initializes the todo app with initial JSON data.
  def index
    @todos = Todo.getInitialData
  end

  # Creates a new todo item via Ajax.
  def create
    @todo = current_user.todos.create!(todo_params)
  end

  # Updates a todo item via Ajax.
  def update
    @todo = Todo.find(params[:id])
    @todo.update_attributes(todo_params)
  end

  # Destroys a todo item specified by id via Ajax.
  def destroy
    @todo = Todo.find(params[:id]).destroy
  end

  private

    def todo_params
      params.require(:todo).permit(:content, :completed)
    end
end
