class RemoveRecipeStringFromRecipeTitles < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE recipes
      SET title = TRIM(TRAILING ' recipe' FROM title)
    SQL
  end
end
