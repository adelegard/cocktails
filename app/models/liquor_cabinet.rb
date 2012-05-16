class LiquorCabinet < ActiveRecord::Base
  belongs_to :user
  belongs_to :ingredient

  class << self

	# Add an ingredient to a users liquor cabinet
  	def addIngredient(ingredient_name, user_id)
  	  ingredient = Ingredient.where(:ingredient => ingredient_name).first
      @liquor_cabinet = LiquorCabinet.find_or_initialize_by_user_id_and_ingredient_id(user_id, ingredient.id)
      @liquor_cabinet.save
  	end

	# remove an ingredient from a users liquor cabinet
  	def removeIngredient(ingredient_name, user_id)
	  ingredient = Ingredient.where(:ingredient => ingredient_name).first
	  if ingredient == nil
	    render :nothing => false
	  end

	  liquor_cabinet = LiquorCabinet.where(:user_id => user_id, :ingredient_id => ingredient.id).first
	    
	  if liquor_cabinet != nil
	    LiquorCabinet.delete_all(["user_id = ? AND ingredient_id = ?", user_id, ingredient.id])
	  end
  	end

    def getByCurrentUser(user_id)
	  liquor_cabinet_ingredients = LiquorCabinet.where(:user_id => user_id)
	  ingredients = []
	  liquor_cabinet_ingredients.each do |lci|
	    ingredients << Ingredient.where(:id => lci.ingredient_id).first
	  end
	  return ingredients
    end

    def getAvailableRecipes(params, user_id)
	    orderBy = params[:sort] != nil ? params[:sort] : "rating_count"
	    orderBy += params[:direction] != nil ? " " + params[:direction].to_s : " DESC"

	    #wow this is slow... hopefully thinking sphinx will fix it
	    return Recipe.paginate_by_sql(["select r.*
	                                  from recipes r
	                                  join recipe_ingredients ri ON r.id = ri.recipe_id
	                                  join recipe_ingredients ri2 on r.id = ri2.recipe_id
	                                  join ingredients i ON ri.ingredient_id = i.id
	                                  where i.id IN (select ingredient_id
	                                                 from liquor_cabinets
	                                                 where user_id = ?)
	                                  group by r.id
	                                  having count(distinct ri.ingredient_id) = count(distinct ri2.ingredient_id)", user_id],
	                                  :order => orderBy,
	                                  :page => params[:page], :per_page => params[:per_page])
    end
  end
end
