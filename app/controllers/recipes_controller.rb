require 'rubygems'
require 'aws/s3'

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
    params.delete(:id) unless params[:id].to_i > 0
    @recipe = Recipe.where(:id => params[:id]).first

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
    @recipe = Recipe.create(:title => params[:recipe][:title], 
                            :directions => params[:recipe][:directions], 
                            :glass => params[:glass], 
                            :alcohol => params[:recipe][:alcohol])

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

  private

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