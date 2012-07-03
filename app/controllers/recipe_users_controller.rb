class RecipeUsersController < ApplicationController
	before_filter :authenticate_user!

  def create
    @recipe_user = RecipeUser.create(params[:recipe_user])
  end

  def created
    @recipes = Recipe.where(:created_by_user_id => current_user.id).paginate(:order => "created_at DESC",
                                                                             :page => params[:page],
                                                                             :per_page => params[:per_page])
    @recipe_users = RecipeUser.getRecipeUsers(@recipes, current_user.id)
    @total_ratings = RecipeUser.getTotalRatings(@recipes)

    @title = "My Created Recipes"
    render 'search/search'
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
    RecipeUser.rate(params[:recipe_id], current_user.id, params[:rating])

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
end
