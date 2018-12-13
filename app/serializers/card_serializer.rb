class CardSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  ## Associations ##
  belongs_to :list, serializer: ListSerializer, if: -> (d){ d.show_details? }
  belongs_to :user, if: -> (d){ d.show_details? && d.scope.admin? }
  has_many :comments, if: -> (d){ d.show_details? } do
    object.comments.order(created_at: :desc).last(3)
  end

  def attributes(*args)
    if instance_options[:details]
      super.merge({comments: object.comments})
    else
      super
    end
  end

  def show_details?
    instance_options[:details].present?
  end
end
