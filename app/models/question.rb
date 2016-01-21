class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true, length: { minimum: 10 }
  validates :body, length: { maximum: 4000 }
  validates :title, length: { maximum: 70 }
end
