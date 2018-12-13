class Api::V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :bad_record
  before_action :set_pagination_limit
  # skip_before_action :verify_authenticity_token, if: proc { |c| c.request.format == 'application/json' }

  protected
  def authenticate_user_with_authentication_token
    @current_user = AuthenticationToken.find_user_from_authentication_token(params[:authentication_token])
    unless @current_user.present?
      render json: ({ result: { messages: 'You required to register or login before continue to this action!', rstatus: 0, errorcode: 401 } }.to_json)
    end
  end

  def bad_record
    render json: ({ result: { messages: 'No records Found', rstatus: 0, errorcode: 404 } }.to_json)
  end

  def render_json_object(object:, details: false, token: false)
    render json: object, scope: @current_user, details: details, token: token
  end

  def render_json_object_error(object)
    render json: ({ result: { messages: object.errors.full_messages.join(', '), rstatus: 0, errorcode: 404 } }.to_json)
  end

  def render_json_message(message)
    render json: ({ result: { messages: message, rstatus: 0, errorcode: 404 } }.to_json)
  end

  def render_json_un_authorization
    render_json_message('You are UnAuthorization to perform this action')
  end

  def parameter_errors
    render_json_message('You have supplied invalid parameter list.')
  end

  def set_pagination_limit
    @limit = params[:limit] || 10
    @page  = params[:page] || 1
  end
end
