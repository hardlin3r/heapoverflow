class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :body, presence: true, length: { minimum: 10, maximum: 8000 }
  validates :question_id, :user_id, presence: true, numericality: true

  default_scope { order(best: :desc).order(created_at: :desc) }

  def set_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      best ? update!(best: false) : update!(best: true)
    end
  end
end
