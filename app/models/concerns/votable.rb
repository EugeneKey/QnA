module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def votes_sum
    votes.sum(:value)
  end

  def vote(user)
    votes.find_by(user: user)
  end
end
