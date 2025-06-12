class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string  :full_name, null: false
      t.string  :username, null: false
      t.string  :email, null: false
      t.string  :mobile_number, null: false
      t.string  :password_digest, null: false
      t.string  :profile_photo
      t.text    :address

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :mobile_number, unique: true
  end
end
