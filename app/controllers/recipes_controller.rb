require 'rubygems'
require 'aws/s3'

class RecipesController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @recipes = Recipe.paginate(:order => "rating_count DESC",
                               :page => params[:page], :per_page => params[:per_page])

    if user_signed_in?
      @recipe_users = []
    end
    @total_ratings = 0
    @recipes.each do |recipe|
      if user_signed_in?
        recipe_user = RecipeUser.where(:recipe_id => recipe.id, :user_id => current_user.id).first
        if recipe_user != nil
          @recipe_users << recipe_user
        end
      end
      @total_ratings += recipe.rating_count != nil ? recipe.rating_count : 0
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

    @ingredients = []
    recipe_ingredients = RecipeIngredient.where(:recipe_id => params[:id])
    recipe_ingredients.each do |recipe_ingredient|
      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
      if user_signed_in?
        in_liquor_cabinet = liquor_cabinet_ingredients.include?(recipe_ingredient.ingredient_id)
      else
        in_liquor_cabinet = nil
      end
      @ingredients << {:ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount, :in_liquor_cabinet => in_liquor_cabinet}
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