class RecipeUsersController < BaseRecipesController
	before_filter :authenticate_user!
  before_filter :display_search_sidebar, :except => [:create]

  def create
    @recipe_user = RecipeUser.create(params[:recipe_user])
  end

  def created
    @recipes = Recipe.where(:created_by_user_id => current_user.id).
                  paginate(:order => "rating_count DESC, rating_avg DESC",
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

  # User Actions

  def rate
    RecipeUser.rate(params[:id], current_user.id, params[:rating])

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

  def like
    RecipeUser.like(params[:id], current_user.id)

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  def set_note
    params[:note] ||= nil
    RecipeUser.set_note(params[:id], current_user.id, params[:note])
    @recipe = Recipe.find(params[:id])
    redirect_to @recipe
  end

end
