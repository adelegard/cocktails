module Admin
  class BaseController < ApplicationController
    before_filter :verify_admin

    private
    def verify_admin
      if current_user.blank?
        redirect_to root_url
      else
        redirect_to root_url unless current_user.role?(:admin)
      end
    end
  end
end