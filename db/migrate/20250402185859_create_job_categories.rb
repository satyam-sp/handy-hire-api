class CreateJobCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :job_categories do |t|
      t.string  :name, null: false  # Removed `unique: true` from here
      t.string  :description
      t.boolean :active, default: false
      t.references :parent, foreign_key: { to_table: :job_categories }, index: true
      t.timestamps
    end

    # Adding unique index for name
    add_index :job_categories, :name, unique: true
  end
end
