class Job < ApplicationRecord
  belongs_to :user  # Employer who created the job
  belongs_to :job_category
  # has_many :applications, dependent: :destroy

  validates :title, :description, :location, :expected_pay, :pay_type, :job_category_id, presence: true
  validates :expected_pay, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[open closed in_progress completed] }
end
