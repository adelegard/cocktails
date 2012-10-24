class LiquorCabinet < ActiveRecord::Base
  belongs_to :user
  belongs_to :ingredient

  class << self

    # Add an ingredient to a users liquor cabinet
  	def add(ingredient_name, user_id)
  	  ingredient = Ingredient.where(:ingredient => ingredient_name).first
      liquor_cabinet = LiquorCabinet.find_or_initialize_by_user_id_and_ingredient_id(user_id, ingredient.id)
      liquor_cabinet.save
  	end

    def add_by_id(ingredient_id, user_id)
      liquor_cabinet = LiquorCabinet.find_or_initialize_by_user_id_and_ingredient_id(user_id, ingredient_id)
      liquor_cabinet.save
    end

    # remove an ingredient from a users liquor cabinet
  	def remove(ingredient_name, user_id)
  	  ingredient = Ingredient.where(:ingredient => ingredient_name).first
  	  if ingredient == nil
  	    render :nothing => false
  	  end

  	  liquor_cabinet = LiquorCabinet.where(:user_id => user_id, :ingredient_id => ingredient.id).first
  	    
  	  if liquor_cabinet != nil
  	    LiquorCabinet.delete_all(["user_id = ? AND ingredient_id = ?", user_id, ingredient.id])
  	  end
  	end

    def remove_by_id(ingredient_id, user_id)
      liquor_cabinet = LiquorCabinet.where(:user_id => user_id, :ingredient_id => ingredient_id).first
      if liquor_cabinet != nil
        LiquorCabinet.delete_all(["user_id = ? AND ingredient_id = ?", user_id, ingredient_id])
      end
    end

    def by_user_id(user_id)
  	  liquor_cabinet_ingredients = LiquorCabinet.where(:user_id => user_id)
  	  ingredients = []
  	  liquor_cabinet_ingredients.each do |lci|
  	    ingredients << Ingredient.where(:id => lci.ingredient_id).first
  	  end
      ingredients.sort_by! { |i| i.ingredient.downcase }
  	  ingredients
    end

    def in_cabinet(ingredient_id, user_id)
      LiquorCabinet.where(:ingredient_id => ingredient_id, :user_id => user_id).count == 1
    end

    def count_by_ingredient_id(ingredient_id)
      LiquorCabinet.where(:ingredient_id => ingredient_id).count
    end

    # this method totally sucks and needs to be vastly optimized
    def available_recipes(params, user_id)
      params[:sort] ||= "created_at"
      params[:direction] ||= "DESC"
      ingredients = LiquorCabinet.where(:user_id => user_id)
      lc_ingredient_ids = ingredients.collect(&:ingredient_id)
      recipes = Recipe.search(:field_weights => {:ingredients => 10, :directions => 1},
                    :with => {:ingredient_ids => lc_ingredient_ids},
                    :order => "#{params[:sort]} #{params[:direction]}",
                    :page => params[:page], :per_page => params[:per_page])
      result_recipes = []
      full_recipes = Recipe.full_recipes(recipes, user_id)
      full_recipes.each do |recipe|
        ingredient_ids = recipe[:ingredients].collect{|r| r[:ingredient][:id]}
        if (ingredient_ids - lc_ingredient_ids).empty?
          result_recipes << recipe
        end
      end
      result_recipes
    end
  end
end
