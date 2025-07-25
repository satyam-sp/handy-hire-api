module Api
  module V1# app/serializers/notification_serializer.rb
    class NotificationsSerializer
      include JSONAPI::Serializer

      # Define the JSON:API type for this resource.
      # This will appear as "type": "notifications" in your JSON output.
      set_type :notification

      # Define attributes to be serialized.
      # For direct model attributes, just list them.
      attributes :id, :message, :read, :created_at, :notifiable_type, :notifiable_id, :image_url

      # For computed attributes (like recipient_type, job_title, sender_name),
      # use the `attribute` method with a block. The block receives the object (notification) as an argument.

      attribute :recipient_type do |notification|
        notification.user_id.present? ? 'user' : 'employee'
      end

      attribute :job_title do |notification|
        # Safely access job title if notifiable is an InstantJobApplication and has a job
        if notification.notifiable.is_a?(InstantJobApplication) && notification.notifiable.instant_job.present?
          notification.notifiable.instant_job.title
        else
          nil
        end
      end

      attribute :sender_name do |notification|
        # Safely access sender name if notifiable is an InstantJobApplication and has an employee
        if notification.notifiable.is_a?(InstantJobApplication) && notification.notifiable.employee.present?
          notification.notifiable.employee.full_name || notification.notifiable.employee.user&.full_name
        else
          nil
        end
      end

      # If you wanted to include relationships in the JSON:API format, you would use:
      # has_one :user, serializer: UserSerializer # Assuming you have a UserSerializer
      # has_one :employee, serializer: EmployeeSerializer # Assuming you have an EmployeeSerializer
      # Polymorphic relationships in JSON:API can be more complex to include automatically,
      # but embedding the relevant data via `attribute` blocks (as done above) is often simpler for derived info.
    end
  end
end