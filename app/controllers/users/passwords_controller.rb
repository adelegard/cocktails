class Users::PasswordsController < Devise::PasswordsController
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