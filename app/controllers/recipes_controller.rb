class RecipesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @recipes = Recipe.paginate(:order => "rating_count DESC, rating_avg DESC", :page => params[:page], :per_page => params[:per_page])
  end

  def show
    params.delete(:id) unless params[:id].to_i > 0
    @recipe = Recipe.where(:id => params[:id]).first

    recipe_ingredients = RecipeIngredient.where(:recipe_id => params[:id])
    @ingredients = []
    recipe_ingredients.each do |recipe_ingredient|
      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
      @ingredients << {:ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount}
    end

    if user_signed_in? == true
      @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
    end

    render 'recipes/show'
  end

  def new
    @recipe = Recipe.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recipe }
    end
  end

  def create
    @recipe = Recipe.new(params[:recipe])
    @recipe.save

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

  def update
    @recipe = Recipe.where(:id => params[:id]).first
debugger
    @recipe.filename = params[:recipe][:photo].original_filename
    @recipe.content_type = params[:recipe][:photo].content_type
    @recipe.save

    recipe_ingredients = RecipeIngredient.where(:recipe_id => params[:id])
    @ingredients = []
    recipe_ingredients.each do |recipe_ingredient|
      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
      @ingredients << {:ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount}
    end

    if user_signed_in? == true
      @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
    end

    render 'recipes/show'
  end

  def rate
    @recipe = Recipe.where(:id => params[:recipe_id]).first
    recipe_user = RecipeUser.find_or_init(:recipe_id => params[:recipe_id], :user_id => current_user.id)
    recipe_user.rating = params[:rating]
    recipe_user.save

    render 'recipes/show'
  end

  def star
    @recipe = Recipe.where(:id => params[:id]).first
    recipe_user = RecipeUser.find_or_init(:recipe_id => params[:id], :user_id => current_user.id)
    recipe_user.starred = recipe_user.starred == false ? true : false
    recipe_user.save

    render 'recipes/show'
  end

end