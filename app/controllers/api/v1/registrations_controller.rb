class Api::V1::RegistrationsController < Api::V1::BaseController
  def create
    if params[:user].present?
      @user = User.new(user_params)
      if @user.save
        render json: @user, token: true
      else
        render json: { errorcode: 400, message: @user.errors.full_messages.join(', ') }.to_json
      end
    else
      bad_record
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
