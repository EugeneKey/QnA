# frozen_string_literal: true
# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user_id, presence: true
  validates :question_id, presence: true, uniqueness: { scope: :user_id }
end
