class CreateTableRecipeUsers < ActiveRecord::Migration
  def change
    create_table :recipe_users do |t|
	  t.integer :recipe_id
	  t.integer :user_id
      t.boolean :starred
      t.decimal :rating

      t.timestamps
    end
  end
end
