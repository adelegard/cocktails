class LiquorCabinetController < ApplicationController
  
  def view
    @ingredients = LiquorCabinet.getByCurrentUser(current_user.id)
    render 'users/liquor_cabinet'
  end

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
end
