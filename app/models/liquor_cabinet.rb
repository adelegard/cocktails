class LiquorCabinet < ActiveRecord::Base
  belongs_to :user
  belongs_to :ingredient

  class << self

    # Add an ingredient to a users liquor cabinet
  	def addIngredient(ingredient_name, user_id)
  	  ingredient = Ingredient.where(:ingredient => ingredient_name).first
      liquor_cabinet = LiquorCabinet.find_or_initialize_by_user_id_and_ingredient_id(user_id, ingredient.id)
      liquor_cabinet.save
  	end

    def addIngredientById(ingredient_id, user_id)
      liquor_cabinet = LiquorCabinet.find_or_initialize_by_user_id_and_ingredient_id(user_id, ingredient_id)
      liquor_cabinet.save
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

    def removeIngredientById(ingredient_id, user_id)
      liquor_cabinet = LiquorCabinet.where(:user_id => user_id, :ingredient_id => ingredient_id).first
      if liquor_cabinet != nil
        LiquorCabinet.delete_all(["user_id = ? AND ingredient_id = ?", user_id, ingredient_id])
      end
    end

    def getByUserId(user_id)
  	  liquor_cabinet_ingredients = LiquorCabinet.where(:user_id => user_id)
  	  ingredients = []
  	  liquor_cabinet_ingredients.each do |lci|
  	    ingredients << Ingredient.where(:id => lci.ingredient_id).first
  	  end
      ingredients.sort_by! { |i| i.ingredient.downcase }
  	  ingredients
    end

    def inCabinet(ingredient_id, user_id)
      LiquorCabinet.where(:ingredient_id => ingredient_id, :user_id => user_id).size == 1
    end

    def getCountByIngredientId(ingredient_id)
      LiquorCabinet.where(:ingredient_id => ingredient_id).size
    end

    def getAvailableRecipes(params, user_id)
      params[:sort] ||= "created_at"
      params[:direction] ||= "DESC"
      ingredients = LiquorCabinet.where(:user_id => user_id)
      Recipe.search(:field_weights => {:ingredients => 10, :directions => 1},
                    :with => {:ingredient_ids => ingredients.collect{|i| i.ingredient_id}},
                    :order => "#{params[:sort]} #{params[:direction]}",
                    :page => params[:page], :per_page => params[:per_page])
    end
  end
end
