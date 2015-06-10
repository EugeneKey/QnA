class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :text, :question_id, :user_id, presence: true
end
