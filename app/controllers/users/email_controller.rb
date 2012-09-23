class Users::EmailController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = User.where(:id => current_user.id).first
    @resource = @user
    render 'users/edit_email'
  end

  def update
    existing_user_with_email = User.where(:email => params[:user][:email]).first

    respond_to do |format|
      if !existing_user_with_email.nil?
        flash[:error] = 'Email address already in use'
        format.html { redirect_to edit_user_email_path }
      elsif User.find(current_user.id).update_without_password(params[:user])
        flash[:success] = 'Email address was successfully updated!'
        format.html { redirect_to edit_user_email_path }
      else
        flash[:error] = 'Error updating email address'
        format.html { redirect_to edit_user_email_path }
      end
    end
  end

end