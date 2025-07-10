# app/serializers/api/v1/employee_serializer.rb

module Api
  module V1
    class UserSerializer
      include JSONAPI::Serializer
      include Rails.application.routes.url_helpers

      set_type :user

      attributes :full_name,
                 :id,
                 :mobile_number,
                 :address
                 

      attribute :profile_photo_url do |object|
        object.profile_photo.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.profile_photo, only_path: true) : nil
      end
    

    end
  end
end
