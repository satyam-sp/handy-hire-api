module Api
  module V1
    class InstantJobSerializer
      include JSONAPI::Serializer

      attributes :title, :description, :latitude, :longitude, :status, :id, :price, :rate_type_humanize, :created_at
      attribute :distance_in_km do |job|
        job.respond_to?(:distance) ? job.distance&.round(2) : nil
      end

      attribute :user do |job|
        {
          full_name: job.user.full_name,
        }
      end

      attribute :job_category do |job|
        {
          name: job.job_category.name
        }
      end


      attribute :images do |job, params|      
        if job.images.attached?
          job.images.map do |image|
            {
              id: image.id,
              url: Rails.application.routes.url_helpers.rails_blob_url(image)
            }
          end
        else
          []
        end
      end
      attribute :application_status do |job, params|
        employee = params[:current_employee]
        if employee.present?
          application = InstantJobApplication.find_by(employee: employee, instant_job: job)
          application&.status
        else
          'pending'
        end
      end

      attribute :final_price do |job, params|
        employee = params[:current_employee]
        if employee.present?
          application = InstantJobApplication.find_by(employee: employee, instant_job: job)
          application&.final_price
        else
          'pending'
        end
      end


      
    end
  end
end
