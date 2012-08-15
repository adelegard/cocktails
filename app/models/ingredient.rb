class Ingredient < ActiveRecord::Base
	has_many :recipe_ingredients
	has_many :recipe, :through => :recipe_ingredients

	validates :ingredient, :presence => true, :length => { :in => 2..60 }, :uniqueness => true

	define_index do
		# fields
		indexes ingredient, :sortable => true

		# attributes
		has :id, :as => :ingredient_id
		has created_at
		has updated_at
		set_property :delta => :delayed
	end

  	class << self

		def get_ingredients(recipe_id, user_signed_in, liquor_cabinet_ingredients)
		    ingredients = []
		    recipe_ingredients = RecipeIngredient.where(:recipe_id => recipe_id)
		    recipe_ingredients.each do |recipe_ingredient|
		      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
		      if user_signed_in
		        in_liquor_cabinet = liquor_cabinet_ingredients.include?(recipe_ingredient.ingredient_id)
		      else
		        in_liquor_cabinet = nil
		      end
		      ingredients << {:id => ingredient.id, :ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount, :in_liquor_cabinet => in_liquor_cabinet}
			  ingredients.sort_by! { |i| [ i[:in_liquor_cabinet] ? 0 : 1, i[:ingredient].downcase ] }
		    end
		    return ingredients
		end

		def getMostUsed(params)
			return Ingredient.paginate_by_sql(["select i.*
												from ingredients i
												join (
													select ri.ingredient_id as id, count(ri.ingredient_id) as count
													from recipe_ingredients ri
													group by ingredient_id
													order by count desc
												) innerQuery on innerQuery.id = i.id"],
			                                    :page => params[:page], :per_page => params[:per_page])
		end
	end
end
