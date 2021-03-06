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

		def favorite(recipe_id, user_id)
		    recipe = Recipe.find(recipe_id)
		    recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user_id)
				recipe_user.starred = recipe_user.starred ? false : true
		    recipe_user.save
		end

		def like(recipe_id, user_id)
		    recipe = Recipe.find(recipe_id)
		    recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user_id)
		    recipe_user.liked = recipe_user.liked ? false : true
		    recipe_user.save
		end

		def dislike(recipe_id, user_id)
		    recipe = Recipe.find(recipe_id)
		    recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user_id)
		    recipe_user.disliked = recipe_user.disliked ? false : true
		    recipe_user.save
		end

    def share(recipe_id, user_id)
      recipe = Recipe.find(recipe_id)
      recipe_user = RecipeUser.find_or_initialize_by_recipe_id_and_user_id(recipe.id, user_id)
      recipe_user.shared = recipe_user.shared ? recipe_user.shared + 1 : 1 #increment the shared count by 1
      recipe_user.save
    end

		def liked_recipes_by_user_id(params, user_id)
			Recipe.joins("JOIN recipe_users ru ON ru.recipe_id = recipes.id").
	    			where('ru.liked = 1 AND ru.user_id = ?', user_id).
	    			paginate(:order => "ru.updated_at DESC",
										 :page => params[:page],
										 :per_page => params[:per_page])
		end

		def disliked_recipes_by_user_id(params, user_id)
			Recipe.joins("JOIN recipe_users ru ON ru.recipe_id = recipes.id").
					where('ru.disliked = 1 AND ru.user_id = ?', user_id).
					paginate(:order => "ru.updated_at DESC",
									:page => params[:page],
									:per_page => params[:per_page])
		end

		def favorite_recipes_by_user_id(params, user_id)
			Recipe.joins('JOIN recipe_users ru ON ru.recipe_id = recipes.id').
					where('ru.starred = 1 AND ru.user_id = ?', user_id).
					paginate(:order => "ru.updated_at DESC",
									:page => params[:page],
									:per_page => params[:per_page])
		end

		def created_recipes_by_user_id(params, user_id)
    		Recipe.where(:created_by_user_id => user_id).paginate(:order => "created_at DESC",
                                                                         :page => params[:page],
                                                                         :per_page => params[:per_page])
		end

		def num_liked_recipes_created_by_user_id(user_id)
			RecipeUser.count_by_sql ["select count(liked) from recipe_users where recipe_id IN(select id from recipes where created_by_user_id = ?)", user_id]
		end
		def num_disliked_recipes_created_by_user_id(user_id)
			RecipeUser.count_by_sql ["select count(disliked) from recipe_users where recipe_id IN(select id from recipes where created_by_user_id = ?)", user_id]
		end
		def num_favorited_recipes_created_by_user_id(user_id)
			RecipeUser.count_by_sql ["select count(starred) from recipe_users where recipe_id IN(select id from recipes where created_by_user_id = ?)", user_id]
		end

		def num_stats_map(recipe_id)
			recipe_users = RecipeUser.where(:recipe_id => recipe_id)

			num_starred = 0
			num_liked = 0
			num_disliked = 0
			num_shared = 0
			recipe_users.each do |recipe_user|
				num_starred = num_starred + 1 if recipe_user.starred
				num_liked = num_liked + 1 if recipe_user.liked
				num_disliked = num_disliked + 1 if recipe_user.disliked
				num_shared = num_shared + recipe_user.shared if recipe_user.shared
			end
			{:num_starred => num_starred, :num_liked => num_liked, :num_disliked => num_disliked, :num_shared => num_shared}
		end
	end
end
