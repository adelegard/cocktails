class AddAttachmentPhotoToRecipeUser < ActiveRecord::Migration
  def change
    add_column :recipe_users, :photo_file_name, :string
    add_column :recipe_users, :photo_content_type, :string
    add_column :recipe_users, :photo_file_size, :integer
    add_column :recipe_users, :photo_updated_at, :datetime
  end
end
