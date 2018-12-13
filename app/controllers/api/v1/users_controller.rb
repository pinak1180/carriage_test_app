class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user_with_authentication_token

  def index
    @users = User.select(:id, :role, :username, :email)
    render json: @users, instance_options: { token: true }
  end

  def update
    if @current_user.update(user_params)
      render json: @current_user
    else
      render json: ({ result: { messages: @current_user.errors.full_messages.join(', '), rstatus: 0, errorcode: 404 } }.to_json)
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
