class List < ApplicationRecord
  ## Associations ##
  has_many :cards, dependent: :destroy
  has_many :assignees, class_name: 'ListAssignee', dependent: :destroy
  belongs_to :user

  ## Validations ##
  validates :title, presence: true
end
