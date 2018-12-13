class CardAccessManager < AccessManager
  def create?
    return true if user.admin?
    user.assigned_lists.exists?(object.list_id)
  end

  def update?
    return true
    user.cards.exists?(object.id)
  end

  def delete?
    update?
  end

  def access_scope
    cards = if user.admin?
              Card.all
            else
              user.cards.where(list_id: user.assigned_lists)
            end
    cards.includes(comments: :comments)
  end

  def show?
    return true if user.admin?
    user.cards.where(list_id: user.assigned_lists).exists?(object.id)
  end
end
