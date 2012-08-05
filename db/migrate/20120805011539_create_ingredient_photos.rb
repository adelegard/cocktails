class CreateIngredientPhotos < ActiveRecord::Migration
  def change
    create_table :ingredient_photos do |t|
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.references :ingredient
      t.references :user

      t.timestamps
    end
    add_index :ingredient_photos, :ingredient_id
    add_index :ingredient_photos, :user_id
  end
end
