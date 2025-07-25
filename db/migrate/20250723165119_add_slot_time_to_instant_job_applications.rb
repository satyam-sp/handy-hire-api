class AddSlotTimeToInstantJobApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :instant_job_applications, :slot_time, :string
  end
end
