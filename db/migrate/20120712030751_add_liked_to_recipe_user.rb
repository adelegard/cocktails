class AddLikedToRecipeUser < ActiveRecord::Migration
  def change
    add_column :recipe_users, :liked, :boolean
  end
end
