module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_up, :vote_down, :cancel_vote]
  end

  def vote_up
    authorize! :vote_up, @votable
    @vote = @votable.votes.create(user: current_user, value: 1)
    render_vote
  end

  def vote_down
    authorize! :vote_down, @votable
    @vote = @votable.votes.create(user: current_user, value: -1)
    render_vote
  end

  def cancel_vote
    authorize! :cancel_vote, @votable
    @vote = @votable.vote(current_user).destroy
    render_vote
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def render_vote
    render json: { votable_id: @vote.votable_id, votes_sum: @votable.votes_sum, type: @vote.votable_type }
  end
end
