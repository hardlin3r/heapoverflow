class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  validates :title, :body, presence: true, length: { minimum: 10 }
  validates :body, length: { maximum: 4000 }
  validates :title, length: { maximum: 70 }
  validates :user_id, presence: true, numericality: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
