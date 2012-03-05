class LiquorCabinetController < ApplicationController
  
  def view
    liquor_cabinet_ingredients = LiquorCabinet.where(:user_id => current_user.id)
    @ingredients = []
    liquor_cabinet_ingredients.each do |lci|
      @ingredients << Ingredient.where(:id => lci.ingredient_id).first
    end

    render 'users/liquor_cabinet'
  end

  def add
  	# Add an ingredient to a users liquor cabinet
  	ingredient = Ingredient.where(:ingredient => params[:q]).first
    @liquor_cabinet = LiquorCabinet.find_or_initialize_by_user_id_and_ingredient_id(current_user.id, ingredient.id)
    @liquor_cabinet.save

    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end

  def remove
  	# remove an ingredient from a users liquor cabinet
    ingredient = Ingredient.where(:ingredient => params[:q]).first
    if ingredient == nil
      render :nothing => false
    end


    liquor_cabinet = LiquorCabinet.where(:user_id => current_user.id, :ingredient_id => ingredient.id).first
    
    if liquor_cabinet != nil
      LiquorCabinet.delete_all(["user_id = ? AND ingredient_id = ?", current_user.id, ingredient.id])
    end

    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end
end
