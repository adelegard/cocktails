class RecipesController < BaseRecipesController

  before_filter :authenticate_user!, :except => [:index, :new_recipes, :popular, :show]
  before_filter :display_search_sidebar, :except => [:show, :new, :uploadphoto]

  def index
    setup_new_recipes
    setup_popular_recipes
    @most_used = Ingredient.getMostUsed(params)
  end

  def new_recipes
    setup_new_recipes
  end

  def popular
    setup_popular_recipes
  end

  def show
    setup_show
  end

  def comments
    setup_show
    @active_tab = "comments"
    render 'recipes/show'
  end

  def photos
    setup_show
    @active_tab = "photos"
    render 'recipes/show'
  end

  def new
    @recipe = Recipe.new
    @glasses = Recipe.getAllGlasses

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recipe }
    end
  end

  def create
    @recipe = Recipe.create(:title => params[:recipe][:title], 
                            :directions => params[:recipe][:directions],
                            :inspiration => params[:recipe][:inspiration], 
                            :glass => params[:glass], 
                            :alcohol => params[:recipe][:alcohol],
                            :servings => params[:servings],
                            :created_by_user_id => current_user.id)
    if params[:recipe_photo] != nil
      recipe_photo = RecipePhoto.create(:recipe_id => @recipe.id,
                                        :user_id => current_user.id)
      recipe_photo.update_attributes(params[:recipe_photo])
    end

    order = 1
    params[:recipe][:ing].each do |key, val|
      ingredient = Ingredient.find_or_create_by_ingredient(val[:liquor])
      RecipeIngredient.create(:recipe_id => @recipe.id, :ingredient_id => ingredient.id, 
                           :order => order, :amount => "#{val[:val]} #{val[:amt]}")
      order = order + 1
    end

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render json: @recipe, status: :created, location: @recipe }
      else
        @glasses = Recipe.getAllGlasses
        format.html { render action: "new" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  def uploadphoto
      @recipe = Recipe.where(:id => params[:id]).first
      @recipe_photo = RecipePhoto.new(:recipe_id => @recipe.id, :user_id => current_user.id)
      render 'recipes/upload_photo'
  end

  def do_upload_photo
    recipe_photo = RecipePhoto.create(:recipe_id => params[:recipe_id],
                                      :user_id => current_user.id)
    recipe_photo.update_attributes(params[:recipe_photo])
    params[:id] = params[:recipe_id]
    setup_show
    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Photo was successfully added!' }
      else
        format.html { redirect_to @recipe, error: 'Error uploading photo :(' }
      end
    end
  end

  def share
    Recipe.share(params)

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  private

  def setup_popular_recipes
    @recipes_popular = Recipe.getPopularRecipes(params)
    @total_ratings_popular = Recipe.total_ratings(@recipes_popular)
    user_id = current_user != nil && current_user.id ? current_user.id : nil
    @full_recipes_popular = Recipe.getFullRecipes(@recipes_popular, user_id)
    if user_signed_in?
      @recipe_users_popular = RecipeUser.getRecipeUsers(@recipes_popular, current_user.id)
    end
  end

  def setup_new_recipes
    @recipes_new = Recipe.new_recipes(params)
    @total_ratings_new = Recipe.total_ratings(@recipes_new)
    user_id = current_user != nil && current_user.id ? current_user.id : nil
    @full_recipes_new = Recipe.getFullRecipes(@recipes_new, user_id)
    if user_signed_in?
      @recipe_users_new = RecipeUser.getRecipeUsers(@recipes_new, current_user.id)
    end
  end

end