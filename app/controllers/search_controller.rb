class SearchController < ApplicationController

  before_filter :set_default_params, :only => %w(simple_results advanced_results)

  def search
    @q = params[:q]
    @recipes = Recipe.paginate(:conditions => ['title LIKE ?', "%#{@q}%"], :order => "rating_count DESC, rating_avg DESC", :page => params[:page], :per_page => params[:per_page])
  end
end