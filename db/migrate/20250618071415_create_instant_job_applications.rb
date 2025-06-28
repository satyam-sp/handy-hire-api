class CreateInstantJobApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :instant_job_applications do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :instant_job, null: false, foreign_key: true
      t.decimal :final_price
      t.integer :status, default: 0, null: false  # enum: pending (0), accepted (1), rejected (2)ar
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
