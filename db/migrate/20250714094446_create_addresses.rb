class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address_line_1, null: false
      t.string :address_line_2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :address_type, null: false # e.g., 'Home', 'Work', 'Other', 'Current'
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7

      t.timestamps
    end
  end
end
