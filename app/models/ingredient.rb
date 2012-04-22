class Ingredient < ActiveRecord::Base
	has_many :recipe_ingredients
	has_many :recipe, :through => :recipe_ingredients

  	class << self
		def search(term)
			return Ingredient.where(:conditions => ['ingredient LIKE ?', "%#{term}%"])
		end

		def getIngredients(recipe_id, user_signed_in, liquor_cabinet_ingredients)
		    ingredients = []
		    recipe_ingredients = RecipeIngredient.where(:recipe_id => recipe_id)
		    recipe_ingredients.each do |recipe_ingredient|
		      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
		      if user_signed_in
		        in_liquor_cabinet = liquor_cabinet_ingredients.include?(recipe_ingredient.ingredient_id)
		      else
		        in_liquor_cabinet = nil
		      end
		      ingredients << {:ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount, :in_liquor_cabinet => in_liquor_cabinet}
		    end
		    return ingredients
		end
	end
end
