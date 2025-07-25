module Api
  module V1
    class InstantJobsSerializer
      include JSONAPI::Serializer

      attributes :title, :description, :latitude, :longitude, :status, :id, :jid

      attribute :distance_in_km do |job|
        job.respond_to?(:distance) ? job.distance&.round(2) * 2 : nil
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

      attribute :application_status, if: proc { |_job, params|
        params[:applications]&.key?(_job.id)
      } do |job, params|
        params[:applications][job.id].status
      end
    end
  end
end
