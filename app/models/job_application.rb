class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates :status, inclusion: { in: %w[pending accepted rejected withdrawn completed] }

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= "pending"
  end
end
