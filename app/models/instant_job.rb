class InstantJob < ApplicationRecord
  belongs_to :user
  belongs_to :job_category
  after_create :notify_nearby_employees


  has_many :instant_job_applications
  has_many :employees, through: :instant_job_applications

  reverse_geocoded_by :latitude, :longitude

  enum status: { active: 0, hold: 1, progress: 2, closed: 3 }
  enum rate_type: {
    per_hour: 0,
    per_day: 1,
    per_job: 2
  }

  has_many_attached :images
  
  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?


  def full_address
    [address_line1, address_line2, city, state, zipcode].compact.join(', ')
  end


  def rate_type_humanize
    rate_type.humanize
  end
  def image_urls
    object.images.map { |img| Rails.application.routes.url_helpers.rails_blob_url(img, only_path: true) }
  end

  def notify_nearby_employees
    radius = 10 # km
    # nearby_employees = Employee.near([latitude, longitude], radius)
    nearby_employees = Employee.all
  
    nearby_employees.each do |employee|
      ActionCable.server.broadcast(
        "ij_notifications_employee_4",
        {
          job_id: id,
          title: "New Job Available!",
          message: description,
          location: { lat: latitude, lng: longitude }
        }
      )
    end
  end


  private

  def address_changed?
    will_save_change_to_address_line1? ||
    will_save_change_to_address_line2? ||
    will_save_change_to_city? ||
    will_save_change_to_state? ||
    will_save_change_to_zipcode?
  end




end