class Users::SettingsController < ApplicationController
  before_filter :authenticate_user!

  def update
    existing_profile_page_user = User.where(:profile_page => params[:user][:profile_page]).first

    respond_to do |format|
      if !existing_profile_page_user.nil? && existing_profile_page_user.id != current_user.id
        flash[:error] = 'Profile page already in use'
        format.html { redirect_to edit_user_registration_path }
      elsif User.find(current_user.id).update_without_password(params[:user])
        flash[:success] = 'Successfully updated your profile'
        format.html { redirect_to edit_user_registration_path }
      else
        flash[:error] = 'Error updating your profile'
        format.html { redirect_to edit_user_registration_path }
      end
    end
  end

end