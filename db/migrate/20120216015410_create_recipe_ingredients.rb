class CreateRecipeIngredients < ActiveRecord::Migration
  def change
    create_table :recipe_ingredients, :id => false do |t|
      t.integer :recipe_id
      t.integer :ingredient_id
      t.integer :order

      t.timestamps
    end
  end
end
