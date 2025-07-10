class AddSlotDateAndSlotTimeToInstantJobs < ActiveRecord::Migration[7.1]
  def change

      add_column :instant_jobs, :slot_date, :date
      add_column :instant_jobs, :slot_time, :string

  end
end
