class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :body, presence: true, length: { minimum: 10, maximum: 8000 }
  validates :question_id, :user_id, presence: true, numericality: true
end
