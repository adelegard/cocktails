Cocktails::Application.routes.draw do
	devise_for :users, :path_names => { :sign_up => "register" }

	resources :recipes

	root :to => "recipes#index"

	match '/rate' => 'recipe_users#rate'
	match '/favorite' => 'recipe_users#favorite'
	match '/all_rated' => 'recipe_users#all_rated'
	match '/favorites' => 'recipe_users#favorites'

	match '/uploadphoto/:id' => 'recipe_users#uploadphoto'
	#match '/uploadphoto/:id'

	match '/search' => 'search#search'

	
end
