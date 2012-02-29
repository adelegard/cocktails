class SearchController < ApplicationController

  before_filter :set_default_params, :only => %w(simple_results advanced_results)

  def search
    @q = params[:q]
    orderBy = params[:sort] != nil ? params[:sort] : "rating_count"
    orderBy += params[:direction] != nil ? " " + params[:direction].to_s : " DESC"
    @recipes = Recipe.paginate(:conditions => ['title LIKE ?', "%#{@q}%"],
                               :order => orderBy,
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
end