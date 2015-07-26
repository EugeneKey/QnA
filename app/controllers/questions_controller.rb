class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :load_answers, only: :show
  before_action :build_answer, only: :show
  before_action :access_question, only: [:edit, :update, :destroy]
  after_action :publish_question, only: :create

  include Voted

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def load_answers
    @answers = @question.answers.find_each
  end

  def build_answer
    @answer = @question.answers.build
  end

  def access_question
    redirect_to root_path, notice: 'Access denied' if  @question.user_id != current_user.id
  end

  def publish_question
    PrivatePub.publish_to '/questions/index', question: @question.to_json if @question.valid?
  end

  def question_params
    params.require(:question).permit(:title, :text, attachments_attributes: [:file, :done, :_destroy])
  end
end
