class User < ApplicationRecord
  has_secure_password
  has_one_attached :profile_photo

  validates :full_name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile_number, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  validates :profile_photo, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes }

  def profile_photo_url
    profile_photo.attached? ? Rails.application.routes.url_helpers.rails_blob_url(profile_photo, only_path: true) : nil
  end

  private

  def password_required?
    new_record? || password.present?
  end
end
