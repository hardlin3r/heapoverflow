class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, except: [:create]

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def destroy
    if current_user.author_of?(@answer)
      respond_with @answer.destroy
    end
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.set_best
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id,
                                   attachments_attributes: [:id, :file, :_destroy])
  end
end
