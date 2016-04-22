class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :votes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :authorizations, dependent: :destroy

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

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email ? email : "temp@#{auth.uid}-#{auth.provider}.com", password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
