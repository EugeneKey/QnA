class Answer < ActiveRecord::Base
  belongs_to :question
  validates :text, :question_id, presence: true
end
