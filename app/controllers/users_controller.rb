class RecipeUsersController < ApplicationController
	before_filter :authenticate_user!

  def profile

    render 'recipes/show'
  end
end
