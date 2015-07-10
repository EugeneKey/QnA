class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, except: [:create]

  include Voted

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    @question = @answer.question if @answer.user_id == current_user.id && @answer.update(answer_params)
  end

  def destroy
    @answer.destroy if @answer.user_id == current_user.id
  end

  def set_best
    @question = @answer.question if @answer.question.user_id == current_user.id && @answer.set_best
  end

  def cancel_best
    @question = @answer.question if @answer.question.user_id == current_user.id && @answer.cancel_best
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text, attachments_attributes: [:file, :done, :_destroy])
  end
end
