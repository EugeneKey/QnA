class Answer < ActiveRecord::Base
  belongs_to :question
  validates :text, :question, presence: true
end
