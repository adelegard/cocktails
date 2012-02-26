class RecipeUsersController < ApplicationController
	before_filter :authenticate_user!

  def all_rated
    @user_recipes = RecipeUser.where(:user_id => current_user.id)
    @recipes = Recipe.find(@user_recipes.collect{|user_recipe| user_recipe.recipe_id})
    Recipe.paginate(:conditions => ['id IN ?', "%#{@user_recipes.collect{|user_recipe| user_recipe.recipe_id}}%"], :order => "rating_count DESC, rating_avg DESC", :page => params[:page], :per_page => params[:per_page])
    render 'search/search'
  end

  def favorites
    @recipes = Recipe.joins('JOIN recipe_users ru ON ru.recipe_id = recipes.id WHERE ru.starred = 1').paginate(:order => "rating_count DESC, rating_avg DESC", :page => params[:page], :per_page => params[:per_page])
    render 'recipes/favorites'
  end

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

  def favorite
    @recipe = Recipe.where(:id => params[:recipe_id]).first
    @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
    @recipe_user.starred = @recipe_user.starred == false || @recipe_user.starred == nil ? true : false
    @recipe_user.save

    recipe_ingredients = RecipeIngredient.where(:recipe_id => params[:id])
    @ingredients = []
    recipe_ingredients.each do |recipe_ingredient|
      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
      @ingredients << {:ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount}
    end

    render 'recipes/show'
  end

  def uploadphoto
      @recipe = Recipe.where(:id => params[:id]).first
      render 'recipes/upload_photo'
  end
end
