class AddPriceAndJobTypeToInstantJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :instant_jobs, :price, :decimal
    add_column :instant_jobs, :rate_type, :integer, default: 0, null: false

  end
end
