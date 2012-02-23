class AddRatingsToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :rating_avg, :decimal

    add_column :recipes, :rating_count, :integer

  end
end
