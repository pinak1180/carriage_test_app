class AccessManager
  attr_reader :object, :user

  def initialize(object: , user: , options: {})
    @object = object
    @user = user
  end

  def create?
    true
  end

  def index?
    true
  end

  def update?
    true
  end

  def delete?
    true
  end

  def show?
    true
  end

  def access_scope
  end
end
