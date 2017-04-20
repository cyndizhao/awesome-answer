class Like < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :user_id, uniqueness: {scope: :question_id}
  # the following validation garantees that a user can only like a question once
end
