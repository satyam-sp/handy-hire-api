# app/serializers/api/v1/employee_serializer.rb

module Api
  module V1
    class EmployeeSerializer
      include JSONAPI::Serializer
      include Rails.application.routes.url_helpers

      set_type :employee

      attributes :full_name,
                 :id,
                 :mobile_number,
                 :email,
                 :date_of_birth,
                 :gender,
                 :aadhaar_number,
                 :pan_number,
                 :address,
                 :job_categories,
                 :experience_years,
                 :work_location,
                 :availability,
                 :expected_pay,
                 :languages_spoken

      # attribute :profile_photo_url do |object|
      #   object.profile_photo.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.profile_photo, only_path: true) : nil
      # end
    end
  end
end
