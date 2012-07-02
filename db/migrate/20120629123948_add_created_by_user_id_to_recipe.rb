class AddCreatedByUserIdToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :created_by_user_id, :integer
  end
end
