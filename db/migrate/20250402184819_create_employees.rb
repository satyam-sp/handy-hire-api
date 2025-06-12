class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      # Authentication
      # t.string  :username, null: false
      t.string  :email
      t.string  :password_digest, null: false

      

      # Basic Information
      t.string  :full_name, null: false
      t.date    :date_of_birth
      t.string  :gender
      t.string  :mobile_number, null: false

      # Identity & Verification
      t.string  :aadhaar_number
      t.boolean :aadhaar_verified, default: false
      t.string  :pan_number
      t.text    :address

      t.text :current_address
      t.boolean :same_as_permanent_address

      # Job Details
      t.integer :experience_years
      t.string  :work_location
      t.string  :availability, default: "parttime"
      t.decimal :expected_pay, precision: 10, scale: 2

      t.boolean :verified, default: :false

      # JSONB Fields
      t.jsonb  :job_category_ids, default: []

      t.jsonb   :languages_spoken, default: []
      t.jsonb   :references_list, default: []
      t.jsonb   :work_photos, default: []
      t.jsonb   :additional_info, default: {}

      # Verification & Ratings
      t.boolean :police_verified, default: false
      t.decimal :rating, precision: 3, scale: 2, default: 0.0
      t.integer :reviews_count, default: 0

      t.integer :registration_step, default: 0


      t.timestamps
    end

    # Add unique constraints
    # add_index :employees, :username, unique: true
    add_index :employees, :email, unique: true
    add_index :employees, :aadhaar_number, unique: true
    add_index :employees, :mobile_number, unique: true
  end
end
