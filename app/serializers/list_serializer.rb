class ListSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_many :cards, if: -> (d){ d.show_details? }
  belongs_to :user, key: :list_owner, if: -> (d){ d.show_details? }

  def show_details?
    instance_options[:details].present? &&
    instance_options[:prefixes].first.eql?('api/v1/lists')
  end
end
