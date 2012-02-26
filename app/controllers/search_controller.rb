class SearchController < ApplicationController

  before_filter :set_default_params, :only => %w(simple_results advanced_results)

  def search
    @q = params[:q]
    @sidebar_link = params[:sidebar_link]
    search_term = @q != nil ? @q : @sidebar_link
    @recipes = Recipe.paginate(:conditions => ['title LIKE ?', "%#{search_term}%"], :order => "rating_count DESC, rating_avg DESC", :page => params[:page], :per_page => params[:per_page])

    if user_signed_in?
    	@recipe_users = []
	    @recipes.each do |recipe|
	    	recipe_user = RecipeUser.where(:recipe_id => recipe.id, :user_id => current_user.id).first
	    	if recipe_user != nil
	    		@recipe_users << recipe_user
	    	end
	    end
	end
  end
end