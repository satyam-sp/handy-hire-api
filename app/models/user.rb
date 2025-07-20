class User < ApplicationRecord
  # has_secure_password
  has_one_attached :profile_photo

  # validates :full_name, presence: true
  # validates :username, presence: true, uniqueness: { case_sensitive: false }
  # validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile_number, presence: true, uniqueness: true, format: { with: /\A[0-9]{10,15}\z/, message: "must be a valid mobile number" }
  # validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  validates :profile_photo, content_type: ['image/png', 'image/jpeg'], size: { less_than: 5.megabytes }
  # before_create :generate_otp_secret

  def profile_photo_url
    profile_photo.attached? ? Rails.application.routes.url_helpers.rails_blob_url(profile_photo, only_path: true) : nil
  end

  has_many :addresses, dependent: :destroy # If a user is deleted, their addresses are also deleted
  has_many :instant_jobs, dependent: :destroy # Assuming instant jobs are also linked to user


  def generate_otp_code
    # Implement your OTP generation logic (e.g., using SecureRandom, or a dedicated gem)
    # This should generate a 6-digit code
    code = rand(100000..999999).to_s
    code = 123456.to_s
    self.otp_secret = code # Store in a temporary column or cache
    self.otp_sent_at = Time.current
    save!
  end

  def verify_otp_code(entered_otp)
    # Implement your OTP verification logic
    # Check if entered_otp matches otp_secret and is not expired (e.g., within 5 minutes)
    # self.otp_secret == entered_otp && (Time.current - self.otp_sent_at) < 5.minutes
    self.otp_secret == entered_otp
  end


  private

  # def password_required?
  #   new_record? || password.present?
  # end
end


