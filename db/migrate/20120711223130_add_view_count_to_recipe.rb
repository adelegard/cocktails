class AddViewCountToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :view_count, :integer
  end
end
