class RecipePublishing < ActiveRecord::Migration
  def up
    add_column :recipes, :published, :timestamp
    Recipe.update_all ["published = ?", Time.now]
  end

  def down
    remove_column :recipes, :published
  end
end
