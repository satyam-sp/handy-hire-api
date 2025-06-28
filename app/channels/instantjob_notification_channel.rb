class InstantjobNotificationChannel < ApplicationCable::Channel
  def subscribed
    employee_id = params[:employee_id]

    if employee_id.blank?
      Rails.logger.warn("❌ No employee_id in subscription")
      return
    end

    stream_name = "ij_employee_notifications_#{employee_id}"
    Rails.logger.info("📡 Subscribed to: #{stream_name}")
    stream_from stream_name
  end
  def receive(data)
    Rails.logger.info("📥 received called with: #{data.inspect}")
  end
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

