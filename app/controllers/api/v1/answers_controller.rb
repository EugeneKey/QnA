# frozen_string_literal: true
class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: :show

  authorize_resource

  def index
    respond_with @question.answers, each_serializer: AnswersListSerializer
  end

  def show
    respond_with @answer
  end

  def create
    respond_with(@answer = @question.answers.create(
      answer_params.merge(user: current_resource_owner)
    ))
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text)
  end
end
