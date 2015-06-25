# == Schema Information
#
# Table name: todos
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  completed  :boolean          default(FALSE)
#

class Todo < ActiveRecord::Base
  belongs_to :user

  def Todo.getInitialData
    User.current_user.todos.select(:id, :content, :completed, :created_at).to_json
  end
end
