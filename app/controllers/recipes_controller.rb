require 'rubygems'
require 'aws/s3'

class RecipesController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @recipes = Recipe.paginate(:order => "rating_count DESC",
                               :page => params[:page], :per_page => params[:per_page])
    @total_ratings = RecipeUser.getTotalRatings(@recipes)
    if user_signed_in?
      @recipe_users = RecipeUser.getRecipeUsers(@recipes, current_user.id)
    end
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
    @recipe = Recipe.create(params[:recipe])

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

end