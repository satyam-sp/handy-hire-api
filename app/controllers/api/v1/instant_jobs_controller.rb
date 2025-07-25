class Api::V1::InstantJobsController < ApplicationController
  # You might need a before_action to authenticate the user/customer for creating jobs
  # For example: before_action :authenticate_customer!, only: [:create]
  # Or if you have a general authentication: before_action :authenticate_user!, only: [:create]

  before_action :set_instance_job, only: [:show]
  before_action :authorize_request, only: [:create, :get_active_jobs, :get_jobs_by_cords, :show]

  def show
    render json: Api::V1::InstantJobSerializer.new(@instance_job,{ params: {current_employee: current_employee, lang: params[:lang]} }).serializable_hash[:data][:attributes]
  end

  def get_active_jobs
    instant_jobs = current_user.instant_jobs.where(status: 'active')
    render json: Api::V1::InstantJobsSerializer.new(instant_jobs, is_collection: true).serializable_hash[:data]
  end

  def get_jobs_by_cords
    lat = params[:lat]
    lon = params[:lon]
    category_ids = params[:job_category_ids] || current_employee.job_category_ids
    radius_km = params[:radius] || 10


    if lat.blank? || lon.blank? || category_ids.blank?
      render json: { error: 'latitude, longitude, and job_category_ids are required' }, status: :unprocessable_entity
      return
    end

    jobs = InstantJob
             .where(job_category_id: category_ids)
             .near([lat, lon], radius_km, units: :km)

    applications = InstantJobApplication
    .where(employee_id: current_employee.id, instant_job_id: jobs.map(&:id))
    .index_by(&:instant_job_id)


    render json: Api::V1::InstantJobsSerializer.new(jobs, {
      params: {
    current_employee: current_employee,
    applications: applications
  }
    }).serializable_hash[:data]

  end

  def create
    # Assuming 'current_customer' is available from your authentication system
    # and that an InstantJob belongs_to :customer
    @instant_job = current_user.instant_jobs.new(instant_job_params)
    if @instant_job.save
      # Render the created job's attributes with a 201 Created status
      render json: Api::V1::InstantJobSerializer.new(@instant_job).serializable_hash[:data][:attributes], status: :created
    else
      # Render validation errors with a 422 Unprocessable Entity status
      render json: { errors: @instant_job.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # --- END NEW ---

  private

  def set_instance_job
    @instance_job = InstantJob.find(params[:id])
  end

  # --- NEW: Strong Parameters for Create Method ---
  def instant_job_params
    params.require(:instant_job).permit(
      :title,
      :description,
      :job_category_id,
      :slot_date,
      :slot_time,
      :rate_type,
      :price,
      :address_line_1,
      :address_line_2,
      :city,
      :state,
      :zip_code,
      :latitude,
      :longitude,
      image_urls: [], 
    )
  end
  # --- END NEW ---
end