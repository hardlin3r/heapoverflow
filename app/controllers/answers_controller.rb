class AnswersController < ApplicationController
  before_action :load_question, only: [:create, :destroy]
  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question, notice: "Answer successfully added!"
    else
      redirect_to @question, alert: "Unable to add an answer!"
    end
  end
  def destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
