class BaseRecipesController < ApplicationController

  private

  def display_search_sidebar
    @display_search_sidebar = true
  end

  def setup_show
    params.delete(:id) unless params[:id].to_i > 0
    recipe = Recipe.where(:id => params[:id]).first
    setup_show_with_recipe(recipe)
  end

  def setup_show_with_recipe(recipe)
    @display_search_sidebar = false
    @recipe = recipe
    @recipe.view_count = @recipe.view_count ? @recipe.view_count + 1 : 1 #increment the view count by 1
    @recipe.save
    @recipe_creator = User.where(:id => @recipe.created_by_user_id).first if @recipe.created_by_user_id != nil
    @recipe_photos = RecipePhoto.where(:recipe_id => @recipe.id)

    liquor_cabinet_ingredients = []
    if user_signed_in?
      @recipe_user = RecipeUser.where(:recipe_id => @recipe.id, :user_id => current_user.id).first_or_create
      liquor_cabinet_ingredients = LiquorCabinet.where(:user_id => current_user.id).collect{|ingredient| ingredient.ingredient_id}
    end
    @ingredients = Ingredient.getIngredients(@recipe.id, user_signed_in?, liquor_cabinet_ingredients)

    user_data = RecipeUser.getUserData(@recipe.id)
    @num_starred = user_data[:num_starred]
    @num_liked = user_data[:num_liked]
    @num_rated = user_data[:num_rated]
    @avg_rating = user_data[:avg_rating]
  end

end