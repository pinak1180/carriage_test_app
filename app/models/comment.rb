class Comment < ApplicationRecord
  ## Associations ##
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  ## Validations ##
  validates :content, presence: true

  def list_resource
     commentable_type.eql?('Card') ? commentable.list : commentable.commentable.list
  end
end
