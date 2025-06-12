class CreateJobApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :job_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.string :status, null: false, default: "pending" # pending, accepted, rejected, withdrawn, completed
      t.text :cover_letter

      t.timestamps
    end
  end
end
