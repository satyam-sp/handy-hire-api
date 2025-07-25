class InstantJobApplication < ApplicationRecord
  belongs_to :employee
  belongs_to :instant_job

  # Optional: status of application (e.g., pending, accepted, rejected)
  enum status: { pending: 0, applied: 1, accepted: 2 }

  validates :employee_id, uniqueness: { scope: :instant_job_id, message: "has already applied for this job" }
  scope :applied, -> { where(status: 'applied') }
  scope :applied_or_accepted, -> { where(status: ['applied', 'accepted']) }

  after_create :create_new_application_notification
  
  def create_new_application_notification
    # Notify the Job Poster (User) that a new application was received for their job
    # Ensure you have 'job' and 'employee' associations defined in this model
    Notification.create!(
      user: self.instant_job.user, 
      notifiable: self, 
      image_url: self.employee.avatar_url, 
      message: "New application for '##{self.instant_job.jid}' from 👨‍🔧#{self.employee.full_name || self.employee.user.full_name}. with offered price ₹#{self.final_price} ",
      read: false
    )
  end



end
