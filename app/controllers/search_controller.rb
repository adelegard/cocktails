class SearchController < ApplicationController

  before_filter :set_default_params, :only => %w(simple_results advanced_results)

  def search
    @q = params[:q]
    @sidebar_link = params[:sidebar_link]
    search_term = @q != nil ? @q : @sidebar_link
    @recipes = Recipe.paginate(:conditions => ['title LIKE ?', "%#{search_term}%"], :order => "rating_count DESC, rating_avg DESC", :page => params[:page], :per_page => params[:per_page])
  end
end