module Admin
  class BaseController < ApplicationController
    before_filter :verify_admin
    
    def index
      #dashboard for admin activites
      @new_users = User.where("created_at >= ?", Time.now.beginning_of_day).count
      @new_recipes = Recipe.where("created_at >= ?", Time.now.beginning_of_day).count
      @new_ingredients = Ingredient.where("created_at >= ?", Time.now.beginning_of_day).count
    end

    private
    def verify_admin
      if current_user.blank?
        redirect_to root_url
      else
        redirect_to root_url unless current_user.role?(:admin)
      end
    end
  end
end