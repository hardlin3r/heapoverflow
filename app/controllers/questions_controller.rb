class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:new, :index, :create]
  def new
    @question = Question.new
    @question.attachments.build
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: "Your question was created successfully"
    else
      render :new, notice: "Title and cody should have length above 10 symbols!"
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = "Question was deleted successfully"
      redirect_to questions_path
    else
      flash[:alert] = "You cannot delete another user's question"
      redirect_to question_url(@question)
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
