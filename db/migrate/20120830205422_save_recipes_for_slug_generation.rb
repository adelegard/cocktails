class SaveRecipesForSlugGeneration < ActiveRecord::Migration
  def change
    Recipe.find_each(&:save)
  end
end
