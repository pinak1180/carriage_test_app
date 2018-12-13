class Card < ApplicationRecord
  ## Associations ##
  belongs_to :user
  belongs_to :list
  has_many :comments, as: :commentable, dependent: :destroy

  ## Validations ##
  validates :title, presence: true
end
