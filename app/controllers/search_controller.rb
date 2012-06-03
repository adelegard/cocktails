class SearchController < ApplicationController

  before_filter :set_default_params, :only => %w(simple_results advanced_results)

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

    if @q.blank?
      if ingredients.empty?
        #return all recipes
        @recipes = Recipe.paginate(:order => "#{params[:sort]} #{params[:direction]}",
                                   :page => params[:page], :per_page => params[:per_page])
      else
        @recipes = Recipe.search(:field_weights => {:ingredients => 10, :directions => 1},
                                 :with_all => with,
                                 :order => order,
                                 :page => params[:page], :per_page => params[:per_page])
      end
    else
      @recipes = Recipe.search("#{@q}",
                                :field_weights => {:title => 20, :ingredients => 10, :directions => 1},
                                :with_all => with,
                                :order => order,
                                :page => params[:page], :per_page => params[:per_page])
    end

    if @recipes.size == 1
      # Then just bring them to the recipe's show page
      @recipe = @recipes[0]
      liquor_cabinet_ingredients = []
      if user_signed_in?
        @recipe_user = RecipeUser.where(:recipe_id => @recipe.id, :user_id => current_user.id).first_or_create
        liquor_cabinet_ingredients = LiquorCabinet.where(:user_id => current_user.id).collect{|ingredient| ingredient.ingredient_id}
      end
      @ingredients = Ingredient.getIngredients(@recipe.id, user_signed_in?, liquor_cabinet_ingredients)

      user_data = RecipeUser.getUserData(@recipe.id)
      @num_starred = user_data[:num_starred]
      @num_rated = user_data[:num_rated]
      @avg_rating = user_data[:avg_rating]
      render 'recipes/show'
    end

    @total_ratings = RecipeUser.getTotalRatings(@recipes)
    if user_signed_in?
      @recipe_users = RecipeUser.getRecipeUsers(@recipes, current_user.id)
    end
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
    names = ingredients.collect{|i| i.ingredient}
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