module Api
  module V1
    class InstantJobApplicationsController < ApplicationController
      before_action :set_employee
      before_action :set_instant_job

      def create
        application = InstantJobApplication.find_or_initialize_by(
          employee: @employee,
          instant_job: @instant_job
        )

        # Allow optional status param, default to 'pending'
        application.status = params[:status] || 'pending'
        application.final_price = params[:final_price]

        if application.save
          render json: {
            message: "Application #{application.previously_new_record? ? 'created' : 'updated'} successfully",
            application: application
          }, status: :ok
        else
          render json: { errors: application.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def cancel_application
        application = InstantJobApplication.find_by(
          employee:  @employee || current_employee,
          instant_job: @instant_job
        )
      
        if application
          application.destroy
          render json: { message: "Application deleted successfully" }, status: :ok
        else
          render json: { error: "Application not found" }, status: :not_found
        end
      end

      private

      def set_employee
        @employee = Employee.find(params[:employee_id])
      end

      def set_instant_job
        @instant_job = InstantJob.find(params[:id])
      end
    end
  end
end
