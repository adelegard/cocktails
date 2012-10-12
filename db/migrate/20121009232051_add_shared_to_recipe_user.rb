class AddSharedToRecipeUser < ActiveRecord::Migration
  def change
    add_column :recipe_users, :shared, :integer
    remove_column :recipes, :shared
  end
end
