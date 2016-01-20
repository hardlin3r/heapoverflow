class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true, length: { minimum: 10, maximum: 8000 }
  validates :question_id, presence: true, numericality: true
end
