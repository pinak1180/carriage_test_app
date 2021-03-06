class Api::V1::SessionsController < Api::V1::BaseController
  before_action :authenticate_user_with_authentication_token, only: [:destroy]

  def create
    @user = User.authenticate_user_with_auth(params[:email], params[:password])
    if @user.present?
      render json: @user, token: true
    else
      render json: ({ result: { messages: User.invalid_credentials, rstatus: 0, errorcode: 404 } }.to_json)
    end
  end

  def destroy
    @token = AuthenticationToken.current_authentication_token_for_user(@current_user.id, params[:authentication_token]).first
    if @token.present?
      @token.destroy
      render json: ({ result: { messages: 'ok', rstatus: 1, errorcode: '' }, data: { messages: 'Logout Successfully!' } }.to_json)
    else
      render json: ({ errors: "No user found with authentication_token = #{params[:authentication_token]}" }.to_json)
    end
  end
end
