Cocktails::Application.routes.draw do
  devise_for :users, :path_names => { :sign_up => "register" }

	root :to => "recipes#index"

	match '/recipes/:id' => 'recipes#show', :as => 'recipe'
	match '/recipes/show' => 'recipes#show'
	match '/rate' => 'recipe_users#rate'
	match '/star' => 'recipe_users#star'

	match '/search' => 'search#search'
end
