class RecipesController < BaseRecipesController

  before_filter :authenticate_user!, :except => [:index, :new_recipes, :popular, :show]
  before_filter :display_search_sidebar, :except => [:show, :new, :uploadphoto]

  # GET /
  def index
    setup_popular_recipes
    setup_new_recipes
    setup_liked_recipes
    setup_disliked_recipes
    setup_favorited_recipes
    setup_created_recipes
    #@most_used = Ingredient.getMostUsed(params)
  end

  # GET /recipes/recent
  def recent
    setup_new_recipes
  end

  # GET /recipes/popular
  def popular
    setup_popular_recipes
  end

  # GET /recipes/:id
  def show
    setup_show
    # friendly_id magic that redirects users with an old url to the current one
    if request.path != recipe_path(@recipe)
      redirect_to @recipe, :status => :moved_permanently
    end
  end

  def comments
    setup_show
    @active_tab = "comments"
    render :show
  end

  def photos
    setup_show
    @active_tab = "photos"
    render :show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
    @glasses = Recipe.getAllGlasses
  end

  # POST /recipes/
  def create
    @recipe = Recipe.create(params[:recipe])
    if params[:recipe_photo] != nil
      recipe_photo = RecipePhoto.create(:recipe_id => @recipe.id,
                                        :user_id => current_user.id)
      recipe_photo.update_attributes(params[:recipe_photo])
    end

    order = 1
    params[:recipe_ing].each do |key, val|
      ingredient = Ingredient.find_or_create_by_ingredient(val[:liquor])
      RecipeIngredient.create(:recipe_id => @recipe.id, :ingredient_id => ingredient.id, 
                           :order => order, :amount => "#{val[:val]} #{val[:amt]}")
      order = order + 1
    end

    if @recipe.save
      redirect_to @recipe, :notice => 'Recipe was successfully created.'
    else
      @glasses = Recipe.getAllGlasses
      render :action => "new"
    end
  end

  # GET /recipes/:id/uploadphoto
  def uploadphoto
    @recipe = Recipe.where(:id => params[:id]).first
    @recipe_photo = RecipePhoto.new(:recipe_id => @recipe.id, :user_id => current_user.id)
  end

  # POST /recipes/:id/do_upload_photo
  def do_upload_photo
    recipe_photo = RecipePhoto.create(:recipe_id => params[:recipe_id],
                                      :user_id => current_user.id)
    recipe_photo.update_attributes(params[:recipe_photo])
    params[:id] = params[:recipe_id]
    setup_show
    if @recipe.save
      redirect_to @recipe, :notice => 'Photo was successfully added!'
    else
      redirect_to @recipe, :error => 'Error uploading photo :('
    end
  end

  private

  def setup_popular_recipes
    recipes_popular = Recipe.getPopularRecipes(params)
    user_id = current_user != nil && current_user.id ? current_user.id : nil
    @full_recipes_popular = Recipe.getFullRecipes(recipes_popular, user_id)
  end

  def setup_new_recipes
    recipes_new = Recipe.getNewRecipes(params)
    user_id = current_user != nil && current_user.id ? current_user.id : nil
    @full_recipes_new = Recipe.getFullRecipes(recipes_new, user_id)
  end

  def setup_liked_recipes
    return if !user_signed_in?
    recipes = RecipeUser.getLikedRecipesByUserId(params, current_user.id)
    @full_recipes_liked = Recipe.getFullRecipes(recipes, current_user.id)
  end

  def setup_disliked_recipes
    return if !user_signed_in?
    recipes = RecipeUser.getDislikedRecipesByUserId(params, current_user.id)
    @full_recipes_disliked = Recipe.getFullRecipes(recipes, current_user.id)
  end

  def setup_favorited_recipes
    return if !user_signed_in?
    recipes = RecipeUser.getFavoriteRecipesByUserId(params, current_user.id)
    @full_recipes_favorited = Recipe.getFullRecipes(recipes, current_user.id)
  end

  def setup_created_recipes
    return if !user_signed_in?
    recipes = Recipe.created_by_user_id(params, current_user.id)
    @full_recipes_created = Recipe.getFullRecipes(recipes, current_user.id)
  end
end