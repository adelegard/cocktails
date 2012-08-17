class RecipeUsersController < BaseRecipesController
	before_filter :authenticate_user!
  before_filter :display_search_sidebar, :except => [:create, :created, :rate, :favorite, :unfavorite]

  def create
    @recipe_user = RecipeUser.create(params[:recipe_user])
  end

  def save_attr
    recipe = Recipe.find(params[:id])
    respond_to do |format|
      if recipe.update_attribute(params[:attr], params[:value])
        format.js { render :text => params[:value] }
      else
        format.js { render :text => recipe[params[:attr]] }
      end
    end
  end

  def created
    @recipes = Recipe.getCreatedRecipesByUserId(params, current_user.id)
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
      format.js { render :nothing => true }
    end
  end

  def favorite
    RecipeUser.favorite(params[:id], current_user.id)

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  def unfavorite
    RecipeUser.unfavorite(params[:id], current_user.id)

    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end

  def like
    RecipeUser.like(params[:id], current_user.id)

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

end
