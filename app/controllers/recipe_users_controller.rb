class RecipeUsersController < ApplicationController
	before_filter :authenticate_user!

  def create
    @recipe_user = RecipeUser.create(params[:recipe_user])
  end

  def update
    RecipeUser.update(params[:recipe_user])

    render 'recipes/show'
  end

  def rated
    @recipes = RecipeUser.getRatedRecipesByUserId(params, current_user.id)
    @recipe_users = RecipeUser.getRecipeUsers(@recipes, current_user.id)
    @total_ratings = RecipeUser.getTotalRatings(@recipes)

    @title = "My Rated Recipes"
    render 'search/search'
  end

  def favorites
    @recipes = RecipeUser.getFavoriteRecipesByUserId(params, current_user.id)
    @recipe_users = RecipeUser.getRecipeUsers(@recipes, current_user.id)
    @total_ratings = RecipeUser.getTotalRatings(@recipes)

    @title = "My Favorite Cocktails"
    render 'search/search'
  end

  def liquor_cabinet_recipes
    @recipes = LiquorCabinet.getAvailableRecipes(params, current_user.id)
    @recipe_users = RecipeUser.getRecipeUsers(@recipes, current_user.id)
    @total_ratings = RecipeUser.getTotalRatings(@recipes)

    @title = "Cocktails I Can Make!"
    render 'search/search'
  end

  def rate
    RecipeUser.rate(params[:id], current_user.id)

    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end

  def favorite
    RecipeUser.favorite(params[:id], current_user.id)

    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end

  def unfavorite
    RecipeUser.unfavorite(params[:id], current_user.id)

    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end

  def uploadphoto
      @recipe = Recipe.where(:id => params[:recipe_id]).first
      @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
      render 'recipes/upload_photo'
  end
end
