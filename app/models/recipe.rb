class Recipe < ActiveRecord::Base
	has_many :recipe_ingredients
	has_many :recipe_users
  has_many :recipe_photos
	has_many :ingredients, :through => :recipe_ingredients
	has_many :users, :through => :recipe_users

  validates :title, :presence => true, :length => { :in => 4..100 }, :uniqueness => true
  validates :servings, :presence => true
  validates_associated :ingredients

  self.per_page = 20

  define_index do
    indexes title, :sortable => true
    indexes alcohol, :sortable => true
    indexes directions
    indexes inspiration
    indexes ingredients(:ingredient), :as => :ingredient, :sortable => true

    has updated_at, created_at, rating_avg, rating_count, view_count, created_by_user_id, servings, shared
    has ingredients(:id), :as => :ingredient_ids
    set_property :delta => :delayed
  end

  class << self

    def getFullRecipes(recipes, current_user_id)
      full_recipes = []
      recipes.each do |recipe|
        full_recipes << getFullRecipe(recipe, current_user_id)
      end
      return full_recipes
    end

    def getFullRecipe(recipe, current_user_id)
      full_recipe = {}
      full_recipe[:recipe] = recipe
      full_recipe[:recipe_creator] = User.find_by_id(recipe.created_by_user_id) if recipe.created_by_user_id != nil
      full_recipe[:recipe_photos] = RecipePhoto.where(:recipe_id => recipe.id)

      liquor_cabinet_ingredients = []
      if current_user_id
        full_recipe[:recipe_user] = RecipeUser.where(:recipe_id => recipe.id, :user_id => current_user_id).first_or_create
        liquor_cabinet_ingredients = LiquorCabinet.where(:user_id => current_user_id).collect{|ingredient| ingredient.ingredient_id}
      end
      full_recipe[:ingredients] = Ingredient.getIngredients(recipe.id, !current_user_id.nil?, liquor_cabinet_ingredients)

      user_data = RecipeUser.getUserData(recipe.id)
      full_recipe[:num_starred] = user_data[:num_starred]
      full_recipe[:num_liked] = user_data[:num_liked]
      full_recipe[:num_rated] = user_data[:num_rated]
      full_recipe[:avg_rating] = user_data[:avg_rating]
      return full_recipe
    end

    def getNewRecipes(params)
        params[:direction] ||= "DESC"
        order = "created_at #{params[:direction]}"
        return Recipe.search(:field_weights => {:created_at => 10, :title => 1},
                             :order => order,
                             :with => {:created_at => 1.month.ago..Time.now},
                             :page => params[:page], :per_page => params[:per_page])
    end

    def searchDb(params)
      orderBy = params[:sort] != nil ? params[:sort] : "rating_count"
      orderBy += params[:direction] != nil ? " " + params[:direction].to_s : " DESC"
      return Recipe.paginate(:conditions => ['title LIKE ?', "%#{@q}%"],
                                 :order => orderBy,
                                 :page => params[:page], :per_page => params[:per_page])
    end

    def getPopularRecipes(params)
      orderBy = params[:sort] != nil ? params[:sort] : nil
      if orderBy != nil
        orderBy += params[:direction] != nil ? " " + params[:direction].to_s : " DESC"
      end

      return Recipe.paginate_by_sql(["select r2.*
                                      from recipes r2
                                      join (
                                      select r.id, ru.rating, count(*) as rating_count
                                      from recipes r
                                      join recipe_users ru ON r.id = ru.recipe_id
                                      where ru.rating > 3
                                      GROUP BY r.id, ru.rating
                                      order by rating_count desc, ru.rating desc
                                      ) innerQuery on innerQuery.id = r2.id"],
                                      :order => orderBy,
                                      :page => params[:page], :per_page => params[:per_page])
    end

    def share(params)
      recipe = Recipe.find(params[:id])
      recipe.shared = recipe.shared ? recipe.shared + 1 : 1 #increment the shared count by 1
      recipe.save
    end


    def getAllGlasses
      return Recipe.uniq.pluck(:glass).sort
    end
  end
end
