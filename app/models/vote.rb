class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :votable, presence: true
  validates :user, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, presence: true, inclusion: { in: [-1, 1] }
end
