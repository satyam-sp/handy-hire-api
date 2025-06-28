class ApplicationController < ActionController::API
  before_action :authorize_request
  before_action :set_active_storage_url_options



  private


  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: request.base_url }
  end


  def authorize_request
    authorization_header = request.headers["Authorization"]
    token = authorization_header&.split(' ')&.last
    @decoded_token = decode_token(token)
    render json: { error: "Unauthorized" }, status: :unauthorized unless @decoded_token
  end

  def decode_token(token)
    begin
      JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    rescue JWT::DecodeError
      nil
    end
  end

  def current_employee
    @current_employee ||= Employee.find_by(id: @decoded_token["employee_id"]) if @decoded_token && @decoded_token["employee_id"]
  end

  def current_user
    @current_user ||= User.find_by(id: @decoded_token["user_id"]) if @decoded_token && @decoded_token["user_id"]
  end
end
