class Question < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  validates :text, :user_id, presence: true
  validates :title, length: { minimum: 10, maximum: 255 }, uniqueness: true, presence: true

end
