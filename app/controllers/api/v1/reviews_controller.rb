class Api::V1::ReviewsController < ApplicationController
  before_action :authenticate_employer, only: [:create]
  before_action :set_job, only: [:create]
  before_action :check_job_completion, only: [:create]


  # ✅ Submit a Review (Supports Anonymous Mode)
  def create
    anonymous_allowed = ENV["ALLOW_ANONYMOUS_REVIEWS"] == "true"
    anonymous_review = params[:anonymous] == "true" && anonymous_allowed

    review = @job.reviews.new(
      employer: anonymous_review ? nil : @current_employer,
      employee: @job.employee,
      rating: params[:rating],
      comment: params[:comment],
      anonymous: anonymous_review
    )

    if review.save
      render json: { message: "Review submitted successfully", review: review }, status: :created
    else
      render json: { error: review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Get Reviews for an Employee (Hide employer name if anonymous)
  def index
    employee = User.find(params[:employee_id])
    reviews = employee.reviews.select(:id, :rating, :comment, :anonymous, :created_at)

    reviews_data = reviews.map do |review|
      {
        id: review.id,
        rating: review.rating,
        comment: review.comment,
        created_at: review.created_at,
        reviewer: review.anonymous ? "Anonymous" : review.employer&.full_name
      }
    end

    render json: { employee: employee.full_name, average_rating: employee.average_rating, reviews: reviews_data }, status: :ok
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Job not found" }, status: :not_found
  end

  def check_job_completion
    unless @job.status == "completed"
      render json: { error: "Review can only be submitted after job completion" }, status: :unprocessable_entity
    end
  end
end

