class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :destroy]
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: "Answer successfully added!"
    else
      redirect_to @question, alert: "Unable to add an answer!"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = "Your answer was deleted successfully"
    else
      flash[:alert] = "You cannot delete another user's answer"
    end
    redirect_to question_url(@question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
