class ListAssignee < ApplicationRecord
  ## Associations ##
  belongs_to :user
  belongs_to :list

  ## Validations ##
  validates :user_id, uniqueness: { scope: :list_id }
end
