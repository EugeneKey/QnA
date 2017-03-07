# frozen_string_literal: true
# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  value        :integer
#  user_id      :integer
#  votable_id   :integer
#  votable_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :votable, presence: true
  validates :user, presence: true,
                   uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, presence: true, inclusion: { in: [-1, 1] }
end
