class BaseRecipesController < ApplicationController

  private

  def display_search_sidebar
    @display_search_sidebar = true
  end

  def setup_show
    recipe = Recipe.find(params[:id])
    user_id = current_user != nil && current_user.id ? current_user.id : nil
    @full_recipe = Recipe.full_recipe(recipe, user_id)
    setup_show_with_recipe(@full_recipe)
  end

  def setup_show_with_recipe(full_recipe)
    @display_search_sidebar = false
    @recipe = full_recipe[:recipe]
    @recipe.view_count = @recipe.view_count ? @recipe.view_count + 1 : 1 #increment the view count by 1
    @recipe.save

    @recipe_creator = full_recipe[:recipe_creator]
    @recipe_photos = full_recipe[:recipe_photos]
    @recipe_user = full_recipe[:recipe_user]
    @ingredients = full_recipe[:ingredients]

    @num_starred = full_recipe[:num_starred]
    @num_liked = full_recipe[:num_liked]
    @num_disliked = full_recipe[:num_disliked]
    @num_shared = full_recipe[:num_shared]
  end

end