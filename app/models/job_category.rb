class JobCategory < ApplicationRecord
    has_many :children, class_name: 'JobCategory', foreign_key: 'parent_id', dependent: :destroy
    belongs_to :parent, class_name: 'JobCategory', optional: true

  
    # has_many :employees_job_categories
    # has_many :employees, through: :employees_job_categories
  
    validates :name, presence: true, uniqueness: true
end
