class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:new, :index, :create]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  def new
    respond_with(@question = Question.new)
  end

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
  end

  def destroy
    if current_user.author_of?(@question)
      respond_with @question.destroy
    else
      flash[:alert] = "You cannot delete another user's question"
      redirect_to question_url(@question)
    end
  end

  private

  def publish_question
    PrivatePub.publish_to("/questions/new",{ question: @question, question_url: question_url(@question) }) if @question.valid?
  end

  def build_answer
    @answer = @question.answers.build
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
