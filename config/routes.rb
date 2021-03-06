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
	match '/recipes/liked' => 'recipe_users#liked', :as => :recipes_liked
	match '/recipes/disliked' => 'recipe_users#disliked', :as => :recipes_disliked
	match '/recipes/created' => 'recipe_users#created', :as => :recipes_created
	match '/recipes/liquor_cabinet' => 'recipe_users#liquor_cabinet_recipes', :as => :recipes_lc

	#recipe lists
	match '/recipes/popular' => 'recipes#popular', :as => :recipes_popular
	match '/recipes/recent' => 'recipes#recent', :as => :recipes_new

	#recipe actions
	match '/recipes/:id/like' => 'recipe_users#like', :via => :post
	match '/recipes/:id/dislike' => 'recipe_users#dislike', :via => :post
	match '/recipes/:id/favorite' => 'recipe_users#favorite', :via => :post
	match '/recipes/:id/share' => 'recipe_users#share', :via => :post

	#recipe photos
	match '/recipes/:id/uploadphoto' => 'recipes#uploadphoto', :as => :recipe_upload_photo
	match '/recipes/:id/do_upload_photo' => 'recipes#do_upload_photo', :as => :recipe_do_upload_photo, :via => :post
	match '/recipes/:recipe_id/photos/:photo_id' => 'recipes#photos', :as => :recipe_photo

	#user pages
	match '/settings/update' => 'users/settings#update', :as => :update_user_settings
	match '/settings/password' => 'users/password#edit', :as => :edit_user_pass
	match '/settings/password/update' => 'users/password#update', :as => :user_pass, :via => :put
	match '/settings/email' => 'users/email#edit', :as => :edit_user_email
	match '/settings/email/update' => 'users/email#update', :as => :user_email, :via => :put
	match '/cabinet' => 'liquor_cabinet#view', :as => :cabinet

	#user actions
	match '/cabinet/add' => 'liquor_cabinet#add', :via => :post
	match '/cabinet/:id/add_by_id' => 'liquor_cabinet#add_by_id', :via => :post
	match '/cabinet/remove' => 'liquor_cabinet#remove', :via => :delete
	match '/cabinet/:id/remove_by_id' => 'liquor_cabinet#remove_by_id', :via => :delete

	#user follow
	match '/user/:id/follow' => 'user_follows#follow', :via => :post
	match '/user/:id/unfollow' => 'user_follows#unfollow', :via => :delete

	#user pages
	match '/user/:id/recipes' => 'users#profile_recipes', :as => :user_profile_recipes
	match '/user/:id/favorites' => 'users#profile_favorites', :as => :user_profile_favorites
	match '/user/:id/liked' => 'users#profile_liked', :as => :user_profile_liked
	match '/user/:id/photos' => 'users#profile_photos', :as => :user_profile_photos
	match '/user/:id/cabinet' => 'users#profile_cabinet', :as => :user_profile_cabinet

	#ingredient pages
	match '/ingredient/:ingredient_id/photos/:photo_id' => 'ingredients#photos', :as => :ingredient_photo

	match '/ingredient/:id/uploadphoto' => 'ingredients#uploadphoto', :as => :ingredient_upload_photo
	match '/ingredient/:id/do_upload_photo' => 'ingredients#do_upload_photo', :as => :ingredient_do_upload_photo, :via => :post

	match '/search' => 'search#search'
	match '/search/autocomplete_recipes' => 'search#autocomplete_recipes'
	match '/search/autocomplete_ingredients' => 'search#autocomplete_ingredients'
	match '/search/autocomplete_ingredients_titles' => 'search#autocomplete_ingredients_titles'

	#contact
	match 'contact' => 'contact#new', :as => 'contact', :via => :get
	match 'contact' => 'contact#create', :as => 'contact', :via => :post

	resources :recipes
	resources :recipe_users
	resources :users
	resources :ingredients

	unless Rails.application.config.consider_all_requests_local
		match '*not_found', to: 'errors#error_404'
	end
end
