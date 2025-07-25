
module Api
  module V1
    class InstantJobApplicationSerializer
      include JSONAPI::Serializer
      attributes  :status, :id, :final_price, :slot_time
      attribute :employee do |job|
        {
          full_name: job.employee.full_name,
          rating: job.employee.rating,
          categories: job.employee.job_categories.map(&:name)&.join(','),
          avatar_url: job.employee.avatar_url
        }
      end 

      attribute :recommended do |job, params|      
        if params[:recommended_app_id]
          params[:recommended_app_id]
        else
          nil
        end
      end
    end
  end
end
