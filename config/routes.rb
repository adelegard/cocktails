Cocktails::Application.routes.draw do
	devise_for :users, :path_names => { :sign_up => "register" }, 
				:controllers => { :omniauth_callbacks => "users/omniauth_callbacks", 
								  :registrations => 'users/registration' }

    match '/about' => 'about#about'
    match '/contact' => 'contact#contact'

	match '/recipes/favorites' => 'recipe_users#favorites'
	match '/recipes/rated' => 'recipe_users#rated'
	match '/recipes/liquor_cabinet' => 'recipe_users#liquor_cabinet_recipes'

	resources :recipes
	resources :recipe_users

	root :to => "recipes#index"

	match '/recipes/show' => 'recipes#show'

	match '/recipes/:id/favorite' => 'recipe_users#favorite'
	match '/recipes/:id/unfavorite' => 'recipe_users#unfavorite'
	match '/recipes/:id/rate' => 'recipe_users#rate'
	match '/recipes/rate' => 'recipe_users#rate'

	match '/profile' => 'users#profile'
	match '/cabinet' => 'liquor_cabinet#view'
	match '/cabinet/add' => 'liquor_cabinet#add'
	match '/cabinet/remove' => 'liquor_cabinet#remove'

	match '/uploadphoto' => 'recipe_users#uploadphoto'
	#match '/uploadphoto/:id'

	match '/search' => 'search#search'
	match '/search/autocomplete_recipes' => 'search#autocomplete_recipes'
	match '/search/autocomplete_ingredients' => 'search#autocomplete_ingredients'

	unless Rails.application.config.consider_all_requests_local
		match '*not_found', to: 'errors#error_404'
	end
end
