class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :votes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  def author_of?(item)
    item.user_id == self.id
  end

  def vote_for(votable, value)
    votes.create(votable: votable, value: value)
  end

  def voted_for?(votable)
    votes.where(votable: votable).any?
  end

  def unvote_for(votable)
    votes.where(votable: votable).delete_all
  end
end
