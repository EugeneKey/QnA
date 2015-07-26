class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable
  after_action :publish_comment

  respond_to :json

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)),
                 location: question_path(@question))
  end

  private

  def load_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
      @question = @commentable
    else
      @commentable = Answer.find(params[:answer_id])
      @question = @commentable.question
    end
  end

  def publish_comment
    PrivatePub.publish_to "/questions/#{@question.id}/comments", comment: @comment.to_json if @comment.valid?
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end