class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :role

  def attributes(*args)
    if instance_options[:token]
      super.merge(authentication_token: authentication_token)
    else
      super
    end
  end

  ## Instance Methods ##
  def authentication_token
    object.authentication_tokens
      .create(token: AuthenticationToken.generate_unique_token)
      .token
  end
end
