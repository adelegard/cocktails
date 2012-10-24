class LiquorCabinetController < ApplicationController
  before_filter :authenticate_user!

  # GET /cabinet  
  def view
    @ingredients = LiquorCabinet.by_user_id(current_user.id)
    render :liquor_cabinet
  end

  # This method and the remove method should be ditched. Passing in a string like this is dumb.
  # POST /cabinet/add
  def add
    if LiquorCabinet.add(params[:q], current_user.id)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # DELETE /cabinet/remove
  def remove
    if LiquorCabinet.remove(params[:q], current_user.id)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # POST /cabinet/:id/add_by_id
  def add_by_id
    if LiquorCabinet.add_by_id(params[:id], current_user.id)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # DELETE /cabinet/:id/remove_by_id
  def remove_by_id
    if LiquorCabinet.remove_by_id(params[:id], current_user.id)
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
