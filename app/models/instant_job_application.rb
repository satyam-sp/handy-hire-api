class InstantJobApplication < ApplicationRecord
  belongs_to :employee
  belongs_to :instant_job

  # Optional: status of application (e.g., pending, accepted, rejected)
  enum status: { pending: 0, applied: 1, accepted: 2 }

  validates :employee_id, uniqueness: { scope: :instant_job_id, message: "has already applied for this job" }

end
