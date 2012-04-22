class Recipe < ActiveRecord::Base
	has_many :recipe_ingredients
	has_many :recipe_users
	has_many :ingredients, :through => :recipe_ingredients
	has_many :users, :through => :recipe_users
	
	define_index do
	  indexes title, :sortable => true
	  indexes alcohol, :sortable => true
	  indexes directions
	  indexes ingredients(:ingredient), :as => :ingredient, :sortable => true
	  
	  has updated_at, created_at, rating_avg, rating_count
	  has ingredients(:id), :as => :ingredient_ids 
	end

	self.per_page = 12
end
