class Api::V1::ListsController < Api::V1::BaseController
  before_action :authenticate_user_with_authentication_token
  before_action :set_list, :set_list_policy, except: [:create, :index]
  before_action :set_member, only: [:assign_member, :un_assign_member]

  def create
    list = @current_user.lists.build(list_params)
    return render_json_un_authorization unless ListAccessManager.new(object: list, user: @current_user).create?
    if list.save
      render_json_object(object: list)
    else
      render_json_object_error(object: list)
    end
  end

  def show
    return render_json_un_authorization unless @list_policy.show?
    render_json_object(object: @list, details: true)
  end

  def update
    if @list.present?
      return render_json_un_authorization unless @list_policy.update?
      if @list.update(list_params)
        render_json_object(object: @list)
      else
        render_json_object_error(@list)
      end
    else
      bad_record
    end
  end

  def destroy
    return render_json_un_authorization unless @list_policy.delete?
    if @list.present?
      @list.destroy
      render_json_message('List deleted Successfully')
    else
      bad_record
    end
  end

  def index
    lists = ListAccessManager.new(object: List.new, user: @current_user).access_scope
    render json: lists.page(@page).per(@limit)
  end

  def assign_member
    return render_json_un_authorization unless @list_policy.assign_member?
    assignee = @list.assignees.build(user_id: @member.id)
    if assignee.save
      render_json_message("List Assigned to #{@member.username} Successfully")
    else
      render_json_message("List is already assigned to #{@member.username}")
    end
  end

  def un_assign_member
    return render_json_un_authorization unless @list_policy.un_assign_member?
    assignee = @list.assignees.find_by(user_id: @member.id)
    if assignee.present?
      assignee.destroy
      render_json_message('List UnAssigned Successfully')
    else
      bad_record
    end
  end

  private
  def list_params
    params.require(:list).permit(:title)
  end

  def set_list
    list_id = (params[:id] || params[:list_id])
    @list = @current_user.admin? ? @current_user.lists.find(list_id) : @current_user.assigned_lists.find(list_id)
  end

  def set_member
    unless (@current_user.admin? || @list.user_id.eql?(@current_user.id))
      render_json_message 'Only list owner or admin can assign/un_assign members'
    end
    @member = User.find(params[:member_id])
    bad_record unless @member.present?
  end

  def set_list_policy
    @list_policy = ListAccessManager.new(object: @list, user: @current_user)
  end
end
