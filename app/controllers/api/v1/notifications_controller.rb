# app/controllers/api/v1/notifications_controller.rb
module Api
  module V1
    class NotificationsController < ApplicationController
      # Ensure that only authenticated users or employees can access these actions
      # You'll need to adapt `authenticate_user_or_employee!` based on your actual authentication system
     
      before_action :authorize_request
      # GET /api/v1/notifications
      # Fetches all notifications for the currently logged-in user or employee
      def index
        if current_user # Assuming `current_user` method returns the authenticated User
          @notifications = current_user.notifications.recent
        elsif current_employee # Assuming `current_employee` method returns the authenticated Employee
          @notifications = current_employee.notifications.recent
        else
          render json: { error: "Authentication required or no valid recipient found." }, status: :unauthorized
          return
        end

        render json: Api::V1::NotificationsSerializer.new(@notifications).serializable_hash
      end

      # PATCH /api/v1/notifications/:id/mark_as_read
      # Marks a specific notification as read
      def mark_as_read
        @notification = Notification.find_by(id: params[:id])

        if @notification.nil?
          render json: { error: "Notification not found." }, status: :not_found
          return
        end

        # Ensure that only the actual recipient can mark their notification as read
        is_recipient = (@notification.user == current_user) || (@notification.employee == current_employee)

        if is_recipient
          if @notification.update(read: true)
            render json: { success: true, notification: Api::V1::NotificationsSerializer.new(@notification).serializable_hash }
          else
            render json: { error: @notification.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        else
          render json: { error: "You are not authorized to mark this notification as read." }, status: :unauthorized
        end
      end

      private

    end
  end
end