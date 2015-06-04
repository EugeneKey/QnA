class AnswersController < ApplicationController
  before_action :load_question, only: [:create, :edit, :update]
  before_action :load_answer, only: [:edit, :update]

  def edit
  end

  def create
      @answer = @question.answers.new(answer_params)
      if @answer.save
        redirect_to @question
      else
        render :new
      end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  private

  def load_question
    @question = Question.find_by(id: params[:question_id])
  end

  def load_answer
    @answer= @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text)
  end
end
