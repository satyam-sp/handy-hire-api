# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
# Destroy existing records to avoid duplication (optional, use cautiously in production)
JobCategory.destroy_all

# Define categories and subcategories
job_categories = {
  "Household Services" => [
    "Maid / Housekeeping", "Cook / Chef", "Babysitter / Nanny", 
    "Elderly Caregiver", "Driver"
  ],
  "Skilled Trades & Repairs" => [
    "Plumber", "Electrician", "Carpenter", "Painter", 
    "AC Technician", "Mechanic"
  ],
  "Construction & General Labor" => [
    "Mason", "Welder", "General Laborer", "Tile Worker", "Roofer"
  ],
  "Outdoor & Maintenance Services" => [
    "Gardener", "Security Guard", "Pest Control", "Car Washer"
  ],
  "Event & Catering" => [
    "Event Helper", "Wedding Decorator", "Catering Staff", "Photographer"
  ],
  "Factory & Warehouse" => [
    "Loader / Unloader", "Warehouse Assistant", "Machine Operator", "Packing Staff"
  ]
}

# Insert parent categories first
job_categories.each do |parent_name, subcategories|
  parent = JobCategory.find_or_create_by(name: parent_name, active: true)

  # Insert subcategories
  subcategories.each do |subcategory|
    JobCategory.find_or_create_by(name: subcategory, parent: parent, active: true)
  end
end


puts "✅ Job categories and subcategories seeded successfully!"


category = JobCategory.find_by(name: "Plumber")
user = User.first

InstantJob.create!(
  title: "Experienced Plumber Needed for Complete Bathroom Fitting",
  description: "Looking for a skilled plumber to install a new bathroom setup...",
  latitude: 22.60,
  longitude: 75.87,
  user: user,
  job_category: category
)