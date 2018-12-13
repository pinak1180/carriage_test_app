class ListAccessManager < AccessManager
  def create?
    return true if user.admin?
    false
  end

  def update?
    create?
  end

  def delete?
    create?
  end

  def access_scope
    if user.admin?
      user.lists ## As only Admin can create Lists
    else
      user.assigned_lists
    end
  end

  def assign_member?
    create?
  end

  def un_assign_member?
    create?
  end

  def show?
    return true if user.admin?
    user.assigned_lists.exists?(object.id)
  end
end
