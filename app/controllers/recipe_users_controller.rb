class RecipeUsersController < BaseRecipesController
	before_filter :authenticate_user!
  before_filter :display_search_sidebar, :except => [:create]

  def create
    @recipe_user = RecipeUser.create(params[:recipe_user])
  end

  def created
    recipes = Recipe.created_by_user_id(params, current_user.id)
    @full_recipes = Recipe.getFullRecipes(recipes, current_user.id)
    render 'recipes/created'
  end

  def liked
    recipes = RecipeUser.getLikedRecipesByUserId(params, current_user.id)
    @full_recipes = Recipe.getFullRecipes(recipes, current_user.id)
    render 'recipes/liked'
  end

  def disliked
    recipes = RecipeUser.getDislikedRecipesByUserId(params, current_user.id)
    @full_recipes = Recipe.getFullRecipes(recipes, current_user.id)
    render 'recipes/disliked'
  end

  def favorites
    recipes = RecipeUser.getFavoriteRecipesByUserId(params, current_user.id)
    @full_recipes = Recipe.getFullRecipes(recipes, current_user.id)
    render 'recipes/favorites'
  end

  def liquor_cabinet_recipes
    recipes = LiquorCabinet.getAvailableRecipes(params, current_user.id)
    @full_recipes = Recipe.getFullRecipes(recipes, current_user.id)

    @title = "Cocktails I Can Make!"
    render 'search/search'
  end

  # Actions

  def favorite
    RecipeUser.favorite(params[:id], current_user.id)

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  def share
    RecipeUser.share(params[:id], current_user.id)

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

  def dislike
    RecipeUser.dislike(params[:id], current_user.id)

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
end
