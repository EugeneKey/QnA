class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  validates :text, presence: true
  validates :title, length: { minimum: 10, maximum: 255 }, uniqueness: true, presence: true
end
