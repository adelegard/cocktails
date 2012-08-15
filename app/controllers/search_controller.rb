class SearchController < BaseRecipesController

  before_filter :set_default_params, :only => %w(simple_results advanced_results)
  before_filter :display_search_sidebar

  def search
    @spirit = params[:spirit]
    @q = params[:q]
    @recipes = []

    @searched_ingredients = params[:ingredients] != nil ? params[:ingredients] : []
    if @searched_ingredients.kind_of?(Array) == false
      temp_array = []
      temp_array << @searched_ingredients
      @searched_ingredients = temp_array
    end

    ingredients = []
    @searched_ingredients.each{|i|
      found_ing = Ingredient.find_by_ingredient(i)
      ingredients << found_ing if found_ing != nil
    }
    
    params[:sort] ||= "rating_count"
    params[:direction] ||= "DESC"
    spirit_ingredient = Ingredient.find_by_ingredient(params[:spirit]) if !params[:spirit].blank?
    ingredients << spirit_ingredient if spirit_ingredient != nil

    order = "#{params[:sort]} #{params[:direction]}"
    with = {:ingredient_ids => ingredients.collect{|i| i.id}}

    @recipes = Recipe.searchByStringAndIngredientIds(@q, ingredients.collect{|i| i.id}, order, params[:page], params[:per_page])
    
    if @recipes.size == 1
      redirect_to @recipes.first
    end

    @total_ratings = Recipe.total_ratings(@recipes)
    if user_signed_in?
      @recipe_users = RecipeUser.getRecipeUsers(@recipes, current_user.id)
    end
    @display_search_sidebar = true
  end

  def autocomplete_recipes
    term = "^" + params[:q] + "*"
    per_page = params[:per_page] ? params[:per_page] : 10
    recipes = Recipe.search term,
      :match_mode => :extended,
      :ignore_errors => true,
      :per_page => per_page,
      :order => "@relevance DESC"
    names = recipes.collect{|i| i.title}
    respond_to do |format|
      format.js {render_json names.to_json}
    end
  end

  def autocomplete_ingredients
    ingredients = search_ingredients(params)
    names_and_ids = Hash.new {|h, k| h[k] = []}
    ingredients.each{|i| names_and_ids[i.id] = i.ingredient}
    respond_to do |format|
      format.js {render_json names_and_ids.to_json}
    end
  end

  def autocomplete_ingredients_titles
    ingredients = search_ingredients(params)
    names_and_ids = Hash.new {|h, k| h[k] = []}
    names = ingredients.collect{|i| i[:ingredient]}
    respond_to do |format|
      format.js {render_json names.to_json}
    end
  end

  private

  def search_ingredients(params)
    term = "^" + params[:q] + "*"
    per_page = params[:per_page] ? params[:per_page] : 10
    return Ingredient.search term,
      :match_mode => :extended,
      :ignore_errors => true,
      :per_page => per_page,
      :order => "@relevance DESC"
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