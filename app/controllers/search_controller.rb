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

  def autocomplete_recipes
    recipes = Recipe.where('title LIKE ?', "%#{params[:q]}%").limit(5)
    names = recipes.collect{|i| i.title}
    respond_to do |format|
      format.js {render_json names.to_json}
    end
  end

  def autocomplete_ingredients
    ingredients = Ingredient.where('ingredient LIKE ?', "%#{params[:q]}%").limit(5)
    names = ingredients.collect{|i| i.ingredient}
    respond_to do |format|
      format.js {render_json names.to_json}
    end
  end

  def render_json(json, options={})
    callback, variable = params[:callback], params[:variable]
    response = begin
      if callback && variable
        "var #{variable} = #{json};\n#{callback}(#{variable});"
      elsif variable
        "var #{variable} = #{json};"
      elsif callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({:content_type => :js, :text => response}.merge(options))
  end
end