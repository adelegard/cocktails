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

    def getNewRecipes
      return Recipe.paginate(:order => "created_at DESC",
                             :page => params[:page], :per_page => params[:per_page])
    end

    def searchDb(params)
      orderBy = params[:sort] != nil ? params[:sort] : "rating_count"
      orderBy += params[:direction] != nil ? " " + params[:direction].to_s : " DESC"
      return Recipe.paginate(:conditions => ['title LIKE ?', "%#{@q}%"],
                                 :order => orderBy,
                                 :page => params[:page], :per_page => params[:per_page])
    end

    def getPopularRecipes
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
  end
end
