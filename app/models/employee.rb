class Employee < ApplicationRecord
    has_secure_password  # Enables authentication via bcrypt
    
    # Validations
    # validates :username, presence: true, uniqueness: true
    # validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
    validates :full_name, presence: true
    validates :mobile_number, presence: true, uniqueness: true
    # validates :aadhaar_number, presence: true, uniqueness: true
    # validates :job_category, presence: true
    # 
    has_one_attached :avatar

    has_many :instant_job_applications
    has_many :instant_jobs, through: :instant_job_applications

    has_many_attached :videos
    has_many :notifications, dependent: :destroy # Assuming employee is a recipient of notifications

    validate :videos_limit
      
    before_save :format_mobile_number
  
    def format_mobile_number
      self.mobile_number = "+91#{mobile_number}" unless mobile_number.start_with?("+91")
    end

    def job_categories
      JobCategory.where(id: job_category_ids)
    end

    def avatar_url
      if avatar.attached?
        Rails.application.routes.url_helpers.url_for(avatar)
      else
        ActionController::Base.helpers.asset_url('employee-avatar.png', host: Rails.application.config.asset_host || Rails.application.routes.default_url_options[:host])
      end
    end

    private

    def videos_limit
      if videos.attached? && videos.count > 4
        errors.add(:videos, "cannot have more than 4 videos")
      end
    end
end
