class IngredientsController < ApplicationController

  before_filter :authenticate_user!, :except => [:detail]

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

    @recipes_popular = Recipe.getPopularRecipesWithIngredients(params, [@ingredient.id])
    @recipes_new = Recipe.getNewRecipesWithIngredients(params, [@ingredient.id])

    @total_ratings_popular = RecipeUser.getTotalRatings(@recipes_popular)
    @total_ratings_new = RecipeUser.getTotalRatings(@recipes_new)

    user_id = user_signed_in? ? current_user.id : nil
    @full_recipes_popular = Recipe.getFullRecipes(@recipes_popular, user_id)
    @full_recipes_new = Recipe.getFullRecipes(@recipes_new, user_id)

    if user_signed_in?
      @recipe_users_popular = RecipeUser.getRecipeUsers(@recipes_popular, current_user.id)
      @recipe_users_new = RecipeUser.getRecipeUsers(@recipes_new, current_user.id)
    end

    render 'ingredients/detail'
  end

  def uploadphoto
      @ingredient = Ingredient.find(params[:id])
      @ingredient_photo = IngredientPhoto.new(:ingredient_id => @ingredient.id, :user_id => current_user.id)
      render 'ingredients/upload_photo'
  end

  def do_upload_photo
    ingredient = Ingredient.find(params[:ingredient_id])
    ingredient_photo = IngredientPhoto.create(:ingredient_id => params[:ingredient_id],
                                          :user_id => current_user.id)
    ingredient_photo.update_attributes(params[:ingredient_photo])
    params[:id] = params[:ingredient_id]

    respond_to do |format|
      if ingredient_photo.save
        format.html { redirect_to ingredient_path(ingredient), notice: 'Photo was successfully added!' }
      else
        format.html { redirect_to ingredient_path(ingredient), error: 'Error uploading photo :(' }
      end
    end
  end

end
