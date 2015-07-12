class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :text, :commentable, :user, presence: true

  default_scope { order('created_at') }
end
