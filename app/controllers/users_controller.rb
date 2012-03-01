class UsersController < ApplicationController
	before_filter :authenticate_user!

  def profile
    render 'users/profile'
  end

end
