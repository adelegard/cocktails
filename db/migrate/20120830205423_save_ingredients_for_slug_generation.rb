class SaveIngredientsForSlugGeneration < ActiveRecord::Migration
  def change
    Ingredient.find_each(&:save)
  end
end
