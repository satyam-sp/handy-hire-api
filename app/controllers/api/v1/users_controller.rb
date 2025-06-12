class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, only: [:profile, :update_profile]

  # ✅ User Registration
  def register
    user = User.new(user_params)

    if params[:profile_photo].present?
      user.profile_photo.attach(params[:profile_photo])
    end

    if user.save
      render json: { message: "Registration successful", user: user_data(user), token: generate_token(user) }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Update Profile (including image upload)
  def update_profile
    if @current_user.update(user_params)
      if params[:profile_photo].present?
        @current_user.profile_photo.purge # Remove old photo
        @current_user.profile_photo.attach(params[:profile_photo])
      end

      render json: { message: "Profile updated", user: user_data(@current_user) }, status: :ok
    else
      render json: { error: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:full_name, :username, :email, :mobile_number, :password, :password_confirmation, :address)
  end

  def user_data(user)
    {
      id: user.id,
      full_name: user.full_name,
      username: user.username,
      email: user.email,
      mobile_number: user.mobile_number,
      profile_photo_url: user.profile_photo_url,
      address: user.address
    }
  end
end
