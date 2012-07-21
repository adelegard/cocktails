class AddServingsToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :servings, :integer, :default => 1
  end
end
