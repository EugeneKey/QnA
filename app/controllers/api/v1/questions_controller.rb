class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: :show

  authorize_resource

  def index
    respond_with (@questions = Question.all), each_serializer: QuestionsListSerializer
  end

  def show
    respond_with @question
  end

  def create
    respond_with (@question = Question.create(question_params.merge(user: current_resource_owner)))
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :text)
  end
end
