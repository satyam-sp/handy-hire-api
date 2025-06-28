class CreateInstantJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :instant_jobs do |t|
      t.string  :title, null: false
      t.text    :description
      t.float   :latitude, null: false
      t.float   :longitude, null: false
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :zipcode
      t.string :state
      t.string :country, default: 'india'
      t.integer :status, default: 0, null: false  # enum: pending (0), accepted (1), rejected (2)ar
      t.references :user, null: false, foreign_key: true
      t.references :job_category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :instant_jobs, [:latitude, :longitude]
  end
end
