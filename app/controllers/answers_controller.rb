class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, except: [:update]
  before_action :load_answer, except: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
 end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def set_best
    if current_user.author_of?(@question)
      @answer.set_best
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
