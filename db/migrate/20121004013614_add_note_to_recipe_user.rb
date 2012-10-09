class AddNoteToRecipeUser < ActiveRecord::Migration
  def change
    add_column :recipe_users, :note, :text
    add_column :recipe_users, :note_updated_at, :datetime
  end
end
