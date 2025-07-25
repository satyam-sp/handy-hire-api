class Address < ApplicationRecord
  belongs_to :user

  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates :address_type, presence: true, inclusion: { in: %w(Home Work Friend Other Current),
                                         message: "%{value} is not a valid address type" }

  # Custom validation to limit addresses per user
  validate :user_address_limit, on: :create

  reverse_geocoded_by :latitude, :longitude

  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?


  def full_address
    [address_line_1.strip, address_line_2.strip, city.strip, state.strip, zip_code.strip, 'india'].compact.join(', ')
  end


  private


  def address_changed?
    will_save_change_to_address_line_1? ||
    will_save_change_to_address_line_2? ||
    will_save_change_to_city? ||
    will_save_change_to_state? ||
    will_save_change_to_zip_code?
  end

  def user_address_limit
    if user && user.addresses.count >= 3
      errors.add(:base, "You can only have a maximum of 3 addresses.")
    end
  end
end
