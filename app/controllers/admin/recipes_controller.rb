module Admin
  class RecipesController < BaseController
    
    def index
      params[:page] ||= 1
      params[:direction] ||= "ASC"
      @recipes = Recipe.page(params[:page])
    end
  
    def show
      @recipe = Recipe.find(params[:id])
    end
    
    def update_status
      @recipe = Recipe.find(params[:id])
      @recipe.published = params[:banned]
      @recipe.save!
    end
    
  end
end
