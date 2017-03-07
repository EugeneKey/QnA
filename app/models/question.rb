# frozen_string_literal: true
# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  validates :text, :user_id, presence: true
  validates :title, length: { minimum: 10, maximum: 255 },
                    uniqueness: true,
                    presence: true

  after_create :subscribe_author

  default_scope { order('created_at') }

  scope :yesterday, -> { where(created_at: Time.current.yesterday.all_day) }

  def subscribe_author
    Subscription.create(question: self, user: user)
  end
end
