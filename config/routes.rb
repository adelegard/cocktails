Cocktails::Application.routes.draw do
  resources :user_follows

	devise_for :users, :path_names => { :sign_up => "register" }, 
				:controllers => { :omniauth_callbacks => "my_devise/omniauth_callbacks", 
								  :registrations => 'my_devise/registration',
								  :sessions => 'my_devise/sessions',
								  :passwords => 'my_devise/passwords' }

	root :to => "recipes#index"

    match '/about' => 'about#about'
    match '/contact' => 'contact#contact'

    #recipe [user] lists
	match '/recipes/favorites' => 'recipe_users#favorites', :as => :recipes_favorites
	match '/recipes/rated' => 'recipe_users#rated', :as => :recipes_rated
	match '/recipes/created' => 'recipe_users#created', :as => :recipes_created
	match '/recipes/liquor_cabinet' => 'recipe_users#liquor_cabinet_recipes', :as => :recipes_lc

	#recipe lists
	match '/recipes/popular' => 'recipes#popular', :as => :recipes_popular
	match '/recipes/recent' => 'recipes#new_recipes', :as => :recipes_new

	#recipe pages
	match '/recipes/show' => 'recipes#show'

	#recipe actions
	match '/recipes/:id/share' => 'recipes#share'
	match '/recipes/:id/favorite' => 'recipe_users#favorite'
	match '/recipes/:id/unfavorite' => 'recipe_users#unfavorite'
	match '/recipes/:id/like' => 'recipe_users#like'
	match '/recipes/:id/rate' => 'recipe_users#rate'
	match '/recipes/rate' => 'recipe_users#rate'

	#recipe photos
	match '/recipes/:id/uploadphoto' => 'recipes#uploadphoto', :as => :recipe_upload_photo
	match '/recipes/:id/do_upload_photo' => 'recipes#do_upload_photo', :as => :recipe_do_upload_photo, :via => :put
	match '/recipes/:recipe_id/photos/:photo_id' => 'recipes#photos', :as => :recipe_photo

	#user pages
	match '/settings/password' => 'users/password#edit', :as => :edit_user_pass
	match '/settings/password/update' => 'users/password#update', :as => :user_pass, :via => :put
	match '/settings/email' => 'users/email#edit', :as => :edit_user_email
	match '/settings/email/update' => 'users/email#update', :as => :user_email, :via => :put
	match '/cabinet' => 'liquor_cabinet#view', :as => :cabinet

	#user actions
	match '/cabinet/add' => 'liquor_cabinet#add'
	match '/cabinet/add_by_id' => 'liquor_cabinet#add_by_id'
	match '/cabinet/remove' => 'liquor_cabinet#remove'
	match '/cabinet/remove_by_id' => 'liquor_cabinet#remove_by_id'

	#user follow
	match '/user/:id/follow' => 'user_follows#follow'
	match '/user/:id/unfollow' => 'user_follows#unfollow'

	#user pages
	match '/user/:id' => 'users#profile', :as => :user_profile
	match '/user/:id/recipes' => 'users#profile_recipes', :as => :user_profile_recipes
	match '/user/:id/favorites' => 'users#profile_favorites', :as => :user_profile_favorites
	match '/user/:id/rated' => 'users#profile_rated', :as => :user_profile_rated
	match '/user/:id/photos' => 'users#profile_photos', :as => :user_profile_photos
	match '/user/:id/cabinet' => 'users#profile_cabinet', :as => :user_profile_cabinet

	#ingredient pages
	match '/ingredient/:id' => 'ingredients#detail', :as => :ingredient_detail
	match '/ingredient/:ingredient_id/photos/:photo_id' => 'ingredients#photos', :as => :ingredient_photo

	match '/ingredient/:id/uploadphoto' => 'ingredients#uploadphoto', :as => :ingredient_upload_photo
	match '/ingredient/:id/do_upload_photo' => 'ingredients#do_upload_photo', :as => :ingredient_do_upload_photo, :via => :put

	match '/search' => 'search#search'
	match '/search/autocomplete_recipes' => 'search#autocomplete_recipes'
	match '/search/autocomplete_ingredients' => 'search#autocomplete_ingredients'
	match '/search/autocomplete_ingredients_titles' => 'search#autocomplete_ingredients_titles'

	resources :recipes
	resources :recipe_users

	unless Rails.application.config.consider_all_requests_local
		match '*not_found', to: 'errors#error_404'
	end
end
