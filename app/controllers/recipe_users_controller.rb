class RecipeUsersController < ApplicationController
	before_filter :authenticate_user!

  def rate
    @recipe = Recipe.where(:id => params[:recipe_id]).first
    @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
    @recipe_user.rating = params[:rating]
    @recipe_user.save

    recipe_ingredients = RecipeIngredient.where(:recipe_id => params[:id])
    @ingredients = []
    recipe_ingredients.each do |recipe_ingredient|
      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
      @ingredients << {:ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount}
    end

    render 'recipes/show'
  end

  def star
    @recipe = Recipe.where(:id => params[:recipe_id]).first
    @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
    @recipe_user.starred = @recipe_user.starred == false ? true : false
    @recipe_user.save

    recipe_ingredients = RecipeIngredient.where(:recipe_id => params[:id])
    @ingredients = []
    recipe_ingredients.each do |recipe_ingredient|
      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
      @ingredients << {:ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount}
    end

    render 'recipes/show'
  end
end
