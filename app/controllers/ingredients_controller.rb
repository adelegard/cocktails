class IngredientsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]

  # GET /ingredients/:id
  def show
    params[:direction] ||= "DESC"
    params[:page] ||= 1
    params[:per_page] ||= 20
    @ingredient = Ingredient.find(params[:id])
    @photos = IngredientPhoto.where(:ingredient_id => @ingredient.id)

    @in_cabinet = false
    if user_signed_in?
      @in_cabinet = LiquorCabinet.inCabinet(@ingredient.id, current_user.id)
    end

    @ingredient_photos = IngredientPhoto.where(:ingredient_id => @ingredient.id)

    @lc_count = LiquorCabinet.getCountByIngredientId(@ingredient.id)
    @recipe_count = Recipe.getRecipeCountByIngredient(@ingredient.id)

    recipes_popular = Recipe.getPopularRecipesWithIngredients(params, [@ingredient.id])
    recipes_new = Recipe.getNewRecipesWithIngredients(params, [@ingredient.id])

    user_id = user_signed_in? ? current_user.id : nil
    @full_recipes_popular = Recipe.getFullRecipes(recipes_popular, user_id)
    @full_recipes_new = Recipe.getFullRecipes(recipes_new, user_id)

    # friendly_id magic that redirects users with an old url to the current one
    if request.path != ingredient_path(@ingredient)
      redirect_to @ingredient, :status => :moved_permanently
    else
      render :detail
    end
  end

  # GET /ingredients/:id/uploadphoto
  def uploadphoto
    @ingredient = Ingredient.find(params[:id])
    @ingredient_photo = IngredientPhoto.new(:ingredient_id => @ingredient.id, :user_id => current_user.id)
  end

  # POST /ingredients/:id/do_upload_photo
  def do_upload_photo
    ingredient = Ingredient.find(params[:ingredient_id])
    ingredient_photo = IngredientPhoto.create(:ingredient_id => params[:ingredient_id],
                                          :user_id => current_user.id)
    ingredient_photo.update_attributes(params[:ingredient_photo])
    params[:id] = params[:ingredient_id]

    if ingredient_photo.save
      redirect_to ingredient_path(ingredient), :notice => 'Photo was successfully added!'
    else
      redirect_to ingredient_path(ingredient), :error => 'Error uploading photo :('
    end
  end

end
