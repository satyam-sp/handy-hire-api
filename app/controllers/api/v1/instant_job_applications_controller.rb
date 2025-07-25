module Api
  module V1
    class InstantJobApplicationsController < ApplicationController
      before_action :set_employee , except: [:index,:update_status, :cancel_application, :revoke_application]
      before_action :set_instant_job

    

      def index
        job_applications
        render json: Api::V1::InstantJobApplicationSerializer.new(@job_applications,  {params: {recommended_app_id: @recommented_application&.id}}).serializable_hash[:data]
      end


      def revoke_application
        binding.pry

        @instant_job.instant_job_applications.update_all(status: 'applied')
        job_applications
        render json: Api::V1::InstantJobApplicationSerializer.new(@job_applications,  {params: {recommended_app_id: @recommented_application&.id}}).serializable_hash[:data]
      end



      def update_status
        application = InstantJobApplication.find(params[:id])
        InstantJobApplication.transaction do
          application.update!(status: params[:status])
          if params[:status] == 2
            other_applications = InstantJobApplication.where(instant_job_id: application.instant_job_id)
                                                      .where.not(id: application.id)
                                                      .where(status: 'accepted') # Only update if not already 'applied'
    
            other_applications.update_all(status: 'applied')
          end
          job_applications
          render json: Api::V1::InstantJobApplicationSerializer.new(@job_applications, {params: {recommended_app_id: @recommented_application&.id}}).serializable_hash[:data]
        end
    
      end


      def create
        application = InstantJobApplication.find_or_initialize_by(
          employee: @employee,
          instant_job: @instant_job
        )

        # Allow optional status param, default to 'pending'
        application.status = params[:status] || 'pending'
        application.final_price = params[:final_price]
        application.slot_time = params[:slot_time]

        if application.save
          # send_apply_notification(application)
          render json: {
            message: "Application #{application.previously_new_record? ? 'created' : 'updated'} successfully",
            application: application
          }, status: :ok
        else
          render json: { errors: application.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def cancel_application
        application = InstantJobApplication.find(params[:id])
        if application
          application.destroy
          # send_cancel_notification application
          render json: { message: "Application deleted successfully", application: {} }, status: :ok
        else
          render json: { error: "Application not found" }, status: :not_found
        end
      end

      private


      def job_applications
        @job_applications = @instant_job.instant_job_applications
        .applied_or_accepted
        .joins(:employee)
        .order('employees.full_name ASC')
        @recommented_application = RecommendedJobApplicationService.new(@instant_job).call

      end

      def set_employee
        @employee = Employee.find(params[:employee_id]) || current_employee
      end

      def set_instant_job
        @instant_job = InstantJob.find(params[:instant_job_id])
      end


      def send_cancel_notification application
        employee = application.employee
        instant_job = application.instant_job
        user = instant_job.user
        title = '👨‍🔧 Application Cancelled'
        description ="#{employee.full_name} has withdrawn their application for Job ##{instant_job.jid} ❌"
        NotificationSenderFcmV1Sender.send_push_notification(user.fcm_token,title,description)
      end

      def send_apply_notification application
        employee = application.employee
        instant_job = application.instant_job
        user = instant_job.user
        title = '👨‍🔧 New Application Received' 
        description ="You’ve received a new application from #{employee.full_name} for job ##{instant_job.jid}. Offered price: ₹#{application.final_price} 🔔"
        NotificationSenderFcmV1Sender.send_push_notification(user.fcm_token,title,description)
      end
    end
  end
end

