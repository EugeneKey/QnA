class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :load_answers, only: [:show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.user_id == current_user.id && @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      flash[:notice] = 'Your question successfully deleted.'
      redirect_to questions_path
    else
      redirect_to @question
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def load_answers
    @answers = @question.answers.find_each
  end

  def question_params
    params.require(:question).permit(:title, :text)
  end
end
