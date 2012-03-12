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
    @total_ratings = 0
    @recipes.each do |recipe|
      recipe_user = RecipeUser.where(:recipe_id => recipe.id, :user_id => current_user.id).first
      if recipe_user != nil
        @recipe_users << recipe_user
      end
      @total_ratings += recipe.rating_count
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

  def liquor_cabinet
    orderBy = params[:sort] != nil ? params[:sort] : "rating_count"
    orderBy += params[:direction] != nil ? " " + params[:direction].to_s : " DESC"

    #wow this is slow... hopefully thinking sphinx will fix it
    @recipes = Recipe.paginate_by_sql(["select r.*
                                  from recipes r
                                  join recipe_ingredients ri ON r.id = ri.recipe_id
                                  join recipe_ingredients ri2 on r.id = ri2.recipe_id
                                  join ingredients i ON ri.ingredient_id = i.id
                                  where i.id IN (select ingredient_id
                                                 from liquor_cabinets
                                                 where user_id = ?)
                                  group by r.id
                                  having count(distinct ri.ingredient_id) = count(distinct ri2.ingredient_id)", current_user.id],
                                  :order => orderBy,
                                  :page => params[:page], :per_page => params[:per_page])
    @recipe_users = []
    @total_ratings = 0
    @recipes.each do |recipe|
      recipe_user = RecipeUser.where(:recipe_id => recipe.id, :user_id => current_user.id).first
      if recipe_user != nil
        @recipe_users << recipe_user
      end
      if recipe.rating_count != nil
        @total_ratings += recipe.rating_count
      end
    end

    @title = "Cocktails I Can Make!"
    render 'search/search'
  end

  def rate
    @recipe = Recipe.where(:id => params[:id]).first
    @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
    @recipe_user.rating = params[:rating]
    @recipe_user.save

    recipe_ingredients = RecipeIngredient.where(:recipe_id => params[:id])
    @ingredients = []
    recipe_ingredients.each do |recipe_ingredient|
      ingredient = Ingredient.where(:id => recipe_ingredient.ingredient_id).first
      @ingredients << {:ingredient => ingredient.ingredient, :order => recipe_ingredient.order, :amount => recipe_ingredient.amount}
    end

    respond_to do |format|
      format.html { redirect_to(@recipe) }
      format.js   { render :nothing => true }
    end
  end

  def favorite
    @recipe = Recipe.where(:id => params[:id]).first
    @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
    @recipe_user.starred = true
    @recipe_user.save

    respond_to do |format|
      format.html { redirect_to(@recipe) }
      format.js   { render :nothing => true }
    end
  end

  def unfavorite
    @recipe = Recipe.where(:id => params[:id]).first
    @recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(@recipe.id, current_user.id)
    @recipe_user.starred = false
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
