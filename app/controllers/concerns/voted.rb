module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_up, :vote_down, :cancel_vote]
  end

  def vote_up
    if @votable.user != current_user
      @vote = @votable.votes.build(user: current_user, value: 1)
      render_vote_create
    else
      render json: "You don't have access for vote", status: :unprocessable_entity
    end
  end

  def vote_down
    if @votable.user != current_user
      @vote = @votable.votes.build(user: current_user, value: -1)
      render_vote_create
    else
      render json: "You don't have access for vote", status: :unprocessable_entity
    end
  end

  def cancel_vote
    @vote = @votable.vote(current_user)
    if @vote
      @vote.destroy
      render json: { votable_id: @vote.votable_id, votes_sum: @votable.votes_sum, type: @vote.votable_type }
    else
      render json: 'You not have vote for Cancel', status: :unprocessable_entity
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def render_vote_create
    if @vote.save
      render json: { votable_id: @vote.votable_id, votes_sum: @votable.votes_sum, type: @vote.votable_type }
    else
      render json: @vote.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
  end
end
