class Api::V1::JobApplicationsController < ApplicationController
  before_action :authenticate_employee, only: [:create, :withdraw]
  before_action :authenticate_employer, only: [:update_status]
  before_action :set_job, only: [:create]
  before_action :set_application, only: [:update_status, :withdraw]

  # ✅ Apply for a Job
  def create
    application = @job.job_applications.new(employee: @current_employee, cover_letter: params[:cover_letter])

    if application.save
      render json: { message: "Application submitted successfully", application: application }, status: :created
    else
      render json: { error: application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Employer Accepts/Rejects the Application
  def update_status
    if @application.update(status: params[:status])
      render json: { message: "Application status updated", application: @application }, status: :ok
    else
      render json: { error: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Employee Withdraws Application
  def withdraw
    if @application.employee == @current_employee
      @application.update(status: "withdrawn")
      render json: { message: "Application withdrawn" }, status: :ok
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Job not found" }, status: :not_found
  end

  def set_application
    @application = JobApplication.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Application not found" }, status: :not_found
  end
end
