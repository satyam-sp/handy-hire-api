# db/migrate/<timestamp>_remove_auth_columns_add_otp_fields_to_users.rb
class RemoveAuthColumnsAddOtpFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      # Remove existing columns
      # t.remove :username
      # t.remove :email
      # t.remove :password_digest

      # Add new columns for OTP
      t.string :otp_secret
      t.datetime :otp_sent_at
    end
    change_column_null :users, :full_name, true


    # Remove indices on columns that no longer exist
    # Ensure these indices exist before attempting to remove them in a real app.
    # In your provided migration, only email has a unique index, so we remove that.
    # remove_index :users, :email # This will remove the index on email if it exists
  end
end