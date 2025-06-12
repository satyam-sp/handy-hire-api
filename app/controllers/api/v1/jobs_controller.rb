class Api::V1::JobsController < ApplicationController
  before_action :authenticate_user
  before_action :set_job, only: [:update, :destroy]
  

  # ✅ Create a new job
  
  def create
    job = @current_user.jobs.new(job_params)

    if job.save
      render json: { message: "Job posted successfully!", job: job }, status: :created
    else
      render json: { error: job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Update job
  def update
    if @job.update(job_params)
      render json: { message: "Job updated successfully!", job: @job }, status: :ok
    else
      render json: { error: @job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Delete job
  def destroy
    @job.destroy
    render json: { message: "Job deleted successfully!" }, status: :ok
  end

  private

  def set_job
    @job = @current_user.jobs.find_by(id: params[:id])
    render json: { error: "Job not found" }, status: :not_found unless @job
  end

  def job_params
    params.permit(:title, :description, :job_category_id, :location, :expected_pay, :pay_type, :start_date, :end_date, :status, :payment_mode)
  end
end
