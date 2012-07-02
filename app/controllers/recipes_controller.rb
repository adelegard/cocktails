class RecipesController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

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
                            :glass => params[:glass], 
                            :alcohol => params[:recipe][:alcohol],
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

  private

  def setup_show
    params.delete(:id) unless params[:id].to_i > 0
    @recipe = Recipe.where(:id => params[:id]).first
    @recipe_creator = User.where(:id => @recipe.created_by_user_id).first if @recipe.created_by_user_id != nil
    @recipe_photos = RecipePhoto.where(:recipe_id => params[:id])

    liquor_cabinet_ingredients = []
    if user_signed_in?
      @recipe_user = RecipeUser.where(:recipe_id => params[:id], :user_id => current_user.id).first_or_create
      liquor_cabinet_ingredients = LiquorCabinet.where(:user_id => current_user.id).collect{|ingredient| ingredient.ingredient_id}
    end
    @ingredients = Ingredient.getIngredients(params[:id], user_signed_in?, liquor_cabinet_ingredients)

    user_data = RecipeUser.getUserData(params[:id])
    @num_starred = user_data[:num_starred]
    @num_rated = user_data[:num_rated]
    @avg_rating = user_data[:avg_rating]
  end

  def setup_popular_recipes
    @recipes_popular = Recipe.getPopularRecipes(params)
    @total_ratings_popular = RecipeUser.getTotalRatings(@recipes_popular)
    if user_signed_in?
      @recipe_users_popular = RecipeUser.getRecipeUsers(@recipes_popular, current_user.id)
    end
  end

  def setup_new_recipes
    @recipes_new = Recipe.getNewRecipes(params)
    @total_ratings_new = RecipeUser.getTotalRatings(@recipes_new)
    if user_signed_in?
      @recipe_users_new = RecipeUser.getRecipeUsers(@recipes_new, current_user.id)
    end
  end

end