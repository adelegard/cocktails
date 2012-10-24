class RecipeUsersController < BaseRecipesController
	before_filter :authenticate_user!
  before_filter :display_search_sidebar

  # GET /recipes/created
  def created
    recipes = Recipe.created_by_user_id(params, current_user.id)
    @full_recipes = Recipe.full_recipes(recipes, current_user.id)
    render 'recipes/created'
  end

  # GET /recipes/liked
  def liked
    recipes = RecipeUser.liked_recipes_by_user_id(params, current_user.id)
    @full_recipes = Recipe.full_recipes(recipes, current_user.id)
    render 'recipes/liked'
  end

  # GET /recipes/disliked
  def disliked
    recipes = RecipeUser.disliked_recipes_by_user_id(params, current_user.id)
    @full_recipes = Recipe.full_recipes(recipes, current_user.id)
    render 'recipes/disliked'
  end

  # GET /recipes/favorites
  def favorites
    recipes = RecipeUser.favorite_recipes_by_user_id(params, current_user.id)
    @full_recipes = Recipe.full_recipes(recipes, current_user.id)
    render 'recipes/favorites'
  end

  # GET /recipes/liquor_cabinet
  def liquor_cabinet_recipes
    @full_recipes = LiquorCabinet.available_recipes(params, current_user.id)

    @title = "Cocktails I Can Make!"
    render 'search/search'
  end

  # Actions

  # POST /recipes/:id/favorite.json
  def favorite
    if RecipeUser.favorite(params[:id], current_user.id)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # POST /recipes/:id/share.json
  def share
    if RecipeUser.share(params[:id], current_user.id)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # POST /recipes/:id/like.json
  def like
    if RecipeUser.like(params[:id], current_user.id)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # POST /recipes/:id/dislike.json
  def dislike
    if RecipeUser.dislike(params[:id], current_user.id)
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
