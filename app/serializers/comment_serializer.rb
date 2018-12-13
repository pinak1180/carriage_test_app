class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content

  has_many :comments, key: :replies
  # belongs_to :commentable, key: :resource
end
