class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      PrivatePub.publish_to "/questions/#{@question.id}/comments", comment: @comment.to_json
      render nothing: true
    else
      render json: @comment.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
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

  def comment_params
    params.require(:comment).permit(:text)
  end
end
