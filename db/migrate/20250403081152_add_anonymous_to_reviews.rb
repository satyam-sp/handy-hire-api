class AddAnonymousToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :anonymous, :boolean, default: false
  end
end
