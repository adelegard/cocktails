class Recipe < ActiveRecord::Base
	has_many :recipe_ingredients
	has_many :recipe_users
  has_many :recipe_photos
	has_many :ingredients, :through => :recipe_ingredients
	has_many :users, :through => :recipe_users

  validates :title, :presence => true, :length => { :in => 4..100 }, :uniqueness => true
  validates :directions, :presence => true, :length => { :in => 10..2000 }
  validates_associated :ingredients

  self.per_page = 20

  define_index do
    indexes title, :sortable => true
    indexes alcohol, :sortable => true
    indexes directions
    indexes ingredients(:ingredient), :as => :ingredient, :sortable => true

    has updated_at, created_at, rating_avg, rating_count, view_count, created_by_user_id
    has ingredients(:id), :as => :ingredient_ids
    set_property :delta => :delayed
  end

  class << self

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


    def getAllGlasses
      return Recipe.uniq.pluck(:glass).sort
    end
  end
end
