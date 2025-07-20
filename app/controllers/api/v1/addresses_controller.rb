# app/controllers/api/v1/addresses_controller.rb
class Api::V1::AddressesController < ApplicationController
  before_action :authorize_request # Ensure user is logged in
  before_action :set_address, only: [:destroy]

  # GET /api/v1/addresses
  def index
    @addresses = current_user.addresses.order(created_at: :asc) # Order for consistent display
    render json: @addresses, status: :ok
  end

  # POST /api/v1/addresses
  def create
    @address = current_user.addresses.build(address_params)

    if @address.save
      render json: @address, status: :created
    else
      render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/addresses/:id
  def destroy
    # Ensure the address belongs to the current user
    if @address.user_id != current_user.id
      render json: { errors: ['Unauthorized to delete this address.'] }, status: :forbidden and return
    end

    if @address.destroy
      head :no_content # 204 No Content
    else
      render json: { errors: ['Failed to delete address.'] }, status: :unprocessable_entity
    end
  end

  private

  def set_address
    @address = Address.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Address not found.'] }, status: :not_found
  end

  def address_params
    params.require(:address).permit(
      :address_line_1,
      :address_line_2,
      :city,
      :state,
      :zip_code,
      :address_type,
      :latitude,
      :longitude
    )
  end
end