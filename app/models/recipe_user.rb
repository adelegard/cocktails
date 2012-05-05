class RecipeUser < ActiveRecord::Base
	belongs_to :recipe
	belongs_to :user

	has_attached_file :photo,
		:storage => :s3,
		:styles => { :small => "150x150>" },
		:bucket => 'adelegard_cocktails',
		:path => "/recipes/:recipe_id/images/:user_id/:style.:extension",
		:s3_credentials => "#{Rails.root}/config/s3.yml"

	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

	class << self

		def update(recipe_user)
		    recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe_user.recipe_id, recipe_user.user_id)

		    recipe_user.photo_file_name = recipe_user.photo.original_filename
		    recipe_user.photo_content_type = recipe_user.photo.content_type
		    recipe_user.photo_file_size = recipe_user.photo.tempfile.size
		    recipe_user.photo_updated_at = Time.new
		    recipe_user.save
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
		    recipe_user.starred = true
		    recipe_user.save
		end

		def unfavorite(recipe_id, user_id)
		    recipe = Recipe.where(:id => recipe_id).first
		    recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user_id)
		    recipe_user.starred = false
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
			ratings = []
			recipe_users.each do |recipe_user|
				if recipe_user.starred != nil
					num_starred = num_starred + 1
				end
				ratings << recipe_user.rating if recipe_user.rating
			end
			avg = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
			return {:num_starred => num_starred, :num_rated => ratings.size, :avg_rating => avg}
		end
	end
end
