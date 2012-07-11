class Users::PasswordController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = User.find(current_user.id)
    #@resource = @user
    render 'users/edit_password'
  end

  def update
    @user = User.find(current_user.id)

    password_valid = @user.valid_password?(params[:user][:password])
    email_changed = @user.email != params[:user][:email]
    password_changed = !params[:user][:password].empty?

    successfully_updated = if password_valid && (email_changed or password_changed)
      @user.update_with_password(params[:user])
    #else
    #  @user.update_without_password(params[:user])
    end

    respond_to do |format|
      if !password_valid
        format.html { redirect_to edit_user_pass_path, error: 'Current password is incorrect' }
      elsif successfully_updated
        sign_in(@user, :bypass => true)
        format.html { redirect_to edit_user_pass_path, notice: 'Password was successfully updated!' }
      else
        format.html { redirect_to edit_user_pass_path, error: 'Error updating password :(' }
      end
    end
  end

end