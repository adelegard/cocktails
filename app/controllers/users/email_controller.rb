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
        format.html { redirect_to edit_user_email_path, error: 'Email address already in use :(' }
      elsif current_user.update_attributes(params[:user])
        format.html { redirect_to edit_user_email_path, notice: 'Email address was successfully updated!' }
      else
        format.html { redirect_to edit_user_email_path, error: 'Error updating email address :(' }
      end
    end
  end

end