class Notification < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :employee, optional: true

  # Polymorphic association to the object that caused the notification
  belongs_to :notifiable, polymorphic: true

  validates :message, presence: true
  
  # Ensure at least one recipient (user or employee) is present
  validate :one_recipient_must_be_present

  # Scopes for easy querying
  scope :unread, -> { where(read: false) }
  scope :for_user, ->(user) { where(user: user) }
  scope :for_employee, ->(employee) { where(employee: employee) }
  scope :recent, -> { order(created_at: :desc) }

  private

  def one_recipient_must_be_present
    unless user_id.present? || employee_id.present?
      errors.add(:base, "A notification must have either a user or an employee recipient.")
    end
  end
end
