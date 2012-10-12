class RemoveRatingFromRecipeUser < ActiveRecord::Migration
  def change
    remove_column :recipe_users, :rating
  end
end
