class CreateRecipePhotos < ActiveRecord::Migration
  def change
    create_table :recipe_photos do |t|
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.references :recipe
      t.references :user

      t.timestamps
    end
    add_index :recipe_photos, :recipe_id
    add_index :recipe_photos, :user_id
  end
end
