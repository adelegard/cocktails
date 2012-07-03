Cocktails::Application.routes.draw do
	devise_for :users, :path_names => { :sign_up => "register" }, 
				:controllers => { :omniauth_callbacks => "users/omniauth_callbacks", 
								  :registrations => 'users/registration' }

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
	match '/recipes/new_recipes' => 'recipes#new_recipes', :as => :recipes_new

	#recipe pages
	match '/recipes/show' => 'recipes#show'

	#recipe actions
	match '/recipes/:id/favorite' => 'recipe_users#favorite'
	match '/recipes/:id/unfavorite' => 'recipe_users#unfavorite'
	match '/recipes/:id/rate' => 'recipe_users#rate'
	match '/recipes/rate' => 'recipe_users#rate'

	#recipe photos
	match '/recipes/uploadphoto' => 'recipes#uploadphoto'
	match '/recipes/do_upload_photo' => 'recipes#do_upload_photo', :as => :recipe_do_upload_photo, :via => :put

	#user pages
	match '/profile' => 'users#profile'
	match '/cabinet' => 'liquor_cabinet#view'

	#user actions
	match '/cabinet/add' => 'liquor_cabinet#add'
	match '/cabinet/remove' => 'liquor_cabinet#remove'

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
