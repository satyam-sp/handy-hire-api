class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.references :user, null: false, foreign_key: true # Employer who posted the job
      t.references :job_category, null: false, foreign_key: true # Job category reference
      t.string :title, null: false
      t.text :description, null: false
      t.string :location, null: false
      t.decimal :expected_pay, precision: 10, scale: 2, null: false
      t.string :pay_type, null: false, default: "fixed" # hourly, daily, fixed
      t.string :payment_mode
      t.date :start_date, null: false
      t.date :end_date
      t.string :status, null: false, default: "open" # open, closed, in_progress, completed

      t.timestamps
    end
  end
end
