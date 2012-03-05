Cocktails::Application.routes.draw do
	devise_for :users, :path_names => { :sign_up => "register" }

	match '/recipes/favorites' => 'recipe_users#favorites'
	match '/recipes/rated' => 'recipe_users#rated'

	resources :recipes
	resources :recipe_users

	root :to => "recipes#index"

	match '/recipes/show' => 'recipes#show'
	#match '/songs/:id' => 'songs#show', :as => 'song'
	#match '/songs/show' => 'songs#show'

	match '/recipes/:id/favorite' => 'recipe_users#favorite'
	match '/recipes/:id/unfavorite' => 'recipe_users#unfavorite'
	match '/recipes/:id/rate' => 'recipe_users#rate'

	match '/profile' => 'users#profile'
	match '/cabinet' => 'liquor_cabinet#view'
	match '/cabinet/add' => 'liquor_cabinet#add'
	match '/cabinet/remove' => 'liquor_cabinet#remove'

	match '/uploadphoto' => 'recipe_users#uploadphoto'
	#match '/uploadphoto/:id'

	match '/search' => 'search#search'
	match '/search/autocomplete_ingredients' => 'search#autocomplete_ingredients'
end
