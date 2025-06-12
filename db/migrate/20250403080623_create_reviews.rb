class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :job, null: false, foreign_key: true
      t.references :user, null: false
      t.references :employee, null: false
      t.integer :rating, null: false
      t.text :comment, null: false
      t.timestamps
    end
  end
end
