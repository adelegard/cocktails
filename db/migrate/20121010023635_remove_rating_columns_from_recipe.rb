class RemoveRatingColumnsFromRecipe < ActiveRecord::Migration
  def change
    remove_column :recipes, :rating_avg
    remove_column :recipes, :rating_count
  end
end
