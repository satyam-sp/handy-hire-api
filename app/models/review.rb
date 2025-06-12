class Review < ApplicationRecord
  belongs_to :job
  belongs_to :user
  belongs_to :employee, counter_cache: true

  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true, length: { minimum: 10 }

  before_create :handle_anonymous_review
  after_create :update_employee_rating

  private

  def handle_anonymous_review
    if ENV["ALLOW_ANONYMOUS_REVIEWS"] == "true" && self.anonymous
      self.employer_id = nil  # Remove employer ID for anonymity
    end
  end

  def update_employee_rating
    employee.update(average_rating: employee.reviews.average(:rating).to_f.round(1))
  end
end
