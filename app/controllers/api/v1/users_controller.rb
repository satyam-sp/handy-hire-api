# app/controllers/api/v1/users_controller.rb
class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: [:send_otp, :verify_otp] # If you have authentication for other actions
  before_action :authorize_request, only: [:update, :get_current_user]
  before_action :set_user, only: [:update]

  def send_otp
    mobile_number = params[:mobile_number]
    user = User.find_or_initialize_by(mobile_number: mobile_number)

    if user.valid?
      otp_code = user.generate_otp_code # Generate and store OTP
      # Send OTP via Twilio
      send_otp_via_twilio(mobile_number, otp_code)
      render json: { message: 'OTP sent successfully!' }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Twilio::REST::RestError => e
    render json: { errors: ["Failed to send SMS: #{e.message}"] }, status: :internal_server_error
  rescue StandardError => e
    render json: { errors: ["An unexpected error occurred: #{e.message}"] }, status: :internal_server_error
  end


  def get_current_user
    
    render json: {
      message: "user",
      user: Api::V1::UserSerializer.new(current_user).serializable_hash[:data][:attributes],
      token: generate_jwt_token(current_user.id)
    }, status: :ok
  end

  def verify_otp
    mobile_number = params[:mobile_number]
    otp = params[:otp]

    user = User.find_by(mobile_number: mobile_number)

    if user && user.verify_otp_code(otp)
      # OTP is valid, generate JWT token
      # Clear OTP secret after successful verification for security
      # user.update(otp_secret: nil, otp_sent_at: nil)

      render json: {
        message: "OTP verified successfully!",
        user: Api::V1::UserSerializer.new(user).serializable_hash[:data][:attributes],
        token: generate_jwt_token(user.id)
      }, status: :ok
    else
      render json: { errors: ['Invalid mobile number or OTP.'] }, status: :unauthorized
    end
  end

  def update
    if current_user.update(user_params)
      render json: {
        message: "OTP verified successfully!",
        user: Api::V1::UserSerializer.new(current_user).serializable_hash[:data][:attributes],
      }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['User not found.'] }, status: :not_found
  end

  def user_params
    # Permit only the fields that can be updated by the user
    params.require(:user).permit(:full_name, :address, :profile_photo)
  end

  def send_otp_via_twilio(to_number, otp_code)
    # client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    # client.messages.create(
    #   from: ENV['TWILIO_PHONE_NUMBER'], # Your Twilio phone number
    #   to: to_number,
    #   body: "Your OTP for login is: #{otp_code}"
    # )
  end

  def generate_jwt_token(user_id)
    # Implement JWT token generation (e.g., using 'jwt' gem)
    # Payload can include user_id and expiry
    payload = { user_id: user_id, exp: (Time.now + 2.hours).to_i } # Token expires in 2 hours
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end
end