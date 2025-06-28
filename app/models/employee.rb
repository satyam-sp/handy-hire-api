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


      
    before_save :format_mobile_number
  
    def format_mobile_number
      self.mobile_number = "+91#{mobile_number}" unless mobile_number.start_with?("+91")
    end

    def job_categories
      JobCategory.where(id: job_category_ids)
    end
end
