Cocktails::Application.routes.draw do
	devise_for :users, :path_names => { :sign_up => "register" }

	resources :recipes
	resources :recipe_users

	root :to => "recipes#index"
	
	match '/recipes/show' => 'recipes#show'
	#match '/songs/:id' => 'songs#show', :as => 'song'
	#match '/songs/show' => 'songs#show'

	match '/favorite' => 'recipe_users#favorite'
	match '/favorites' => 'recipe_users#favorites'
	match '/rate' => 'recipe_users#rate'
	match '/rated' => 'recipe_users#rated'
	match '/profile' => 'users#profile'
	match '/cabinet' => 'liquor_cabinet#view'
	match '/cabinet/save' => 'liquor_cabinet#save'

	match '/uploadphoto' => 'recipe_users#uploadphoto'
	#match '/uploadphoto/:id'

	match '/search' => 'search#search'
	match '/search/autocomplete_ingredients' => 'search#autocomplete_ingredients'
end
