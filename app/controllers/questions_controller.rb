class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  def new
    @question = Question.new
  end

  def index
    @questions = Question.all
  end

  def show
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
    params.require(:question).permit(:title, :body)
  end
end
