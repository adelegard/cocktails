class Recipe < ActiveRecord::Base
	has_many :recipe_ingredients
	has_many :recipe_users
	has_many :ingredients, :through => :recipe_ingredients
	has_many :users, :through => :recipe_users

	self.per_page = 12
end
