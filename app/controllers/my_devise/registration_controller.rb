class MyDevise::RegistrationController < Devise::RegistrationsController
  before_filter :set_common_stuff, :except => [:edit]

  def new
    begin
      if session[:omniauth][:info][:nickname]
        @nickname = session[:omniauth][:info][:nickname]
      end
    rescue
    end
    super
  end

  def create
    super
    if user_signed_in? && session[:omniauth]
      current_user.nickname = session[:omniauth][:info][:nickname] if session[:omniauth][:info][:nickname]
      current_user.name = session[:omniauth][:info][:name] if session[:omniauth][:info][:name]
      current_user.save if current_user.nickname || current_user.name

      current_user.authentications.create!(:provider => session[:omniauth]['provider'], 
      	    :uuid => session[:omniauth]['uid'])
    end
  end

  def edit
    super
  end
  
  def update
    super
  end

  private

  def set_common_stuff
    @hide_topnav_items = true
  end

end