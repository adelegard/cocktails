class LiquorCabinetController < ApplicationController
  
  def view
    @ingredients = LiquorCabinet.getByUserId(current_user.id)
    render 'users/liquor_cabinet'
  end

  # This method and the remove method should be ditched. Passing in a string like this is dumb.
  def add
    LiquorCabinet.addIngredient(params[:q], current_user.id)
    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end

  def remove
    LiquorCabinet.removeIngredient(params[:q], current_user.id)
    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end

  def add_by_id
    LiquorCabinet.addIngredientById(params[:id], current_user.id)
    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end

  def remove_by_id
    LiquorCabinet.removeIngredientById(params[:id], current_user.id)
    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end
end
