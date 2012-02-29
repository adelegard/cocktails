class RecipeUsersController < ApplicationController
	before_filter :authenticate_user!

  def create
    @recipe_user = RecipeUser.create(params[:recipe_user])
  end

  def update
    @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(params[:recipe_user][:recipe_id], current_user.id)

    @recipe_user.photo_file_name = params[:recipe_user][:photo].original_filename
    @recipe_user.photo_content_type = params[:recipe_user][:photo].content_type
    @recipe_user.photo_file_size = params[:recipe_user][:photo].tempfile.size
    @recipe_user.photo_updated_at = Time.new
    @recipe_user.save

    @recipe = Recipe.where(:id => @recipe_user.recipe_id).first
    recipe_ingredients = RecipeIngredient.where(:recipe_id => @recipe.id)
    @ingredients = []
    recipe_ingredients.each do |recipe_ingredient|
      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
      @ingredients << {:ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount}
    end

    render 'recipes/show'
  end

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
    @total_ratings = 0
    @recipes.each do |recipe|
      recipe_user = RecipeUser.where(:recipe_id => recipe.id, :user_id => current_user.id).first
      if recipe_user != nil
        @recipe_users << recipe_user
      end
      @total_ratings += recipe.rating_count
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

    respond_to do |format|
      format.html { redirect_to(@recipe) }
      format.js   { render :nothing => true }
    end
  end

  def uploadphoto
      @recipe = Recipe.where(:id => params[:recipe_id]).first
      @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
      render 'recipes/upload_photo'
  end
end
