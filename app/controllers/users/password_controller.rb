class Users::PasswordController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = User.find(current_user.id)
    #@resource = @user
    render 'users/edit_password'
  end

  def update
    @user = User.find(current_user.id)
    current_valid_password = @user.valid_password?(params[:user][:current_password])
    password_changed = !params[:user][:password].empty?
    successfully_updated = if current_valid_password && password_changed
      @user.update_with_password(params[:user])
    end

    respond_to do |format|
      if !current_valid_password
        flash[:error] = 'Current password is incorrect'
        format.html { redirect_to edit_user_pass_path }
      elsif !successfully_updated.nil? && successfully_updated
        flash[:success] = 'Password was successfully updated!'
        sign_in(@user, :bypass => true)
        format.html { redirect_to edit_user_pass_path }
      else
        flash[:error] = 'Error updating password'
        format.html { redirect_to edit_user_pass_path }
      end
    end
  end

end