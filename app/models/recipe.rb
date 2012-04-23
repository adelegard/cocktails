class Recipe < ActiveRecord::Base
	has_many :recipe_ingredients
	has_many :recipe_users
	has_many :ingredients, :through => :recipe_ingredients
	has_many :users, :through => :recipe_users

  self.per_page = 12

  define_index do
    # fields
    indexes title, :sortable => true
    indexes directions
    indexes glass, :sortable => true
    indexes alcohol, :sortable => true
    indexes rating_avg, :sortable => true
    indexes rating_count, :sortable => true

    # attributes
    has :id, :as => :recipe_id
    has created_at
    has updated_at
  end

  class << self

    def getHomePageRecipes
      return Recipe.paginate(:order => "rating_count DESC",
                                 :page => params[:page], :per_page => params[:per_page])
    end

    def searchDb(params)
      orderBy = params[:sort] != nil ? params[:sort] : "rating_count"
      orderBy += params[:direction] != nil ? " " + params[:direction].to_s : " DESC"
      return Recipe.paginate(:conditions => ['title LIKE ?', "%#{@q}%"],
                                 :order => orderBy,
                                 :page => params[:page], :per_page => params[:per_page])
    end
  end
end
