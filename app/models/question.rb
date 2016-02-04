class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :title, :body, presence: true, length: { minimum: 10 }
  validates :body, length: { maximum: 4000 }
  validates :title, length: { maximum: 70 }
  validates :user_id, presence: true, numericality: true
end
