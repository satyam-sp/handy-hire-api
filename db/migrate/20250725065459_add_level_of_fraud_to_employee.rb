class AddLevelOfFraudToEmployee < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :fraud_level, :integer, default: 0
  end
end
