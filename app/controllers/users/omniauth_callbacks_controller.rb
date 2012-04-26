class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:success] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    @user = User.find_for_twitter_oauth(env['omniauth.auth'])

    if @user.persisted?
      flash[:success] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Twitter'
      @user.remember_me = true
      sign_in_and_redirect @user, :event => :authentication
    else
      if @user.save
        flash[:success] = "Signed in successfully."
        sign_in_and_redirect(:user, @user)
      else
        session[:omniauth] = env['omniauth.auth'].except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  def google
    google_and_open_id
  end

  def open_id
    google_and_open_id
  end

  def google_and_open_id
    @user = User.find_for_open_id(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:success] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end