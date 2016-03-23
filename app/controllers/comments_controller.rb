class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :load_commentable, only: :create

  def create
    @comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    end
  end
end
