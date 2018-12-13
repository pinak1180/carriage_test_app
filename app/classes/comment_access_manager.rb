class CommentAccessManager < AccessManager
  def create?
    return true if user.admin?
    list_id = object.list_resource.id
    user.assigned_lists.exists?(list_id)
  end

  def update?
    return true if user.admin?
    object.user_id.eql?(user.id)
  end

  def delete?
    create?
  end
end
