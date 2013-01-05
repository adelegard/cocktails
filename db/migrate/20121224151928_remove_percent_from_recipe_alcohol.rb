class RemovePercentFromRecipeAlcohol < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE recipes
      SET alcohol = SUBSTRING(alcohol, 1, CHAR_LENGTH(alcohol) - 1)
      WHERE RIGHT(alcohol, 1) = '%'
    SQL
  end
end
