class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :employee, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.text :message
      t.string :image_url
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
