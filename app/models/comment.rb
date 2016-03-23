class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  default_scope { order(created_at: :asc) }
  validates :body, :user_id, presence: true
end
