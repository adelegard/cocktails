class MyDevise::PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication, :except => [:edit_while_logged_in]
  before_filter :set_common_stuff

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  private

  def set_common_stuff
    @hide_topnav_items = true
  end

end