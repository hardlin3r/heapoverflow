module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
    accepts_nested_attributes_for :votes
  end
end
