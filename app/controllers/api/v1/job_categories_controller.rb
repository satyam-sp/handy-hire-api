class Api::V1::JobCategoriesController < ApplicationController
  def index
    job_categories = JobCategory.includes(:children).where(parent_id: nil)
    
    render json: job_categories.as_json(
      only: [:id, :name],
      include: {
        children: { only: [:id, :name, :active] }
      }
    )
  end
end
