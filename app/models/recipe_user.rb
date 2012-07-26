class RecipeUser < ActiveRecord::Base
	belongs_to :recipe
	belongs_to :user

	class << self

		def update(recipe_user)
		    the_recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe_user[:recipe_id], recipe_user[:user_id])

		    the_recipe_user[:photo_file_name] = recipe_user[:photo].original_filename
		    the_recipe_user[:photo_content_type] = recipe_user[:photo].content_type
		    the_recipe_user[:photo_file_size] = recipe_user[:photo].tempfile.size
		    the_recipe_user[:photo_updated_at] = Time.new
		    the_recipe_user.save
		end

		def rate(recipe_id, user_id, rating)
		    recipe = Recipe.where(:id => recipe_id).first
		    recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user_id)
		    recipe_user.rating = rating
		    recipe_user.save
		end

		def favorite(recipe_id, user_id)
		    recipe = Recipe.where(:id => recipe_id).first
		    recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user_id)
			recipe_user.starred = recipe_user.starred ? false : true #allows us to get rid of the unfavorite method below
		    recipe_user.save
		end

		def unfavorite(recipe_id, user_id)
		    recipe = Recipe.where(:id => recipe_id).first
		    recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user_id)
		    recipe_user.starred = false
		    recipe_user.save
		end

		def like(recipe_id, user_id)
		    recipe = Recipe.where(:id => recipe_id).first
		    recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user_id)
		    recipe_user.liked = recipe_user.liked ? false : true
		    recipe_user.save
		end

		def getRatedRecipesByUserId(params, user_id)
		    return Recipe.joins("JOIN recipe_users ru ON ru.recipe_id = recipes.id")
		                      .where('ru.rating is not null AND ru.user_id = ?', user_id)
		                      .paginate(:order => "rating_count DESC, rating_avg DESC",
		                                :page => params[:page],
		                                :per_page => params[:per_page])
		end

		def getFavoriteRecipesByUserId(params, user_id)
		    return Recipe.joins('JOIN recipe_users ru ON ru.recipe_id = recipes.id')
		                      .where('ru.starred = 1 AND ru.user_id = ?', user_id)
		                      .paginate(:order => "rating_count DESC, rating_avg DESC",
		                                :page => params[:page],
		                                :per_page => params[:per_page])
		end

		def getCreatedRecipesByUserId(params, user_id)
    		return Recipe.where(:created_by_user_id => user_id).paginate(:order => "created_at DESC",
                                                                         :page => params[:page],
                                                                         :per_page => params[:per_page])
		end

		def getNumLikedCreatedRecipesByUserId(user_id)
			return RecipeUser.count_by_sql ["select count(liked) from recipe_users where recipe_id IN(select id from recipes where created_by_user_id = ?)", user_id]
		end
		def getNumFavoritedCreatedRecipesByUserId(user_id)
			return RecipeUser.count_by_sql ["select count(starred) from recipe_users where recipe_id IN(select id from recipes where created_by_user_id = ?)", user_id]
		end

		def getRecipeUsers(recipes, user_id)
		    recipe_users = []
		    recipes.each do |recipe|
		      recipe_user = RecipeUser.where(:recipe_id => recipe.id, :user_id => user_id).first
		      if recipe_user != nil
		        recipe_users << recipe_user
		      end
		    end
		    return recipe_users
		end

		def getTotalRatings(recipes)
		    total_ratings = 0
		    recipes.each do |recipe|
		      if recipe.rating_count != nil
		        total_ratings += recipe.rating_count
		      end
		    end
		    return total_ratings
		end

		def getUserData(recipe_id)
			recipe_users = RecipeUser.where(:recipe_id => recipe_id)

			num_starred = 0
			num_liked = 0
			ratings = []
			recipe_users.each do |recipe_user|
				num_starred = num_starred + 1 if recipe_user.starred
				num_liked = num_liked + 1 if recipe_user.liked
				ratings << recipe_user.rating if recipe_user.rating
			end
			avg = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
			return {:num_starred => num_starred, :num_liked => num_liked, :num_rated => ratings.size, :avg_rating => avg}
		end
	end
end
