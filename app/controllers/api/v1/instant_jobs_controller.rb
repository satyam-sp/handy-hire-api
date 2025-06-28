class Api::V1::InstantJobsController < ApplicationController

  before_action :set_instance_job, only: [:show]
  def show
    render json: Api::V1::InstantJobSerializer.new(@instance_job,{ params: {current_employee: current_employee} }).serializable_hash[:data][:attributes]
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




    render json: Api::V1::InstantJobsSerializer.new(jobs, is_collection: true).serializable_hash[:data]

  end

  private
  def set_instance_job
    @instance_job = InstantJob.find(params[:id])
  end
end