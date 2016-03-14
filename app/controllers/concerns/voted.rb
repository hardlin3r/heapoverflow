module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_vote, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    vote :up
  end

  def downvote
    vote :down
  end

  def unvote
    if current_user.author_of?(@votable)
      flash[:error] = "You cannot vote for your own #{model_klass}"
    else
      if current_user.voted_for?(@votable)
        flash[:success] = "Your vote has been deleted, you can re-vote now"
        current_user.unvote_for(@votable)
      else
        flash[:error] = "You didn't yet voted for #{model_klass}, there is nothing to reset"
      end
    end
    render 'vote'
  end

  private

  def vote(up_or_down)
    if current_user.author_of?(@votable)
      flash[:error] = "You cannot vote for your own #{model_klass}"
    else
      if current_user.voted_for?(@votable)
        flash[:error] = "You already voted #{up_or_down} for this #{model_klass}"
      else
        flash[:success] = "You have successfully voted #{up_or_down} for this #{model_klass}"
        case up_or_down
        when :up
          current_user.vote_for(@votable, 1)
        when :down
          current_user.vote_for(@votable, -1)
        end
      end
    end
    render 'vote'
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_vote
    @votable = model_klass.find(params[:id])
  end
end
