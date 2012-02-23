class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :directions
      t.string :glass
      t.string :alcohol

      t.timestamps
    end
  end
end
