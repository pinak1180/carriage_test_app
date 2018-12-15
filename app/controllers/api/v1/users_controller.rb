class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user_with_authentication_token

  def index
    @users = User.select(:id, :role, :username, :email)
    render_json_object(object: @users)
  end

  def update
    if @current_user.update(user_params)
      render_json_object(object: @current_user)
    else
      render_json_object_error(object: @current_user)
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
