class AddDeltaColumnToRecipesAndIngredients < ActiveRecord::Migration
  def change
      add_column :recipes, :delta, :boolean, :default => true, :null => false
      add_column :ingredients, :delta, :boolean, :default => true, :null => false
  end
end
