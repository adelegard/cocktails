class Ingredient < ActiveRecord::Base
	has_many :recipe_ingredients
	has_many :recipe, :through => :recipe_ingredients

  	class << self
		def search(term)
			return Ingredient.where(:conditions => ['ingredient LIKE ?', "%#{term}%"])
		end
	end
end
