class CreateLiquorCabinets < ActiveRecord::Migration
  def change
    create_table :liquor_cabinets, :id => false do |t|
      t.integer :user_id
      t.integer :ingredient_id

      t.timestamps
    end
  end
end
