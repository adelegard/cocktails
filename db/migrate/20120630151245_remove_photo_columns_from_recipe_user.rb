class RemovePhotoColumnsFromRecipeUser < ActiveRecord::Migration
  def change
    remove_column :recipe_users, :photo_file_name
    remove_column :recipe_users, :photo_content_type
    remove_column :recipe_users, :photo_file_size
    remove_column :recipe_users, :photo_updated_at
  end
end
