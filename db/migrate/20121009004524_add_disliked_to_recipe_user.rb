class AddDislikedToRecipeUser < ActiveRecord::Migration
  def change
    add_column :recipe_users, :disliked, :boolean
  end
end
