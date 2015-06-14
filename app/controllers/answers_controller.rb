class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question
  before_action :load_answer, only: [:edit, :update, :destroy]

  def edit
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @answer.user_id == current_user.id && @answer.update(answer_params)
      @question = @answer.question
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    @question = @answer.question
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    end
    redirect_to @question
  end

  private

  def load_question
    @question = Question.find_by(id: params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text)
  end
end
