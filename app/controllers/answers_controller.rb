class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, except: [:create]

  def edit
  end

  def create
      @answer = @question.answers.build(answer_params.merge(user: current_user))
      flash.now[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def update
    if @answer.user_id == current_user.id && @answer.update(answer_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy
    flash[:notice] = 'Your answer successfully deleted.' if @answer.user_id == current_user.id && @answer.destroy
    redirect_to @answer.question
  end

  private

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
