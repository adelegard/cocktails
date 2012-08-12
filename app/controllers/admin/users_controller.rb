module Admin
  class UsersController < BaseController
    
    def index
      params[:page] ||= 1
      params[:direction] ||= "ASC"
      @users = User.page(params[:page]).order("email " + params[:direction])
    end
  
    def show
      @user = User.find(params[:id])
    end
  end
end
