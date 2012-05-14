class SearchController < ApplicationController

  before_filter :set_default_params, :only => %w(simple_results advanced_results)

  def search
    
    #@recipe = Recipe.find_by_title(params[:q])
    #redirect_to @recipe unless @recipe.blank?
    
    @spirit = params[:spirit]
    @q = params[:q]
    @recipes = []
    
    params[:direction] ||= "DESC"
    ingredient = params[:spirit].blank? ? [] : Ingredient.find_by_ingredient(params[:spirit])
    
    if @q.blank?  #return all recipes
      params[:sort] ||= "rating_count"
      if ingredient.blank?
        @recipes = Recipe.paginate(:order => "#{params[:sort]} #{params[:direction]}",
                                :page => params[:page], :per_page => params[:per_page])
      else
        @recipes = ingredient.recipe.page(params[:page]).order("#{params[:sort]} #{params[:direction]}")
        # @recipes = Recipe.paginate(:order => "#{params[:sort]} #{params[:direction]}",
                                # :page => params[:page], :per_page => params[:per_page])
      end
    else
      with = ingredient.blank? ? nil : {:ingredient_ids => ingredient.id}
      order = params[:sort].blank? ? nil : "#{params[:sort]} #{params[:direction]}"
      
      @recipes = Recipe.search("#{@q}",
                                 :field_weights => {:title => 20, :ingredients => 10, :directions => 1},
                                 :with => with,
                                 :order => order,
                                 :page => params[:page], :per_page => params[:per_page])
    end

    @total_ratings = RecipeUser.getTotalRatings(@recipes)
    if user_signed_in?
      @recipe_users = RecipeUser.getRecipeUsers(@recipes, current_user.id)
    end
  end

  def autocomplete_recipes
    term = "^" + params[:q] + "*"
    recipes = Recipe.search term,
      :match_mode => :extended,
      :ignore_errors => true,
      :order => "@relevance DESC"
    names = recipes.collect{|i| i.title}
    respond_to do |format|
      format.js {render_json names.to_json}
    end
  end

  def autocomplete_ingredients
    term = "^" + params[:q] + "*"
    ingredients = Ingredient.search term,
      :match_mode => :extended,
      :ignore_errors => true,
      :order => "@relevance DESC"
    names_and_ids = Hash.new {|h, k| h[k] = []}
    ingredients.each{|i| names_and_ids[i.id] = i.ingredient}
    respond_to do |format|
      format.js {render_json names_and_ids.to_json}
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