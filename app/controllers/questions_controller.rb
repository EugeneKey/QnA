class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :load_answers, :build_answer, :load_subscription, only: :show

  after_action :publish_question, only: :create

  authorize_resource

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

  def publish_question
    PrivatePub.publish_to '/questions/index', question: @question.to_json if @question.valid?
  end

  def question_params
    params.require(:question).permit(:title, :text, attachments_attributes: [:file, :done, :_destroy])
  end

  def load_subscription
    @subscription = Subscription.where(user: current_user, question: @question).first
  end
end
