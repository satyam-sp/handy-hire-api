module Api
  module V1
    class InstantJobSerializer
      include JSONAPI::Serializer

      attributes  :title, :description, :latitude,:jid, :longitude, :status, :id, :price, :rate_type_humanize, :created_at,:slot_date, :slot_time
      # attribute :title do |job, params|
      #   get_translations(job, params)[:title]
      # end
    
      # attribute :description do |job, params|
      #   get_translations(job, params)[:description]
      # end
    
      
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
      attribute :application do |object, params|
        employee = params[:current_employee]
        application = InstantJobApplication.find_by(employee_id: employee&.id, instant_job_id: object&.id)
        if application
          {
            id: application.id,
            status: application.status,
            final_price: application.final_price,
            slot_time: application.slot_time,
            applied_at: application.created_at
          }
        else
          nil
        end
      end


      private

      def self.get_translations(job, params)
        lang = params[:lang] || "en"
        cache = params[:_translation_cache] ||= {}
      
        # If lang is empty or 'en', return original texts without translation
        if lang == "en" || lang.empty?
          return {
            title: job.title.to_s,
            description: job.description.to_s
          }
        end
      
        cache_key = "#{job.id}_#{lang}_#{job.updated_at.to_i}"
        return cache[cache_key] if cache.key?(cache_key)
      
        result = Rails.cache.fetch("instant_job_#{cache_key}", expires_in: 12.hours) do
          texts = [job.title.to_s, job.description.to_s]
          translated = LibreTranslateService.new.translate_batch(texts, from: "en", to: lang)
          {
            title: translated[0],
            description: translated[1]
          }
        end
      
        cache[cache_key] = result
        result
      end


      
    end
  end
end
