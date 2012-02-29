Cocktails::Application.routes.draw do
	devise_for :users, :path_names => { :sign_up => "register" }

	resources :recipes
	resources :recipe_users

	root :to => "recipes#index"
	
	match '/recipes/show' => 'recipes#show'
	#match '/songs/:id' => 'songs#show', :as => 'song'
	#match '/songs/show' => 'songs#show'

	match '/rate' => 'recipe_users#rate'
	match '/favorite' => 'recipe_users#favorite'
	match '/rated' => 'recipe_users#rated'
	match '/favorites' => 'recipe_users#favorites'
	match '/profile' => 'recipe_users#profile'

	match '/uploadphoto' => 'recipe_users#uploadphoto'
	#match '/uploadphoto/:id'

	match '/search' => 'search#search'
end
