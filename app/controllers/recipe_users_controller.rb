class RecipeUsersController < ApplicationController
	before_filter :authenticate_user!

  def rated
    @recipes = Recipe.joins("JOIN recipe_users ru ON ru.recipe_id = recipes.id")
                      .where('ru.rating is not null AND ru.user_id = ?', current_user.id)
                      .paginate(:order => "rating_count DESC, rating_avg DESC",
                                :page => params[:page],
                                :per_page => params[:per_page])

    @recipe_users = []
    @recipes.each do |recipe|
      recipe_user = RecipeUser.where(:recipe_id => recipe.id, :user_id => current_user.id).first
      if recipe_user != nil
        @recipe_users << recipe_user
      end
    end

    @title = "My Rated Recipes"
    render 'search/search'
  end

  def favorites
    @recipes = Recipe.joins('JOIN recipe_users ru ON ru.recipe_id = recipes.id')
                      .where('ru.starred = 1 AND ru.user_id = ?', current_user.id)
                      .paginate(:order => "rating_count DESC, rating_avg DESC",
                                :page => params[:page],
                                :per_page => params[:per_page])

    @recipe_users = []
    @recipes.each do |recipe|
      recipe_user = RecipeUser.where(:recipe_id => recipe.id, :user_id => current_user.id).first
      if recipe_user != nil
        @recipe_users << recipe_user
      end
    end

    @title = "My Favorite Cocktails"
    render 'search/search'
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
